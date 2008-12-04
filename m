Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYLDRgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYLDRgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbYLDRcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:15 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27818 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbYLDRcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:09 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4P6-04-YDK-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/19] AMD IOMMU: move invalidation command building to a separate function
Date: Thu, 4 Dec 2008 18:31:44 +0100
Message-ID: <1228411916-22668-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0152 (UTC) FILETIME=[34D75600:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: refactoring of iommu_queue_inv_iommu_pages

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ac801f1..d4d0369 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -282,6 +282,21 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 	return ret;
 }
 
+static void __iommu_build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
+					  u16 domid, int pde, int s)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	address &= PAGE_MASK;
+	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
+	cmd->data[1] |= domid;
+	cmd->data[2] = lower_32_bits(address);
+	cmd->data[3] = upper_32_bits(address);
+	if (s) /* size bit - we flush more than one 4kb page */
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
+}
+
 /*
  * Generic command send function for invalidaing TLB entries
  */
@@ -291,16 +306,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	struct iommu_cmd cmd;
 	int ret;
 
-	memset(&cmd, 0, sizeof(cmd));
-	address &= PAGE_MASK;
-	CMD_SET_TYPE(&cmd, CMD_INV_IOMMU_PAGES);
-	cmd.data[1] |= domid;
-	cmd.data[2] = lower_32_bits(address);
-	cmd.data[3] = upper_32_bits(address);
-	if (s) /* size bit - we flush more than one 4kb page */
-		cmd.data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
-	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
-		cmd.data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
+	__iommu_build_inv_iommu_pages(&cmd, address, domid, pde, s);
 
 	ret = iommu_queue_command(iommu, &cmd);
 
-- 
1.5.6.4


