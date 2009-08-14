Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZHNBsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZHNBsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZHNBsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:48:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:49900 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbZHNBsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:48:40 -0400
Message-ID: <4A84C21A.4000705@kernel.org>
Date: Thu, 13 Aug 2009 18:47:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] pci/intr_remapping: allocate irq_iommu on node -v3
References: <4A84C13E.5050606@kernel.org> <4A84C190.1060005@kernel.org>
In-Reply-To: <4A84C190.1060005@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make it use node from irq_desc.
v3: use irq_node

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/intr_remapping.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -55,15 +55,12 @@ static struct irq_2_iommu *irq_2_iommu(u
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
+static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
 
-	/*
-	 * alloc irq desc if not allocated already.
-	 */
-	desc = irq_to_desc_alloc_node(irq, node);
+	desc = irq_to_desc(irq);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return NULL;
@@ -72,16 +69,11 @@ static struct irq_2_iommu *irq_2_iommu_a
 	irq_iommu = desc->irq_2_iommu;
 
 	if (!irq_iommu)
-		desc->irq_2_iommu = get_one_free_irq_2_iommu(node);
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(irq_node(irq));
 
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
-{
-	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
-}
-
 #else /* !CONFIG_SPARSE_IRQ */
 
 static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
