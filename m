Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbYGKUSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbYGKUSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYGKURz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:17:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:2955 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYGKURz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,347,1212390000"; 
   d="scan'208";a="591789019"
Message-Id: <20080711201442.910680000@linux-os.sc.intel.com>
References: <20080711201442.769225000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Jul 2008 13:11:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, x86@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 2/3] x2apic: xen64 paravirt basic apic ops
Content-Disposition: inline; filename=64bit_paravirt_apic_ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the Xen specific basic apic ops, in additon to paravirt apic ops,
with some misc warning fixes.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---

Index: tree-x86/arch/x86/xen/enlighten.c
===================================================================
--- tree-x86.orig/arch/x86/xen/enlighten.c	2008-07-11 11:26:17.000000000 -0700
+++ tree-x86/arch/x86/xen/enlighten.c	2008-07-11 11:55:58.000000000 -0700
@@ -576,16 +576,45 @@
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-static u32 xen_apic_read(unsigned long reg)
+static u32 xen_apic_read(u32 reg)
 {
 	return 0;
 }
 
-static void xen_apic_write(unsigned long reg, u32 val)
+static void xen_apic_write(u32 reg, u32 val)
 {
 	/* Warn to see if there's any stray references */
 	WARN_ON(1);
 }
+
+#ifdef CONFIG_X86_64
+static u64 xen_apic_icr_read(void)
+{
+	return 0;
+}
+
+static void xen_apic_icr_write(u32 low, u32 id)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static void xen_apic_wait_icr_idle(void)
+{
+        return;
+}
+
+static struct apic_ops xen_basic_apic_ops = {
+	.read = xen_apic_read,
+	.write = xen_apic_write,
+	.write_atomic = xen_apic_write,
+	.icr_read = xen_apic_icr_read,
+	.icr_write = xen_apic_icr_write,
+	.wait_icr_idle = xen_apic_wait_icr_idle,
+	.safe_wait_icr_idle = xen_apic_wait_icr_idle,
+};
+#endif
+
 #endif
 
 static void xen_flush_tlb(void)
@@ -1269,9 +1298,11 @@
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
+#ifndef CONFIG_X86_64
 	.apic_write = xen_apic_write,
 	.apic_write_atomic = xen_apic_write,
 	.apic_read = xen_apic_read,
+#endif
 	.setup_boot_clock = paravirt_nop,
 	.setup_secondary_clock = paravirt_nop,
 	.startup_ipi_hook = paravirt_nop,
@@ -1673,6 +1704,12 @@
 	pv_irq_ops = xen_irq_ops;
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
+#ifdef CONFIG_X86_64
+	/*
+	 * for 64bit, set up the basic apic ops aswell.
+	 */
+	apic_ops = &xen_basic_apic_ops;
+#endif
 
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start = xen_ptep_modify_prot_start;
Index: tree-x86/include/asm-x86/paravirt.h
===================================================================
--- tree-x86.orig/include/asm-x86/paravirt.h	2008-07-11 10:58:31.000000000 -0700
+++ tree-x86/include/asm-x86/paravirt.h	2008-07-11 12:00:12.000000000 -0700
@@ -200,13 +200,15 @@
 
 struct pv_apic_ops {
 #ifdef CONFIG_X86_LOCAL_APIC
+#ifndef CONFIG_X86_64
 	/*
 	 * Direct APIC operations, principally for VMI.  Ideally
 	 * these shouldn't be in this interface.
 	 */
-	void (*apic_write)(unsigned long reg, u32 v);
-	void (*apic_write_atomic)(unsigned long reg, u32 v);
-	u32 (*apic_read)(unsigned long reg);
+	void (*apic_write)(u32 reg, u32 v);
+	void (*apic_write_atomic)(u32 reg, u32 v);
+	u32 (*apic_read)(u32 reg);
+#endif
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
 
@@ -903,17 +905,17 @@
  * Basic functions accessing APICs.
  */
 #ifndef CONFIG_X86_64
-static inline void apic_write(unsigned long reg, u32 v)
+static inline void apic_write(u32 reg, u32 v)
 {
 	PVOP_VCALL2(pv_apic_ops.apic_write, reg, v);
 }
 
-static inline void apic_write_atomic(unsigned long reg, u32 v)
+static inline void apic_write_atomic(u32 reg, u32 v)
 {
 	PVOP_VCALL2(pv_apic_ops.apic_write_atomic, reg, v);
 }
 
-static inline u32 apic_read(unsigned long reg)
+static inline u32 apic_read(u32 reg)
 {
 	return PVOP_CALL1(unsigned long, pv_apic_ops.apic_read, reg);
 }
Index: tree-x86/arch/x86/lguest/boot.c
===================================================================
--- tree-x86.orig/arch/x86/lguest/boot.c	2008-07-11 10:36:24.000000000 -0700
+++ tree-x86/arch/x86/lguest/boot.c	2008-07-11 12:01:51.000000000 -0700
@@ -783,11 +783,11 @@
  * code qualifies for Advanced.  It will also never interrupt anything.  It
  * does, however, allow us to get through the Linux boot code. */
 #ifdef CONFIG_X86_LOCAL_APIC
-static void lguest_apic_write(unsigned long reg, u32 v)
+static void lguest_apic_write(u32 reg, u32 v)
 {
 }
 
-static u32 lguest_apic_read(unsigned long reg)
+static u32 lguest_apic_read(u32 reg)
 {
 	return 0;
 }

-- 

