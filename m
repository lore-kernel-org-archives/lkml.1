Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbXILXZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbXILXZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbXILXZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:25:44 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:30485 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753156AbXILXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:25:43 -0400
X-YMail-OSG: ivQ4KR8VM1lF1cu0oSBIO8JdJ0afvWNM1Bcdt99z3oyRSWVnB_1sHRzHxDlvVQpcEd0BS4xbXpX0iQZs34zsjXdk9dwBH3136iUlE0TaBpMZuLDf_NA.F1WoY5L1
Date: Wed, 12 Sep 2007 16:25:34 -0700
From: Chris Wedgwood <cw@f00f.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: davej@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Eric Sandeen <sandeen@sandeen.net>
Subject: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070912232534.GA26868@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a somewhat rough first-pass at making a 'minimal tree'
installation target.  This installs a partial source-tree which you
can use to build external modules against.  It feels pretty unclean
but I'm not aware of a much better way to do some of this.

This patch works for me, even when using O=<buildtree>.  It probably
needs further cleanups.

Comments?

-----
Add a 'mintree-install' makefile target.

Red Hat and other distributions typically have some logic in their
kernel package build system to create/install 'minimalist source tree'
which contains enough state to build external modules against but is
much smaller than the entire build-tree.

This introduces similar logic, the guts of this was taken from a
Fedora Core spec file and mutilated to make it work for O=<...>
builds.
-----


diff --git a/Makefile b/Makefile
index 3067f6a..1246939 100644
--- a/Makefile
+++ b/Makefile
@@ -1085,6 +1085,11 @@ package-dir	:= $(srctree)/scripts/package
 	$(Q)$(MAKE) $(build)=$(package-dir) $@
 rpm: include/config/kernel.release FORCE
 	$(Q)$(MAKE) $(build)=$(package-dir) $@
+# /usr/src/linux to match what most distro's do
+#export INSTALL_MINTREE_PATH ?= /usr/src/linux
+export INSTALL_MINTREE_PATH ?= /tmp/mt-test/
+mintree-install: include/config/kernel.release FORCE
+	$(Q)$(MAKE) $(build)=$(package-dir) $@
 
 
 # Brief documentation of the typical targets used
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 7c434e0..0c5f07d 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -86,6 +86,12 @@ tar%pkg: FORCE
 clean-dirs += $(objtree)/tar-install/
 
 
+# minimal tree installation target
+# ---------------------------------------------------------------------------
+mintree-install: FORCE
+	$(MAKE) KBUILD_SRC=
+	$(CONFIG_SHELL) $(srctree)/scripts/package/mintree-install
+
 # Help text displayed when executing 'make help'
 # ---------------------------------------------------------------------------
 help: FORCE
@@ -96,4 +102,6 @@ help: FORCE
 	@echo '  tar-pkg         - Build the kernel as an uncompressed tarball'
 	@echo '  targz-pkg       - Build the kernel as a gzip compressed tarball'
 	@echo '  tarbz2-pkg      - Build the kernel as a bzip2 compressed tarball'
+	@echo '  mintree-install - Build the kernel and install a minimal-build-tree'
+	@echo '                    that can be used to build external modules against'
 
diff --git a/scripts/package/mintree-install b/scripts/package/mintree-install
new file mode 100644
index 0000000..1362cc2
--- /dev/null
+++ b/scripts/package/mintree-install
@@ -0,0 +1,87 @@
+#!/bin/bash
+
+# miniman-tree-install
+#
+# This should install necessary the headers, makefiles and
+# configuration files in a location so that you can use kbuild to
+# build external (out of tree) modules without needing the entire
+# kernel build tree.
+#
+
+# This has been shamelessly taken from a Red Hat's spec file,
+# http://cvs.fedora.redhat.com/viewcvs/devel/kernel/kernel.spec?rev=1.145&view=markup
+
+# FIXME:cw Some parts of this are still icky, it's not clear how best
+# to clean some of this up.  Error handling is more or less
+# non-existent.  You could argue that this entire process should be
+# done differently (ie. using kbuild knowledge instead of a whole lot
+# of hard-coded magic here).
+
+# FIXME:cw If any of srctree, objtree or INSTALL_MINTREE_PATH have
+# spaces in them some parts of this will fail as-is, it shouldn't be
+# that hard to fix (it's not clear if the rest of t kbuild is clean in
+# that respect though)
+
+# This relies on the following environment variables being sane and
+# passed in from the Makefiles:
+#
+#    INSTALL_MINTREE_PATH
+#    KERNELVERSION
+
+
+# target directory
+tgtdir="${INSTALL_MINTREE_PATH}"/${KERNELVERSION}/
+
+
+# And save the headers/makefiles etc for building modules against
+#
+# This all looks scary, but the end result is supposed to be:
+# * all arch relevant include/ files
+# * all Makefile/Kconfig files
+# * all script/ files
+
+cd "$srctree" || exit $?
+
+mkdir -p ${tgtdir}
+
+# first copy everything.  If objtree differs from srctree (ie. O=<...>
+# is used) then make sure we don't copy the Makefile(s) from inside
+# $objtree
+if [ "$srctree" != "$objtree" ] ; then
+    cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*" -not -ipath "$objtree/*Makefile" ) ${tgtdir}
+else
+    cp --parents $(find -type f -name "Makefile*" -o -name "Kconfig*") ${tgtdir}
+fi
+
+cp "${objtree}/Module.symvers" ${tgtdir}
+# then drop all but the needed Makefiles/Kconfig files
+#rm -rf ${tgtdir}/Documentation
+rm -rf "${tgtdir}/scripts"
+rm -rf "${tgtdir}/include"
+cp "${objtree}/.config" ${tgtdir}
+cp -a scripts ${tgtdir}
+if [ -d ${srctree}/arch/${ARCH}/scripts ]; then
+    cp -a ${srctree}/arch/${ARCH}/scripts ${tgtdir}/arch/${ARCH} || :
+fi
+if [ -f ${objtree}/arch/${ARCH}/*lds ]; then
+    cp -a ${objtree}/arch/${ARCH}/*lds ${tgtdir}/arch/${ARCH}/ || :
+fi
+rm -f ${tgtdir}/scripts/*.o
+rm -f ${tgtdir}/scripts/*/*.o
+mkdir -p ${tgtdir}/include
+
+cd include
+cp -a acpi keys linux math-emu media mtd net pcmcia rdma rxrpc scsi sound video asm-generic ${tgtdir}/include
+cp -a ${objtree}/include/config ${objtree}/include/asm ${tgtdir}/include
+cp -a $(readlink ${objtree}/include/asm) ${tgtdir}/include
+if [ "$ARCH" = "x86_64" ]; then
+    cp -a asm-i386 ${tgtdir}/include
+fi
+
+# Make sure the Makefile and version.h have a matching timestamp so
+# that external modules can be built
+touch -r ${tgtdir}/Makefile ${tgtdir}/include/linux/version.h
+touch -r ${tgtdir}/.config ${tgtdir}/include/linux/autoconf.h
+# Copy .config to include/config/auto.conf so "make prepare" is
+# unnecessary.
+cp ${tgtdir}/.config ${tgtdir}/include/config/auto.conf
