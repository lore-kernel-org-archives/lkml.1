Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbYAZQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbYAZQLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYAZP6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:58:06 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757104AbYAZP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:58:02 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       sam@ravnborg.org
Subject: [PATCH 02/52] [microblaze] Makefiles for Microblaze cpu
Date: Thu, 24 Jan 2008 16:05:19 +0100
Message-Id: <d1a01bc4ca9328b2f93e924b133fab00ee6355c7.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Makefile                  |   66 +++++++++++++++++++++++++++++
 arch/microblaze/boot/Makefile             |   17 +++++++
 arch/microblaze/kernel/Makefile           |   14 ++++++
 arch/microblaze/kernel/cpu/Makefile       |    8 ++++
 arch/microblaze/lib/Makefile              |    5 ++
 arch/microblaze/mm/Makefile               |    5 ++
 arch/microblaze/platform/Makefile         |    3 +
 arch/microblaze/platform/generic/Makefile |    5 ++
 8 files changed, 123 insertions(+), 0 deletions(-)
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
index 0000000..b5920e5
--- /dev/null
+++ b/arch/microblaze/Makefile
@@ -0,0 +1,66 @@
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
+core-y		+= arch/microblaze/kernel/ arch/microblaze/mm/
+#		   arch/microblaze/platform/
+
+
+boot := arch/$(ARCH)/boot
+
+all: linux.bin
+
+
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+linux.bin linux.bin.gz: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
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
index 0000000..26bef1a
--- /dev/null
+++ b/arch/microblaze/kernel/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile
+#
+
+extra-y := head.o vmlinux.lds
+
+obj-y += early_printk.o entry.o exceptions.o hack.o heartbeat.o \
+	hw_exception_handler.o init_task.o intc.o irq.o of_device.o \
+	of_platform.o process.o prom.o prom_parse.o ptrace.o semaphore.o \
+	setup.o signal.o sys_microblaze.o time.o timer.o traps.o
+
+obj-y += cpu/
+
+obj-$(CONFIG_MODULES)	+= microblaze_ksyms.o module.o
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
index 0000000..fa18e83
--- /dev/null
+++ b/arch/microblaze/lib/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile
+#
+
+lib-y := checksum.o memcpy.o memmove.o memset.o uaccess.o
diff --git a/arch/microblaze/mm/Makefile b/arch/microblaze/mm/Makefile
new file mode 100644
index 0000000..4f2f490
--- /dev/null
+++ b/arch/microblaze/mm/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile
+#
+
+obj-y := consistent.o init.o lmb.o
diff --git a/arch/microblaze/platform/Makefile b/arch/microblaze/platform/Makefile
new file mode 100644
index 0000000..8797e83
--- /dev/null
+++ b/arch/microblaze/platform/Makefile
@@ -0,0 +1,3 @@
+#
+# Makefile for arch/microblaze/platform directory
+#
diff --git a/arch/microblaze/platform/generic/Makefile b/arch/microblaze/platform/generic/Makefile
new file mode 100644
index 0000000..ff5ef1e
--- /dev/null
+++ b/arch/microblaze/platform/generic/Makefile
@@ -0,0 +1,5 @@
+#
+# Empty Makefile to keep make clean happy
+#
+
+
-- 
1.5.4.rc4.14.g6fc74

