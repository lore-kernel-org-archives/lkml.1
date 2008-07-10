Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYGJSmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYGJSmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYGJSlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:65169 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYGJSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061616"
Message-Id: <20080710182237.630380000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:46 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 12/26] x64, x2apic/intr-remap: 8259 specific mask/unmask routines
Content-Disposition: inline; filename=8259_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8259 specific mask/unmask routines which be used later while enabling
interrupt-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/i8259.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/i8259.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/i8259.c	2008-07-10 09:52:09.000000000 -0700
@@ -282,6 +282,30 @@
 
 device_initcall(i8259A_init_sysfs);
 
+void mask_8259A(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
+void unmask_8259A(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
+	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
 void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
Index: tree-x86/include/asm-x86/i8259.h
===================================================================
--- tree-x86.orig/include/asm-x86/i8259.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/i8259.h	2008-07-10 09:52:09.000000000 -0700
@@ -57,4 +57,7 @@
 
 extern struct irq_chip i8259A_chip;
 
+extern void mask_8259A(void);
+extern void unmask_8259A(void);
+
 #endif	/* __ASM_I8259_H__ */

-- 

