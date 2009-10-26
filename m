Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZJZWC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZJZWC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZJZWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:02:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:28173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZJZWCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:33 -0400
X-ExtLoop1: 1
Message-Id: <20091026230002.043281924@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:36 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [RFC patch 6/6] x86: remove local_irq_enable()/local_irq_disable() in fixup_irqs()
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_irq_migration_during_cpu_offline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure that we handle all the pending interrupts (destined for this cpu that
is going down) in the interrupt subsystem before the cpu goes offline,
fixup_irqs() does:

	local_irq_enable();
	mdelay(1);
	local_irq_disable();

Enabling interrupts is not a good thing as this cpu is already offline.
So this patch replaces that logic with,

	mdelay(1);
	check APIC_IRR bits
	Retrigger the irq at the new destination if any interrupt has arrived
	via IPI.

For IO-APIC level triggered interrupts, this retrigger IPI will appear as an
edge interrupt. ack_apic_level() will detect this condition and IO-APIC RTE's
remoteIRR is cleared using directed EOI(using IO-APIC EOI register) on Intel
platforms and for others it uses the existing mask+edge logic followed by
unmask+level.

We can also remove mdelay() and then send spuriuous interrupts to
new cpu targets for all the irqs that were handled previously by this cpu
that is going offline. While it works, I have seen spurious interrupt messages
(nothing wrong but still annoying messages during cpu offline, which
can be seen during suspend/resume etc)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/irq.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

Index: tip/arch/x86/kernel/irq.c
===================================================================
--- tip.orig/arch/x86/kernel/irq.c
+++ tip/arch/x86/kernel/irq.c
@@ -279,7 +279,7 @@ EXPORT_SYMBOL_GPL(vector_used_by_percpu_
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
 {
-	unsigned int irq;
+	unsigned int irq, vector;
 	static int warned;
 	struct irq_desc *desc;
 
@@ -334,9 +334,33 @@ void fixup_irqs(void)
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
+	/*
+	 * We can remove mdelay() and then send spuriuous interrupts to
+	 * new cpu targets for all the irqs that were handled previously by
+	 * this cpu. While it works, I have seen spurious interrupt messages
+	 * (nothing wrong but still...).
+	 *
+	 * So for now, retain mdelay(1) and check the IRR and then send those
+	 * interrupts to new targets as this cpu is already offlined...
+	 */
 	mdelay(1);
-	local_irq_disable();
+
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		unsigned int irr;
+
+		if (__get_cpu_var(vector_irq)[vector] < 0)
+			continue;
+
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		if (irr  & (1 << (vector % 32))) {
+			irq = __get_cpu_var(vector_irq)[vector];
+
+			desc = irq_to_desc(irq);
+			spin_lock(&desc->lock);
+			if (desc->chip->retrigger)
+				desc->chip->retrigger(irq);
+			spin_unlock(&desc->lock);
+		}
+	}
 }
 #endif


