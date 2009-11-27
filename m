Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZK0N7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZK0N7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZK0N7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:59:41 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16053
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753162AbZK0Nz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:58 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD6-01-6RV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/34] x86/amd-iommu: Move find_protection_domain to helper functions
Date: Fri, 27 Nov 2009 14:55:32 +0100
Message-ID: <1259330145-14865-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0295 (UTC) FILETIME=[52AF4D70:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a helper function and when its placed in the helper
function section we can remove its forward declaration.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   57 +++++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e5bbe9a..405f8da 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -59,7 +59,6 @@ struct iommu_cmd {
 
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
-static struct dma_ops_domain *find_protection_domain(u16 devid);
 static u64 *alloc_pte(struct protection_domain *domain,
 		      unsigned long address, int end_lvl,
 		      u64 **pte_page, gfp_t gfp);
@@ -84,6 +83,34 @@ static inline u16 get_device_id(struct device *dev)
 	return calc_devid(pdev->bus->number, pdev->devfn);
 }
 
+/*
+ * In this function the list of preallocated protection domains is traversed to
+ * find the domain for a specific device
+ */
+static struct dma_ops_domain *find_protection_domain(u16 devid)
+{
+	struct dma_ops_domain *entry, *ret = NULL;
+	unsigned long flags;
+	u16 alias = amd_iommu_alias_table[devid];
+
+	if (list_empty(&iommu_pd_list))
+		return NULL;
+
+	spin_lock_irqsave(&iommu_pd_list_lock, flags);
+
+	list_for_each_entry(entry, &iommu_pd_list, list) {
+		if (entry->target_dev == devid ||
+		    entry->target_dev == alias) {
+			ret = entry;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+
+	return ret;
+}
+
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -1456,34 +1483,6 @@ static bool check_device(struct device *dev)
 }
 
 /*
- * In this function the list of preallocated protection domains is traversed to
- * find the domain for a specific device
- */
-static struct dma_ops_domain *find_protection_domain(u16 devid)
-{
-	struct dma_ops_domain *entry, *ret = NULL;
-	unsigned long flags;
-	u16 alias = amd_iommu_alias_table[devid];
-
-	if (list_empty(&iommu_pd_list))
-		return NULL;
-
-	spin_lock_irqsave(&iommu_pd_list_lock, flags);
-
-	list_for_each_entry(entry, &iommu_pd_list, list) {
-		if (entry->target_dev == devid ||
-		    entry->target_dev == alias) {
-			ret = entry;
-			break;
-		}
-	}
-
-	spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
-
-	return ret;
-}
-
-/*
  * In the dma_ops path we only have the struct device. This function
  * finds the corresponding IOMMU, the protection domain and the
  * requestor id for a given device.
-- 
1.6.5.3


