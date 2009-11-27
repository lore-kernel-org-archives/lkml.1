Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZK0N4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZK0N4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZK0N4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:14 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52994
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753294AbZK0N4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:56:01 -0500
X-SpamScore: 0
X-BigFish: VPS0(zz10d1Izz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD5-01-6RS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 25/34] x86/amd-iommu: Rearrange dma_ops related functions
Date: Fri, 27 Nov 2009 14:55:36 +0100
Message-ID: <1259330145-14865-26-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0357 (UTC) FILETIME=[52B8C350:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rearranges two dma_ops related functions so that
their forward declarations are not longer necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   89 ++++++++++++++++++++----------------------
 1 files changed, 42 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 90b3650..14b60c0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -57,11 +57,6 @@ struct iommu_cmd {
 	u32 data[4];
 };
 
-static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
-			     struct unity_map_entry *e);
-static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
-				      unsigned long start_page,
-				      unsigned int pages);
 static void reset_iommu_command_buffer(struct amd_iommu *iommu);
 static void update_domain(struct protection_domain *domain);
 
@@ -823,28 +818,6 @@ static int iommu_for_unity_map(struct amd_iommu *iommu,
 }
 
 /*
- * Init the unity mappings for a specific IOMMU in the system
- *
- * Basically iterates over all unity mapping entries and applies them to
- * the default domain DMA of that IOMMU if necessary.
- */
-static int iommu_init_unity_mappings(struct amd_iommu *iommu)
-{
-	struct unity_map_entry *entry;
-	int ret;
-
-	list_for_each_entry(entry, &amd_iommu_unity_map, list) {
-		if (!iommu_for_unity_map(iommu, entry))
-			continue;
-		ret = dma_ops_unity_map(iommu->default_dom, entry);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-/*
  * This function actually applies the mapping to the page table of the
  * dma_ops domain.
  */
@@ -873,6 +846,28 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 }
 
 /*
+ * Init the unity mappings for a specific IOMMU in the system
+ *
+ * Basically iterates over all unity mapping entries and applies them to
+ * the default domain DMA of that IOMMU if necessary.
+ */
+static int iommu_init_unity_mappings(struct amd_iommu *iommu)
+{
+	struct unity_map_entry *entry;
+	int ret;
+
+	list_for_each_entry(entry, &amd_iommu_unity_map, list) {
+		if (!iommu_for_unity_map(iommu, entry))
+			continue;
+		ret = dma_ops_unity_map(iommu->default_dom, entry);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
  * Inits the unity mappings required for a specific device
  */
 static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
@@ -909,6 +904,26 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  */
 
 /*
+ * Used to reserve address ranges in the aperture (e.g. for exclusion
+ * ranges.
+ */
+static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
+				      unsigned long start_page,
+				      unsigned int pages)
+{
+	unsigned int i, last_page = dom->aperture_size >> PAGE_SHIFT;
+
+	if (start_page + pages > last_page)
+		pages = last_page - start_page;
+
+	for (i = start_page; i < start_page + pages; ++i) {
+		int index = i / APERTURE_RANGE_PAGES;
+		int page  = i % APERTURE_RANGE_PAGES;
+		__set_bit(page, dom->aperture[index]->bitmap);
+	}
+}
+
+/*
  * This function is used to add a new aperture range to an existing
  * aperture in case of dma_ops domain allocation or address allocation
  * failure.
@@ -1166,26 +1181,6 @@ static void domain_id_free(int id)
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
-/*
- * Used to reserve address ranges in the aperture (e.g. for exclusion
- * ranges.
- */
-static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
-				      unsigned long start_page,
-				      unsigned int pages)
-{
-	unsigned int i, last_page = dom->aperture_size >> PAGE_SHIFT;
-
-	if (start_page + pages > last_page)
-		pages = last_page - start_page;
-
-	for (i = start_page; i < start_page + pages; ++i) {
-		int index = i / APERTURE_RANGE_PAGES;
-		int page  = i % APERTURE_RANGE_PAGES;
-		__set_bit(page, dom->aperture[index]->bitmap);
-	}
-}
-
 static void free_pagetable(struct protection_domain *domain)
 {
 	int i, j;
-- 
1.6.5.3


