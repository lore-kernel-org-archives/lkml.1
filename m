Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZH3Nqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZH3Nqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZH3Nqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:46:50 -0400
Received: from www.tglx.de ([62.245.132.106]:53101 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbZH3Nqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:46:47 -0400
Message-Id: <20090830134517.760669912@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 30 Aug 2009 13:46:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [patch 3/3] x86: Add Moorestown early detection
References: <20090830134446.843410397@linutronix.de>
Content-Disposition: inline; filename=x86-add-moorestown-early-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown MID devices need to be detected early in the boot process
to setup and do not call x86_default_early_setup as there is no EBDA
region to reserve.

[ Copied the minimal code from Jacobs latest MRST series ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig             |   13 +++++++++++++
 arch/x86/include/asm/setup.h |    6 ++++++
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/head32.c     |    3 +++
 arch/x86/kernel/mrst.c       |   24 ++++++++++++++++++++++++
 5 files changed, 47 insertions(+)

Index: linux-2.6-tip/arch/x86/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/x86/Kconfig
+++ linux-2.6-tip/arch/x86/Kconfig
@@ -318,6 +318,7 @@ config X86_EXTENDED_PLATFORM
 		SGI 320/540 (Visual Workstation)
 		Summit/EXA (IBM x440)
 		Unisys ES7000 IA32 series
+		Moorestown MID devices
 
 	  If you have one of these systems, or if you want to build a
 	  generic distribution kernel, say Y here - otherwise say N.
@@ -377,6 +378,18 @@ config X86_ELAN
 
 	  If unsure, choose "PC-compatible" instead.
 
+config X86_MRST
+       bool "Moorestown MID platform"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
+	  Internet Device(MID) platform. Moorestown consists of two chips:
+	  Lincroft (CPU core, graphics, and memory controller) and Langwell IOH.
+	  Unlike standard x86 PCs, Moorestown does not have many legacy devices
+	  nor standard legacy replacement devices/features. e.g. Moorestown does
+	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
Index: linux-2.6-tip/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/setup.h
+++ linux-2.6-tip/arch/x86/include/asm/setup.h
@@ -49,6 +49,12 @@ extern void reserve_standard_io_resource
 extern void i386_reserve_resources(void);
 extern void setup_default_timer_irq(void);
 
+#ifdef CONFIG_X86_MRST
+extern void x86_mrst_early_setup(void);
+#else
+static inline void x86_mrst_early_setup(void) { }
+#endif
+
 #ifndef _SETUP
 
 /*
Index: linux-2.6-tip/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/Makefile
+++ linux-2.6-tip/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
Index: linux-2.6-tip/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/head32.c
+++ linux-2.6-tip/arch/x86/kernel/head32.c
@@ -45,6 +45,9 @@ void __init i386_start_kernel(void)
 
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
+	case X86_SUBARCH_MRST:
+		x86_mrst_early_setup();
+		break;
 	default:
 		i386_default_early_setup();
 		break;
Index: linux-2.6-tip/arch/x86/kernel/mrst.c
===================================================================
--- /dev/null
+++ linux-2.6-tip/arch/x86/kernel/mrst.c
@@ -0,0 +1,24 @@
+/*
+ * mrst.c: Intel Moorestown platform specific setup code
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Jacob Pan (jacob.jun.pan@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/init.h>
+
+#include <asm/setup.h>
+
+/*
+ * Moorestown specific x86_init function overrides and early setup
+ * calls.
+ */
+void __init x86_mrst_early_setup(void)
+{
+	x86_init.resources.probe_roms = x86_init_noop;
+	x86_init.resources.reserve_resources = x86_init_noop;
+}


