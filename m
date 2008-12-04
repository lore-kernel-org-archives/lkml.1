Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbYLDRhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbYLDRhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbYLDRc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:26 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47521 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbYLDRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:11 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBD4P8-04-YDN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/19] AMD IOMMU: add protection domain flags
Date: Thu, 4 Dec 2008 18:31:46 +0100
Message-ID: <1228411916-22668-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0214 (UTC) FILETIME=[34E0CBE0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imapct: add a new struct member to 'struct protection_domain'

When using protection domains for dma_ops and KVM its better to know for
which subsystem it was allocated. Add a flags member to struct
protection domain for that purpose.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   14 +++++++++-----
 arch/x86/kernel/amd_iommu.c            |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 1a30c04..b74d35f 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -190,16 +190,20 @@
 /* FIXME: move this macro to <linux/pci.h> */
 #define PCI_BUS(x) (((x) >> 8) & 0xff)
 
+/* Protection domain flags */
+#define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
+
 /*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
  */
 struct protection_domain {
-	spinlock_t lock; /* mostly used to lock the page table*/
-	u16 id;		 /* the domain id written to the device table */
-	int mode;	 /* paging mode (0-6 levels) */
-	u64 *pt_root;	 /* page table root pointer */
-	void *priv;	 /* private data */
+	spinlock_t lock;	/* mostly used to lock the page table*/
+	u16 id;			/* the domain id written to the device table */
+	int mode;		/* paging mode (0-6 levels) */
+	u64 *pt_root;		/* page table root pointer */
+	unsigned long flags;	/* flags to find out type of domain */
+	void *priv;		/* private data */
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 3fb5a04..07ef5e9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -723,6 +723,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 		goto free_dma_dom;
 	dma_dom->domain.mode = PAGE_MODE_3_LEVEL;
 	dma_dom->domain.pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+	dma_dom->domain.flags = PD_DMA_OPS_MASK;
 	dma_dom->domain.priv = dma_dom;
 	if (!dma_dom->domain.pt_root)
 		goto free_dma_dom;
-- 
1.5.6.4


