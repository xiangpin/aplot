PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: rd check clean

alldocs: rd readme mkdocs

rd:
	Rscript -e 'roxygen2::roxygenise(".")'

readme:
	Rscript -e 'rmarkdown::render("README.Rmd")'

readme2:
	Rscript -e 'rmarkdown::render("README.Rmd", "html_document")'

build: rd
	cd ..;\
	R CMD build $(PKGSRC)

build2: rd
	cd ..;\
	R CMD build --no-build-vignettes $(PKGSRC)

install: build2
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

check: 
	cd ..;\
	# Rscript -e 'rcmdcheck::rcmdcheck("$(PKGNAME)_$(PKGVERS).tar.gz", args="--as-cran")'
	Rscript -e 'devtools::check()'

check2: build
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz

bioccheck:
	cd ..;\
	Rscript -e 'BiocCheck::BiocCheck("$(PKGNAME)_$(PKGVERS).tar.gz")'

clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/

