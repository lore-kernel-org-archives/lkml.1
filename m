Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbZIDJpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbZIDJpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933476AbZIDJpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:20 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:21490
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933340AbZIDJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:16 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXRA-04-HZQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/8] x86/amd-iommu: Panic if IOMMU command buffer reset fails
Date: Fri, 4 Sep 2009 11:44:41 +0200
Message-ID: <1252057482-32207-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0429 (UTC) FILETIME=[55D15A50:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent the driver from doing recursive command buffer
resets, just panic when that recursion happens.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 +++
 arch/x86/kernel/amd_iommu.c            |    7 +++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index c54bc97..e676746 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -337,6 +337,9 @@ struct amd_iommu {
 	/* if one, we need to send a completion wait command */
 	bool need_sync;
 
+	/* becomes true if a command buffer reset is running */
+	bool reset_in_progress;
+
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 };
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2333d61..b62a2f6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -553,9 +553,16 @@ static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 {
 	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
 
+	if (iommu->reset_in_progress)
+		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
+
+	iommu->reset_in_progress = true;
+
 	amd_iommu_reset_cmd_buffer(iommu);
 	flush_all_devices_for_iommu(iommu);
 	flush_all_domains_on_iommu(iommu);
+
+	iommu->reset_in_progress = false;
 }
 
 /****************************************************************************
-- 
1.6.3.3


