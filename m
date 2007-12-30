Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbXL3Nh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbXL3Nh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbXL3NhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:37:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:34134 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXL3NhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:37:20 -0500
Date: Sun, 30 Dec 2007 14:36:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH corrected] x86: unify arch/x86/boot/compressed/Makefile(s)
Message-ID: <20071230133648.GA13945@uranus.ravnborg.org>
References: <20071230132608.GA13857@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230132608.GA13857@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So trivial that I sent the wrong patch - sorry.
The correct version is below.

	Sam

Trivial unification of the two Makefiles.
Tested doing a defconfig build for both 32 and 64 bit and
no build changes occured.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/boot/compressed/Makefile    |   62 ++++++++++++++++++++++++++++++++-
 arch/x86/boot/compressed/Makefile_32 |   50 ---------------------------
 arch/x86/boot/compressed/Makefile_64 |   30 ----------------
 arch/x86/lib/Makefile                |   25 ++++++++++++-
 4 files changed, 83 insertions(+), 84 deletions(-)
 delete mode 100644 arch/x86/boot/compressed/Makefile_32
 delete mode 100644 arch/x86/boot/compressed/Makefile_64

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 52c1db8..d6ae347 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -1,5 +1,63 @@
+#
+# linux/arch/x86/boot/compressed/Makefile
+#
+# create a compressed vmlinux image from the original vmlinux
+#
+
+targets := vmlinux vmlinux.bin vmlinux.bin.gz head_$(BITS).o misc_$(BITS).o piggy.o
+
+KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
+KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
+cflags-$(CONFIG_X86_64) := -mcmodel=small
+KBUILD_CFLAGS += $(cflags-y)
+KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
+KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
+
+KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
+
+LDFLAGS := -m elf_$(UTS_MACHINE)
+LDFLAGS_vmlinux := -T
+
+$(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc_$(BITS).o $(obj)/piggy.o FORCE
+	$(call if_changed,ld)
+	@:
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+
+
 ifeq ($(CONFIG_X86_32),y)
-include ${srctree}/arch/x86/boot/compressed/Makefile_32
+targets += vmlinux.bin.all vmlinux.relocs
+hostprogs-y := relocs
+
+quiet_cmd_relocs = RELOCS  $@
+      cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
+$(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
+	$(call if_changed,relocs)
+
+vmlinux.bin.all-y := $(obj)/vmlinux.bin
+vmlinux.bin.all-$(CONFIG_RELOCATABLE) += $(obj)/vmlinux.relocs
+quiet_cmd_relocbin = BUILD   $@
+      cmd_relocbin = cat $(filter-out FORCE,$^) > $@
+$(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
+	$(call if_changed,relocbin)
+
+ifdef CONFIG_RELOCATABLE
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
+	$(call if_changed,gzip)
 else
-include ${srctree}/arch/x86/boot/compressed/Makefile_64
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,gzip)
 endif
+LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
+
+else
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,gzip)
+
+LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
+endif
+
+
+$(obj)/piggy.o: $(obj)/vmlinux_$(BITS).scr $(obj)/vmlinux.bin.gz FORCE
+	$(call if_changed,ld)
diff --git a/arch/x86/boot/compressed/Makefile_32 b/arch/x86/boot/compressed/Makefile_32
deleted file mode 100644
index e43ff7c..0000000
--- a/arch/x86/boot/compressed/Makefile_32
+++ /dev/null
@@ -1,50 +0,0 @@
-#
-# linux/arch/x86/boot/compressed/Makefile
-#
-# create a compressed vmlinux image from the original vmlinux
-#
-
-targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head_32.o misc_32.o piggy.o \
-			vmlinux.bin.all vmlinux.relocs
-EXTRA_AFLAGS	:= -traditional
-
-LDFLAGS_vmlinux := -T
-hostprogs-y	:= relocs
-
-KBUILD_CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
-	   -fno-strict-aliasing -fPIC \
-	   $(call cc-option,-ffreestanding) \
-	   $(call cc-option,-fno-stack-protector)
-LDFLAGS := -m elf_i386
-
-$(obj)/vmlinux: $(src)/vmlinux_32.lds $(obj)/head_32.o $(obj)/misc_32.o $(obj)/piggy.o FORCE
-	$(call if_changed,ld)
-	@:
-
-$(obj)/vmlinux.bin: vmlinux FORCE
-	$(call if_changed,objcopy)
-
-quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
-$(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
-	$(call if_changed,relocs)
-
-vmlinux.bin.all-y := $(obj)/vmlinux.bin
-vmlinux.bin.all-$(CONFIG_RELOCATABLE) += $(obj)/vmlinux.relocs
-quiet_cmd_relocbin = BUILD   $@
-      cmd_relocbin = cat $(filter-out FORCE,$^) > $@
-$(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
-	$(call if_changed,relocbin)
-
-ifdef CONFIG_RELOCATABLE
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,gzip)
-else
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,gzip)
-endif
-
-LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
-
-$(obj)/piggy.o: $(src)/vmlinux_32.scr $(obj)/vmlinux.bin.gz FORCE
-	$(call if_changed,ld)
diff --git a/arch/x86/boot/compressed/Makefile_64 b/arch/x86/boot/compressed/Makefile_64
deleted file mode 100644
index 7801e8d..0000000
--- a/arch/x86/boot/compressed/Makefile_64
+++ /dev/null
@@ -1,30 +0,0 @@
-#
-# linux/arch/x86/boot/compressed/Makefile
-#
-# create a compressed vmlinux image from the original vmlinux
-#
-
-targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head_64.o misc_64.o piggy.o
-
-KBUILD_CFLAGS := -m64 -D__KERNEL__ $(LINUXINCLUDE) -O2  \
-	  -fno-strict-aliasing -fPIC -mcmodel=small \
-	   $(call cc-option, -ffreestanding) \
-	   $(call cc-option, -fno-stack-protector)
-KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
-LDFLAGS := -m elf_x86_64
-
-LDFLAGS_vmlinux := -T
-$(obj)/vmlinux: $(src)/vmlinux_64.lds $(obj)/head_64.o $(obj)/misc_64.o $(obj)/piggy.o FORCE
-	$(call if_changed,ld)
-	@:
-
-$(obj)/vmlinux.bin: vmlinux FORCE
-	$(call if_changed,objcopy)
-
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,gzip)
-
-LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
-
-$(obj)/piggy.o: $(obj)/vmlinux_64.scr $(obj)/vmlinux.bin.gz FORCE
-	$(call if_changed,ld)
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 329da27..29ea5ac 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -1,5 +1,26 @@
+#
+# Makefile for x86_64-specific library files.
+#
+
 ifeq ($(CONFIG_X86_32),y)
-include ${srctree}/arch/x86/lib/Makefile_32
+lib-y += checksum_32.o delay_32.o
+lib-y += usercopy_32.o getuser_32.o putuser_32.o
+lib-y += memcpy_32.o strstr_32.o
+lib-y += bitops_32.o semaphore_32.o string_32.o
+
+lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
+
 else
-include ${srctree}/arch/x86/lib/Makefile_64
+obj-y += io_64.o iomap_copy_64.o
+
+CFLAGS_csum-partial_64.o := -funroll-loops
+
+lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o delay_64.o
+lib-y += usercopy_64.o getuser_64.o putuser_64.o
+lib-y += thunk_64.o clear_page_64.o copy_page_64.o bitstr_64.o bitops_64.o
+lib-y += memcpy_64.o memmove_64.o memset_64.o
+lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
+
 endif
+
+obj-$(CONFIG_SMP)	+= msr-on-cpu.o
\ No newline at end of file
-- 
1.5.3.7.1112.g9758e

