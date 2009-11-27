Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZK0N6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZK0N6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZK0N6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:58:52 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16163
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753019AbZK0N4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:01 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i27bh6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD8-02-34W-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 34/34] x86/amd-iommu: Remove amd_iommu_pd_table
Date: Fri, 27 Nov 2009 14:55:45 +0100
Message-ID: <1259330145-14865-35-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0717 (UTC) FILETIME=[52EFB1D0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Bypass-Agent: IPF-1;
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data that was stored in this table is now available in
dev->archdata.iommu. So this table is not longer necessary.
This patch removes the remaining uses of that variable and
removes it from the code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 --
 arch/x86/kernel/amd_iommu.c            |   35 ++++++++++---------------------
 arch/x86/kernel/amd_iommu_init.c       |   18 ----------------
 3 files changed, 11 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index f92d1b3..ba19ad4 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -457,9 +457,6 @@ extern unsigned amd_iommu_aperture_order;
 /* largest PCI device id we expect translation requests for */
 extern u16 amd_iommu_last_bdf;
 
-/* data structures for protection domain handling */
-extern struct protection_domain **amd_iommu_pd_table;
-
 /* allocation bitmap for domain ids */
 extern unsigned long *amd_iommu_pd_alloc_bitmap;
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b75fcd9..32fb091 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1309,8 +1309,6 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain)
 {
 	u64 pte_root = virt_to_phys(domain->pt_root);
 
-	BUG_ON(amd_iommu_pd_table[devid] != NULL);
-
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
@@ -1318,20 +1316,10 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain)
 	amd_iommu_dev_table[devid].data[2] = domain->id;
 	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
 	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
-
-	amd_iommu_pd_table[devid] = domain;
-
 }
 
 static void clear_dte_entry(u16 devid)
 {
-	struct protection_domain *domain = amd_iommu_pd_table[devid];
-
-	BUG_ON(domain == NULL);
-
-	/* remove domain from the lookup table */
-	amd_iommu_pd_table[devid] = NULL;
-
 	/* remove entry from the device table seen by the hardware */
 	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
 	amd_iommu_dev_table[devid].data[1] = 0;
@@ -1641,15 +1629,11 @@ static struct protection_domain *get_domain(struct device *dev)
 
 static void update_device_table(struct protection_domain *domain)
 {
-	unsigned long flags;
-	int i;
+	struct iommu_dev_data *dev_data;
 
-	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (amd_iommu_pd_table[i] != domain)
-			continue;
-		write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-		set_dte_entry(i, domain);
-		write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		u16 devid = get_device_id(dev_data->dev);
+		set_dte_entry(devid, domain);
 	}
 }
 
@@ -2259,14 +2243,17 @@ free_domains:
 
 static void cleanup_domain(struct protection_domain *domain)
 {
+	struct iommu_dev_data *dev_data, *next;
 	unsigned long flags;
-	u16 devid;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 
-	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
-		if (amd_iommu_pd_table[devid] == domain)
-			clear_dte_entry(devid);
+	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
+		struct device *dev = dev_data->dev;
+
+		do_detach(dev);
+		atomic_set(&dev_data->bind, 0);
+	}
 
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index fe1686f..7ffc399 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -165,12 +165,6 @@ u16 *amd_iommu_alias_table;
 struct amd_iommu **amd_iommu_rlookup_table;
 
 /*
- * The pd table (protection domain table) is used to find the protection domain
- * data structure a device belongs to. Indexed with the PCI device id too.
- */
-struct protection_domain **amd_iommu_pd_table;
-
-/*
  * AMD IOMMU allows up to 2^16 differend protection domains. This is a bitmap
  * to know which ones are already in use.
  */
@@ -1238,15 +1232,6 @@ static int __init amd_iommu_init(void)
 	if (amd_iommu_rlookup_table == NULL)
 		goto free;
 
-	/*
-	 * Protection Domain table - maps devices to protection domains
-	 * This table has the same size as the rlookup_table
-	 */
-	amd_iommu_pd_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-				     get_order(rlookup_table_size));
-	if (amd_iommu_pd_table == NULL)
-		goto free;
-
 	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(
 					    GFP_KERNEL | __GFP_ZERO,
 					    get_order(MAX_DOMAIN_ID/8));
@@ -1314,9 +1299,6 @@ free:
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
 		   get_order(MAX_DOMAIN_ID/8));
 
-	free_pages((unsigned long)amd_iommu_pd_table,
-		   get_order(rlookup_table_size));
-
 	free_pages((unsigned long)amd_iommu_rlookup_table,
 		   get_order(rlookup_table_size));
 
-- 
1.6.5.3


