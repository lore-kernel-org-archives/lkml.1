Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYLIOZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYLIOZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbYLIORP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:15 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53556 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYLIOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:43 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBM4Z7-03-KKO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/21] AMD IOMMU: move invalidation command building to a separate function
Date: Tue, 9 Dec 2008 15:16:04 +0100
Message-ID: <1228832178-13429-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0911 (UTC) FILETIME=[B45EA6F0:01C95A08]
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
index db89001..80758cc 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -285,6 +285,21 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
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
@@ -294,16 +309,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
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


