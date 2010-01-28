Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089Ab0A1Lj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0A1Lj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701Ab0A1LjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:39:18 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:47666
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932264Ab0A1LjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:39:13 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBW-02-6ZX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/11] iommu-api: Add iommu_map and iommu_unmap functions
Date: Thu, 28 Jan 2010 12:37:53 +0100
Message-ID: <1264678682-30655-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0727 (UTC) FILETIME=[645CCC70:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions provide support for mapping and
unmapping physical addresses to io virtual addresses. The
difference to the iommu_(un)map_range() is that the new
functions take a gfp_order parameter instead of a size. This
allows the IOMMU backend implementations to detect easier if
a given range can be mapped by larger page sizes.
These new functions should replace the old ones in the long
term.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/base/iommu.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/iommu.h |   16 ++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index f4c86c4..cf7cbec 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -107,3 +107,34 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
 	return iommu_ops->domain_has_cap(domain, cap);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
+
+int iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, int gfp_order, int prot)
+{
+	unsigned long invalid_mask;
+	size_t size;
+
+	size         = 0x1000UL << gfp_order;
+	invalid_mask = size - 1;
+
+	BUG_ON((iova | paddr) & invalid_mask);
+
+	return iommu_ops->map_range(domain, iova, paddr, size, prot);
+}
+EXPORT_SYMBOL_GPL(iommu_map);
+
+int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
+{
+	unsigned long invalid_mask;
+	size_t size;
+
+	size         = 0x1000UL << gfp_order;
+	invalid_mask = size - 1;
+
+	BUG_ON(iova & invalid_mask);
+
+	iommu_ops->unmap_range(domain, iova, size);
+
+	return gfp_order;
+}
+EXPORT_SYMBOL_GPL(iommu_unmap);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0f18f37..6d0035b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -60,6 +60,10 @@ extern int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
 			   phys_addr_t paddr, size_t size, int prot);
 extern void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
 			      size_t size);
+extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
+		     phys_addr_t paddr, int gfp_order, int prot);
+extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+		       int gfp_order);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
@@ -108,6 +112,18 @@ static inline void iommu_unmap_range(struct iommu_domain *domain,
 {
 }
 
+static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
+			    phys_addr_t paddr, int gfp_order, int prot)
+{
+	return -ENODEV;
+}
+
+static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			      int gfp_order)
+{
+	return -ENODEV;
+}
+
 static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 					     unsigned long iova)
 {
-- 
1.6.6


