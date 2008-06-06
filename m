Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYFFKtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYFFKtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYFFKtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:49:22 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:57202 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYFFKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:49:21 -0400
X-BigFish: VPS-3(zz18c1K655Oc8kzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K21FDX-02-KBH-01
In-Reply-To: <alpine.LFD.1.10.0806052239110.3235@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0806052239110.3235@apollo.tec.linutronix.de>
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 6 Jun 2008 12:01:13 +0200
Subject: [PATCH] fix build bug in "x86: add PCI extended config space access for AMD Barcelona" (try #3)
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <20080606104814.484CF806B@erda.amd.com>
X-OriginalArrivalTime: 06 Jun 2008 10:48:14.0523 (UTC) FILETIME=[D242B8B0:01C8C7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much more less code now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/amd.c    |    2 --
 arch/x86/kernel/cpu/amd_64.c |    1 +
 arch/x86/kernel/cpu/cpu.h    |    5 +++++
 arch/x86/kernel/setup.c      |    4 ++--
 arch/x86/kernel/setup.h      |   26 --------------------------
 arch/x86/kernel/setup_64.c   |    2 --
 include/asm-x86/mmconfig.h   |    6 ------
 7 files changed, 8 insertions(+), 38 deletions(-)
 delete mode 100644 arch/x86/kernel/setup.h

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 656b40a..a38d54f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -4,10 +4,8 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
-#include <asm/mmconfig.h>
 
 #include <mach_apic.h>
-#include "../setup.h"
 #include "cpu.h"
 
 /*
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index 180097e..626fc21 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -6,6 +6,7 @@
 #include <asm/cacheflush.h>
 
 #include <mach_apic.h>
+#include "cpu.h"
 
 extern int __cpuinit get_model_name(struct cpuinfo_x86 *c);
 extern void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 783691b..f5d5bb1 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -1,3 +1,4 @@
+#ifdef CONFIG_X86_32
 
 struct cpu_model_info {
 	int vendor;
@@ -36,3 +37,7 @@ extern struct cpu_vendor_dev __x86cpuvendor_start[], __x86cpuvendor_end[];
 
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
+
+#endif /* CONFIG_X86_32 */
+
+extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d8f1712..f2dc414 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -136,6 +136,8 @@ void __init setup_per_cpu_areas(void)
 	setup_cpumask_of_cpu();
 }
 
+#endif
+
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
 void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
@@ -148,5 +150,3 @@ void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
 	}
 	set_cpu_cap(c, X86_FEATURE_PCI_EXT_CFG);
 }
-
-#endif
diff --git a/arch/x86/kernel/setup.h b/arch/x86/kernel/setup.h
deleted file mode 100644
index 66cc2c7..0000000
--- a/arch/x86/kernel/setup.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * Internal declarations for shared x86 setup code.
- *
- * Copyright (c) 2008 Advanced Micro Devices, Inc.
- * Contributed by Robert Richter <robert.richter@amd.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
- * 02111-1307 USA
- */
-
-#ifndef _ARCH_X86_KERNEL_SETUP_H
-
-extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
-
-#endif	/* _ARCH_X86_KERNEL_SETUP_H */
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 215bd67..25afdd8 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -73,8 +73,6 @@
 #include <asm/pat.h>
 #include <asm/mmconfig.h>
 
-#include "setup.h"
-
 #include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index 691798f..95beda0 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -9,10 +9,4 @@ static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
 #endif
 
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_64)
-extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
-#else
-static inline void amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c) { }
-#endif
-
 #endif
-- 
1.5.5.3


