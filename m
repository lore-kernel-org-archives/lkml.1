Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXL2Umd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXL2Umd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXL2UlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:41:22 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38794 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbXL2UlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:41:20 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@saturn.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Subject: [PATCH 1/5] x86: unification of arch/x86/Makefiles
Date: Sat, 29 Dec 2007 21:41:12 +0100
Message-Id: <1198960876-21159-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20071229203836.GA21020@uranus.ravnborg.org>
References: <20071229203836.GA21020@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@saturn.ravnborg.org>

Unify the 32 and 64 bit specific Makefiles.
The unification was simplest to do in one step although the
readability of the patch suffers a bit from this.

Noteworthy remarks on the unification:
- The 64 bit cpu stuff should be moved to Makefile_32.cpu
  but I did not feel confident doing it due to subtle differences
- The use of cflags-y were abandoned since we have seen one bug where
  we did wrong due to missing assignment to KBUILD_CFLAGS.
  The cc-option marcro uses KBUILD_CFLAGS.
- The "No need to remake" line are deleted. It caused "make -B" to fail
- For 64 bit the sub architecture stuff is not used.
- The way head64.o is specified could be nicer - but it awaits the
  introduction of head32.o (which seems like a win to introduce for readability)
- Patch is checkpatch clean

Patch is tested by doing a defconfig build for i386 and x86_64 and in both
cases monitoring that only relevant files were recompiled when applying
the patch.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86/Makefile    |  243 +++++++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/Makefile_32 |  181 -------------------------------------
 arch/x86/Makefile_64 |  141 -----------------------------
 3 files changed, 239 insertions(+), 326 deletions(-)
 delete mode 100644 arch/x86/Makefile_32
 delete mode 100644 arch/x86/Makefile_64

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 7aa1dc6..e5fbad6 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -7,13 +7,248 @@ else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif
 
-# No need to remake these files
-$(srctree)/arch/x86/Makefile%: ;
+# BITS is used as extension for files which are available in a 32 bit
+# and a 64 bit version to simplify shared Makefiles.
+# e.g.: obj-y += foo_$(BITS).o
+export BITS
 
 ifeq ($(CONFIG_X86_32),y)
+        BITS := 32
         UTS_MACHINE := i386
-        include $(srctree)/arch/x86/Makefile_32
+
+        HAS_BIARCH := $(call cc-option-yn, -m32)
+        ifeq ($(HAS_BIARCH),y)
+                AS := $(AS) --32
+                LD := $(LD) -m elf_i386
+                CC := $(CC) -m32
+        endif
+
+        ifdef CONFIG_RELOCATABLE
+                LDFLAGS_vmlinux := --emit-relocs
+        endif
+        CHECKFLAGS += -D__i386__
+
+        KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
+
+        # prevent gcc from keeping the stack 16 byte aligned
+        KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
+
+        # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+        # a lot more stack due to the lack of sharing of stacklots:
+        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
+                echo $(call cc-option,-fno-unit-at-a-time); fi ;)
+
+        # CPU-specific tuning. Anything which can be shared with UML should go here.
+        include $(srctree)/arch/x86/Makefile_32.cpu
+        KBUILD_CFLAGS += $(cflags-y)
+
+        # temporary until string.h is fixed
+        KBUILD_CFLAGS += -ffreestanding
 else
+        BITS := 64
         UTS_MACHINE := x86_64
-        include $(srctree)/arch/x86/Makefile_64
+        CHECKFLAGS += -D__x86_64__ -m64
+
+        KBUILD_AFLAGS += -m64
+        KBUILD_CFLAGS += -m64
+
+        # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
+        cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
+        cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
+
+        cflags-$(CONFIG_MCORE2) += \
+                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
+        KBUILD_CFLAGS += $(cflags-y)
+
+        KBUILD_CFLAGS += -mno-red-zone
+        KBUILD_CFLAGS += -mcmodel=kernel
+
+        KBUILD_CFLAGS += -Wno-sign-compare
+        KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+        # -funit-at-a-time shrinks the kernel .text considerably
+        # unfortunately it makes reading oopses harder.
+        KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
+
+        # prevent gcc from generating any FP code by mistake
+        KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+        # this works around some issues with generating unwind tables in older gccs
+        # newer gccs do it by default
+        KBUILD_CFLAGS += -maccumulate-outgoing-args
+
+        stackp := $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh
+        stackp-$(CONFIG_CC_STACKPROTECTOR) := $(shell $(stackp) \
+                "$(CC)" -fstack-protector )
+        stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(stackp) \
+                "$(CC)" -fstack-protector-all )
+
+        KBUILD_CFLAGS += $(stackp-y)
+endif
+
+# Stackpointer is addressed different for 32 bit and 64 bit x86
+sp-$(CONFIG_X86_32) := esp
+sp-$(CONFIG_X86_64) := rsp
+
+# do binutils support CFI?
+cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(sp-y)$(comma)0\n.cfi_endproc,-DCONFIG_AS_CFI=1)
+# is .cfi_signal_frame supported too?
+cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
+
+LDFLAGS := -m elf_$(UTS_MACHINE)
+OBJCOPYFLAGS := -O binary -R .note -R .comment -S
+KBUILD_CFLAGS += -pipe
+
+###
+# Sub architecture support
+# fcore-y is linked before mcore-y files.
+
+# Default subarch .c files
+mcore-y  := arch/x86/mach-default
+
+# Voyager subarch support
+mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
+mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
+
+# VISWS subarch support
+mflags-$(CONFIG_X86_VISWS)	:= -Iinclude/asm-x86/mach-visws
+mcore-$(CONFIG_X86_VISWS)	:= arch/x86/mach-visws/
+
+# NUMAQ subarch support
+mflags-$(CONFIG_X86_NUMAQ)	:= -Iinclude/asm-x86/mach-numaq
+mcore-$(CONFIG_X86_NUMAQ)	:= arch/x86/mach-default/
+
+# BIGSMP subarch support
+mflags-$(CONFIG_X86_BIGSMP)	:= -Iinclude/asm-x86/mach-bigsmp
+mcore-$(CONFIG_X86_BIGSMP)	:= arch/x86/mach-default/
+
+# RDC R-321x subarch support
+mflags-$(CONFIG_X86_RDC321X)	:= -Iinclude/asm-x86/mach-rdc321x
+fcore-$(CONFIG_X86_RDC321X)	+= arch/x86/mach-rdc321x/
+mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default/
+
+
+#Summit subarch support
+mflags-$(CONFIG_X86_SUMMIT)	:= -Iinclude/asm-x86/mach-summit
+mcore-$(CONFIG_X86_SUMMIT)	:= arch/x86/mach-default/
+
+# generic subarchitecture
+mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
+fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
+mcore-$(CONFIG_X86_GENERICARCH)	:= arch/x86/mach-default/
+
+
+# ES7000 subarch support
+mflags-$(CONFIG_X86_ES7000)	:= -Iinclude/asm-x86/mach-es7000
+fcore-$(CONFIG_X86_ES7000)	:= arch/x86/mach-es7000/
+mcore-$(CONFIG_X86_ES7000)	:= arch/x86/mach-default/
+
+# default subarch .h files
+mflags-y += -Iinclude/asm-x86/mach-default
+
+# 64 bit does not support subarch support - clear sub arch variables
+fcore-$(CONFIG_X86_64)  :=
+mcore-$(CONFIG_X86_64)  :=
+mflags-$(CONFIG_X86_64) :=
+
+KBUILD_CFLAGS += $(mflags-y)
+KBUILD_AFLAGS += $(mflags-y)
+
+###
+# Kernel objects
+
+head-y                := arch/x86/kernel/head_$(BITS).o
+head-$(CONFIG_X86_64) += arch/x86/kernel/head64.o
+head-y                += arch/x86/kernel/init_task.o
+
+libs-y  += arch/x86/lib/
+
+# Sub architecture files that needs linking first
+core-y += $(fcore-y)
+
+# Xen paravirtualization support
+core-$(CONFIG_XEN) += arch/x86/xen/
+
+# lguest paravirtualization support
+core-$(CONFIG_LGUEST_GUEST) += arch/x86/lguest/
+
+core-y += arch/x86/kernel/
+core-y += arch/x86/mm/
+
+# Remaining sub architecture files
+core-y += $(mcore-y)
+
+core-y += arch/x86/crypto/
+core-y += arch/x86/vdso/
+core-$(CONFIG_IA32_EMULATION) += arch/x86/ia32/
+
+# drivers-y are linked after core-y
+drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
+drivers-$(CONFIG_PCI)            += arch/x86/pci/
+
+# must be linked after kernel/
+drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
+
+ifeq ($(CONFIG_X86_32),y)
+drivers-$(CONFIG_PM) += arch/x86/power/
+drivers-$(CONFIG_FB) += arch/x86/video/
 endif
+
+####
+# boot loader support. Several targets are kept for legacy purposes
+
+boot := arch/x86/boot
+
+PHONY += zImage bzImage compressed zlilo bzlilo \
+         zdisk bzdisk fdimage fdimage144 fdimage288 isoimage install
+
+# Default kernel to build
+all: bzImage
+
+# KBUILD_IMAGE specify target image being built
+                    KBUILD_IMAGE := $(boot)/bzImage
+zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
+
+zImage bzImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
+	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/bzImage
+
+compressed: zImage
+
+zlilo bzlilo: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zlilo
+
+zdisk bzdisk: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zdisk
+
+fdimage fdimage144 fdimage288 isoimage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
+
+install: vdso_install
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+
+PHONY += vdso_install
+vdso_install:
+	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
+
+archclean:
+	$(Q)rm -rf $(objtree)/arch/i386
+	$(Q)rm -rf $(objtree)/arch/x86_64
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+define archhelp
+  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
+  echo  '  install	- Install kernel using'
+  echo  '		   (your) ~/bin/installkernel or'
+  echo  '		   (distribution) /sbin/installkernel or'
+  echo  '		   install to $$(INSTALL_PATH) and run lilo'
+  echo  '  bzdisk       - Create a boot floppy in /dev/fd0'
+  echo  '  fdimage      - Create a boot floppy image'
+  echo  '  isoimage     - Create a boot CD-ROM image'
+endef
+
+CLEAN_FILES += arch/x86/boot/fdimage \
+	       arch/x86/boot/image.iso \
+	       arch/x86/boot/mtools.conf
diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
deleted file mode 100644
index 293eda3..0000000
--- a/arch/x86/Makefile_32
+++ /dev/null
@@ -1,181 +0,0 @@
-#
-# i386 Makefile
-#
-# This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" cleaning up for this architecture.
-#
-# This file is subject to the terms and conditions of the GNU General Public
-# License.  See the file "COPYING" in the main directory of this archive
-# for more details.
-#
-# Copyright (C) 1994 by Linus Torvalds
-#
-# 19990713  Artur Skawina <skawina@geocities.com>
-#           Added '-march' and '-mpreferred-stack-boundary' support
-#
-# 20050320  Kianusch Sayah Karadji <kianusch@sk-tech.net>
-#           Added support for GEODE CPU
-
-# BITS is used as extension for files which are available in a 32 bit
-# and a 64 bit version to simplify shared Makefiles.
-# e.g.: obj-y += foo_$(BITS).o
-BITS := 32
-export BITS
-
-HAS_BIARCH      := $(call cc-option-yn, -m32)
-ifeq ($(HAS_BIARCH),y)
-AS              := $(AS) --32
-LD              := $(LD) -m elf_i386
-CC              := $(CC) -m32
-endif
-
-LDFLAGS		:= -m elf_i386
-OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
-ifdef CONFIG_RELOCATABLE
-LDFLAGS_vmlinux := --emit-relocs
-endif
-CHECKFLAGS	+= -D__i386__
-
-KBUILD_CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
-
-# prevent gcc from keeping the stack 16 byte aligned
-KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
-
-# CPU-specific tuning. Anything which can be shared with UML should go here.
-include $(srctree)/arch/x86/Makefile_32.cpu
-
-# temporary until string.h is fixed
-cflags-y += -ffreestanding
-
-# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
-# a lot more stack due to the lack of sharing of stacklots:
-KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
-
-# do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-
-# is .cfi_signal_frame supported too?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
-KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
-
-KBUILD_CFLAGS += $(cflags-y)
-
-# Default subarch .c files
-mcore-y  := arch/x86/mach-default
-
-# Voyager subarch support
-mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
-mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager
-
-# VISWS subarch support
-mflags-$(CONFIG_X86_VISWS)	:= -Iinclude/asm-x86/mach-visws
-mcore-$(CONFIG_X86_VISWS)	:= arch/x86/mach-visws
-
-# NUMAQ subarch support
-mflags-$(CONFIG_X86_NUMAQ)	:= -Iinclude/asm-x86/mach-numaq
-mcore-$(CONFIG_X86_NUMAQ)	:= arch/x86/mach-default
-
-# BIGSMP subarch support
-mflags-$(CONFIG_X86_BIGSMP)	:= -Iinclude/asm-x86/mach-bigsmp
-mcore-$(CONFIG_X86_BIGSMP)	:= arch/x86/mach-default
-
-# RDC R-321x subarch support
-mflags-$(CONFIG_X86_RDC321X)	:= -Iinclude/asm-x86/mach-rdc321x
-mcore-$(CONFIG_X86_RDC321X)	:= arch/x86/mach-default
-core-$(CONFIG_X86_RDC321X)	+= arch/x86/mach-rdc321x/
-
-#Summit subarch support
-mflags-$(CONFIG_X86_SUMMIT) := -Iinclude/asm-x86/mach-summit
-mcore-$(CONFIG_X86_SUMMIT)  := arch/x86/mach-default
-
-# generic subarchitecture
-mflags-$(CONFIG_X86_GENERICARCH) := -Iinclude/asm-x86/mach-generic
-mcore-$(CONFIG_X86_GENERICARCH) := arch/x86/mach-default
-core-$(CONFIG_X86_GENERICARCH) += arch/x86/mach-generic/
-
-# ES7000 subarch support
-mflags-$(CONFIG_X86_ES7000)	:= -Iinclude/asm-x86/mach-es7000
-mcore-$(CONFIG_X86_ES7000)	:= arch/x86/mach-default
-core-$(CONFIG_X86_ES7000)	:= arch/x86/mach-es7000/
-
-# Xen paravirtualization support
-core-$(CONFIG_XEN)		+= arch/x86/xen/
-
-# lguest paravirtualization support
-core-$(CONFIG_LGUEST_GUEST)	+= arch/x86/lguest/
-
-# default subarch .h files
-mflags-y += -Iinclude/asm-x86/mach-default
-
-head-y := arch/x86/kernel/head_32.o arch/x86/kernel/init_task.o
-
-libs-y 					+= arch/x86/lib/
-core-y					+= arch/x86/kernel/ \
-					   arch/x86/mm/ \
-					   $(mcore-y)/ \
-					   arch/x86/crypto/ \
-					   arch/x86/vdso/
-drivers-$(CONFIG_MATH_EMULATION)	+= arch/x86/math-emu/
-drivers-$(CONFIG_PCI)			+= arch/x86/pci/
-# must be linked after kernel/
-drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
-drivers-$(CONFIG_PM)			+= arch/x86/power/
-drivers-$(CONFIG_FB)                    += arch/x86/video/
-
-KBUILD_CFLAGS += $(mflags-y)
-KBUILD_AFLAGS += $(mflags-y)
-
-boot := arch/x86/boot
-
-PHONY += zImage bzImage compressed zlilo bzlilo \
-         zdisk bzdisk fdimage fdimage144 fdimage288 isoimage install
-
-all: bzImage
-
-# KBUILD_IMAGE specify target image being built
-                    KBUILD_IMAGE := $(boot)/bzImage
-zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
-
-zImage bzImage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
-	$(Q)mkdir -p $(objtree)/arch/i386/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
-
-compressed: zImage
-
-zlilo bzlilo: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zlilo
-
-zdisk bzdisk: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zdisk
-
-fdimage fdimage144 fdimage288 isoimage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
-
-install: vdso_install
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
-
-PHONY += vdso_install
-vdso_install:
-	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
-
-archclean:
-	$(Q)rm -rf $(objtree)/arch/i386/boot
-	$(Q)$(MAKE) $(clean)=arch/x86/boot
-
-define archhelp
-  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
-  echo  '  install	- Install kernel using'
-  echo  '		   (your) ~/bin/installkernel or'
-  echo  '		   (distribution) /sbin/installkernel or'
-  echo  '		   install to $$(INSTALL_PATH) and run lilo'
-  echo  '  bzdisk       - Create a boot floppy in /dev/fd0'
-  echo  '  fdimage      - Create a boot floppy image'
-  echo  '  isoimage     - Create a boot CD-ROM image'
-endef
-
-CLEAN_FILES += arch/x86/boot/fdimage \
-	       arch/x86/boot/image.iso \
-	       arch/x86/boot/mtools.conf
diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
deleted file mode 100644
index d12bb14..0000000
--- a/arch/x86/Makefile_64
+++ /dev/null
@@ -1,141 +0,0 @@
-#
-# x86_64 Makefile
-#
-# This file is included by the global makefile so that you can add your own
-# architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" and "archdep" for cleaning up and making dependencies for
-# this architecture
-#
-# This file is subject to the terms and conditions of the GNU General Public
-# License.  See the file "COPYING" in the main directory of this archive
-# for more details.
-#
-# Copyright (C) 1994 by Linus Torvalds
-#
-# 19990713  Artur Skawina <skawina@geocities.com>
-#           Added '-march' and '-mpreferred-stack-boundary' support
-# 20000913  Pavel Machek <pavel@suse.cz>
-#	    Converted for x86_64 architecture
-# 20010105  Andi Kleen, add IA32 compiler.
-#           ....and later removed it again....
-#
-# $Id: Makefile,v 1.31 2002/03/22 15:56:07 ak Exp $
-
-# BITS is used as extension for files which are available in a 32 bit
-# and a 64 bit version to simplify shared Makefiles.
-# e.g.: obj-y += foo_$(BITS).o
-BITS := 64
-export BITS
-
-LDFLAGS		:= -m elf_x86_64
-OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
-LDFLAGS_vmlinux :=
-CHECKFLAGS      += -D__x86_64__ -m64
-
-cflags-y	:=
-cflags-kernel-y	:=
-cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
-cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
-# gcc doesn't support -march=core2 yet as of gcc 4.3, but I hope it
-# will eventually. Use -mtune=generic as fallback
-cflags-$(CONFIG_MCORE2) += \
-	$(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
-cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
-
-cflags-y += -m64
-cflags-y += -mno-red-zone
-cflags-y += -mcmodel=kernel
-cflags-y += -pipe
-cflags-y += -Wno-sign-compare
-cflags-y += -fno-asynchronous-unwind-tables
-ifneq ($(CONFIG_DEBUG_INFO),y)
-# -fweb shrinks the kernel a bit, but the difference is very small
-# it also messes up debugging, so don't use it for now.
-#cflags-y += $(call cc-option,-fweb)
-endif
-# -funit-at-a-time shrinks the kernel .text considerably
-# unfortunately it makes reading oopses harder.
-cflags-y += $(call cc-option,-funit-at-a-time)
-# prevent gcc from generating any FP code by mistake
-cflags-y += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
-# this works around some issues with generating unwind tables in older gccs
-# newer gccs do it by default
-cflags-y += -maccumulate-outgoing-args
-
-# do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-
-# is .cfi_signal_frame supported too?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
-KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
-
-cflags-$(CONFIG_CC_STACKPROTECTOR) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector )
-cflags-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector-all )
-
-KBUILD_CFLAGS += $(cflags-y)
-CFLAGS_KERNEL += $(cflags-kernel-y)
-KBUILD_AFLAGS += -m64
-
-head-y := arch/x86/kernel/head_64.o arch/x86/kernel/head64.o arch/x86/kernel/init_task.o
-
-libs-y 					+= arch/x86/lib/
-core-y					+= arch/x86/kernel/ \
-					   arch/x86/mm/ \
-					   arch/x86/crypto/ \
-					   arch/x86/vdso/
-core-$(CONFIG_IA32_EMULATION)		+= arch/x86/ia32/
-drivers-$(CONFIG_PCI)			+= arch/x86/pci/
-drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
-
-boot := arch/x86/boot
-
-PHONY += bzImage bzlilo install archmrproper \
-	 fdimage fdimage144 fdimage288 isoimage archclean
-
-#Default target when executing "make"
-all: bzImage
-
-BOOTIMAGE                     := arch/x86/boot/bzImage
-KBUILD_IMAGE                  := $(BOOTIMAGE)
-
-bzImage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) $(BOOTIMAGE)
-	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
-
-bzlilo: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zlilo
-
-bzdisk: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zdisk
-
-fdimage fdimage144 fdimage288 isoimage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@
-
-install: vdso_install
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
-
-vdso_install:
-	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
-
-archclean:
-	$(Q)rm -rf $(objtree)/arch/x86_64/boot
-	$(Q)$(MAKE) $(clean)=$(boot)
-
-define archhelp
-  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
-  echo  '  install	- Install kernel using'
-  echo  '		   (your) ~/bin/installkernel or'
-  echo  '		   (distribution) /sbin/installkernel or'
-  echo  '		   install to $$(INSTALL_PATH) and run lilo'
-  echo  '  bzdisk       - Create a boot floppy in /dev/fd0'
-  echo  '  fdimage      - Create a boot floppy image'
-  echo  '  isoimage     - Create a boot CD-ROM image'
-endef
-
-CLEAN_FILES += arch/x86/boot/fdimage \
-	       arch/x86/boot/image.iso \
-	       arch/x86/boot/mtools.conf
-
-
-- 
1.5.3.7.1112.g9758e

