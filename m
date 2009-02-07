Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZBGAB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZBGAB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZBGABT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:01:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:45917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZBGABS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:01:18 -0500
Message-ID: <498CCF28.3050207@kernel.org>
Date: Fri, 06 Feb 2009 16:00:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/irq: optimizing nr_irqs
References: <498CCEDB.8050708@kernel.org>
In-Reply-To: <498CCEDB.8050708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: more depend on cards to be used

depend on nr_irq_gsi more, and have a ratio for MSI

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3479,9 +3479,9 @@ int arch_setup_msi_irqs(struct pci_dev *
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want);
-		irq_want++;
 		if (irq == 0)
 			return -1;
+		irq_want = irq + 1;
 #ifdef CONFIG_INTR_REMAP
 		if (!intr_remapping_enabled)
 			goto no_ir;
@@ -3835,11 +3835,14 @@ int __init arch_probe_nr_irqs(void)
 {
 	int nr;
 
-	nr = ((8 * nr_cpu_ids) > (32 * nr_ioapics) ?
-		(NR_VECTORS + (8 * nr_cpu_ids)) :
-		(NR_VECTORS + (32 * nr_ioapics)));
-
-	if (nr < nr_irqs && nr > nr_irqs_gsi)
+	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
+#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
+	/*
+	 * for MSI and HT dyn irq
+	 */
+	nr += nr_irqs_gsi * 16;
+#endif
+	if (nr < (NR_VECTORS * nr_cpu_ids))
 		nr_irqs = nr;
 
 	return 0;
