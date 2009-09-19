Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZISOwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZISOwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 10:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZISOwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 10:52:04 -0400
Received: from [195.41.46.236] ([195.41.46.236]:58500 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZISOwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 10:52:02 -0400
Date: Sat, 19 Sep 2009 16:51:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Russell King <linux@arm.linux.org.uk>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH] arm, cris, mips, sparc, powerpc, um, xtensa: fix build
	with bash 4.0
Message-ID: <20090919145157.GA26137@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is submitted to kbuild-next today.
Sorry for being late in the merge window with this!

Testing would be appraciated so I do not introduce
build errors.
Especially mips.

	Sam

commit 8ddcb5b9c1dd42f4fd0f79931330773243cf25cf
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sat Sep 19 16:34:22 2009 +0200

    arm, cris, mips, sparc, powerpc, um, xtensa: fix build with bash 4.0
    
    Albin Tonnerre <albin.tonnerre@free-electrons.com> reported:
    
        Bash 4 filters out variables which contain a dot in them.
        This happends to be the case of CPPFLAGS_vmlinux.lds.
        This is rather unfortunate, as it now causes
        build failures when using SHELL=/bin/bash to compile,
        or when bash happens to be used by make (eg when it's /bin/sh)
    
    Remove the common definition of CPPFLAGS_vmlinux.lds by
    pushing relevant stuff to either Makefile.build or the
    arch specific kernel/Makefile where we build the linker script.
    
    This is also nice cleanup as we move the information out where
    it is used.
    
    Notes for the different architectures touched:
    
    arm - we use an already exported symbol
    cris - we use a config symbol aleady available
           [Not build tested]
    mips - the jiffies complexity has moved to vmlinux.lds.S where we need it.
           Added a few variables to CPPFLAGS - they are only used by
           the linker script.
           [Not build tested]
    powerpc - removed assignment that is not needed
              [not build tested]
    sparc - simplified it using $(BITS)
    um - introduced a few new exported variables to deal with this
    xtensa - added options to CPP invocation
             [not build tested]
    
    Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
    Cc: Russell King <linux@arm.linux.org.uk>
    Cc: Mikael Starvik <starvik@axis.com>
    Cc: Jesper Nilsson <jesper.nilsson@axis.com>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: Jeff Dike <jdike@addtoit.com>
    Cc: Chris Zankel <chris@zankel.net>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Makefile b/Makefile
index c41035a..5045f43 100644
--- a/Makefile
+++ b/Makefile
@@ -1016,11 +1016,6 @@ prepare0: archprepare FORCE
 # All the preparing..
 prepare: prepare0
 
-# Leave this as default for preprocessing vmlinux.lds.S, which is now
-# done in arch/$(ARCH)/kernel/Makefile
-
-export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
-
 # The asm symlink changes when $(ARCH) changes.
 # Detect this and ask user to run make mrproper
 # If asm is a stale symlink (point to dir that does not exist) remove it
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 68c6ab0..c695fda 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -14,7 +14,7 @@ LDFLAGS_vmlinux	:=-p --no-undefined -X
 ifeq ($(CONFIG_CPU_ENDIAN_BE8),y)
 LDFLAGS_vmlinux	+= --be8
 endif
-CPPFLAGS_vmlinux.lds = -DTEXT_OFFSET=$(TEXT_OFFSET)
+
 OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
 GZFLAGS		:=-9
 #KBUILD_CFLAGS	+=-pipe
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 3213c93..c446aef 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -2,7 +2,8 @@
 # Makefile for the linux kernel.
 #
 
-AFLAGS_head.o := -DTEXT_OFFSET=$(TEXT_OFFSET)
+CPPFLAGS_vmlinux.lds := -DTEXT_OFFSET=$(TEXT_OFFSET)
+AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 ifdef CONFIG_DYNAMIC_FTRACE
 CFLAGS_REMOVE_ftrace.o = -pg
diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index 71e17d3..29c2ceb 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -42,8 +42,6 @@ LD = $(CROSS_COMPILE)ld -mcrislinux
 
 OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 
-CPPFLAGS_vmlinux.lds = -DDRAM_VIRTUAL_BASE=0x$(CONFIG_ETRAX_DRAM_VIRTUAL_BASE)
-
 KBUILD_AFLAGS += -mlinux -march=$(arch-y) $(inc)
 KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe $(inc)
 KBUILD_CPPFLAGS += $(inc)
diff --git a/arch/cris/kernel/Makefile b/arch/cris/kernel/Makefile
index ee7bcd4..b45640b 100644
--- a/arch/cris/kernel/Makefile
+++ b/arch/cris/kernel/Makefile
@@ -3,6 +3,7 @@
 # Makefile for the linux kernel.
 #
 
+CPPFLAGS_vmlinux.lds := -DDRAM_VIRTUAL_BASE=0x$(CONFIG_ETRAX_DRAM_VIRTUAL_BASE)
 extra-y	:= vmlinux.lds
 
 obj-y   := process.o traps.o irq.o ptrace.o setup.o time.o sys_cris.o
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index c825b14..77f5021 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -627,16 +627,6 @@ endif
 cflags-y			+= -I$(srctree)/arch/mips/include/asm/mach-generic
 drivers-$(CONFIG_PCI)		+= arch/mips/pci/
 
-ifdef CONFIG_32BIT
-ifdef CONFIG_CPU_LITTLE_ENDIAN
-JIFFIES			= jiffies_64
-else
-JIFFIES			= jiffies_64 + 4
-endif
-else
-JIFFIES			= jiffies_64
-endif
-
 #
 # Automatically detect the build format. By default we choose
 # the elf format according to the load address.
@@ -660,8 +650,9 @@ ifdef CONFIG_64BIT
 endif
 
 KBUILD_AFLAGS	+= $(cflags-y)
-KBUILD_CFLAGS	+= $(cflags-y) \
-			-D"VMLINUX_LOAD_ADDRESS=$(load-y)"
+KBUILD_CFLAGS	+= $(cflags-y)
+KBUILD_CPPFLAGS += -D"VMLINUX_LOAD_ADDRESS=$(load-y)"
+KBUILD_CPPFLAGS += -D"DATAOFFSET=$(if $(dataoffset-y),$(dataoffset-y),0)"
 
 LDFLAGS			+= -m $(ld-emul)
 
@@ -676,18 +667,6 @@ endif
 
 OBJCOPYFLAGS		+= --remove-section=.reginfo
 
-#
-# Choosing incompatible machines durings configuration will result in
-# error messages during linking.  Select a default linkscript if
-# none has been choosen above.
-#
-
-CPPFLAGS_vmlinux.lds := \
-	$(KBUILD_CFLAGS) \
-	-D"LOADADDR=$(load-y)" \
-	-D"JIFFIES=$(JIFFIES)" \
-	-D"DATAOFFSET=$(if $(dataoffset-y),$(dataoffset-y),0)"
-
 head-y := arch/mips/kernel/head.o arch/mips/kernel/init_task.o
 
 libs-y			+= arch/mips/lib/
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 2769bed..36cd85e 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -10,7 +10,16 @@ PHDRS {
 	text PT_LOAD FLAGS(7);	/* RWX */
 	note PT_NOTE FLAGS(4);	/* R__ */
 }
-jiffies = JIFFIES;
+
+ifdef CONFIG_32BIT
+	ifdef CONFIG_CPU_LITTLE_ENDIAN
+		jiffies  = jiffies_64
+	else
+		jiffies  = jiffies_64 + 4
+	endif
+else
+	jiffies  = jiffies_64
+endif
 
 SECTIONS
 {
@@ -29,7 +38,7 @@ SECTIONS
 	/* . = 0xa800000000300000; */
 	. = 0xffffffff80300000;
 #endif
-	. = LOADADDR;
+	. = VMLINUX_LOAD_ADDRESS;
 	/* read-only */
 	_text = .;	/* Text and read-only data */
 	.text : {
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 13e3fd8..aacf629 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -158,8 +158,6 @@ drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 # Default to zImage, override when needed
 all: zImage
 
-CPPFLAGS_vmlinux.lds	:= -Upowerpc
-
 BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
 
 PHONY += $(BOOT_TARGETS)
diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index 467221d..dfe272d 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -31,7 +31,6 @@ export BITS    := 32
 #KBUILD_CFLAGS += -g -pipe -fcall-used-g5 -fcall-used-g7
 KBUILD_CFLAGS += -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7
 KBUILD_AFLAGS += -m32
-CPPFLAGS_vmlinux.lds += -m32
 
 #LDFLAGS_vmlinux = -N -Ttext 0xf0004000
 #  Since 2.5.40, the first stage is left not btfix-ed.
@@ -45,9 +44,6 @@ else
 
 CHECKFLAGS      += -D__sparc__ -D__sparc_v9__ -D__arch64__ -m64
 
-# Undefine sparc when processing vmlinux.lds - it is used
-# And teach CPP we are doing 64 bit builds (for this case)
-CPPFLAGS_vmlinux.lds += -m64 -Usparc
 LDFLAGS              := -m elf64_sparc
 export BITS          := 64
 
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 247cc62..96aad39 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -7,7 +7,11 @@ ccflags-y := -Werror
 
 extra-y     := head_$(BITS).o
 extra-y     += init_task.o
-extra-y     += vmlinux.lds
+
+# Undefine sparc when processing vmlinux.lds - it is used
+# And teach CPP we are doing $(BITS) builds (for this case)
+CPPFLAGS_vmlinux.lds := -Usparc -m$(BITS)
+extra-y              += vmlinux.lds
 
 obj-$(CONFIG_SPARC32)   += entry.o wof.o wuf.o
 obj-$(CONFIG_SPARC32)   += etrap_32.o
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0728def..fc633db 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -96,11 +96,10 @@ CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,)
 	$(call cc-option, -fno-stack-protector,) \
 	$(call cc-option, -fno-stack-protector-all,)
 
-CONFIG_KERNEL_STACK_ORDER ?= 2
-STACK_SIZE := $(shell echo $$[ 4096 * (1 << $(CONFIG_KERNEL_STACK_ORDER)) ] )
-
-CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
-	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
+# Options used by linker script
+export LDS_START      := $(START)
+export LDS_ELF_ARCH   := $(ELF_ARCH)
+export LDS_ELF_FORMAT := $(ELF_FORMAT)
 
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index 388ec0a..1119233 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -3,6 +3,9 @@
 # Licensed under the GPL
 #
 
+CPPFLAGS_vmlinux.lds := -U$(SUBARCH) -DSTART=$(LDS_START) \
+                        -DELF_ARCH=$(LDS_ELF_ARCH)        \
+                        -DELF_FORMAT=$(LDS_ELF_FORMAT)
 extra-y := vmlinux.lds
 clean-files :=
 
diff --git a/arch/um/kernel/vmlinux.lds.S b/arch/um/kernel/vmlinux.lds.S
index f8aeb44..16e49bf 100644
--- a/arch/um/kernel/vmlinux.lds.S
+++ b/arch/um/kernel/vmlinux.lds.S
@@ -1,3 +1,6 @@
+
+KERNEL_STACK_SIZE = 4096 * (1 << CONFIG_KERNEL_STACK_ORDER);
+
 #ifdef CONFIG_LD_SCRIPT_STATIC
 #include "uml.lds.S"
 #else
diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index fe3186d..6f56d95 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -27,7 +27,8 @@ sed-y = -e 's/(\(\.[a-z]*it\|\.ref\|\)\.text)/(\1.literal \1.text)/g'	\
 	-e 's/(\(\.text\.[a-z]*\))/(\1.literal \1)/g'
 
 quiet_cmd__cpp_lds_S = LDS     $@
-      cmd__cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ $< | sed $(sed-y) >$@
+      cmd__cpp_lds_S = $(CPP) $(cpp_flags) -P -C -Uxtensa -D__ASSEMBLY__ $< \
+                       | sed $(sed-y) >$@
 
 $(obj)/vmlinux.lds: $(src)/vmlinux.lds.S FORCE
 	$(call if_changed_dep,_cpp_lds_S)
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 6e41b3b..d542566 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -270,7 +270,8 @@ targets += $(extra-y) $(MAKECMDGOALS) $(always)
 # Linker scripts preprocessor (.lds.S -> .lds)
 # ---------------------------------------------------------------------------
 quiet_cmd_cpp_lds_S = LDS     $@
-      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -o $@ $<
+      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -C -U$(ARCH) \
+	                     -D__ASSEMBLY__ -o $@ $<
 
 $(obj)/%.lds: $(src)/%.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
