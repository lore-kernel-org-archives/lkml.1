Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbYGJSrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbYGJSrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYGJSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:13519 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbYGJSlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="306573277"
Message-Id: <20080710182238.487433000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 18/26] x64, x2apic/intr-remap: x2apic ops for x2apic mode support
Content-Disposition: inline; filename=basic_x2apic_ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2apic ops for x2apic mode support. This uses MSR interface and differs
slightly from the xapic register layout.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/apic_64.c	2008-07-10 09:52:14.000000000 -0700
+++ tree-x86/arch/x86/kernel/apic_64.c	2008-07-10 09:52:22.000000000 -0700
@@ -171,6 +171,41 @@
 
 EXPORT_SYMBOL_GPL(apic_ops);
 
+static void x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return;
+}
+
+static u32 safe_x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return 0;
+}
+
+void x2apic_icr_write(u32 low, u32 id)
+{
+	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
+}
+
+u64 x2apic_icr_read(void)
+{
+	unsigned long val;
+
+	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+	return val;
+}
+
+static struct apic_ops x2apic_ops = {
+	.read = native_apic_msr_read,
+	.write = native_apic_msr_write,
+	.write_atomic = native_apic_msr_write,
+	.icr_read = x2apic_icr_read,
+	.icr_write = x2apic_icr_write,
+	.wait_icr_idle = x2apic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
+};
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
Index: tree-x86/include/asm-x86/apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/apic.h	2008-07-10 09:52:14.000000000 -0700
+++ tree-x86/include/asm-x86/apic.h	2008-07-10 09:52:22.000000000 -0700
@@ -7,6 +7,8 @@
 #include <asm/apicdef.h>
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/cpufeature.h>
+#include <asm/msr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -73,6 +75,26 @@
 	return *((volatile u32 *)(APIC_BASE + reg));
 }
 
+static inline void native_apic_msr_write(u32 reg, u32 v)
+{
+	if (reg == APIC_DFR || reg == APIC_ID || reg == APIC_LDR ||
+	    reg == APIC_LVR)
+		return;
+
+	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
+}
+
+static inline u32 native_apic_msr_read(u32 reg)
+{
+	u32 low, high;
+
+	if (reg == APIC_DFR)
+		return -1;
+
+	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
+	return low;
+}
+
 #ifdef CONFIG_X86_32
 extern void apic_wait_icr_idle(void);
 extern u32 safe_apic_wait_icr_idle(void);
Index: tree-x86/include/asm-x86/apicdef.h
===================================================================
--- tree-x86.orig/include/asm-x86/apicdef.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/apicdef.h	2008-07-10 09:52:22.000000000 -0700
@@ -105,6 +105,7 @@
 #define	APIC_TMICT	0x380
 #define	APIC_TMCCT	0x390
 #define	APIC_TDCR	0x3E0
+#define APIC_SELF_IPI	0x3F0
 #define		APIC_TDR_DIV_TMBASE	(1 << 2)
 #define		APIC_TDR_DIV_1		0xB
 #define		APIC_TDR_DIV_2		0x0
@@ -128,6 +129,8 @@
 #define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
+#define APIC_BASE_MSR	0x800
+#define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
 # define MAX_IO_APICS 64

-- 

