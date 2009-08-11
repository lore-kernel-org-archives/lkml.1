Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZHKMAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZHKMAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZHKMAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:00:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:35438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZHKL7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:38 -0400
Message-ID: <4A80E2E2.5000208@kernel.org>
Date: Mon, 10 Aug 2009 20:17:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
CC: linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH] pci/intr_remapping: allocate irq_iommu on node -v2
References: <4A785C17.3030104@kernel.org>	<tip-94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5@git.kernel.org>	<20090809104400.GA1087@elte.hu> <20090810092921.48c3123f@jbarnes-g45>
In-Reply-To: <20090810092921.48c3123f@jbarnes-g45>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make it use node from irq_desc.

also need to make sure legacy irq node is right, when there is no ram on node 0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/intr_remapping.c |   10 +++++++++-
 kernel/irq/handle.c          |    5 ++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -79,7 +79,15 @@ static struct irq_2_iommu *irq_2_iommu_a
 
 static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
-	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
+	int node;
+
+#ifdef CONFIG_SMP
+	node = irq_to_desc(irq)->node;
+#else
+	node = cpu_to_node(boot_cpu_id);
+#endif
+
+	return irq_2_iommu_alloc_node(irq, node);
 }
 
 #else /* !CONFIG_SPARSE_IRQ */
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -161,7 +161,7 @@ int __init early_irq_init(void)
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
- 	node = first_online_node;
+	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
@@ -172,6 +172,9 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
+#ifdef CONFIG_SMP
+		desc[i].node = node;
+#endif
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
