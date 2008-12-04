Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbYLDRbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbYLDRbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYLDR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:21 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36498 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbYLDR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:10 -0500
X-BigFish: VPS-3(ze80iz18c1K655Oc8kzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBD4K5-03-CR7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/11] add frontend implementation for the IOMMU API
Date: Thu, 4 Dec 2008 18:28:48 +0100
Message-ID: <1228411736-22644-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0694 (UTC) FILETIME=[C947A160:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This API can be used by KVM for accessing different types of IOMMUs to
do device passthrough to guests. Beside that this API can also be used
by device drivers to map non-linear host memory into dma-linear
addresses to prevent sgather-gather DMA. UIO may be another user for
this API.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/base/iommu.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 100 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/iommu.c

diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
new file mode 100644
index 0000000..5e039d4
--- /dev/null
+++ b/drivers/base/iommu.c
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
+struct iommu_domain *iommu_domain_alloc(void)
+{
+	struct iommu_domain *domain;
+	int ret;
+
+	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	ret = iommu_ops->domain_init(domain);
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
+int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
+		    phys_addr_t paddr, size_t size, int prot)
+{
+	return iommu_ops->map(domain, iova, paddr, size, prot);
+}
+EXPORT_SYMBOL_GPL(iommu_map_range);
+
+void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
+		      size_t size)
+{
+	iommu_ops->unmap(domain, iova, size);
+}
+EXPORT_SYMBOL_GPL(iommu_unmap_range);
+
+phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
+			       unsigned long iova)
+{
+	return iommu_ops->iova_to_phys(domain, iova);
+}
+EXPORT_SYMBOL_GPL(iommu_iova_to_phys);
-- 
1.5.6.4


