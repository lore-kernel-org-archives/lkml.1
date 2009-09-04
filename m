Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbZIDJqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbZIDJqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbZIDJqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:46:45 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:48577
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933559AbZIDJpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:41 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXRX-02-2ET-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/8] x86/amd-iommu: Add reset function for command buffers
Date: Fri, 4 Sep 2009 11:44:39 +0200
Message-ID: <1252057482-32207-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0429 (UTC) FILETIME=[55D15A50:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors parts of the command buffer
initialization code into a seperate function which can be
used to reset the command buffer later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 +++
 arch/x86/kernel/amd_iommu_init.c       |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0c878ca..c54bc97 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -457,4 +457,7 @@ static inline void amd_iommu_stats_init(void) { }
 
 #endif /* CONFIG_AMD_IOMMU_STATS */
 
+/* some function prototypes */
+extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
+
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c1b17e9..1752afe 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -435,6 +435,20 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 }
 
 /*
+ * This function resets the command buffer if the IOMMU stopped fetching
+ * commands from it.
+ */
+void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
+
+	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
+	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
+}
+
+/*
  * This function writes the command buffer address to the hardware and
  * enables it.
  */
@@ -450,11 +464,7 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
-	/* set head and tail to zero manually */
-	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
-	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
-
-	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
+	amd_iommu_reset_cmd_buffer(iommu);
 }
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
-- 
1.6.3.3


