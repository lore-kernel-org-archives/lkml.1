Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYIDAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYIDAKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYIDAJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:09:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:34249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYIDAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="41316117"
Message-Id: <20080904000237.746216000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 16:58:31 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [patch 1/5] x2apic: fix reserved APIC register accesses in print_local_APIC()
Content-Disposition: inline; filename=fix_reserved_apic_reg_access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: x2apic: fix reserved APIC register accesses in print_local_APIC()

APIC_ARBPRI is a reserved register for XAPIC and beyond.
APIC_RRR is a reserved register except for 82489DX, APIC for Pentium processors.
APIC_EOI is a write only register.
APIC_DFR is reserved in x2apic mode.

Access to these registers in x2apic will result in #GP fault. Fix these
apic register accesses.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
---

Index: tip/arch/x86/kernel/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/io_apic.c	2008-09-03 14:02:56.000000000 -0700
+++ tip/arch/x86/kernel/io_apic.c	2008-09-03 14:51:24.000000000 -0700
@@ -1751,21 +1751,30 @@
 	printk(KERN_DEBUG "... APIC TASKPRI: %08x (%02x)\n", v, v & APIC_TPRI_MASK);
 
 	if (APIC_INTEGRATED(ver)) {                     /* !82489DX */
-		v = apic_read(APIC_ARBPRI);
-		printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
-			v & APIC_ARBPRI_MASK);
+		if (!APIC_XAPIC(ver)) {
+			v = apic_read(APIC_ARBPRI);
+			printk(KERN_DEBUG "... APIC ARBPRI: %08x (%02x)\n", v,
+			       v & APIC_ARBPRI_MASK);
+		}
 		v = apic_read(APIC_PROCPRI);
 		printk(KERN_DEBUG "... APIC PROCPRI: %08x\n", v);
 	}
 
-	v = apic_read(APIC_EOI);
-	printk(KERN_DEBUG "... APIC EOI: %08x\n", v);
-	v = apic_read(APIC_RRR);
-	printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
+	/*
+	 * Remote read supported only in the 82489DX and local APIC for
+	 * Pentium processors.
+	 */
+	if (!APIC_INTEGRATED(ver) || maxlvt == 3) {
+		v = apic_read(APIC_RRR);
+		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
+	}
+
 	v = apic_read(APIC_LDR);
 	printk(KERN_DEBUG "... APIC LDR: %08x\n", v);
-	v = apic_read(APIC_DFR);
-	printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+	if (!x2apic_enabled()) {
+		v = apic_read(APIC_DFR);
+		printk(KERN_DEBUG "... APIC DFR: %08x\n", v);
+	}
 	v = apic_read(APIC_SPIV);
 	printk(KERN_DEBUG "... APIC SPIV: %08x\n", v);
 
Index: tip/include/asm-x86/apic.h
===================================================================
--- tip.orig/include/asm-x86/apic.h	2008-09-03 14:02:56.000000000 -0700
+++ tip/include/asm-x86/apic.h	2008-09-03 14:43:02.000000000 -0700
@@ -98,6 +98,20 @@
 extern void enable_x2apic(void);
 extern void enable_IR_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
+static inline int x2apic_enabled(void)
+{
+	int msr, msr2;
+
+	if (!cpu_has_x2apic)
+		return 0;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (msr & X2APIC_ENABLE)
+		return 1;
+	return 0;
+}
+#else
+#define x2apic_enabled()	0
 #endif
 
 struct apic_ops {

-- 

