Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbYEENOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbYEENOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYEENNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:13:43 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:39041 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755976AbYEENNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:13:41 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 02/56] microblaze_v2: Makefiles for Microblaze cpu
Date: Sun,  4 May 2008 13:40:51 +0200
Message-Id: <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Makefile                  |   63 +++++++++++++++++++++++++++++
 arch/microblaze/boot/Makefile             |   17 ++++++++
 arch/microblaze/kernel/Makefile           |   17 ++++++++
 arch/microblaze/kernel/cpu/Makefile       |    8 ++++
 arch/microblaze/lib/Makefile              |    5 ++
 arch/microblaze/mm/Makefile               |    5 ++
 arch/microblaze/platform/Makefile         |    3 +
 arch/microblaze/platform/generic/Makefile |    3 +
 8 files changed, 121 insertions(+), 0 deletions(-)
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
index 0000000..fb80b49
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
+core-y		+= arch/microblaze/kernel/ arch/microblaze/mm/
+#		   arch/microblaze/platform/
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
index 0000000..716a0a5
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
+	hw_exception_handler.o init_task.o intc.o irq.o \
+	process.o prom.o ptrace.o \
+	setup.o signal.o sys_microblaze.o time.o timer.o traps.o
+
+obj-y += cpu/
+
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+obj-$(CONFIG_HACK)		+= hack.o
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
index 0000000..8797e83
--- /dev/null
+++ b/arch/microblaze/platform/Makefile
@@ -0,0 +1,3 @@
+#
+# Makefile for arch/microblaze/platform directory
+#
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

