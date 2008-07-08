Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYGHMob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYGHMob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbYGHMnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:43:25 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27528 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757782AbYGHMnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:43:22 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 02/58] microblaze_v5: Makefiles for Microblaze cpu
Date: Tue,  8 Jul 2008 13:59:02 +0200
Message-Id: <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Makefile                  |   63 +++++++++++++++++++++++++++++
 arch/microblaze/boot/Makefile             |   17 ++++++++
 arch/microblaze/kernel/Makefile           |   17 ++++++++
 arch/microblaze/kernel/cpu/Makefile       |    8 ++++
 arch/microblaze/lib/Makefile              |    5 ++
 arch/microblaze/mm/Makefile               |    5 ++
 arch/microblaze/platform/Makefile         |    6 +++
 arch/microblaze/platform/generic/Makefile |    3 +
 8 files changed, 124 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/Makefile
 create mode 100644 arch/microblaze/boot/Makefile
 create mode 100644 arch/microblaze/kernel/Makefile
 create mode 100644 arch/microblaze/kernel/cpu/Makefile
 create mode 100644 arch/microblaze/lib/Makefile
 create mode 100644 arch/microblaze/mm/Makefile
 create mode 100644 arch/microblaze/platform/Makefile
 create mode 100644 arch/microblaze/platform/generic/Makefile

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
new file mode 100644
index 0000000..7e9e1b4
--- /dev/null
+++ b/arch/microblaze/Makefile
@@ -0,0 +1,63 @@
+UTS_SYSNAME = -DUTS_SYSNAME=\"uClinux\"
+
+# What CPU vesion are we building for, and crack it open
+# as major.minor.rev
+CPU_VER=$(subst ",,$(CONFIG_XILINX_MICROBLAZE0_HW_VER) )
+CPU_MAJOR=$(shell echo $(CPU_VER) | cut -d '.' -f 1)
+CPU_MINOR=$(shell echo $(CPU_VER) | cut -d '.' -f 2)
+CPU_REV=$(shell echo $(CPU_VER) | cut -d '.' -f 3)
+
+export CPU_VER CPU_MAJOR CPU_MINOR CPU_REV
+
+# Use cpu-related CONFIG_ vars to set compile options.
+
+# Work out HW multipler support.  This is icky.
+# 1. Spartan2 has no HW multiplers.
+# 2. MicroBlaze v3.x always uses them, except in Spartan 2
+# 3. All other FPGa/CPU ver combos, we can trust the CONFIG_ settings
+ifeq (,$(findstring spartan2,$(CONFIG_XILINX_MICROBLAZE0_FAMILY)))
+  ifeq ($(CPU_MAJOR),3)
+    CPUFLAGS-1 += -mno-xl-soft-mul
+  else
+    # USE_HW_MUL can be 0, 1, or 2, defining a heirarchy of HW Mul support.
+    CPUFLAGS-$(subst 1,,$(CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL)) += -mxl-multiply-high
+    CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL) += -mno-xl-soft-mul
+  endif
+endif
+CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_DIV) += -mno-xl-soft-div
+CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
+CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP) += -mxl-pattern-compare
+
+CPUFLAGS-1 += $(call cc-option,-mcpu=v$(CPU_VER))
+
+# The various CONFIG_XILINX cpu features options are integers 0/1/2...
+# rather than bools y/n
+CFLAGS += $(CPUFLAGS-1)
+CFLAGS += $(CPUFLAGS-2)
+
+# r31 holds current when in kernel mode
+CFLAGS += -ffixed-r31
+
+LDFLAGS_BLOB := --format binary --oformat elf32-microblaze
+
+LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
+
+head-y		:= arch/microblaze/kernel/head.o
+libs-y		+= arch/microblaze/lib/ $(LIBGCC)
+core-y		+= arch/microblaze/kernel/ arch/microblaze/mm/ \
+		   arch/microblaze/platform/
+
+boot := arch/$(ARCH)/boot
+
+all: linux.bin
+
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+linux.bin linux.bin.gz: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+define archhelp
+  echo  '* linux.bin    - Create raw binary'
+  echo  '  linux.bin.gz - Create compressed raw binary'
+endef
diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
new file mode 100644
index 0000000..844edf4
--- /dev/null
+++ b/arch/microblaze/boot/Makefile
@@ -0,0 +1,17 @@
+#
+# arch/microblaze/boot/Makefile
+#
+
+targets := linux.bin linux.bin.gz
+
+OBJCOPYFLAGS_linux.bin  := -O binary
+
+$(obj)/linux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
+
+$(obj)/linux.bin.gz: $(obj)/linux.bin FORCE
+	$(call if_changed,gzip)
+	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
+
+clean-kernel += linux.bin linux.bin.gz
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
new file mode 100644
index 0000000..f7a6bb8
--- /dev/null
+++ b/arch/microblaze/kernel/Makefile
@@ -0,0 +1,17 @@
+#
+# Makefile
+#
+
+extra-y := head.o vmlinux.lds
+
+obj-y += entry.o exceptions.o \
+	hw_exception_handler.o init_task.o intc.o irq.o of_device.o \
+	process.o prom.o ptrace.o \
+	setup.o signal.o sys_microblaze.o timer.o traps.o
+
+obj-y += cpu/
+
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-$(CONFIG_SELFMOD)		+= selfmod.o
+obj-$(CONFIG_HEART_BEAT)	+= heartbeat.o
+obj-$(CONFIG_MODULES)		+= microblaze_ksyms.o module.o
diff --git a/arch/microblaze/kernel/cpu/Makefile b/arch/microblaze/kernel/cpu/Makefile
new file mode 100644
index 0000000..20646e5
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/Makefile
@@ -0,0 +1,8 @@
+#
+# Build the appropriate CPU version support
+#
+
+EXTRA_CFLAGS += -DCPU_MAJOR=$(CPU_MAJOR) -DCPU_MINOR=$(CPU_MINOR) \
+		-DCPU_REV=$(CPU_REV)
+
+obj-y += cache.o cpuinfo.o cpuinfo-pvr-full.o cpuinfo-static.o mb.o pvr.o
diff --git a/arch/microblaze/lib/Makefile b/arch/microblaze/lib/Makefile
new file mode 100644
index 0000000..f0c36ff
--- /dev/null
+++ b/arch/microblaze/lib/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile
+#
+
+lib-y := memcpy.o memmove.o memset.o uaccess.o
diff --git a/arch/microblaze/mm/Makefile b/arch/microblaze/mm/Makefile
new file mode 100644
index 0000000..bf9e447
--- /dev/null
+++ b/arch/microblaze/mm/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile
+#
+
+obj-y := init.o
diff --git a/arch/microblaze/platform/Makefile b/arch/microblaze/platform/Makefile
new file mode 100644
index 0000000..ea1b75c
--- /dev/null
+++ b/arch/microblaze/platform/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for arch/microblaze/platform directory
+#
+#obj-$(CONFIG_PLATFORM_GENERIC) += generic/
+
+obj-y	+= platform.o
diff --git a/arch/microblaze/platform/generic/Makefile b/arch/microblaze/platform/generic/Makefile
new file mode 100644
index 0000000..9a8b1bd
--- /dev/null
+++ b/arch/microblaze/platform/generic/Makefile
@@ -0,0 +1,3 @@
+#
+# Empty Makefile to keep make clean happy
+#
-- 
1.5.4.GIT

