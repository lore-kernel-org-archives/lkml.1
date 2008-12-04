Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYLDRfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYLDRfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbYLDRcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:13 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47323 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711AbYLDRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:08 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBD4P7-04-YDL-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/19] AMD IOMMU: add iommu_flush_domain function
Date: Thu, 4 Dec 2008 18:31:45 +0100
Message-ID: <1228411916-22668-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0152 (UTC) FILETIME=[34D75600:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a function to flush a domain id on every IOMMU

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d4d0369..3fb5a04 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -350,6 +350,28 @@ static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
 	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
 }
 
+/*
+ * This function is used to flush the IO/TLB for a given protection domain
+ * on every IOMMU in the system
+ */
+static void iommu_flush_domain(u16 domid)
+{
+	unsigned long flags;
+	struct amd_iommu *iommu;
+	struct iommu_cmd cmd;
+
+	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+				      domid, 1, 1);
+
+	list_for_each_entry(iommu, &amd_iommu_list, list) {
+		spin_lock_irqsave(&iommu->lock, flags);
+		__iommu_queue_command(iommu, &cmd);
+		__iommu_completion_wait(iommu);
+		__iommu_wait_for_completion(iommu);
+		spin_unlock_irqrestore(&iommu->lock, flags);
+	}
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
-- 
1.5.6.4


