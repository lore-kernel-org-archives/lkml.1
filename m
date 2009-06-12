Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbZFLQa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbZFLQa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764630AbZFLQZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39100 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763258AbZFLQZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 18/27] Blackfin: add support for bzip2/lzma compressed kernel images
Date: Fri, 12 Jun 2009 12:24:36 -0400
Message-Id: <1244823885-22410-19-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since U-Boot can support these compression types, add appropriate targets
to the Blackfin boot files.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig         |    3 +++
 arch/blackfin/Makefile        |    7 +++++--
 arch/blackfin/boot/.gitignore |    3 ++-
 arch/blackfin/boot/Makefile   |   31 ++++++++++++++++++++++++-------
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 2cf455a..6ae9a03 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -20,6 +20,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	def_bool y
 	select HAVE_IDE
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_BZIP2
+	select HAVE_KERNEL_LZMA
 	select HAVE_OPROFILE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index d54c828..6f9533c 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -137,7 +137,7 @@ archclean:
 
 INSTALL_PATH ?= /tftpboot
 boot := arch/$(ARCH)/boot
-BOOT_TARGETS = vmImage
+BOOT_TARGETS = vmImage vmImage.bz2 vmImage.gz vmImage.lzma
 PHONY += $(BOOT_TARGETS) install
 KBUILD_IMAGE := $(boot)/vmImage
 
@@ -150,7 +150,10 @@ install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
 define archhelp
-  echo  '* vmImage         - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage)'
+  echo  '* vmImage         - Alias to selected kernel format (vmImage.gz by default)'
+  echo  '  vmImage.bz2     - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.bz2)'
+  echo  '* vmImage.gz      - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.gz)'
+  echo  '  vmImage.lzma    - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage.lzma)'
   echo  '  install         - Install kernel using'
   echo  '                     (your) ~/bin/$(CROSS_COMPILE)installkernel or'
   echo  '                     (distribution) PATH: $(CROSS_COMPILE)installkernel or'
diff --git a/arch/blackfin/boot/.gitignore b/arch/blackfin/boot/.gitignore
index 3ae0399..229e508 100644
--- a/arch/blackfin/boot/.gitignore
+++ b/arch/blackfin/boot/.gitignore
@@ -1 +1,2 @@
-+vmImage
+vmImage*
+vmlinux*
diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index e028d13..3ab6f23 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -8,24 +8,41 @@
 
 MKIMAGE := $(srctree)/scripts/mkuboot.sh
 
-targets := vmImage
-extra-y += vmlinux.bin vmlinux.gz
+targets := vmImage vmImage.bz2 vmImage.gz vmImage.lzma
+extra-y += vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma
 
 quiet_cmd_uimage = UIMAGE  $@
       cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
-                   -C gzip -n 'Linux-$(KERNELRELEASE)' -a $(CONFIG_BOOT_LOAD) \
+                   -C $(2) -n 'Linux-$(KERNELRELEASE)' -a $(CONFIG_BOOT_LOAD) \
                    -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
                    -d $< $@
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-$(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
-$(obj)/vmImage: $(obj)/vmlinux.gz
-	$(call if_changed,uimage)
-	@$(kecho) 'Kernel: $@ is ready'
+$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,bzip2)
+
+$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,lzma)
+
+$(obj)/vmImage.bz2: $(obj)/vmlinux.bin.bz2
+	$(call if_changed,uimage,bzip2)
+
+$(obj)/vmImage.gz: $(obj)/vmlinux.bin.gz
+	$(call if_changed,uimage,gzip)
+
+$(obj)/vmImage.lzma: $(obj)/vmlinux.bin.lzma
+	$(call if_changed,uimage,lzma)
+
+suffix-$(CONFIG_KERNEL_GZIP)  := gz
+suffix-$(CONFIG_KERNEL_BZIP2) := bz2
+suffix-$(CONFIG_KERNEL_LZMA)  := lzma
+$(obj)/vmImage: $(obj)/vmImage.$(suffix-y)
+	@ln -sf $(notdir $<) $@
 
 install:
 	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"
-- 
1.6.3.1

