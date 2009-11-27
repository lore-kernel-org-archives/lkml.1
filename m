Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZK0N6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZK0N6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZK0N6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:58:51 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:53571
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753010AbZK0N4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:01 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD8-01-6RZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 29/34] x86/amd-iommu: Keep devices per domain in a list
Date: Fri, 27 Nov 2009 14:55:40 +0100
Message-ID: <1259330145-14865-30-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0639 (UTC) FILETIME=[52E3CAF0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a list to each protection domain which
keeps all devices associated with the domain. This can be
used later to optimize certain functions and to completly
remove the amd_iommu_pd_table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu.c            |   11 +++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 434e90e..93953d1 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -235,6 +235,7 @@ extern bool amd_iommu_np_cache;
  */
 struct protection_domain {
 	struct list_head list;  /* for list of all protection domains */
+	struct list_head dev_list; /* List of all devices in this domain */
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
@@ -251,6 +252,7 @@ struct protection_domain {
  * This struct contains device specific data for the IOMMU
  */
 struct iommu_dev_data {
+	struct list_head list;		  /* For domain->dev_list */
 	struct device *alias;		  /* The Alias Device */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reverent count */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f5db7d5..530d608 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1286,6 +1286,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(void)
 	dma_dom->domain.id = domain_id_alloc();
 	if (dma_dom->domain.id == 0)
 		goto free_dma_dom;
+	INIT_LIST_HEAD(&dma_dom->domain.dev_list);
 	dma_dom->domain.mode = PAGE_MODE_2_LEVEL;
 	dma_dom->domain.pt_root = (void *)get_zeroed_page(GFP_KERNEL);
 	dma_dom->domain.flags = PD_DMA_OPS_MASK;
@@ -1408,6 +1409,7 @@ static int __attach_device(struct device *dev,
 	if (alias != devid) {
 		if (alias_data->domain == NULL) {
 			alias_data->domain = domain;
+			list_add(&alias_data->list, &domain->dev_list);
 			set_dte_entry(alias, domain);
 		}
 
@@ -1416,6 +1418,7 @@ static int __attach_device(struct device *dev,
 
 	if (dev_data->domain == NULL) {
 		dev_data->domain = domain;
+		list_add(&dev_data->list, &domain->dev_list);
 		set_dte_entry(devid, domain);
 	}
 
@@ -1460,6 +1463,7 @@ static void __detach_device(struct device *dev)
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 	struct iommu_dev_data *dev_data = get_dev_data(dev);
 	struct iommu_dev_data *alias_data;
+	unsigned long flags;
 
 	BUG_ON(!iommu);
 
@@ -1469,13 +1473,19 @@ static void __detach_device(struct device *dev)
 	if (devid != alias) {
 		alias_data = get_dev_data(dev_data->alias);
 		if (atomic_dec_and_test(&alias_data->bind)) {
+			spin_lock_irqsave(&alias_data->domain->lock, flags);
 			clear_dte_entry(alias);
+			list_del(&alias_data->list);
+			spin_unlock_irqrestore(&alias_data->domain->lock, flags);
 			alias_data->domain = NULL;
 		}
 	}
 
 	if (atomic_dec_and_test(&dev_data->bind)) {
+		spin_lock_irqsave(&dev_data->domain->lock, flags);
 		clear_dte_entry(devid);
+		list_del(&dev_data->list);
+		spin_unlock_irqrestore(&dev_data->domain->lock, flags);
 		dev_data->domain = NULL;
 	}
 
@@ -2294,6 +2304,7 @@ static struct protection_domain *protection_domain_alloc(void)
 	domain->id = domain_id_alloc();
 	if (!domain->id)
 		goto out_err;
+	INIT_LIST_HEAD(&domain->dev_list);
 
 	add_domain_to_list(domain);
 
-- 
1.6.5.3


