Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbXLFMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbXLFMtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXLFMnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:08 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53728 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXLFMnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:06 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <d4afb29e07a69a0dcc00c167602c4aadc470d09a.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:07:06 +0100
Subject: [PATCH 23/47] Update CRIS main Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old and non-generic targets, use generic ones instead.
- Add sub-arch as mach-fs or mach-a3 for EtraxFS and Artpec-3 respectively.
- Add links to sub-arch directories, and erase before trying to create them.
- Include from sub-arch specific include directory "mach".
- Add files to be cleaned in CLEAN_FILES instead of as archclean target.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Makefile |  139 ++++++++++++++++++++++++++--------------------------
 1 files changed, 70 insertions(+), 69 deletions(-)

diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index e6bf00c..838cd2a 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -1,4 +1,4 @@
-# $Id: Makefile,v 1.28 2005/03/17 10:44:37 larsv Exp $
+#
 # cris/Makefile
 #
 # This file is included by the global makefile so that you can add your own
@@ -10,28 +10,36 @@
 # License.  See the file "COPYING" in the main directory of this archive
 # for more details.
 
-# A bug in ld prevents us from having a (constant-value) symbol in a
-# "ORIGIN =" or "LENGTH =" expression.
-
 arch-y := v10
 arch-$(CONFIG_ETRAX_ARCH_V10) := v10
 arch-$(CONFIG_ETRAX_ARCH_V32) := v32
 
-# No config avaiable for make clean etc
+# No config available for make clean etc
+mach-y := fs
+mach-$(CONFIG_CRIS_MACH_ARTPEC3) := a3
+mach-$(CONFIG_ETRAXFS) := fs
+
 ifneq ($(arch-y),)
 SARCH := arch-$(arch-y)
 else
 SARCH :=
 endif
 
+ifneq ($(mach-y),)
+MACH := mach-$(mach-y)
+else
+MACH :=
+endif
+
 LD = $(CROSS_COMPILE)ld -mcrislinux
 
 OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 
 CPPFLAGS_vmlinux.lds = -DDRAM_VIRTUAL_BASE=0x$(CONFIG_ETRAX_DRAM_VIRTUAL_BASE)
-KBUILD_AFLAGS += -mlinux
 
-KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe
+KBUILD_AFLAGS += -mlinux -march=$(arch-y) -Iinclude/asm/arch/mach -Iinclude/asm/arch
+
+KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe -Iinclude/asm/arch/mach -Iinclude/asm/arch
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS)) -g
@@ -44,6 +52,9 @@ LIBGCC = $(shell $(CC) $(KBUILD_CFLAGS) -print-file-name=libgcc.a)
 
 core-y		+= arch/$(ARCH)/kernel/ arch/$(ARCH)/mm/
 core-y		+= arch/$(ARCH)/$(SARCH)/kernel/ arch/$(ARCH)/$(SARCH)/mm/
+ifdef CONFIG_ETRAX_ARCH_V32
+core-y		+= arch/$(ARCH)/$(SARCH)/$(MACH)/
+endif
 drivers-y	+= arch/$(ARCH)/$(SARCH)/drivers/
 libs-y		+= arch/$(ARCH)/$(SARCH)/lib/ $(LIBGCC)
 
@@ -52,79 +63,69 @@ SRC_ARCH              = $(srctree)/arch/$(ARCH)
 # cris object files path
 OBJ_ARCH              = $(objtree)/arch/$(ARCH)
 
-target_boot_arch_dir  = $(OBJ_ARCH)/$(SARCH)/boot
-target_boot_dir       = $(OBJ_ARCH)/boot
-src_boot_dir          = $(SRC_ARCH)/boot
-target_compressed_dir = $(OBJ_ARCH)/boot/compressed
-src_compressed_dir    = $(SRC_ARCH)/boot/compressed
-target_rescue_dir     = $(OBJ_ARCH)/boot/rescue
-src_rescue_dir        = $(SRC_ARCH)/boot/rescue
-
-export target_boot_arch_dir target_boot_dir src_boot_dir target_compressed_dir src_compressed_dir target_rescue_dir src_rescue_dir
-
-vmlinux.bin: vmlinux
-	$(OBJCOPY) $(OBJCOPYFLAGS) vmlinux vmlinux.bin
-
-timage: vmlinux.bin
-	cat vmlinux.bin cramfs.img >timage
-
-simimage: timage
-	cp vmlinux.bin simvmlinux.bin
-
-# the following will remake timage without compiling the kernel
-# it does of course require that all object files exist...
-
-cramfs:
-## cramfs      - Creates a cramfs image
-	mkcramfs -b 8192 -m romfs_meta.txt root cramfs.img
-	cat vmlinux.bin cramfs.img >timage
+boot := arch/$(ARCH)/boot
+MACHINE := arch/$(ARCH)/$(SARCH)
 
-clinux: vmlinux.bin decompress.bin rescue.bin
+all: zImage
 
-decompress.bin: $(target_boot_dir)
-	@$(MAKE) -f $(src_compressed_dir)/Makefile $(target_compressed_dir)/decompress.bin
+zImage Image: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-$(target_rescue_dir)/rescue.bin: $(target_boot_dir)
-	@$(MAKE) -f $(src_rescue_dir)/Makefile $(target_rescue_dir)/rescue.bin
-
-zImage: $(target_boot_dir) vmlinux.bin $(target_rescue_dir)/rescue.bin
-## zImage     - Compressed kernel (gzip)
-	@$(MAKE) -f $(src_boot_dir)/Makefile zImage
-
-$(target_boot_dir): $(target_boot_arch_dir)
-	ln -sfn $< $@
-
-$(target_boot_arch_dir):
-	mkdir -p $@
-
-compressed: zImage
-
-archmrproper:
-archclean:
-	@if [ -d arch/$(ARCH)/boot ]; then \
-		$(MAKE) $(clean)=arch/$(ARCH)/boot ; \
-	fi
-	rm -f timage vmlinux.bin decompress.bin rescue.bin cramfs.img
-	rm -rf $(LD_SCRIPT).tmp
-
-archprepare: $(SRC_ARCH)/.links $(srctree)/include/asm-$(ARCH)/.arch
+archprepare: $(SRC_ARCH)/.links $(srctree)/include/asm-$(ARCH)/.arch FORCE
 
 # Create some links to make all tools happy
 $(SRC_ARCH)/.links:
 	@rm -rf $(SRC_ARCH)/drivers
-	@ln -sfn $(SRC_ARCH)/$(SARCH)/drivers $(SRC_ARCH)/drivers
+	@ln -sfn $(SARCH)/drivers $(SRC_ARCH)/drivers
 	@rm -rf $(SRC_ARCH)/boot
-	@ln -sfn $(SRC_ARCH)/$(SARCH)/boot $(SRC_ARCH)/boot
+	@ln -sfn $(SARCH)/boot $(SRC_ARCH)/boot
 	@rm -rf $(SRC_ARCH)/lib
-	@ln -sfn $(SRC_ARCH)/$(SARCH)/lib $(SRC_ARCH)/lib
-	@ln -sfn $(SRC_ARCH)/$(SARCH) $(SRC_ARCH)/arch
-	@ln -sfn $(SRC_ARCH)/$(SARCH)/vmlinux.lds.S $(SRC_ARCH)/kernel/vmlinux.lds.S
-	@ln -sfn $(SRC_ARCH)/$(SARCH)/kernel/asm-offsets.c $(SRC_ARCH)/kernel/asm-offsets.c
+	@ln -sfn $(SARCH)/lib $(SRC_ARCH)/lib
+	@rm -f $(SRC_ARCH)/arch/mach
+	@rm -rf $(SRC_ARCH)/arch
+	@ln -sfn $(SARCH) $(SRC_ARCH)/arch
+ifdef CONFIG_ETRAX_ARCH_V32
+	@ln -sfn ../$(SARCH)/$(MACH) $(SRC_ARCH)/arch/mach
+endif
+	@rm -rf $(SRC_ARCH)/kernel/vmlinux.lds.S
+	@ln -sfn ../$(SARCH)/vmlinux.lds.S $(SRC_ARCH)/kernel/vmlinux.lds.S
+	@rm -rf $(SRC_ARCH)/kernel/asm-offsets.c
+	@ln -sfn ../$(SARCH)/kernel/asm-offsets.c $(SRC_ARCH)/kernel/asm-offsets.c
 	@touch $@
 
 # Create link to sub arch includes
 $(srctree)/include/asm-$(ARCH)/.arch: $(wildcard include/config/arch/*.h)
-	@echo '  Making $(srctree)/include/asm-$(ARCH)/arch -> $(srctree)/include/asm-$(ARCH)/$(SARCH) symlink'
-	@rm -f include/asm-$(ARCH)/arch
-	@ln -sf $(srctree)/include/asm-$(ARCH)/$(SARCH) $(srctree)/include/asm-$(ARCH)/arch
+	@echo '  SYMLINK include/asm-$(ARCH)/arch -> include/asm-$(ARCH)/$(SARCH)'
+	@rm -f $(srctree)/include/asm-$(ARCH)/arch/mach
+	@rm -f $(srctree)/include/asm-$(ARCH)/arch
+	@ln -sf $(SARCH) $(srctree)/include/asm-$(ARCH)/arch
+ifdef CONFIG_ETRAX_ARCH_V32
+	@ln -sf $(MACH) $(srctree)/include/asm-$(ARCH)/arch/mach
+endif
 	@touch $@
+
+archclean:
+	$(Q)if [ -e arch/$(ARCH)/boot ]; then \
+		$(MAKE) $(clean)=arch/$(ARCH)/boot; \
+	fi
+
+CLEAN_FILES += \
+	$(MACHINE)/boot/zImage \
+	$(MACHINE)/boot/compressed/decompress.bin \
+	$(MACHINE)/boot/compressed/piggy.gz \
+	$(MACHINE)/boot/rescue/rescue.bin \
+	$(SRC_ARCH)/.links \
+	$(srctree)/include/asm-$(ARCH)/.arch
+
+MRPROPER_FILES += \
+	$(SRC_ARCH)/drivers \
+	$(SRC_ARCH)/boot \
+	$(SRC_ARCH)/lib \
+	$(SRC_ARCH)/arch \
+	$(SRC_ARCH)/kernel/vmlinux.lds.S \
+	$(SRC_ARCH)/kernel/asm-offsets.c
+
+define archhelp
+  echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
+  echo  '* Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
+endef
-- 
1.5.3.6.970.gd25430

