Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZBHJpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZBHJpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZBHJpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:45:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:44540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZBHJpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:45:03 -0500
Message-ID: <498EA964.2070902@kernel.org>
Date: Sun, 08 Feb 2009 01:44:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/irq: optimizing nr_irqs -v2
References: <498CCEDB.8050708@kernel.org> <498CCF28.3050207@kernel.org>
In-Reply-To: <498CCF28.3050207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: more depend on cards to be used

depend on nr_irq_gsi more, and have a ratio for MSI

v2: make nr_irqs shoule less than NR_VECTORS * nr_cpu_ids
   aka if only one cpu, we only can support nr_irqs = NR_VECTORS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3482,9 +3482,9 @@ int arch_setup_msi_irqs(struct pci_dev *
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
@@ -3838,11 +3838,17 @@ int __init arch_probe_nr_irqs(void)
 {
 	int nr;
 
-	nr = ((8 * nr_cpu_ids) > (32 * nr_ioapics) ?
-		(NR_VECTORS + (8 * nr_cpu_ids)) :
-		(NR_VECTORS + (32 * nr_ioapics)));
+	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
+		nr_irqs = NR_VECTORS * nr_cpu_ids;
 
-	if (nr < nr_irqs && nr > nr_irqs_gsi)
+	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
+#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
+	/*
+	 * for MSI and HT dyn irq
+	 */
+	nr += nr_irqs_gsi * 16;
+#endif
+	if (nr < nr_irqs)
 		nr_irqs = nr;
 
 	return 0;
