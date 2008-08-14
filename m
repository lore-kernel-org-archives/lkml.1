Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbYHNR5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbYHNR5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbYHNRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:55:49 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:22672 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436AbYHNRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:55:47 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5LR4B-03-ZTN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] AMD IOMMU: use status bit instead of memory write-back for completion wait
Date: Thu, 14 Aug 2008 19:55:15 +0200
Message-ID: <1218736518-25301-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
References: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 14 Aug 2008 17:55:18.0548 (UTC) FILETIME=[E9DF6540:01C8FE36]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |   17 ++++++++++-------
 include/asm-x86/amd_iommu_types.h |    4 ++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 22d7d05..028e945 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -101,16 +101,13 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret;
+	int ret, ready = 0;
+	unsigned status = 0;
 	struct iommu_cmd cmd;
-	volatile u64 ready = 0;
-	unsigned long ready_phys = virt_to_phys(&ready);
 	unsigned long i = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.data[0] = LOW_U32(ready_phys) | CMD_COMPL_WAIT_STORE_MASK;
-	cmd.data[1] = upper_32_bits(ready_phys);
-	cmd.data[2] = 1; /* value written to 'ready' */
+	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
 	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
 
 	iommu->need_sync = 0;
@@ -122,9 +119,15 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
-		cpu_relax();
+		/* wait for the bit to become one */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
 	}
 
+	/* set bit back to zero */
+	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
+	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
 		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
 
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index e6b4d5b..2c23834 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -69,6 +69,9 @@
 #define MMIO_EVT_TAIL_OFFSET	0x2018
 #define MMIO_STATUS_OFFSET	0x2020
 
+/* MMIO status bits */
+#define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
+
 /* feature control bits */
 #define CONTROL_IOMMU_EN        0x00ULL
 #define CONTROL_HT_TUN_EN       0x01ULL
@@ -89,6 +92,7 @@
 #define CMD_INV_IOMMU_PAGES     0x03
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
+#define CMD_COMPL_WAIT_INT_MASK		0x02
 #define CMD_INV_IOMMU_PAGES_SIZE_MASK	0x01
 #define CMD_INV_IOMMU_PAGES_PDE_MASK	0x02
 
-- 
1.5.3.7


