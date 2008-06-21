Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYFUWHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYFUWHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYFUWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:07:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58517 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYFUWHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:07:34 -0400
Date: Sun, 22 Jun 2008 00:08:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] kbuild: prepare headers_* for arch/$ARCH/include
Message-ID: <20080621220818.GB12279@uranus.ravnborg.org>
References: <20080621220703.GA12279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621220703.GA12279@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dbe54b86ff10b0f6d0a5d1b8e706696f87b9b42a Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 21 Jun 2008 00:24:17 +0200
Subject: [PATCH] kbuild: prepare headers_* for arch/$ARCH/include

Factor out the headers_*_all support to a seperate
shell script and add support for arch specific
header files can be located in either

    arch/$ARCH/include/asm
or
    include/asm-$ARCH/

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile           |   37 ++++++++++++++++++-------------------
 scripts/headers.sh |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 19 deletions(-)
 create mode 100755 scripts/headers.sh

diff --git a/Makefile b/Makefile
index 309f49d..e309a87 100644
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
1.5.4.1.143.ge7e51

