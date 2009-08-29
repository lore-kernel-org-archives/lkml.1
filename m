Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZH2N73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZH2N73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZH2N72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:59:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:36551 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZH2N71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:59:27 -0400
Date: Sat, 29 Aug 2009 13:58:58 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A95C392.5050903@kernel.org>
References: <4A95C392.5050903@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] pci/intr_remapping: Allocate irq_iommu on node
Message-ID: <tip-70590ea75b7f9ef4846b0b0f4400e8338dbcc7eb@git.kernel.org>
Git-Commit-ID: 70590ea75b7f9ef4846b0b0f4400e8338dbcc7eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 13:58:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70590ea75b7f9ef4846b0b0f4400e8338dbcc7eb
Gitweb:     http://git.kernel.org/tip/70590ea75b7f9ef4846b0b0f4400e8338dbcc7eb
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 26 Aug 2009 16:21:54 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 15:53:01 +0200

pci/intr_remapping: Allocate irq_iommu on node

make it use the node from irq_desc.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A95C392.5050903@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 drivers/pci/intr_remapping.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 4f5b871..4480364 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -55,15 +55,12 @@ static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
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
@@ -72,16 +69,11 @@ static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
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
