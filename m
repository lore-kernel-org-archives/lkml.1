Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZH1Vw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZH1Vw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZH1Vw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:52:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60014 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbZH1Vwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:52:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208,223";a="488365421"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>
Date: Fri, 28 Aug 2009 14:52:54 -0700
Subject: [RFC PATCH 2/7] x86: introduce a set of platform feature flags
Thread-Topic: [RFC PATCH 2/7] x86: introduce a set of platform feature flags
Thread-Index: Acoir9vx9XaYijQEQY+7z9INN3fH8AFdtSuw
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA873@orsmsx508.amr.corp.intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205601.878468441@linutronix.de> <4A8F1E4D.9080409@goop.org>
 <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908220034110.1769@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8c587b87eef49660b498dd3728dab73a254b7ea9 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 11 Jun 2009 09:37:26 -0700
Subject: [PATCH] x86: introduce a set of platform feature flags

This patch introduces a set of x86 pc platform feature flags. the intention is
to clean up setup code based on the availability of patform features.

With the introduction of non-PC x86 platforms, these flags will also pave
the way for cleaner integration.

The current feature flags are not a complete set of all possible PC features
only the ones relavent to system setup, such as resource allocation, are
included.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/Kconfig                        |   13 +++-
 arch/x86/include/asm/platform_feature.h |   68 +++++++++++++++++++
 arch/x86/kernel/.gitignore              |    1 +
 arch/x86/kernel/Makefile                |   11 +++
 arch/x86/kernel/mkx86pcflags.pl         |   32 +++++++++
 arch/x86/kernel/platform_info.c         |  112 +++++++++++++++++++++++++++++++
 6 files changed, 236 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/platform_feature.h
 create mode 100644 arch/x86/kernel/mkx86pcflags.pl
 create mode 100644 arch/x86/kernel/platform_info.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..7990f6c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1658,7 +1658,18 @@ config CMDLINE_OVERRIDE
 
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
-
+config MRST
+	bool "Moorestown MID platform"
+	default n
+	depends on X86_32
+	select SFI
+	help
+	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
+	  Internet Device(MID) platform. Moorestown consists of two chips:
+	  Lincroft (CPU core, graphics, and memory controller) and Langwell IOH.
+	  Unlike standard x86 PCs, Moorestown does not have many legacy devices
+	  nor standard legacy replacement devices/features. e.g. Moorestown does
+	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/include/asm/platform_feature.h b/arch/x86/include/asm/platform_feature.h
new file mode 100644
index 0000000..fcf9907
--- /dev/null
+++ b/arch/x86/include/asm/platform_feature.h
@@ -0,0 +1,68 @@
+/*
+ * platform_feature.h - Defines x86 platform feature bits
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Jacob Pan (jacob.jun.pan@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note: platform feature flags allow kernel to identify hardware capabilities
+ * at boottime and runtime. It enables binary compaitiblity between standard
+ * X86 PC and non-standard X86 platforms such as MID. These flags are default
+ * to X86 PC standard, at boot time, they will be overwritten by system tables
+ * provided by firmware.
+ *
+ */
+#ifndef _ASM_X86_PLATFORM_FEATURE_H
+#define _ASM_X86_PLATFORM_FEATURE_H
+
+#ifndef __ASSEMBLY__
+#include <linux/bitops.h>
+#endif
+#include <asm/required-features.h>
+
+#define N_PLATFORM_CAPINTS	2	/* N 32-bit words worth of info */
+/* X86 base platform features, include PC, legacy free MID devices, etc.
+ * This list provides early and important information to the kernel in a
+ * centralized place such that kernel can make a decision on the best
+ * choice of which system devices to use. e.g. timers or interrupt
+ * controllers.
+ */
+#define X86_PLATFORM_FEATURE_8259		(0*32+0) /* i8259A PIC */
+#define X86_PLATFORM_FEATURE_8254		(0*32+1) /* i8253/4 PIT */
+#define X86_PLATFORM_FEATURE_IOAPIC		(0*32+2) /* IO-APIC */
+#define X86_PLATFORM_FEATURE_HPET		(0*32+3) /* HPET timer */
+#define X86_PLATFORM_FEATURE_RTC		(0*32+4) /* real time clock*/
+#define X86_PLATFORM_FEATURE_FLOPPY		(0*32+5) /* ISA floppy */
+#define X86_PLATFORM_FEATURE_ISA		(0*32+6) /* ISA/LPC bus */
+#define X86_PLATFORM_FEATURE_BIOS		(0*32+7) /* BIOS service,
+							   *  e.g. int calls
+							   *  EBDA, etc.
+							   */
+#define X86_PLATFORM_FEATURE_ACPI		(0*32+8) /* has ACPI support */
+#define X86_PLATFORM_FEATURE_SFI		(0*32+9) /* has SFI support */
+#define X86_PLATFORM_FEATURE_8042		(0*32+10) /* i8042 KBC */
+#define X86_PLATFORM_FEATURE_APBT		(0*32+11) /* APB timer */
+#define X86_PLATFORM_FEATURE_VRTC		(0*32+12) /* virtual RTC */
+#define X86_PLATFORM_FEATURE_PCISHIM		(0*32+13) /* fake PCI MCFG */
+
+extern __u32 platform_feature[N_PLATFORM_CAPINTS];
+extern const char *const
+	x86_platform_available_feature[N_PLATFORM_CAPINTS * 32];
+#define platform_has(bit) \
+	test_bit(bit, (unsigned long *)platform_feature)
+
+#define platform_feature_set_flag(bit) \
+	__set_bit(bit, (unsigned long *)platform_feature)
+
+#define clear_platform_feature(bit) \
+	__clear_bit(bit, (unsigned long *)platform_feature)
+
+void platform_feature_init_default(void);
+void clear_all_platform_feature(void);
+
+
+#endif /* _ASM_X86_PLATFORM_FEATURE_H */
diff --git a/arch/x86/kernel/.gitignore b/arch/x86/kernel/.gitignore
index 08f4fd7..0943d5e 100644
--- a/arch/x86/kernel/.gitignore
+++ b/arch/x86/kernel/.gitignore
@@ -1,3 +1,4 @@
 vsyscall.lds
 vsyscall_32.lds
 vmlinux.lds
+x86pcflags.c
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5929855..7aed450 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
+obj-y				+= platform_info.o x86pcflags.o
 obj-y				+= acpi/
 obj-y				+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
@@ -114,6 +115,16 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
+quiet_cmd_mkx86pcflags = MKFEATURE   $@
+      cmd_mkx86pcflags = $(PERL) $(srctree)/$(src)/mkx86pcflags.pl $< $@
+
+platform_feature = $(src)/../include/asm/platform_feature.h
+
+
+targets += x86pcflags.c
+$(obj)/x86pcflags.c: $(platform_feature) $(src)/mkx86pcflags.pl FORCE
+	$(call if_changed,mkx86pcflags)
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/mkx86pcflags.pl b/arch/x86/kernel/mkx86pcflags.pl
new file mode 100644
index 0000000..19c13aa
--- /dev/null
+++ b/arch/x86/kernel/mkx86pcflags.pl
@@ -0,0 +1,32 @@
+#!/usr/bin/perl
+#
+# Generate the x86_platform_available_feature[] array from arch/x86/include/asm/platform_feature.h
+#
+
+($in, $out) = @ARGV;
+
+open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
+open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
+
+print OUT "#include <asm/platform_feature.h>\n\n";
+print OUT "const char * const x86_platform_available_feature[N_PLATFORM_CAPINTS*32] = {\n";
+
+while (defined($line = <IN>)) {
+	if ($line =~ /^\s*\#\s*define\s+(X86_PLATFORM_FEATURE_(\S+))\s+(.*)$/) {
+		$macro = $1;
+		$feature = $2;
+		$tail = $3;
+		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
+			$feature = $1;
+		}
+
+		if ($feature ne '') {
+			printf OUT "\t%-32s = \"%s\",\n",
+				"[$macro]", "\L$feature";
+		}
+	}
+}
+print OUT "};\n";
+
+close(IN);
+close(OUT);
diff --git a/arch/x86/kernel/platform_info.c b/arch/x86/kernel/platform_info.c
new file mode 100644
index 0000000..63cee8f
--- /dev/null
+++ b/arch/x86/kernel/platform_info.c
@@ -0,0 +1,112 @@
+#include <linux/smp.h>
+#include <linux/timex.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include <linux/sysdev.h>
+#include <linux/cpu.h>
+
+#include <asm/bootparam.h>
+#include <asm/platform_feature.h>
+#include <asm/setup.h>
+#include <asm/bios_ebda.h>
+
+/*
+ * Set of default platform features of standard X86 PC. May be overwritten by
+ * information found during boot, such as boot parameters, SFI, ACPI tables,
+ * etc. Not every X86PC feature is listed here, only include useful ones that
+ * can not be safely detected at runtime.
+ */
+__u32 platform_feature[N_PLATFORM_CAPINTS] =
+{
+	(1UL << X86_PLATFORM_FEATURE_8259) |
+	(1UL << X86_PLATFORM_FEATURE_8042) |
+	(1UL << X86_PLATFORM_FEATURE_IOAPIC) |
+	(1UL << X86_PLATFORM_FEATURE_BIOS) |
+	(1UL << X86_PLATFORM_FEATURE_HPET) |
+	(1UL << X86_PLATFORM_FEATURE_8254) |
+	(1UL << X86_PLATFORM_FEATURE_RTC) |
+	(1UL << X86_PLATFORM_FEATURE_ISA) |
+	(1UL << X86_PLATFORM_FEATURE_FLOPPY),
+	0
+};
+EXPORT_SYMBOL_GPL(platform_feature);
+
+inline void clear_all_platform_feature(void)
+{
+	memset(platform_feature, 0, sizeof(platform_feature));
+}
+
+static ssize_t
+sysfs_show_available_platform_feature(struct sys_device *dev,
+				struct sysdev_attribute *attr, char *buf)
+{
+	ssize_t count = 0;
+	int i;
+
+	for (i = 0; i < 32*N_PLATFORM_CAPINTS; i++) {
+		if (x86_platform_available_feature[i] != NULL) {
+			count += snprintf(buf + count,
+					max((ssize_t)PAGE_SIZE - count,
+						(ssize_t)0), "%s ",
+				x86_platform_available_feature[i]);
+		}
+	}
+	count += snprintf(buf + count,
+			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");
+
+	return count;
+}
+
+static ssize_t
+sysfs_show_current_platform_feature(struct sys_device *dev,
+				  struct sysdev_attribute *attr,
+				  char *buf)
+{
+	ssize_t count = 0;
+	int i;
+
+	for (i = 0; i < 32*N_PLATFORM_CAPINTS; i++) {
+		if (platform_has(i))
+			count += snprintf(buf + count,
+				  max((ssize_t)PAGE_SIZE - count, (ssize_t)0),
+				  "%s ", x86_platform_available_feature[i]);
+	}
+	count += snprintf(buf + count,
+			  max((ssize_t)PAGE_SIZE - count, (ssize_t)0), "\n");
+
+	return count;
+}
+
+static SYSDEV_ATTR(current_platform_feature, 0444,
+		   sysfs_show_current_platform_feature,
+		   NULL);
+
+static SYSDEV_ATTR(available_platform_feature, 0444,
+		   sysfs_show_available_platform_feature, NULL);
+
+static struct sysdev_class platform_feature_sysclass = {
+	.name = "platform_feature",
+};
+
+static struct sys_device device_platform_feature = {
+	.id	= 0,
+	.cls	= &platform_feature_sysclass,
+};
+
+static int __init sysfs_platforminfo_init(void)
+{
+	int error = sysdev_class_register(&platform_feature_sysclass);
+
+	if (!error)
+		error = sysdev_register(&device_platform_feature);
+	if (!error)
+		error = sysdev_create_file(
+				&device_platform_feature,
+				&attr_current_platform_feature);
+	if (!error)
+		error = sysdev_create_file(
+				&device_platform_feature,
+				&attr_available_platform_feature);
+	return error;
+}
+arch_initcall(sysfs_platforminfo_init);
-- 
1.5.6.5

