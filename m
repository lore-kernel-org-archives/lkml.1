Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0BKOeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:34:37 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:44870
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751726Ab0BKOdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:39 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRO-01-0UL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/7] x86/amd-iommu: Add flush_info to protection domains
Date: Thu, 11 Feb 2010 15:33:11 +0100
Message-ID: <1265898797-32183-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0525 (UTC) FILETIME=[291BEA50:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new sub-struct to protection domains which
is used to keep information about what parts of the domain
needs to be flushed on the hardware side.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   11 +++++++++++
 arch/x86/kernel/amd_iommu.c            |   23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ba19ad4..30c4410 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -230,6 +230,16 @@ extern bool amd_iommu_np_cache;
 #define APERTURE_PAGE_INDEX(a)	(((a) >> 21) & 0x3fULL)
 
 /*
+ * This struct holds information about the parts of a protection domain that
+ * needs to be flushed on the IOMMU hardware.
+ */
+struct flush_info {
+	bool tlb;
+	u64 start;
+	u64 end;
+};
+
+/*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
  */
@@ -244,6 +254,7 @@ struct protection_domain {
 	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
+	struct flush_info flush;
 	void *priv;		/* private data */
 
 };
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index adb0ba0..fcb85e8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -78,6 +78,19 @@ static struct iommu_dev_data *get_dev_data(struct device *dev)
 	return dev->archdata.iommu;
 }
 
+static void update_flush_info_tlb(struct protection_domain *domain,
+				  u64 start, u64 end)
+{
+	if (!domain->flush.tlb) {
+		domain->flush.tlb   = true;
+		domain->flush.start = start;
+		domain->flush.end   = end;
+	} else {
+		domain->flush.start = min(start, domain->flush.start);
+		domain->flush.end   = max(end  , domain->flush.end);
+	}
+}
+
 /*
  * In this function the list of preallocated protection domains is traversed to
  * find the domain for a specific device
@@ -1849,6 +1862,9 @@ retry:
 
 	ADD_STATS_COUNTER(alloced_io_mem, size);
 
+	if (unlikely(amd_iommu_np_cache))
+		update_flush_info_tlb(&dma_dom->domain, start, size);
+
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
 		iommu_flush_tlb(&dma_dom->domain);
 		dma_dom->need_flush = false;
@@ -1895,6 +1911,8 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 		start += PAGE_SIZE;
 	}
 
+	update_flush_info_tlb(&dma_dom->domain, dma_addr, size);
+
 	SUB_STATS_COUNTER(alloced_io_mem, size);
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
@@ -2465,6 +2483,9 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 		paddr += PAGE_SIZE;
 	}
 
+	if (unlikely(amd_iommu_np_cache))
+		update_flush_info_tlb(domain, iova, iova + size);
+
 	return 0;
 }
 
@@ -2482,6 +2503,8 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 		iova  += PAGE_SIZE;
 	}
 
+	update_flush_info_tlb(domain, iova, iova + size);
+
 	iommu_flush_tlb_pde(domain);
 }
 
-- 
1.6.6


