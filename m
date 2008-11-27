Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYK0Pmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYK0Pmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYK0PlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:23 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:61815 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYK0PlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:11 -0500
X-BigFish: VPS-4(zz18c1K655Oc8kzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KB00W7-03-L7B-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] introcude linux/iommu.h for an iommu api
Date: Thu, 27 Nov 2008 16:40:47 +0100
Message-ID: <1227800454-9555-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0789 (UTC) FILETIME=[88DF2B50:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the API to abstract the exported VT-d functions
for KVM into a generic API. This way the AMD IOMMU implementation can
plug into this API later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/iommu.h |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/iommu.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
new file mode 100644
index 0000000..6dbc279
--- /dev/null
+++ b/include/linux/iommu.h
@@ -0,0 +1,100 @@
+/*
+ * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef __LINUX_IOMMU_H
+#define __LINUX_IOMMU_H
+
+struct device;
+
+struct iommu_domain {
+	void *priv;
+};
+
+struct iommu_ops {
+	int (*domain_init)(struct iommu_domain *domain, struct device *dev);
+	void (*domain_destroy)(struct iommu_domain *domain);
+	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
+	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
+	int (*map)(struct iommu_domain *domain, dma_addr_t iova,
+		   phys_addr_t paddr, size_t size, int prot);
+	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
+				    dma_addr_t iova);
+};
+
+#ifdef CONFIG_IOMMU_API
+
+extern void register_iommu(struct iommu_ops *ops);
+extern bool iommu_found(void);
+extern struct iommu_domain *iommu_domain_alloc(struct device *dev);
+extern void iommu_domain_free(struct iommu_domain *domain);
+extern int iommu_attach_device(struct iommu_domain *domain,
+			       struct device *dev);
+extern void iommu_detach_device(struct iommu_domain *domain,
+				struct device *dev);
+extern int iommu_map_address(struct iommu_domain *domain, dma_addr_t iova,
+			     phys_addr_t paddr, size_t size, int prot);
+extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
+				      dma_addr_t iova);
+
+#else /* CONFIG_IOMMU_API */
+
+static inline void register_iommu(struct iommu_ops *ops)
+{
+}
+
+static inline bool iommu_found(void)
+{
+	return false;
+}
+
+static inline struct iommu_domain *iommu_domain_alloc(struct device *dev)
+{
+	return NULL;
+}
+
+static inline void iommu_domain_free(struct iommu_domain *domain)
+{
+}
+
+static inline int iommu_attach_device(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline void iommu_detach_device(struct iommu_domain *domain,
+				       struct device *dev)
+{
+}
+
+static inline int iommu_map_address(struct iommu_domain *domain,
+				    dma_addr_t iova, phys_addr_t paddr,
+				    size_t size, int prot)
+{
+	return -ENODEV;
+}
+
+static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
+					     dma_addr_t iova)
+{
+	return 0;
+}
+
+#endif /* CONFIG_IOMMU_API */
+
+#endif /* __LINUX_IOMMU_H */
-- 
1.5.6.4


