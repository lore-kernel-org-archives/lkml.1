Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbYLIO0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbYLIO0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYLIORU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:20 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41387 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYLIOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:45 -0500
X-BigFish: VPS4(ze80izzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBM4ZA-04-AES-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/21] AMD IOMMU: register functions for the IOMMU API
Date: Tue, 9 Dec 2008 15:16:18 +0100
Message-ID: <1228832178-13429-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-21-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-8-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-9-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-10-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-11-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-12-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-13-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-14-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-15-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-16-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-17-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-18-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-19-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-20-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-21-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0411 (UTC) FILETIME=[B4AAF230:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b42578b..6670aae 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -38,6 +38,8 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
+static struct iommu_ops amd_iommu_ops;
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -1481,6 +1483,8 @@ int __init amd_iommu_init_dma_ops(void)
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
 
+	register_iommu(&amd_iommu_ops);
+
 	return 0;
 
 free_domains:
@@ -1733,3 +1737,13 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 
 	return paddr;
 }
+
+static struct iommu_ops amd_iommu_ops = {
+	.domain_init = amd_iommu_domain_init,
+	.domain_destroy = amd_iommu_domain_destroy,
+	.attach_dev = amd_iommu_attach_device,
+	.detach_dev = amd_iommu_detach_device,
+	.map = amd_iommu_map_range,
+	.unmap = amd_iommu_unmap_range,
+	.iova_to_phys = amd_iommu_iova_to_phys,
+};
-- 
1.5.6.4


