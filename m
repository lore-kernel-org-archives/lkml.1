Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYIBXw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYIBXw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYIBXwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:52:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:27282 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYIBXwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:52:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="331870955"
Message-Id: <20080902234759.554038000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Sep 2008 16:46:58 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] x2apic: fix reserved APIC register accesses in print_local_APIC()
Content-Disposition: inline; filename=fix_reserved_apic_reg_access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: x2apic: fix reserved APIC register accesses in print_local_APIC()

APIC_ARBPRI is a reserved register for XAPIC and beyond.
APIC_RRR is a reserved register for integrated APIC's.
APIC_EOI is a write only register.
APIC_DFR is reserved in x2apic mode.

Access to these registers in x2apic will result in #GP fault. Fix these
apic register accesses.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/io_apic.c	2008-09-02 16:04:04.000000000 -0700
+++ tip/arch/x86/kernel/io_apic.c	2008-09-02 16:17:13.000000000 -0700
@@ -1751,21 +1751,24 @@
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
+	} else {
+		v = apic_read(APIC_RRR);
+		printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
 	}
 
-	v = apic_read(APIC_EOI);
-	printk(KERN_DEBUG "... APIC EOI: %08x\n", v);
-	v = apic_read(APIC_RRR);
-	printk(KERN_DEBUG "... APIC RRR: %08x\n", v);
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
--- tip.orig/include/asm-x86/apic.h	2008-09-02 16:04:04.000000000 -0700
+++ tip/include/asm-x86/apic.h	2008-09-02 16:15:42.000000000 -0700
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

