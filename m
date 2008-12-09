Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYLIOWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYLIOWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYLIOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:50 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52802 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYLIOQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:29 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4Z7-03-KKP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/21] AMD IOMMU: refactor completion wait handling into separate functions
Date: Tue, 9 Dec 2008 15:16:03 +0100
Message-ID: <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:18.0896 (UTC) FILETIME=[B45C5D00:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: split one function into three

The separate functions are required synchronize commands across all
hardware IOMMUs in the system.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   65 +++++++++++++++++++++++++++++--------------
 1 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 11de0f1..db89001 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -195,6 +195,46 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 }
 
 /*
+ * This function waits until an IOMMU has completed a completion
+ * wait command
+ */
+static void __iommu_wait_for_completion(struct amd_iommu *iommu)
+{
+	int ready = 0;
+	unsigned status = 0;
+	unsigned long i = 0;
+
+	while (!ready && (i < EXIT_LOOP_COUNT)) {
+		++i;
+		/* wait for the bit to become one */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
+	}
+
+	/* set bit back to zero */
+	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
+	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
+	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
+		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+}
+
+/*
+ * This function queues a completion wait command into the command
+ * buffer of an IOMMU
+ */
+static int __iommu_completion_wait(struct amd_iommu *iommu)
+{
+	struct iommu_cmd cmd;
+
+	 memset(&cmd, 0, sizeof(cmd));
+	 cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
+	 CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
+
+	 return __iommu_queue_command(iommu, &cmd);
+}
+
+/*
  * This function is called whenever we need to ensure that the IOMMU has
  * completed execution of all commands we sent. It sends a
  * COMPLETION_WAIT command and waits for it to finish. The IOMMU informs
@@ -203,14 +243,8 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret = 0, ready = 0;
-	unsigned status = 0;
-	struct iommu_cmd cmd;
-	unsigned long flags, i = 0;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
-	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
+	int ret = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&iommu->lock, flags);
 
@@ -219,24 +253,13 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	iommu->need_sync = 0;
 
-	ret = __iommu_queue_command(iommu, &cmd);
+	ret = __iommu_completion_wait(iommu);
 
 	if (ret)
 		goto out;
 
-	while (!ready && (i < EXIT_LOOP_COUNT)) {
-		++i;
-		/* wait for the bit to become one */
-		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
-	}
-
-	/* set bit back to zero */
-	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
-	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
+	__iommu_wait_for_completion(iommu);
 
-	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
-		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
-- 
1.5.6.4


