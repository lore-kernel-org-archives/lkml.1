Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbYF3VmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbYF3VmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763126AbYF3Vex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48246 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763164AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 10/24] kbuild: prepare headers_* for arch/$ARCH/include
Date: Mon, 30 Jun 2008 23:35:04 +0200
Message-Id: <1214861718-32626-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the headers_*_all support to a seperate
shell script and add support for arch specific
header files can be located in either

    arch/$ARCH/include/asm
or
    include/asm-$ARCH/

In "make help" always display the headers_* targets.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile           |   49 ++++++++++++++++++++++---------------------------
 scripts/headers.sh |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 27 deletions(-)
 create mode 100755 scripts/headers.sh

diff --git a/Makefile b/Makefile
index 572ecfb..acb961e 100644
--- a/Makefile
+++ b/Makefile
@@ -205,6 +205,9 @@ ifeq ($(ARCH),x86_64)
         SRCARCH := x86
 endif
 
+# Where to locate arch specific headers
+hdr-arch       := $(SRCARCH)
+
 KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
@@ -1000,43 +1003,39 @@ depend dep:
 #Default location for installed headers
 export INSTALL_HDR_PATH = $(objtree)/usr
 
-hdr-filter := generic um ppc sparc64 cris
-hdr-archs  := $(filter-out $(hdr-filter),                           \
-                  $(patsubst $(srctree)/include/asm-%/Kbuild,%,     \
-                      $(wildcard $(srctree)/include/asm-*/Kbuild)))
 hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
+# Find out where the Kbuild file is located to support
+# arch/$(ARCH)/include/asm
+hdr-dir = $(strip                                                         \
+          $(if $(wildcard $(srctree)/arch/$(hdr-arch)/include/asm/Kbuild), \
+               arch/$(hdr-arch)/include/asm, include/asm-$(hdr-arch)))
+
+# If we do an all arch process set dst to asm-$(hdr-arch)
+hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 
 PHONY += __headers
 __headers: include/linux/version.h scripts_basic FORCE
 	$(Q)$(MAKE) $(build)=scripts scripts/unifdef
 
 PHONY += headers_install_all
-headers_install_all: __headers
-	$(Q)$(MAKE) $(hdr-inst)=include
-	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) $(hdr-inst)=include/asm-$$arch   \
-	         SRCARCH=$$arch dst=include/asm-$$arch;  \
-	 done
+headers_install_all:
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/headers.sh install
 
 PHONY += headers_install
 headers_install: __headers
-	$(if $(wildcard $(srctree)/include/asm-$(SRCARCH)/Kbuild),, \
-	$(error Headers not exportable for this architecture ($(SRCARCH))))
+	$(if $(wildcard $(srctree)/$(hdr-dir)/Kbuild),, \
+	$(error Headers not exportable for the $(SRCARCH) architecture))
 	$(Q)$(MAKE) $(hdr-inst)=include
-	$(Q)$(MAKE) $(hdr-inst)=include/asm-$(SRCARCH) dst=include/asm
+	$(Q)$(MAKE) $(hdr-inst)=$(hdr-dir) $(hdr-dst)
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
-	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
-	$(Q)set -e; for arch in $(hdr-archs); do \
-	 $(MAKE) SRCARCH=$$arch $(hdr-inst)=include/asm-$$arch HDRCHECK=1 ;\
-	 done
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/headers.sh check
 
 PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
-	$(Q)$(MAKE) $(hdr-inst)=include/asm-$(SRCARCH) \
-	            dst=include/asm HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=$(hdr-dir) $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
@@ -1217,21 +1216,17 @@ help:
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  kernelrelease	  - Output the release version string'
 	@echo  '  kernelversion	  - Output the version stored in Makefile'
-	@if [ -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
-	 echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
+	@echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
 	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
-	 fi
-	@echo  ''
+	 echo  ''
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
 	@echo  '  versioncheck    - Sanity check on version.h usage'
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
-	@if [ -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
-	 echo  '  headers_check   - Sanity check on exported headers'; \
-	 fi
-	@echo  ''
+	@echo  '  headers_check   - Sanity check on exported headers'; \
+	 echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
diff --git a/scripts/headers.sh b/scripts/headers.sh
new file mode 100755
index 0000000..d33426f
--- /dev/null
+++ b/scripts/headers.sh
@@ -0,0 +1,41 @@
+#!/bin/sh
+# Run headers_$1 command for all suitable architectures
+
+# Stop on error
+set -e
+
+do_command()
+{
+	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
+		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
+	elif [ -f ${srctree}/include/asm-$2/Kbuild ]; then
+		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
+	else
+		printf "Ignoring arch: %s\n" ${arch}
+	fi
+}
+
+# Do not try this architecture
+drop="generic um ppc sparc64 cris"
+
+archs=$(ls ${srctree}/arch)
+
+for arch in ${archs}; do
+	case ${arch} in
+	um)        # no userspace export
+		;;
+	ppc)       # headers exported by powerpc
+		;;
+	sparc64)   # headers exported by sparc
+		;;
+	cris)      # headers export are known broken
+		;;
+	*)
+		if [ -d ${srctree}/arch/${arch} ]; then
+			do_command $1 ${arch}
+		fi
+		;;
+	esac
+done
+
+
-- 
1.5.6.1.93.gef98

