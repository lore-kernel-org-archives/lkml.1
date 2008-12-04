Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbYLDRmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbYLDRmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYLDRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:54 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15535 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639AbYLDRc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:26 -0500
X-BigFish: VPS3(zzzzzzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KBD4PA-03-CXC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/19] AMD IOMMU: add domain init function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:49 +0100
Message-ID: <1228411916-22668-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0277 (UTC) FILETIME=[34EA68D0:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function for allocation protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index afd2128..5d56cba 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -22,6 +22,7 @@
 #include <linux/bitops.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/iommu.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/amd_iommu_types.h>
@@ -1473,3 +1474,40 @@ free_domains:
 
 	return ret;
 }
+
+/*****************************************************************************
+ *
+ * The following functions belong to the exported interface of AMD IOMMU
+ *
+ * This interface allows access to lower level functions of the IOMMU
+ * like protection domain handling and assignement of devices to domains
+ * which is not possible with the dma_ops interface.
+ *
+ *****************************************************************************/
+
+static int amd_iommu_domain_init(struct iommu_domain *dom)
+{
+	struct protection_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return -ENOMEM;
+
+	spin_lock_init(&domain->lock);
+	domain->mode = PAGE_MODE_3_LEVEL;
+	domain->id = domain_id_alloc();
+	if (!domain->id)
+		goto out_free;
+	domain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!domain->pt_root)
+		goto out_free;
+
+	dom->priv = domain;
+
+	return 0;
+
+out_free:
+	kfree(domain);
+
+	return -ENOMEM;
+}
-- 
1.5.6.4


