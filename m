Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224Ab0A1LlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0A1LlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686Ab0A1Lkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:40:49 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:51731 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0A1Lie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:34 -0500
X-SpamScore: 3
X-BigFish: VPS3(z2d9bozab9bh936eMzz1202hzzz32i6bh87h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBY-01-FXQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/11] iommu-api: Add ->{un}map callbacks to iommu_ops
Date: Thu, 28 Jan 2010 12:37:54 +0100
Message-ID: <1264678682-30655-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0758 (UTC) FILETIME=[64618760:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new callbacks for mapping and unmapping
pages to the iommu_ops structure. These callbacks are aware
of page sizes which makes them different to the
->{un}map_range callbacks.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/base/iommu.c  |    6 ++++++
 include/linux/iommu.h |    4 ++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index cf7cbec..55d37e4 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -119,6 +119,9 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 
 	BUG_ON((iova | paddr) & invalid_mask);
 
+	if (iommu_ops->map)
+		return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
+
 	return iommu_ops->map_range(domain, iova, paddr, size, prot);
 }
 EXPORT_SYMBOL_GPL(iommu_map);
@@ -133,6 +136,9 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 
 	BUG_ON(iova & invalid_mask);
 
+	if (iommu_ops->unmap)
+		return iommu_ops->unmap(domain, iova, gfp_order);
+
 	iommu_ops->unmap_range(domain, iova, size);
 
 	return gfp_order;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6d0035b..5a7a3d8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -36,6 +36,10 @@ struct iommu_ops {
 	void (*domain_destroy)(struct iommu_domain *domain);
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
+	int (*map)(struct iommu_domain *domain, unsigned long iova,
+		   phys_addr_t paddr, int gfp_order, int prot);
+	int (*unmap)(struct iommu_domain *domain, unsigned long iova,
+		     int gfp_order);
 	int (*map_range)(struct iommu_domain *domain, unsigned long iova,
 			 phys_addr_t paddr, size_t size, int prot);
 	void (*unmap_range)(struct iommu_domain *domain, unsigned long iova,
-- 
1.6.6


