Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXKZOAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXKZOAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXKZOAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:00:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:22602 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXKZOAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=MI/3raRE6cB+M4q0oMbS0c1CKYYp8c845j+yWR69ixohXZ5QA5g3DEKpM4Nv7CRfe/R5kPK0JDxRIhmIcVUoNyEf1wCNKrZgqQg2BFoxXVKUbxqaJdWI0Di515/wkE8EuFRVClAsuoLERE8hqV5xNjF7innMVxRmHn/Ol2znEm8=
Date: Mon, 26 Nov 2007 15:00:12 +0100
From: Loic Grenie <loic.grenie@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] Make arch/x86/Makefile_{32,64} more similar
Message-ID: <20071126140012.GB17093@cognac.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


   This is a patch to improve the similarity between arch/x86/Makefile_32
   and arch/x86/Makefile_64. The remaining differences between both
   makefiles are nearly trivial and it is probably possible to collapse
   most of them in arch/x86/Makefile, leaving only a few assignements
   in arch/x86/Makefile_??.

      Some observations:

   - I have added UTS_MACHINE (I don't know if it's needed or correct) and
     used it.
   - I have modified two orders:
     in Makefile_32, core-y has two directory names inverted
     in Makefile_64, I've inverted init_task.o and head64.o
     In addition the order of elements in the PHONY variable has been
     modified.
   - I think my modifications for zlilo, zImage, compressed and zdisk
     targets are correct, but it may be a good idea to check.
   - I've added a variable stackreg and used it to define cflags-y and
     KBUILD_AFLAGS, I'd like a Makefile-guru to check what I've written.
   - Some of the remaining differences between both Makefile's look
     strange, maybe a little cleanup is needed.

  I attach a diff between the patched Makefile's.

     Kindly,

        Loïc Grenié


Signed-off-by: Loïc Grenié <loic.grenie@gmail.com>
---
 arch/x86/Makefile_32 |   66 +++++++++++++++++++++++++++----------------------
 arch/x86/Makefile_64 |   49 +++++++++++++++++++-----------------
 2 files changed, 62 insertions(+), 53 deletions(-)

diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
index 50394da..e11c123 100644
--- a/arch/x86/Makefile_32
+++ b/arch/x86/Makefile_32
@@ -3,7 +3,8 @@
 #
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies. Remember to do have actions
-# for "archclean" cleaning up for this architecture.
+# for "archclean" and "archdep" for cleaning up and making dependencies for
+# this architecture
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -22,6 +23,7 @@
 # e.g.: obj-y += foo_$(BITS).o
 BITS := 32
 export BITS
+UTS_MACHINE := i386
 
 HAS_BIARCH      := $(call cc-option-yn, -m32)
 ifeq ($(HAS_BIARCH),y)
@@ -30,12 +32,12 @@ LD              := $(LD) -m elf_i386
 CC              := $(CC) -m32
 endif
 
-LDFLAGS		:= -m elf_i386
+LDFLAGS		:= -m elf_$(UTS_MACHINE)
 OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
 ifdef CONFIG_RELOCATABLE
 LDFLAGS_vmlinux := --emit-relocs
 endif
-CHECKFLAGS	+= -D__i386__
+CHECKFLAGS	+= -D__$(UTS_MACHINE)__
 
 KBUILD_CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
 
@@ -57,15 +59,14 @@ cflags-y += -maccumulate-outgoing-args
 KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset esp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+stackreg=esp
+cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(stackreg)${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(stackreg)${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
 KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
 
-KBUILD_CFLAGS += $(cflags-y)
-
 # Default subarch .c files
 mcore-y  := arch/x86/mach-default
 
@@ -108,13 +109,18 @@ core-$(CONFIG_LGUEST_GUEST)	+= arch/x86/lguest/
 # default subarch .h files
 mflags-y += -Iinclude/asm-x86/mach-default
 
-head-y := arch/x86/kernel/head_32.o arch/x86/kernel/init_task.o
+KBUILD_CFLAGS += $(cflags-y)
+KBUILD_CFLAGS += $(mflags-y)
+KBUILD_AFLAGS += $(mflags-y)
+
+head-y := arch/x86/kernel/head_$(BITS).o arch/x86/kernel/init_task.o \
+
 
 libs-y 					+= arch/x86/lib/
 core-y					+= arch/x86/kernel/ \
 					   arch/x86/mm/ \
-					   $(mcore-y)/ \
-					   arch/x86/crypto/
+					   arch/x86/crypto/ \
+					   $(mcore-y)/
 drivers-$(CONFIG_MATH_EMULATION)	+= arch/x86/math-emu/
 drivers-$(CONFIG_PCI)			+= arch/x86/pci/
 # must be linked after kernel/
@@ -122,45 +128,45 @@ drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
 drivers-$(CONFIG_PM)			+= arch/x86/power/
 drivers-$(CONFIG_FB)                    += arch/x86/video/
 
-KBUILD_CFLAGS += $(mflags-y)
-KBUILD_AFLAGS += $(mflags-y)
-
 boot := arch/x86/boot
 
-PHONY += zImage bzImage compressed zlilo bzlilo \
-         zdisk bzdisk fdimage fdimage144 fdimage288 isoimage install
+PHONY += bzImage bzlilo install fdimage fdimage144 fdimage288 isoimage \
+         zImage compressed zlilo zdisk bzdisk
 
+#Default target when executing "make"
 all: bzImage
 
 # KBUILD_IMAGE specify target image being built
-                    KBUILD_IMAGE := $(boot)/bzImage
-zImage zlilo zdisk: KBUILD_IMAGE := arch/x86/boot/zImage
+KBUILD_IMAGE                     := $(boot)/bzImage
+zImage zlilo zdisk: KBUILD_IMAGE := $(boot)/zImage
 
-zImage bzImage: vmlinux
+bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
-	$(Q)mkdir -p $(objtree)/arch/i386/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/i386/boot/bzImage
+	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/bzImage
 
-compressed: zImage
+compressed zImage: bzImage
 
-zlilo bzlilo: vmlinux
+bzlilo: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zlilo
 
-zdisk bzdisk: vmlinux
+bzdisk: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zdisk
 
+zdisk: bzdisk
+
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
 install:
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
 archclean:
-	$(Q)rm -rf $(objtree)/arch/i386/boot
-	$(Q)$(MAKE) $(clean)=arch/x86/boot
+	$(Q)rm -rf $(objtree)/arch/$(UTS_MACHINE)/boot
+	$(Q)$(MAKE) $(clean)=$(boot)
 
 define archhelp
-  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
+  echo  '* bzImage	- Compressed kernel image ($(boot)/bzImage)'
   echo  '  install	- Install kernel using'
   echo  '		   (your) ~/bin/installkernel or'
   echo  '		   (distribution) /sbin/installkernel or'
@@ -170,6 +176,6 @@ define archhelp
   echo  '  isoimage     - Create a boot CD-ROM image'
 endef
 
-CLEAN_FILES += arch/x86/boot/fdimage \
-	       arch/x86/boot/image.iso \
-	       arch/x86/boot/mtools.conf
+CLEAN_FILES += $(boot)/fdimage \
+	       $(boot)/image.iso \
+	       $(boot)/mtools.conf
diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
index a804860..4b137ba 100644
--- a/arch/x86/Makefile_64
+++ b/arch/x86/Makefile_64
@@ -26,11 +26,13 @@
 # e.g.: obj-y += foo_$(BITS).o
 BITS := 64
 export BITS
+UTS_MACHINE := x86_64
 
-LDFLAGS		:= -m elf_x86_64
+LDFLAGS		:= -m elf_$(UTS_MACHINE)
 OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
 LDFLAGS_vmlinux :=
-CHECKFLAGS      += -D__x86_64__ -m64
+CHECKFLAGS	+= -D__$(UTS_MACHINE)__
+CHECKFLAGS	+= -m64
 
 cflags-y	:=
 cflags-kernel-y	:=
@@ -63,8 +65,9 @@ cflags-y += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 cflags-y += -maccumulate-outgoing-args
 
 # do binutils support CFI?
-cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
-KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset rsp${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+stackreg=rsp
+cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(stackreg)${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
+KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(stackreg)${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
 # is .cfi_signal_frame supported too?
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
@@ -77,7 +80,8 @@ KBUILD_CFLAGS += $(cflags-y)
 CFLAGS_KERNEL += $(cflags-kernel-y)
 KBUILD_AFLAGS += -m64
 
-head-y := arch/x86/kernel/head_64.o arch/x86/kernel/head64.o arch/x86/kernel/init_task.o
+head-y := arch/x86/kernel/head_$(BITS).o arch/x86/kernel/init_task.o \
+		arch/x86/kernel/head64.o
 
 libs-y 					+= arch/x86/lib/
 core-y					+= arch/x86/kernel/ \
@@ -86,35 +90,36 @@ core-y					+= arch/x86/kernel/ \
 					   arch/x86/vdso/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86/pci/
+# must be linked after kernel/
 drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
 
 boot := arch/x86/boot
 
-PHONY += bzImage bzlilo install archmrproper \
-	 fdimage fdimage144 fdimage288 isoimage archclean
+PHONY += bzImage bzlilo install fdimage fdimage144 fdimage288 isoimage \
+	 archclean archmrproper
 
 #Default target when executing "make"
 all: bzImage
 
-BOOTIMAGE                     := arch/x86/boot/bzImage
-KBUILD_IMAGE                  := $(BOOTIMAGE)
+# KBUILD_IMAGE specify target image being built
+KBUILD_IMAGE                     := $(boot)/bzImage
 
 bzImage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) $(BOOTIMAGE)
-	$(Q)mkdir -p $(objtree)/arch/x86_64/boot
-	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/x86_64/boot/bzImage
+	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
+	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
+	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/bzImage
 
 bzlilo: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zlilo
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zlilo
 
 bzdisk: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) zdisk
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zdisk
 
 fdimage fdimage144 fdimage288 isoimage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
 install: vdso_install
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(BOOTIMAGE) $@ 
+	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
 vdso_install:
 ifeq ($(CONFIG_IA32_EMULATION),y)
@@ -123,11 +128,11 @@ endif
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
 
 archclean:
-	$(Q)rm -rf $(objtree)/arch/x86_64/boot
+	$(Q)rm -rf $(objtree)/arch/$(UTS_MACHINE)/boot
 	$(Q)$(MAKE) $(clean)=$(boot)
 
 define archhelp
-  echo  '* bzImage	- Compressed kernel image (arch/x86/boot/bzImage)'
+  echo  '* bzImage	- Compressed kernel image ($(boot)/bzImage)'
   echo  '  install	- Install kernel using'
   echo  '		   (your) ~/bin/installkernel or'
   echo  '		   (distribution) /sbin/installkernel or'
@@ -137,8 +142,6 @@ define archhelp
   echo  '  isoimage     - Create a boot CD-ROM image'
 endef
 
-CLEAN_FILES += arch/x86/boot/fdimage \
-	       arch/x86/boot/image.iso \
-	       arch/x86/boot/mtools.conf
-
-
+CLEAN_FILES += $(boot)/fdimage \
+	       $(boot)/image.iso \
+	       $(boot)/mtools.conf
-- 
1.5.3.4

--GRPZ8SYKNexpdSJ7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x86mkf.diff"

diff -u a/arch/x86/Makefile_32 b/arch/x86/Makefile_64
--- a/arch/x86/Makefile_32	2007-11-23 13:05:13.000000000 +0100
+++ b/arch/x86/Makefile_64	2007-11-23 13:05:13.000000000 +0100
@@ -1,5 +1,5 @@
 #
-# i386 Makefile
+# x86_64 Makefile
 #
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies. Remember to do have actions
@@ -14,52 +14,58 @@
 #
 # 19990713  Artur Skawina <skawina@geocities.com>
 #           Added '-march' and '-mpreferred-stack-boundary' support
+# 20000913  Pavel Machek <pavel@suse.cz>
+#	    Converted for x86_64 architecture
+# 20010105  Andi Kleen, add IA32 compiler.
+#           ....and later removed it again....
 #
-# 20050320  Kianusch Sayah Karadji <kianusch@sk-tech.net>
-#           Added support for GEODE CPU
+# $Id: Makefile,v 1.31 2002/03/22 15:56:07 ak Exp $
 
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
 # e.g.: obj-y += foo_$(BITS).o
-BITS := 32
+BITS := 64
 export BITS
-UTS_MACHINE := i386
-
-HAS_BIARCH      := $(call cc-option-yn, -m32)
-ifeq ($(HAS_BIARCH),y)
-AS              := $(AS) --32
-LD              := $(LD) -m elf_i386
-CC              := $(CC) -m32
-endif
+UTS_MACHINE := x86_64
 
 LDFLAGS		:= -m elf_$(UTS_MACHINE)
 OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
-ifdef CONFIG_RELOCATABLE
-LDFLAGS_vmlinux := --emit-relocs
-endif
+LDFLAGS_vmlinux :=
 CHECKFLAGS	+= -D__$(UTS_MACHINE)__
+CHECKFLAGS	+= -m64
 
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
+cflags-y	:=
+cflags-kernel-y	:=
+cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
+cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
+# gcc doesn't support -march=core2 yet as of gcc 4.3, but I hope it
+# will eventually. Use -mtune=generic as fallback
+cflags-$(CONFIG_MCORE2) += \
+	$(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
+
+cflags-y += -m64
+cflags-y += -mno-red-zone
+cflags-y += -mcmodel=kernel
+cflags-y += -pipe
+cflags-y += -Wno-sign-compare
+cflags-y += -fno-asynchronous-unwind-tables
+ifneq ($(CONFIG_DEBUG_INFO),y)
+# -fweb shrinks the kernel a bit, but the difference is very small
+# it also messes up debugging, so don't use it for now.
+#cflags-y += $(call cc-option,-fweb)
+endif
+# -funit-at-a-time shrinks the kernel .text considerably
+# unfortunately it makes reading oopses harder.
+cflags-y += $(call cc-option,-funit-at-a-time)
+# prevent gcc from generating any FP code by mistake
+cflags-y += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 # this works around some issues with generating unwind tables in older gccs
 # newer gccs do it by default
 cflags-y += -maccumulate-outgoing-args
 
-# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
-# a lot more stack due to the lack of sharing of stacklots:
-KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
-
 # do binutils support CFI?
-stackreg=esp
+stackreg=rsp
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(stackreg)${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(stackreg)${comma}0\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
 
@@ -67,100 +73,60 @@
 cflags-y += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
 KBUILD_AFLAGS += $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1,)
 
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
+cflags-$(CONFIG_CC_STACKPROTECTOR) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector )
+cflags-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh "$(CC)" -fstack-protector-all )
 
 KBUILD_CFLAGS += $(cflags-y)
-KBUILD_CFLAGS += $(mflags-y)
-KBUILD_AFLAGS += $(mflags-y)
+CFLAGS_KERNEL += $(cflags-kernel-y)
+KBUILD_AFLAGS += -m64
 
 head-y := arch/x86/kernel/head_$(BITS).o arch/x86/kernel/init_task.o \
-
+		arch/x86/kernel/head64.o
 
 libs-y 					+= arch/x86/lib/
 core-y					+= arch/x86/kernel/ \
 					   arch/x86/mm/ \
 					   arch/x86/crypto/ \
-					   $(mcore-y)/
-drivers-$(CONFIG_MATH_EMULATION)	+= arch/x86/math-emu/
+					   arch/x86/vdso/
+core-$(CONFIG_IA32_EMULATION)		+= arch/x86/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86/pci/
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
-drivers-$(CONFIG_PM)			+= arch/x86/power/
-drivers-$(CONFIG_FB)                    += arch/x86/video/
 
 boot := arch/x86/boot
 
 PHONY += bzImage bzlilo install fdimage fdimage144 fdimage288 isoimage \
-         zImage compressed zlilo zdisk bzdisk
+	 archclean archmrproper
 
 #Default target when executing "make"
 all: bzImage
 
 # KBUILD_IMAGE specify target image being built
 KBUILD_IMAGE                     := $(boot)/bzImage
-zImage zlilo zdisk: KBUILD_IMAGE := $(boot)/zImage
 
 bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
 	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/bzImage
 
-compressed zImage: bzImage
-
 bzlilo: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zlilo
 
 bzdisk: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zdisk
 
-zdisk: bzdisk
-
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
+vdso_install:
+ifeq ($(CONFIG_IA32_EMULATION),y)
+	$(Q)$(MAKE) $(build)=arch/x86/ia32 $@
+endif
+	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
+
 archclean:
 	$(Q)rm -rf $(objtree)/arch/$(UTS_MACHINE)/boot
 	$(Q)$(MAKE) $(clean)=$(boot)

--GRPZ8SYKNexpdSJ7--
