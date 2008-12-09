Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYLIOVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYLIOVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYLIOQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:43 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:39373 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYLIOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:29 -0500
X-BigFish: VPS3(zzzzzzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4Z8-03-KKT-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/21] AMD IOMMU: add device detach helper functions
Date: Tue, 9 Dec 2008 15:16:09 +0100
Message-ID: <1228832178-13429-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-12-git-send-email-joerg.roedel@amd.com>
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
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0114 (UTC) FILETIME=[B47DA0A0:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add helper functions to detach a device from a domain

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 61584d5..47158e3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1469,3 +1469,44 @@ free_domains:
 
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
+static void __detach_device(struct protection_domain *domain, u16 devid)
+{
+
+	/* lock domain */
+	spin_lock(&domain->lock);
+
+	/* remove domain from the lookup table */
+	amd_iommu_pd_table[devid] = NULL;
+
+	/* remove entry from the device table seen by the hardware */
+	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
+	amd_iommu_dev_table[devid].data[1] = 0;
+	amd_iommu_dev_table[devid].data[2] = 0;
+
+	/* decrease reference counter */
+	domain->dev_cnt -= 1;
+
+	/* ready */
+	spin_unlock(&domain->lock);
+}
+
+static void detach_device(struct protection_domain *domain, u16 devid)
+{
+	unsigned long flags;
+
+	/* lock device table */
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	__detach_device(domain, devid);
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+}
-- 
1.5.6.4


