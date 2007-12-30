Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXL3N0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXL3N0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXL3N0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:26:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49413 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbXL3N0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:26:09 -0500
Date: Sun, 30 Dec 2007 14:26:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86: unify arch/x86/boot/compressed/Makefile(s)
Message-ID: <20071230132608.GA13857@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial unification of the two Makefiles.
Tested doing a defconfig build for both 32 and 64 bit and
no build changes occured.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

Made on top of the mm branch of the x86 tree, but
expect it to apply cleanly to the setup tree.
If you want a rediff let me know.

	Sam

>From 4e773455f0a1db85b981dc58d8fc18cb08e62fb2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 30 Dec 2007 14:23:06 +0100
Subject: [PATCH] x86: unify arch/x86/boot/compressed/Makefile(s)

Trivial unification of the two Makefiles.
Tested doing a defconfig build for both 32 and 64 bit and
no build changes occured.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/boot/compressed/Makefile    |   62 ++++++++++++++++++++++++++++++++-
 arch/x86/boot/compressed/Makefile_32 |   50 ---------------------------
 arch/x86/boot/compressed/Makefile_64 |   30 ----------------
 3 files changed, 60 insertions(+), 82 deletions(-)
 delete mode 100644 arch/x86/boot/compressed/Makefile_32
 delete mode 100644 arch/x86/boot/compressed/Makefile_64

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 52c1db8..0674275 100644
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
+cflags-$(CONFIG_X86_32) := -mcmodel=small
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
-- 
1.5.3.7.1112.g9758e

