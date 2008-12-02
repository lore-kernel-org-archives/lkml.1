Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYLBNBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYLBNBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYLBNBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:01:33 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:49112 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYLBNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:31 -0500
X-BigFish: VPS-4(zz18c1K655Oc8kzzzzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UA-04-VCJ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/12] introcude linux/iommu.h for an iommu api
Date: Tue, 2 Dec 2008 14:01:15 +0100
Message-ID: <1228222883-17207-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0833 (UTC) FILETIME=[1433EE90:01C9547E]
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
 include/linux/iommu.h |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/iommu.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
new file mode 100644
index 0000000..47e9ec8
--- /dev/null
+++ b/include/linux/iommu.h
@@ -0,0 +1,109 @@
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
+	int (*domain_init)(struct iommu_domain *domain);
+	void (*domain_destroy)(struct iommu_domain *domain);
+	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
+	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
+	int (*map)(struct iommu_domain *domain, unsigned long iova,
+		   phys_addr_t paddr, size_t size, int prot);
+	void (*unmap)(struct iommu_domain *domain, unsigned long iova,
+		      size_t size);
+	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
+				    unsigned long iova);
+};
+
+#ifdef CONFIG_IOMMU_API
+
+extern void register_iommu(struct iommu_ops *ops);
+extern bool iommu_found(void);
+extern struct iommu_domain *iommu_domain_alloc(void);
+extern void iommu_domain_free(struct iommu_domain *domain);
+extern int iommu_attach_device(struct iommu_domain *domain,
+			       struct device *dev);
+extern void iommu_detach_device(struct iommu_domain *domain,
+				struct device *dev);
+extern int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
+			   phys_addr_t paddr, size_t size, int prot);
+extern void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
+			      size_t size);
+extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
+				      unsigned long iova);
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
+static inline struct iommu_domain *iommu_domain_alloc(void)
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
+static inline int iommu_map_range(struct iommu_domain *domain,
+				  unsigned long iova, phys_addr_t paddr,
+				  size_t size, int prot)
+{
+	return -ENODEV;
+}
+
+static inline void iommu_unmap_range(struct iommu_domain *domain,
+				     unsigned long iova, size_t size)
+{
+}
+
+static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
+					     unsigned long iova)
+{
+	return 0;
+}
+
+#endif /* CONFIG_IOMMU_API */
+
+#endif /* __LINUX_IOMMU_H */
-- 
1.5.6.4


