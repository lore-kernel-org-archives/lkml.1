Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZK0N4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZK0N4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZK0Nz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:55:59 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52763
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753034AbZK0Nz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:56 -0500
X-SpamScore: 0
X-BigFish: VPS0(zz10d1Izz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD2-02-34N-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/34] x86/amd-iommu: Implement protection domain list
Date: Fri, 27 Nov 2009 14:55:20 +0100
Message-ID: <1259330145-14865-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0061 (UTC) FILETIME=[528B98D0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to keep a global list of all protection
domains. This allows to simplify the resume code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    7 ++++++
 arch/x86/kernel/amd_iommu.c            |   33 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/amd_iommu_init.c       |    8 +++++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index e68b148..b332b7f 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -231,6 +231,7 @@ extern bool amd_iommu_dump;
  * independent of their use.
  */
 struct protection_domain {
+	struct list_head list;  /* for list of all protection domains */
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
@@ -376,6 +377,12 @@ extern struct amd_iommu *amd_iommus[MAX_IOMMUS];
 extern int amd_iommus_present;
 
 /*
+ * Declarations for the global list of all protection domains
+ */
+extern spinlock_t amd_iommu_pd_lock;
+extern struct list_head amd_iommu_pd_list;
+
+/*
  * Structure defining one entry in the device table
  */
 struct dev_table_entry {
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b2c19f4..0c4319b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -985,6 +985,31 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
  *
  ****************************************************************************/
 
+/*
+ * This function adds a protection domain to the global protection domain list
+ */
+static void add_domain_to_list(struct protection_domain *domain)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
+	list_add(&domain->list, &amd_iommu_pd_list);
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
+}
+
+/*
+ * This function removes a protection domain to the global
+ * protection domain list
+ */
+static void del_domain_from_list(struct protection_domain *domain)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
+	list_del(&domain->list);
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
+}
+
 static u16 domain_id_alloc(void)
 {
 	unsigned long flags;
@@ -1073,6 +1098,8 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 	if (!dom)
 		return;
 
+	del_domain_from_list(&dom->domain);
+
 	free_pagetable(&dom->domain);
 
 	for (i = 0; i < APERTURE_MAX_RANGES; ++i) {
@@ -1113,6 +1140,8 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 	dma_dom->need_flush = false;
 	dma_dom->target_dev = 0xffff;
 
+	add_domain_to_list(&dma_dom->domain);
+
 	if (alloc_new_range(iommu, dma_dom, true, GFP_KERNEL))
 		goto free_dma_dom;
 
@@ -2188,6 +2217,8 @@ static void protection_domain_free(struct protection_domain *domain)
 	if (!domain)
 		return;
 
+	del_domain_from_list(domain);
+
 	if (domain->id)
 		domain_id_free(domain->id);
 
@@ -2207,6 +2238,8 @@ static struct protection_domain *protection_domain_alloc(void)
 	if (!domain->id)
 		goto out_err;
 
+	add_domain_to_list(domain);
+
 	return domain;
 
 out_err:
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8567d16..73d5173 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -142,6 +142,12 @@ struct amd_iommu *amd_iommus[MAX_IOMMUS];
 int amd_iommus_present;
 
 /*
+ * List of protection domains - used during resume
+ */
+LIST_HEAD(amd_iommu_pd_list);
+spinlock_t amd_iommu_pd_lock;
+
+/*
  * Pointer to the device table which is shared by all AMD IOMMUs
  * it is indexed by the PCI device id or the HT unit id and contains
  * information about the domain the device belongs to as well as the
@@ -1263,6 +1269,8 @@ static int __init amd_iommu_init(void)
 	 */
 	amd_iommu_pd_alloc_bitmap[0] = 1;
 
+	spin_lock_init(&amd_iommu_pd_lock);
+
 	/*
 	 * now the data structures are allocated and basically initialized
 	 * start the real acpi table scan
-- 
1.6.5.3


