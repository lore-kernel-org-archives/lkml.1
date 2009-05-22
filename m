Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZEVMQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZEVMQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbZEVMP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:15:58 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:35953
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758039AbZEVMP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:15:56 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OQB-03-949-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] amd-iommu: consolidate hardware initialization to one function
Date: Fri, 22 May 2009 14:15:33 +0200
Message-ID: <1242994540-28799-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0157 (UTC) FILETIME=[06AC9FD0:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup and consolidate hardware initialization

This patch restructures the AMD IOMMU initialization code to initialize
all hardware registers with one single function call.
This is helpful for suspend/resume support.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   50 ++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 675a4b6..74f4f1f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -252,13 +252,6 @@ static void __init iommu_enable(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
-/* Function to enable IOMMU event logging and event interrupts */
-static void __init iommu_enable_event_logging(struct amd_iommu *iommu)
-{
-	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
-	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
-}
-
 /*
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
@@ -413,25 +406,36 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 {
 	u8 *cmd_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 			get_order(CMD_BUFFER_SIZE));
-	u64 entry;
 
 	if (cmd_buf == NULL)
 		return NULL;
 
 	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
 
-	entry = (u64)virt_to_phys(cmd_buf);
+	return cmd_buf;
+}
+
+/*
+ * This function writes the command buffer address to the hardware and
+ * enables it.
+ */
+static void iommu_enable_command_buffer(struct amd_iommu *iommu)
+{
+	u64 entry;
+
+	BUG_ON(iommu->cmd_buf == NULL);
+
+	entry = (u64)virt_to_phys(iommu->cmd_buf);
 	entry |= MMIO_CMD_SIZE_512;
+
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-			&entry, sizeof(entry));
+		    &entry, sizeof(entry));
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
 	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 
 	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
-
-	return cmd_buf;
 }
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
@@ -443,20 +447,27 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 /* allocates the memory where the IOMMU will log its events to */
 static u8 * __init alloc_event_buffer(struct amd_iommu *iommu)
 {
-	u64 entry;
 	iommu->evt_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						get_order(EVT_BUFFER_SIZE));
 
 	if (iommu->evt_buf == NULL)
 		return NULL;
 
+	return iommu->evt_buf;
+}
+
+static void iommu_enable_event_buffer(struct amd_iommu *iommu)
+{
+	u64 entry;
+
+	BUG_ON(iommu->evt_buf == NULL);
+
 	entry = (u64)virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+
 	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
-	iommu->evt_buf_size = EVT_BUFFER_SIZE;
-
-	return iommu->evt_buf;
+	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 }
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
@@ -710,7 +721,6 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (!iommu->mmio_base)
 		return -ENOMEM;
 
-	iommu_set_device_table(iommu);
 	iommu->cmd_buf = alloc_command_buffer(iommu);
 	if (!iommu->cmd_buf)
 		return -ENOMEM;
@@ -837,6 +847,8 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 		return 1;
 	}
 
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+
 	return 0;
 }
 
@@ -972,9 +984,11 @@ static void __init enable_iommus(void)
 	struct amd_iommu *iommu;
 
 	for_each_iommu(iommu) {
+		iommu_set_device_table(iommu);
+		iommu_enable_command_buffer(iommu);
+		iommu_enable_event_buffer(iommu);
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
-		iommu_enable_event_logging(iommu);
 		iommu_enable(iommu);
 	}
 }
-- 
1.6.3.1


