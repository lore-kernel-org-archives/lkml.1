Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYIQQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYIQQ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYIQQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:20 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53008 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbYIQQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:17 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7CMWB-04-US4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/23] AMD IOMMU: don't assing preallocated protection domains to devices
Date: Wed, 17 Sep 2008 18:52:48 +0200
Message-ID: <1221670377-19295-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0126 (UTC) FILETIME=[D673CAE0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In isolation mode the protection domains for the devices are
preallocated and preassigned. This is bad if a device should be passed
to a virtualization guest because the IOMMU code does not know if it is
in use by a driver. This patch changes the code to assign the device to
the preallocated domain only if there were dma mapping requests for it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |   43 ++++++++++++++++++++++++++++++++----
 include/asm-x86/amd_iommu_types.h |    6 +++++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0410be1..09d5e92 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -33,6 +33,10 @@
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
+/* A list of preallocated protection domains */
+static LIST_HEAD(iommu_pd_list);
+static DEFINE_SPINLOCK(iommu_pd_list_lock);
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -663,6 +667,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->next_bit = 0;
 
 	dma_dom->need_flush = false;
+	dma_dom->target_dev = 0xffff;
 
 	/* Intialize the exclusion range if necessary */
 	if (iommu->exclusion_start &&
@@ -769,6 +774,33 @@ static bool check_device(struct device *dev)
 }
 
 /*
+ * In this function the list of preallocated protection domains is traversed to
+ * find the domain for a specific device
+ */
+static struct dma_ops_domain *find_protection_domain(u16 devid)
+{
+	struct dma_ops_domain *entry, *ret = NULL;
+	unsigned long flags;
+
+	if (list_empty(&iommu_pd_list))
+		return NULL;
+
+	spin_lock_irqsave(&iommu_pd_list_lock, flags);
+
+	list_for_each_entry(entry, &iommu_pd_list, list) {
+		if (entry->target_dev == devid) {
+			ret = entry;
+			list_del(&ret->list);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+
+	return ret;
+}
+
+/*
  * In the dma_ops path we only have the struct device. This function
  * finds the corresponding IOMMU, the protection domain and the
  * requestor id for a given device.
@@ -803,9 +835,11 @@ static int get_device_resources(struct device *dev,
 	*iommu = amd_iommu_rlookup_table[*bdf];
 	if (*iommu == NULL)
 		return 0;
-	dma_dom = (*iommu)->default_dom;
 	*domain = domain_for_device(*bdf);
 	if (*domain == NULL) {
+		dma_dom = find_protection_domain(*bdf);
+		if (!dma_dom)
+			dma_dom = (*iommu)->default_dom;
 		*domain = &dma_dom->domain;
 		set_device_domain(*iommu, *domain, *bdf);
 		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
@@ -1257,10 +1291,9 @@ void prealloc_protection_domains(void)
 		if (!dma_dom)
 			continue;
 		init_unity_mappings_for_device(dma_dom, devid);
-		set_device_domain(iommu, &dma_dom->domain, devid);
-		printk(KERN_INFO "AMD IOMMU: Allocated domain %d for device ",
-		       dma_dom->domain.id);
-		print_devid(devid, 1);
+		dma_dom->target_dev = devid;
+
+		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
 }
 
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 1c9d8d4..56dc6bd 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -227,6 +227,12 @@ struct dma_ops_domain {
 
 	/* This will be set to true when TLB needs to be flushed */
 	bool need_flush;
+
+	/*
+	 * if this is a preallocated domain, keep the device for which it was
+	 * preallocated in this variable
+	 */
+	u16 target_dev;
 };
 
 /*
-- 
1.5.6.4


