Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbYK0PoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbYK0PoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYK0Pld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:33 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:30593 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYK0PlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:18 -0500
X-BigFish: VPS-3(ze80iz18c1K655Oc8kzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KB00W6-04-B7S-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] add frontend implementation for the IOMMU API
Date: Thu, 27 Nov 2008 16:40:48 +0100
Message-ID: <1227800454-9555-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0805 (UTC) FILETIME=[88E19C50:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/base/iommu.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/iommu.c

diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
new file mode 100644
index 0000000..7250b9c
--- /dev/null
+++ b/drivers/base/iommu.c
@@ -0,0 +1,94 @@
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
+#include <linux/bug.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/iommu.h>
+
+static struct iommu_ops *iommu_ops;
+
+void register_iommu(struct iommu_ops *ops)
+{
+	if (iommu_ops)
+		BUG();
+
+	iommu_ops = ops;
+}
+
+bool iommu_found()
+{
+	return iommu_ops != NULL;
+}
+EXPORT_SYMBOL_GPL(iommu_found);
+
+struct iommu_domain *iommu_domain_alloc(struct device *dev)
+{
+	struct iommu_domain *domain;
+	int ret;
+
+	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	ret = iommu_ops->domain_init(domain, dev);
+	if (ret)
+		goto out_free;
+
+	return domain;
+
+out_free:
+	kfree(domain);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(iommu_domain_alloc);
+
+void iommu_domain_free(struct iommu_domain *domain)
+{
+	iommu_ops->domain_destroy(domain);
+	kfree(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_free);
+
+int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
+{
+	return iommu_ops->attach_dev(domain, dev);
+}
+EXPORT_SYMBOL_GPL(iommu_attach_device);
+
+void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
+{
+	iommu_ops->detach_dev(domain, dev);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_device);
+
+int iommu_map_address(struct iommu_domain *domain,
+		      dma_addr_t iova, phys_addr_t paddr,
+		      size_t size, int prot)
+{
+	return iommu_ops->map(domain, iova, paddr, size, prot);
+}
+EXPORT_SYMBOL_GPL(iommu_map_address);
+
+phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
+			       dma_addr_t iova)
+{
+	return iommu_ops->iova_to_phys(domain, iova);
+}
+EXPORT_SYMBOL_GPL(iommu_iova_to_phys);
-- 
1.5.6.4


