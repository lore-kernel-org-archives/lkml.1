Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZE3NB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZE3NB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZE3NBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:01:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:47742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZE3NBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:01:18 -0400
Date: Sat, 30 May 2009 13:00:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Generate per command manpages (and pdf/html, etc.)
Message-ID: <tip-c1c2365acf8c044f749c0fe1ea236497e8d1718e@git.kernel.org>
Git-Commit-ID: c1c2365acf8c044f749c0fe1ea236497e8d1718e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 13:00:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1c2365acf8c044f749c0fe1ea236497e8d1718e
Gitweb:     http://git.kernel.org/tip/c1c2365acf8c044f749c0fe1ea236497e8d1718e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 30 May 2009 12:38:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 May 2009 13:52:44 +0200

perf_counter tools: Generate per command manpages (and pdf/html, etc.)

Import Git's nice .txt => {man/html/pdf} generation machinery.

Fix various errors in the Documentation/perf*.txt description as well.

Also fix a bug in builtin-help: we'd map 'perf help top' to 'perftop'
if only the 'perf' binary is in the default PATH - confusing the manpage
logic. I dont fully understand why Git did it this way - but i suppose
it's a migration artifact from their migration from standalone git-xyz
commands to 'git xyz' commands. The perf tools were always using the
modern form so it's not an issue there.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Documentation/Makefile  |  300 ++++++++++++++++++++
 .../perf_counter/Documentation/asciidoc.conf       |   91 ++++++
 .../perf_counter/Documentation/manpage-1.72.xsl    |   14 +
 .../perf_counter/Documentation/manpage-base.xsl    |   35 +++
 .../Documentation/manpage-bold-literal.xsl         |   17 ++
 .../perf_counter/Documentation/manpage-normal.xsl  |   13 +
 .../Documentation/manpage-suppress-sp.xsl          |   21 ++
 .../perf_counter/Documentation/perf-record.txt     |   10 +-
 .../perf_counter/Documentation/perf-report.txt     |    8 +-
 .../perf_counter/Documentation/perf-stat.txt       |    5 +-
 .../perf_counter/Documentation/perf-top.txt        |    8 +-
 Documentation/perf_counter/Documentation/perf.txt  |   23 ++
 Documentation/perf_counter/Makefile                |   61 ++++
 Documentation/perf_counter/builtin-help.c          |    2 +-
 14 files changed, 581 insertions(+), 27 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/Makefile b/Documentation/perf_counter/Documentation/Makefile
new file mode 100644
index 0000000..5457192
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/Makefile
@@ -0,0 +1,300 @@
+MAN1_TXT= \
+	$(filter-out $(addsuffix .txt, $(ARTICLES) $(SP_ARTICLES)), \
+		$(wildcard perf-*.txt)) \
+	perf.txt
+MAN5_TXT=
+MAN7_TXT=
+
+MAN_TXT = $(MAN1_TXT) $(MAN5_TXT) $(MAN7_TXT)
+MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
+MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
+
+DOC_HTML=$(MAN_HTML)
+
+ARTICLES =
+# with their own formatting rules.
+SP_ARTICLES =
+API_DOCS = $(patsubst %.txt,%,$(filter-out technical/api-index-skel.txt technical/api-index.txt, $(wildcard technical/api-*.txt)))
+SP_ARTICLES += $(API_DOCS)
+SP_ARTICLES += technical/api-index
+
+DOC_HTML += $(patsubst %,%.html,$(ARTICLES) $(SP_ARTICLES))
+
+DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
+DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
+DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
+
+prefix?=$(HOME)
+bindir?=$(prefix)/bin
+htmldir?=$(prefix)/share/doc/perf-doc
+pdfdir?=$(prefix)/share/doc/perf-doc
+mandir?=$(prefix)/share/man
+man1dir=$(mandir)/man1
+man5dir=$(mandir)/man5
+man7dir=$(mandir)/man7
+# DESTDIR=
+
+ASCIIDOC=asciidoc
+ASCIIDOC_EXTRA =
+MANPAGE_XSL = manpage-normal.xsl
+XMLTO_EXTRA =
+INSTALL?=install
+RM ?= rm -f
+DOC_REF = origin/man
+HTML_REF = origin/html
+
+infodir?=$(prefix)/share/info
+MAKEINFO=makeinfo
+INSTALL_INFO=install-info
+DOCBOOK2X_TEXI=docbook2x-texi
+DBLATEX=dblatex
+ifndef PERL_PATH
+	PERL_PATH = /usr/bin/perl
+endif
+
+-include ../config.mak.autogen
+-include ../config.mak
+
+#
+# For asciidoc ...
+#	-7.1.2,	no extra settings are needed.
+#	8.0-,	set ASCIIDOC8.
+#
+
+#
+# For docbook-xsl ...
+#	-1.68.1,	set ASCIIDOC_NO_ROFF? (based on changelog from 1.73.0)
+#	1.69.0,		no extra settings are needed?
+#	1.69.1-1.71.0,	set DOCBOOK_SUPPRESS_SP?
+#	1.71.1,		no extra settings are needed?
+#	1.72.0,		set DOCBOOK_XSL_172.
+#	1.73.0-,	set ASCIIDOC_NO_ROFF
+#
+
+#
+# If you had been using DOCBOOK_XSL_172 in an attempt to get rid
+# of 'the ".ft C" problem' in your generated manpages, and you
+# instead ended up with weird characters around callouts, try
+# using ASCIIDOC_NO_ROFF instead (it works fine with ASCIIDOC8).
+#
+
+ifdef ASCIIDOC8
+ASCIIDOC_EXTRA += -a asciidoc7compatible
+endif
+ifdef DOCBOOK_XSL_172
+ASCIIDOC_EXTRA += -a perf-asciidoc-no-roff
+MANPAGE_XSL = manpage-1.72.xsl
+else
+	ifdef ASCIIDOC_NO_ROFF
+	# docbook-xsl after 1.72 needs the regular XSL, but will not
+	# pass-thru raw roff codes from asciidoc.conf, so turn them off.
+	ASCIIDOC_EXTRA += -a perf-asciidoc-no-roff
+	endif
+endif
+ifdef MAN_BOLD_LITERAL
+XMLTO_EXTRA += -m manpage-bold-literal.xsl
+endif
+ifdef DOCBOOK_SUPPRESS_SP
+XMLTO_EXTRA += -m manpage-suppress-sp.xsl
+endif
+
+SHELL_PATH ?= $(SHELL)
+# Shell quote;
+SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
+
+#
+# Please note that there is a minor bug in asciidoc.
+# The version after 6.0.3 _will_ include the patch found here:
+#   http://marc.theaimsgroup.com/?l=perf&m=111558757202243&w=2
+#
+# Until that version is released you may have to apply the patch
+# yourself - yes, all 6 characters of it!
+#
+
+QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
+QUIET_SUBDIR1  =
+
+ifneq ($(findstring $(MAKEFLAGS),w),w)
+PRINT_DIR = --no-print-directory
+else # "make -w"
+NO_SUBDIR = :
+endif
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
+	QUIET_XMLTO	= @echo '   ' XMLTO $@;
+	QUIET_DB2TEXI	= @echo '   ' DB2TEXI $@;
+	QUIET_MAKEINFO	= @echo '   ' MAKEINFO $@;
+	QUIET_DBLATEX	= @echo '   ' DBLATEX $@;
+	QUIET_XSLTPROC	= @echo '   ' XSLTPROC $@;
+	QUIET_GEN	= @echo '   ' GEN $@;
+	QUIET_STDERR	= 2> /dev/null
+	QUIET_SUBDIR0	= +@subdir=
+	QUIET_SUBDIR1	= ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+			  $(MAKE) $(PRINT_DIR) -C $$subdir
+	export V
+endif
+endif
+
+all: html man
+
+html: $(DOC_HTML)
+
+$(DOC_HTML) $(DOC_MAN1) $(DOC_MAN5) $(DOC_MAN7): asciidoc.conf
+
+man: man1 man5 man7
+man1: $(DOC_MAN1)
+man5: $(DOC_MAN5)
+man7: $(DOC_MAN7)
+
+info: perf.info perfman.info
+
+pdf: user-manual.pdf
+
+install: install-man
+
+install-man: man
+	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
+#	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
+#	$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
+	$(INSTALL) -m 644 $(DOC_MAN1) $(DESTDIR)$(man1dir)
+#	$(INSTALL) -m 644 $(DOC_MAN5) $(DESTDIR)$(man5dir)
+#	$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
+
+install-info: info
+	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
+	$(INSTALL) -m 644 perf.info perfman.info $(DESTDIR)$(infodir)
+	if test -r $(DESTDIR)$(infodir)/dir; then \
+	  $(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perf.info ;\
+	  $(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perfman.info ;\
+	else \
+	  echo "No directory found in $(DESTDIR)$(infodir)" >&2 ; \
+	fi
+
+install-pdf: pdf
+	$(INSTALL) -d -m 755 $(DESTDIR)$(pdfdir)
+	$(INSTALL) -m 644 user-manual.pdf $(DESTDIR)$(pdfdir)
+
+install-html: html
+	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
+
+../PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) PERF-VERSION-FILE
+
+-include ../PERF-VERSION-FILE
+
+#
+# Determine "include::" file references in asciidoc files.
+#
+doc.dep : $(wildcard *.txt) build-docdep.perl
+	$(QUIET_GEN)$(RM) $@+ $@ && \
+	$(PERL_PATH) ./build-docdep.perl >$@+ $(QUIET_STDERR) && \
+	mv $@+ $@
+
+-include doc.dep
+
+cmds_txt = cmds-ancillaryinterrogators.txt \
+	cmds-ancillarymanipulators.txt \
+	cmds-mainporcelain.txt \
+	cmds-plumbinginterrogators.txt \
+	cmds-plumbingmanipulators.txt \
+	cmds-synchingrepositories.txt \
+	cmds-synchelpers.txt \
+	cmds-purehelpers.txt \
+	cmds-foreignscminterface.txt
+
+$(cmds_txt): cmd-list.made
+
+cmd-list.made: cmd-list.perl ../command-list.txt $(MAN1_TXT)
+	$(QUIET_GEN)$(RM) $@ && \
+	$(PERL_PATH) ./cmd-list.perl ../command-list.txt $(QUIET_STDERR) && \
+	date >$@
+
+clean:
+	$(RM) *.xml *.xml+ *.html *.html+ *.1 *.5 *.7
+	$(RM) *.texi *.texi+ *.texi++ perf.info perfman.info
+	$(RM) howto-index.txt howto/*.html doc.dep
+	$(RM) technical/api-*.html technical/api-index.txt
+	$(RM) $(cmds_txt) *.made
+
+$(MAN_HTML): %.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b xhtml11 -d manpage -f asciidoc.conf \
+		$(ASCIIDOC_EXTRA) -aperf_version=$(PERF_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+%.1 %.5 %.7 : %.xml
+	$(QUIET_XMLTO)$(RM) $@ && \
+	xmlto -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+
+%.xml : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		$(ASCIIDOC_EXTRA) -aperf_version=$(PERF_VERSION) -o $@+ $< && \
+	mv $@+ $@
+
+XSLT = docbook.xsl
+XSLTOPTS = --xinclude --stringparam html.stylesheet docbook-xsl.css
+
+user-manual.html: user-manual.xml
+	$(QUIET_XSLTPROC)xsltproc $(XSLTOPTS) -o $@ $(XSLT) $<
+
+perf.info: user-manual.texi
+	$(QUIET_MAKEINFO)$(MAKEINFO) --no-split -o $@ user-manual.texi
+
+user-manual.texi: user-manual.xml
+	$(QUIET_DB2TEXI)$(RM) $@+ $@ && \
+	$(DOCBOOK2X_TEXI) user-manual.xml --encoding=UTF-8 --to-stdout >$@++ && \
+	$(PERL_PATH) fix-texi.perl <$@++ >$@+ && \
+	rm $@++ && \
+	mv $@+ $@
+
+user-manual.pdf: user-manual.xml
+	$(QUIET_DBLATEX)$(RM) $@+ $@ && \
+	$(DBLATEX) -o $@+ -p /etc/asciidoc/dblatex/asciidoc-dblatex.xsl -s /etc/asciidoc/dblatex/asciidoc-dblatex.sty $< && \
+	mv $@+ $@
+
+perfman.texi: $(MAN_XML) cat-texi.perl
+	$(QUIET_DB2TEXI)$(RM) $@+ $@ && \
+	($(foreach xml,$(MAN_XML),$(DOCBOOK2X_TEXI) --encoding=UTF-8 \
+		--to-stdout $(xml) &&) true) > $@++ && \
+	$(PERL_PATH) cat-texi.perl $@ <$@++ >$@+ && \
+	rm $@++ && \
+	mv $@+ $@
+
+perfman.info: perfman.texi
+	$(QUIET_MAKEINFO)$(MAKEINFO) --no-split --no-validate $*.texi
+
+$(patsubst %.txt,%.texi,$(MAN_TXT)): %.texi : %.xml
+	$(QUIET_DB2TEXI)$(RM) $@+ $@ && \
+	$(DOCBOOK2X_TEXI) --to-stdout $*.xml >$@+ && \
+	mv $@+ $@
+
+howto-index.txt: howto-index.sh $(wildcard howto/*.txt)
+	$(QUIET_GEN)$(RM) $@+ $@ && \
+	'$(SHELL_PATH_SQ)' ./howto-index.sh $(wildcard howto/*.txt) >$@+ && \
+	mv $@+ $@
+
+$(patsubst %,%.html,$(ARTICLES)) : %.html : %.txt
+	$(QUIET_ASCIIDOC)$(ASCIIDOC) -b xhtml11 $*.txt
+
+WEBDOC_DEST = /pub/software/tools/perf/docs
+
+$(patsubst %.txt,%.html,$(wildcard howto/*.txt)): %.html : %.txt
+	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
+	sed -e '1,/^$$/d' $< | $(ASCIIDOC) -b xhtml11 - >$@+ && \
+	mv $@+ $@
+
+install-webdoc : html
+	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(WEBDOC_DEST)
+
+quick-install: quick-install-man
+
+quick-install-man:
+	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(DOC_REF) $(DESTDIR)$(mandir)
+
+quick-install-html:
+	'$(SHELL_PATH_SQ)' ./install-doc-quick.sh $(HTML_REF) $(DESTDIR)$(htmldir)
+
+.PHONY: .FORCE-PERF-VERSION-FILE
diff --git a/Documentation/perf_counter/Documentation/asciidoc.conf b/Documentation/perf_counter/Documentation/asciidoc.conf
new file mode 100644
index 0000000..356b23a
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/asciidoc.conf
@@ -0,0 +1,91 @@
+## linkperf: macro
+#
+# Usage: linkperf:command[manpage-section]
+#
+# Note, {0} is the manpage section, while {target} is the command.
+#
+# Show PERF link as: <command>(<section>); if section is defined, else just show
+# the command.
+
+[macros]
+(?su)[\\]?(?P<name>linkperf):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
+
+[attributes]
+asterisk=&#42;
+plus=&#43;
+caret=&#94;
+startsb=&#91;
+endsb=&#93;
+tilde=&#126;
+
+ifdef::backend-docbook[]
+[linkperf-inlinemacro]
+{0%{target}}
+{0#<citerefentry>}
+{0#<refentrytitle>{target}</refentrytitle><manvolnum>{0}</manvolnum>}
+{0#</citerefentry>}
+endif::backend-docbook[]
+
+ifdef::backend-docbook[]
+ifndef::perf-asciidoc-no-roff[]
+# "unbreak" docbook-xsl v1.68 for manpages. v1.69 works with or without this.
+# v1.72 breaks with this because it replaces dots not in roff requests.
+[listingblock]
+<example><title>{title}</title>
+<literallayout>
+ifdef::doctype-manpage[]
+&#10;.ft C&#10;
+endif::doctype-manpage[]
+|
+ifdef::doctype-manpage[]
+&#10;.ft&#10;
+endif::doctype-manpage[]
+</literallayout>
+{title#}</example>
+endif::perf-asciidoc-no-roff[]
+
+ifdef::perf-asciidoc-no-roff[]
+ifdef::doctype-manpage[]
+# The following two small workarounds insert a simple paragraph after screen
+[listingblock]
+<example><title>{title}</title>
+<literallayout>
+|
+</literallayout><simpara></simpara>
+{title#}</example>
+
+[verseblock]
+<formalpara{id? id="{id}"}><title>{title}</title><para>
+{title%}<literallayout{id? id="{id}"}>
+{title#}<literallayout>
+|
+</literallayout>
+{title#}</para></formalpara>
+{title%}<simpara></simpara>
+endif::doctype-manpage[]
+endif::perf-asciidoc-no-roff[]
+endif::backend-docbook[]
+
+ifdef::doctype-manpage[]
+ifdef::backend-docbook[]
+[header]
+template::[header-declarations]
+<refentry>
+<refmeta>
+<refentrytitle>{mantitle}</refentrytitle>
+<manvolnum>{manvolnum}</manvolnum>
+<refmiscinfo class="source">perf</refmiscinfo>
+<refmiscinfo class="version">{perf_version}</refmiscinfo>
+<refmiscinfo class="manual">perf Manual</refmiscinfo>
+</refmeta>
+<refnamediv>
+  <refname>{manname}</refname>
+  <refpurpose>{manpurpose}</refpurpose>
+</refnamediv>
+endif::backend-docbook[]
+endif::doctype-manpage[]
+
+ifdef::backend-xhtml11[]
+[linkperf-inlinemacro]
+<a href="{target}.html">{target}{0?({0})}</a>
+endif::backend-xhtml11[]
diff --git a/Documentation/perf_counter/Documentation/manpage-1.72.xsl b/Documentation/perf_counter/Documentation/manpage-1.72.xsl
new file mode 100644
index 0000000..b4d315c
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/manpage-1.72.xsl
@@ -0,0 +1,14 @@
+<!-- manpage-1.72.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles peculiarities in docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<xsl:import href="manpage-base.xsl"/>
+
+<!-- these are the special values for the roff control characters
+     needed for docbook-xsl 1.72.0 -->
+<xsl:param name="git.docbook.backslash">&#x2593;</xsl:param>
+<xsl:param name="git.docbook.dot"      >&#x2302;</xsl:param>
+
+</xsl:stylesheet>
diff --git a/Documentation/perf_counter/Documentation/manpage-base.xsl b/Documentation/perf_counter/Documentation/manpage-base.xsl
new file mode 100644
index 0000000..a264fa6
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/manpage-base.xsl
@@ -0,0 +1,35 @@
+<!-- manpage-base.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- these params silence some output from xmlto -->
+<xsl:param name="man.output.quietly" select="1"/>
+<xsl:param name="refentry.meta.get.quietly" select="1"/>
+
+<!-- convert asciidoc callouts to man page format;
+     git.docbook.backslash and git.docbook.dot params
+     must be supplied by another XSL file or other means -->
+<xsl:template match="co">
+	<xsl:value-of select="concat(
+			      $git.docbook.backslash,'fB(',
+			      substring-after(@id,'-'),')',
+			      $git.docbook.backslash,'fR')"/>
+</xsl:template>
+<xsl:template match="calloutlist">
+	<xsl:value-of select="$git.docbook.dot"/>
+	<xsl:text>sp&#10;</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:text>&#10;</xsl:text>
+</xsl:template>
+<xsl:template match="callout">
+	<xsl:value-of select="concat(
+			      $git.docbook.backslash,'fB',
+			      substring-after(@arearefs,'-'),
+			      '. ',$git.docbook.backslash,'fR')"/>
+	<xsl:apply-templates/>
+	<xsl:value-of select="$git.docbook.dot"/>
+	<xsl:text>br&#10;</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/perf_counter/Documentation/manpage-bold-literal.xsl b/Documentation/perf_counter/Documentation/manpage-bold-literal.xsl
new file mode 100644
index 0000000..608eb5d
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/manpage-bold-literal.xsl
@@ -0,0 +1,17 @@
+<!-- manpage-bold-literal.xsl:
+     special formatting for manpages rendered from asciidoc+docbook -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- render literal text as bold (instead of plain or monospace);
+     this makes literal text easier to distinguish in manpages
+     viewed on a tty -->
+<xsl:template match="literal">
+	<xsl:value-of select="$git.docbook.backslash"/>
+	<xsl:text>fB</xsl:text>
+	<xsl:apply-templates/>
+	<xsl:value-of select="$git.docbook.backslash"/>
+	<xsl:text>fR</xsl:text>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/perf_counter/Documentation/manpage-normal.xsl b/Documentation/perf_counter/Documentation/manpage-normal.xsl
new file mode 100644
index 0000000..a48f5b1
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/manpage-normal.xsl
@@ -0,0 +1,13 @@
+<!-- manpage-normal.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles anything we want to keep away from docbook-xsl 1.72.0 -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<xsl:import href="manpage-base.xsl"/>
+
+<!-- these are the normal values for the roff control characters -->
+<xsl:param name="git.docbook.backslash">\</xsl:param>
+<xsl:param name="git.docbook.dot"	>.</xsl:param>
+
+</xsl:stylesheet>
diff --git a/Documentation/perf_counter/Documentation/manpage-suppress-sp.xsl b/Documentation/perf_counter/Documentation/manpage-suppress-sp.xsl
new file mode 100644
index 0000000..a63c763
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/manpage-suppress-sp.xsl
@@ -0,0 +1,21 @@
+<!-- manpage-suppress-sp.xsl:
+     special settings for manpages rendered from asciidoc+docbook
+     handles erroneous, inline .sp in manpage output of some
+     versions of docbook-xsl -->
+<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
+		version="1.0">
+
+<!-- attempt to work around spurious .sp at the tail of the line
+     that some versions of docbook stylesheets seem to add -->
+<xsl:template match="simpara">
+  <xsl:variable name="content">
+    <xsl:apply-templates/>
+  </xsl:variable>
+  <xsl:value-of select="normalize-space($content)"/>
+  <xsl:if test="not(ancestor::authorblurb) and
+                not(ancestor::personblurb)">
+    <xsl:text>&#10;&#10;</xsl:text>
+  </xsl:if>
+</xsl:template>
+
+</xsl:stylesheet>
diff --git a/Documentation/perf_counter/Documentation/perf-record.txt b/Documentation/perf_counter/Documentation/perf-record.txt
index a93d2ec..4d3416f 100644
--- a/Documentation/perf_counter/Documentation/perf-record.txt
+++ b/Documentation/perf_counter/Documentation/perf-record.txt
@@ -1,5 +1,5 @@
 perf-record(1)
-==========
+==============
 
 NAME
 ----
@@ -53,12 +53,6 @@ OPTIONS
 -l::
         scale counter values
 
-Configuration
--------------
-
-EXAMPLES
---------
-
 SEE ALSO
 --------
-linkperf:git-stat[1]
+linkperf:perf-stat[1]
diff --git a/Documentation/perf_counter/Documentation/perf-report.txt b/Documentation/perf_counter/Documentation/perf-report.txt
index 49efe16..52d3fc6 100644
--- a/Documentation/perf_counter/Documentation/perf-report.txt
+++ b/Documentation/perf_counter/Documentation/perf-report.txt
@@ -1,5 +1,5 @@
 perf-report(1)
-==========
+==============
 
 NAME
 ----
@@ -21,12 +21,6 @@ OPTIONS
 --input=::
         Input file name. (default: perf.data)
 
-Configuration
--------------
-
-EXAMPLES
---------
-
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/Documentation/perf_counter/Documentation/perf-stat.txt b/Documentation/perf_counter/Documentation/perf-stat.txt
index 828c59f..a67d0e3 100644
--- a/Documentation/perf_counter/Documentation/perf-stat.txt
+++ b/Documentation/perf_counter/Documentation/perf-stat.txt
@@ -51,9 +51,6 @@ OPTIONS
 -l::
         scale counter values
 
-Configuration
--------------
-
 EXAMPLES
 --------
 
@@ -74,4 +71,4 @@ $ perf stat sleep 1
 
 SEE ALSO
 --------
-linkperf:git-tops[1]
+linkperf:perf-tops[1]
diff --git a/Documentation/perf_counter/Documentation/perf-top.txt b/Documentation/perf_counter/Documentation/perf-top.txt
index 057333b..15251e4 100644
--- a/Documentation/perf_counter/Documentation/perf-top.txt
+++ b/Documentation/perf_counter/Documentation/perf-top.txt
@@ -50,12 +50,6 @@ OPTIONS
 -l::
         scale counter values
 
-Configuration
--------------
-
-EXAMPLES
---------
-
 SEE ALSO
 --------
-linkperf:git-stat[1]
+linkperf:perf-stat[1]
diff --git a/Documentation/perf_counter/Documentation/perf.txt b/Documentation/perf_counter/Documentation/perf.txt
new file mode 100644
index 0000000..e3d8b38
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/perf.txt
@@ -0,0 +1,23 @@
+perf(1)
+=======
+
+NAME
+----
+perf - Performance analysis tools for Linux
+
+SYNOPSIS
+--------
+[verse]
+'perf' [--version] [--help] COMMAND [ARGS]
+
+DESCRIPTION
+-----------
+Performance counters for Linux are are a new kernel-based subsystem
+that provide a framework for all things performance analysis. It
+covers hardware level (CPU/PMU, Performance Monitoring Unit) features
+and software features (software counters, tracepoints) as well.
+
+SEE ALSO
+--------
+linkperf:perf-stat[1], linkperf:perf-top[1],
+linkperf:perf-record[1], linkperf:perf-report[1]
diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 8f72584..416ab11 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -693,6 +693,21 @@ builtin-revert.o wt-status.o: wt-status.h
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
+doc:
+	$(MAKE) -C Documentation all
+
+man:
+	$(MAKE) -C Documentation man
+
+html:
+	$(MAKE) -C Documentation html
+
+info:
+	$(MAKE) -C Documentation info
+
+pdf:
+	$(MAKE) -C Documentation pdf
+
 TAGS:
 	$(RM) TAGS
 	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
@@ -781,6 +796,31 @@ ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
 endif
 
+install-doc:
+	$(MAKE) -C Documentation install
+
+install-man:
+	$(MAKE) -C Documentation install-man
+
+install-html:
+	$(MAKE) -C Documentation install-html
+
+install-info:
+	$(MAKE) -C Documentation install-info
+
+install-pdf:
+	$(MAKE) -C Documentation install-pdf
+
+quick-install-doc:
+	$(MAKE) -C Documentation quick-install
+
+quick-install-man:
+	$(MAKE) -C Documentation quick-install-man
+
+quick-install-html:
+	$(MAKE) -C Documentation quick-install-html
+
+
 ### Maintainer's dist rules
 
 perf.spec: perf.spec.in
@@ -801,6 +841,26 @@ dist: perf.spec perf-archive$(X) configure
 	@$(RM) -r $(PERF_TARNAME)
 	gzip -f -9 $(PERF_TARNAME).tar
 
+htmldocs = perf-htmldocs-$(PERF_VERSION)
+manpages = perf-manpages-$(PERF_VERSION)
+dist-doc:
+	$(RM) -r .doc-tmp-dir
+	mkdir .doc-tmp-dir
+	$(MAKE) -C Documentation WEBDOC_DEST=../.doc-tmp-dir install-webdoc
+	cd .doc-tmp-dir && $(TAR) cf ../$(htmldocs).tar .
+	gzip -n -9 -f $(htmldocs).tar
+	:
+	$(RM) -r .doc-tmp-dir
+	mkdir -p .doc-tmp-dir/man1 .doc-tmp-dir/man5 .doc-tmp-dir/man7
+	$(MAKE) -C Documentation DESTDIR=./ \
+		man1dir=../.doc-tmp-dir/man1 \
+		man5dir=../.doc-tmp-dir/man5 \
+		man7dir=../.doc-tmp-dir/man7 \
+		install
+	cd .doc-tmp-dir && $(TAR) cf ../$(manpages).tar .
+	gzip -n -9 -f $(manpages).tar
+	$(RM) -r .doc-tmp-dir
+
 rpm: dist
 	$(RPMBUILD) -ta $(PERF_TARNAME).tar.gz
 
@@ -819,6 +879,7 @@ clean:
 	$(RM) -r $(PERF_TARNAME) .doc-tmp-dir
 	$(RM) $(PERF_TARNAME).tar.gz perf-core_$(PERF_VERSION)-*.tar.gz
 	$(RM) $(htmldocs).tar.gz $(manpages).tar.gz
+	$(MAKE) -C Documentation/ clean
 	$(RM) PERF-VERSION-FILE PERF-CFLAGS PERF-BUILD-OPTIONS
 
 .PHONY: all install clean strip
diff --git a/Documentation/perf_counter/builtin-help.c b/Documentation/perf_counter/builtin-help.c
index d2bd317..a3894bf 100644
--- a/Documentation/perf_counter/builtin-help.c
+++ b/Documentation/perf_counter/builtin-help.c
@@ -317,7 +317,7 @@ static const char *cmd_to_page(const char *perf_cmd)
 	else if (is_perf_command(perf_cmd))
 		return prepend("perf-", perf_cmd);
 	else
-		return prepend("perf", perf_cmd);
+		return prepend("perf-", perf_cmd);
 }
 
 static void setup_man_path(void)
