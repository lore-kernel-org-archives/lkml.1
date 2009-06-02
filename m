Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZFBJEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZFBJEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZFBJEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:04:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:48513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZFBJEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:04:32 -0400
Date: Tue, 2 Jun 2009 09:03:31 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
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
Subject: [tip:perfcounters/core] perf_counter tools: Cleanup Makefile
Message-ID: <tip-c1079abd1d5e66edabeb04d75e48e604cd8c167f@git.kernel.org>
Git-Commit-ID: c1079abd1d5e66edabeb04d75e48e604cd8c167f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 09:03:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1079abd1d5e66edabeb04d75e48e604cd8c167f
Gitweb:     http://git.kernel.org/tip/c1079abd1d5e66edabeb04d75e48e604cd8c167f
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 2 Jun 2009 10:17:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 11:01:43 +0200

perf_counter tools: Cleanup Makefile

We currently build perf-stat/record etc, only to do nothing
with them.  We also install the perf binary in two places,
$prefix/bin and $perfexec_instdir, which appears to be for
binaries which perf would exec were a command not linked in.
Correct this, and comment out broken/incomplete targets dist
and coverage.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile |  141 ++++++++++++++++++-----------------
 1 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 3b8275f..eae8856 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -260,8 +260,6 @@ PROGRAMS += perf
 
 # List built-in command $C whose implementation cmd_$C() is not in
 # builtin-$C.o but is linked in as part of some other command.
-BUILT_INS += $(patsubst builtin-%.o,perf-%$X,$(BUILTIN_OBJS))
-
 #
 # None right now:
 #
@@ -791,12 +789,14 @@ export perfexec_instdir
 
 install: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-	$(INSTALL) $(ALL_PROGRAMS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) perf$X '$(DESTDIR_SQ)$(bindir_SQ)'
+ifdef BUILT_INS
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
 endif
+endif
 
 install-doc:
 	$(MAKE) -C Documentation install
@@ -824,52 +824,55 @@ quick-install-html:
 
 
 ### Maintainer's dist rules
-
-perf.spec: perf.spec.in
-	sed -e 's/@@VERSION@@/$(PERF_VERSION)/g' < $< > $@+
-	mv $@+ $@
-
-PERF_TARNAME=perf-$(PERF_VERSION)
-dist: perf.spec perf-archive$(X) configure
-	./perf-archive --format=tar \
-		--prefix=$(PERF_TARNAME)/ HEAD^{tree} > $(PERF_TARNAME).tar
-	@mkdir -p $(PERF_TARNAME)
-	@cp perf.spec configure $(PERF_TARNAME)
-	@echo $(PERF_VERSION) > $(PERF_TARNAME)/version
-	$(TAR) rf $(PERF_TARNAME).tar \
-		$(PERF_TARNAME)/perf.spec \
-		$(PERF_TARNAME)/configure \
-		$(PERF_TARNAME)/version
-	@$(RM) -r $(PERF_TARNAME)
-	gzip -f -9 $(PERF_TARNAME).tar
-
-htmldocs = perf-htmldocs-$(PERF_VERSION)
-manpages = perf-manpages-$(PERF_VERSION)
-dist-doc:
-	$(RM) -r .doc-tmp-dir
-	mkdir .doc-tmp-dir
-	$(MAKE) -C Documentation WEBDOC_DEST=../.doc-tmp-dir install-webdoc
-	cd .doc-tmp-dir && $(TAR) cf ../$(htmldocs).tar .
-	gzip -n -9 -f $(htmldocs).tar
-	:
-	$(RM) -r .doc-tmp-dir
-	mkdir -p .doc-tmp-dir/man1 .doc-tmp-dir/man5 .doc-tmp-dir/man7
-	$(MAKE) -C Documentation DESTDIR=./ \
-		man1dir=../.doc-tmp-dir/man1 \
-		man5dir=../.doc-tmp-dir/man5 \
-		man7dir=../.doc-tmp-dir/man7 \
-		install
-	cd .doc-tmp-dir && $(TAR) cf ../$(manpages).tar .
-	gzip -n -9 -f $(manpages).tar
-	$(RM) -r .doc-tmp-dir
-
-rpm: dist
-	$(RPMBUILD) -ta $(PERF_TARNAME).tar.gz
+#
+# None right now
+#
+#
+# perf.spec: perf.spec.in
+#	sed -e 's/@@VERSION@@/$(PERF_VERSION)/g' < $< > $@+
+#	mv $@+ $@
+#
+# PERF_TARNAME=perf-$(PERF_VERSION)
+# dist: perf.spec perf-archive$(X) configure
+#	./perf-archive --format=tar \
+#		--prefix=$(PERF_TARNAME)/ HEAD^{tree} > $(PERF_TARNAME).tar
+#	@mkdir -p $(PERF_TARNAME)
+#	@cp perf.spec configure $(PERF_TARNAME)
+#	@echo $(PERF_VERSION) > $(PERF_TARNAME)/version
+#	$(TAR) rf $(PERF_TARNAME).tar \
+#		$(PERF_TARNAME)/perf.spec \
+#		$(PERF_TARNAME)/configure \
+#		$(PERF_TARNAME)/version
+#	@$(RM) -r $(PERF_TARNAME)
+#	gzip -f -9 $(PERF_TARNAME).tar
+#
+# htmldocs = perf-htmldocs-$(PERF_VERSION)
+# manpages = perf-manpages-$(PERF_VERSION)
+# dist-doc:
+#	$(RM) -r .doc-tmp-dir
+#	mkdir .doc-tmp-dir
+#	$(MAKE) -C Documentation WEBDOC_DEST=../.doc-tmp-dir install-webdoc
+#	cd .doc-tmp-dir && $(TAR) cf ../$(htmldocs).tar .
+#	gzip -n -9 -f $(htmldocs).tar
+#	:
+#	$(RM) -r .doc-tmp-dir
+#	mkdir -p .doc-tmp-dir/man1 .doc-tmp-dir/man5 .doc-tmp-dir/man7
+#	$(MAKE) -C Documentation DESTDIR=./ \
+#		man1dir=../.doc-tmp-dir/man1 \
+#		man5dir=../.doc-tmp-dir/man5 \
+#		man7dir=../.doc-tmp-dir/man7 \
+#		install
+#	cd .doc-tmp-dir && $(TAR) cf ../$(manpages).tar .
+#	gzip -n -9 -f $(manpages).tar
+#	$(RM) -r .doc-tmp-dir
+#
+# rpm: dist
+#	$(RPMBUILD) -ta $(PERF_TARNAME).tar.gz
 
 ### Cleaning rules
 
 distclean: clean
-	$(RM) configure
+#	$(RM) configure
 
 clean:
 	$(RM) *.o */*.o $(LIB_FILE)
@@ -896,25 +899,27 @@ check-builtins::
 
 ### Test suite coverage testing
 #
-.PHONY: coverage coverage-clean coverage-build coverage-report
-
-coverage:
-	$(MAKE) coverage-build
-	$(MAKE) coverage-report
-
-coverage-clean:
-	rm -f *.gcda *.gcno
-
-COVERAGE_CFLAGS = $(CFLAGS) -O0 -ftest-coverage -fprofile-arcs
-COVERAGE_LDFLAGS = $(CFLAGS)  -O0 -lgcov
-
-coverage-build: coverage-clean
-	$(MAKE) CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" all
-	$(MAKE) CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" \
-		-j1 test
-
-coverage-report:
-	gcov -b *.c */*.c
-	grep '^function.*called 0 ' *.c.gcov */*.c.gcov \
-		| sed -e 's/\([^:]*\)\.gcov: *function \([^ ]*\) called.*/\1: \2/' \
-		| tee coverage-untested-functions
+# None right now
+#
+# .PHONY: coverage coverage-clean coverage-build coverage-report
+#
+# coverage:
+#	$(MAKE) coverage-build
+#	$(MAKE) coverage-report
+#
+# coverage-clean:
+#	rm -f *.gcda *.gcno
+#
+# COVERAGE_CFLAGS = $(CFLAGS) -O0 -ftest-coverage -fprofile-arcs
+# COVERAGE_LDFLAGS = $(CFLAGS)  -O0 -lgcov
+#
+# coverage-build: coverage-clean
+#	$(MAKE) CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" all
+#	$(MAKE) CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" \
+#		-j1 test
+#
+# coverage-report:
+#	gcov -b *.c */*.c
+#	grep '^function.*called 0 ' *.c.gcov */*.c.gcov \
+#		| sed -e 's/\([^:]*\)\.gcov: *function \([^ ]*\) called.*/\1: \2/' \
+#		| tee coverage-untested-functions
