Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYLIOXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYLIOXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYLIOQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:57 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:39616 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYLIOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:31 -0500
X-BigFish: VPS-3(ze80iz18c1K655Oc8kzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4YY-03-KK9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/11] add frontend implementation for the IOMMU API
Date: Tue, 9 Dec 2008 15:16:02 +0100
Message-ID: <1228832170-13405-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832170-13405-1-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-2-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:10.0833 (UTC) FILETIME=[AF8E0C10:01C95A08]
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
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
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


