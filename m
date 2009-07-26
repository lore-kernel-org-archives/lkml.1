Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZGZAKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZGZAKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 20:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZGZAKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 20:10:22 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:56842 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbZGZAKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 20:10:22 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kbuild@vger.kernel.org
Subject: kbuild: fix the binrpm-pkg target to work with KBUILD_OUTPUT set
Date: Sun, 26 Jul 2009 02:10:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907260210.19784.elendil@planet.nl>
X-OriginalArrivalTime: 26 Jul 2009 00:10:21.0623 (UTC) FILETIME=[7743E470:01CA0D85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binrpm-pkg target (binary RPM only) fails when called with
KBUILD_OUTPUT set. This patch makes it work.

For the rpm-pkg target (source + binary RPM), building with
KBUILD_OUTPUT set is not possible and also not needed as the
actual build is done in a temporary directory anyway, so check
that KBUILD_OUTPUT is not set in that case to avoid later errors.

Signed-off-by: Frans Pop <elendil@planet.nl>
---

I ran into this while trying if I could build an RPM kernel package on
my Debian notebook :-)

The patch has been tested by doing three builds:
- make -j4 rpm-pkg
- make -j4 binrpm-pkg
- KBUILD_OUTPUT=../builds/amd64 make -j4 binrpm-pkg

For all three the contents of the resulting binary RPM package was identical
(and looked correct); the source RPM package from the first build looked sane.

A 'KBUILD_OUTPUT=../builds/amd64 make -j4 rpm-pkg' fails as intended.

One open issue is that the following commands should IIUC be identical,
but the second one does not work:
- KBUILD_OUTPUT=../builds/amd64 make -j4 binrpm-pkg
- make -j4 O=../builds/amd64 binrpm-pkg

AFAICT the root Makefile is supposed to set KBUILD_OUTPUT based on O=, but
that is not visible when the lines within the binrpm-pkg target are executed.
My make foo was not strong enough to debug this. Sam, do you know?

Cheers,
FJP

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index fa4a0a1..b305c57 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -18,6 +18,9 @@
 # e) generate the rpm files, based on kernel.spec
 # - Use /. to avoid tar packing just the symlink
 
+# Note that the rpm-pkg target cannot be used with KBUILD_OUTPUT,
+# but the binrpm-pkg target can; for some reason O= gets ignored.
+
 # Do we have rpmbuild, otherwise fall back to the older rpm
 RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
 	           else echo rpm; fi)
@@ -33,6 +36,12 @@ $(objtree)/kernel.spec: $(MKSPEC) $(srctree)/Makefile
 	$(CONFIG_SHELL) $(MKSPEC) > $@
 
 rpm-pkg rpm: $(objtree)/kernel.spec FORCE
+	@if test -n "$(KBUILD_OUTPUT)"; then \
+		echo "Building source + binary RPM is not possible outside the"; \
+		echo "kernel source tree. Don't set KBUILD_OUTPUT, or use the"; \
+		echo "binrpm-pkg target instead."; \
+		false; \
+	fi
 	$(MAKE) clean
 	$(PREV) ln -sf $(srctree) $(KERNELPATH)
 	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion > $(objtree)/.scmversion
@@ -61,7 +70,7 @@ binrpm-pkg: $(objtree)/binkernel.spec FORCE
 	set -e; \
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
-	$(RPM) $(RPMOPTS) --define "_builddir $(srctree)" --target \
+	$(RPM) $(RPMOPTS) --define "_builddir $(objtree)" --target \
 		$(UTS_MACHINE) -bb $<
 
 clean-files += $(objtree)/binkernel.spec
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 3d93f8c..ce9c60e 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -70,7 +70,7 @@ echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
 echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"
 
-echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
+echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} KBUILD_SRC= modules_install'
 echo "%ifarch ia64"
 echo 'cp $KBUILD_IMAGE $RPM_BUILD_ROOT'"/boot/efi/vmlinuz-$KERNELRELEASE"
 echo 'ln -s '"efi/vmlinuz-$KERNELRELEASE" '$RPM_BUILD_ROOT'"/boot/"
