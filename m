Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYLDRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYLDRlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbYLDRcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:51 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38202 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbYLDRcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:22 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4P6-04-YDI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/19] AMD IOMMU: refactor completion wait handling into separate functions
Date: Thu, 4 Dec 2008 18:31:43 +0100
Message-ID: <1228411916-22668-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0089 (UTC) FILETIME=[34CDB910:01C95636]
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
 arch/x86/kernel/amd_iommu.c |   67 +++++++++++++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b774638..ac801f1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -193,31 +193,14 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 }
 
 /*
- * This function is called whenever we need to ensure that the IOMMU has
- * completed execution of all commands we sent. It sends a
- * COMPLETION_WAIT command and waits for it to finish. The IOMMU informs
- * us about that by writing a value to a physical address we pass with
- * the command.
+ * This function waits until an IOMMU has completed a completion
+ * wait command
  */
-static int iommu_completion_wait(struct amd_iommu *iommu)
+static void __iommu_wait_for_completion(struct amd_iommu *iommu)
 {
-	int ret = 0, ready = 0;
+	int ready = 0;
 	unsigned status = 0;
-	struct iommu_cmd cmd;
-	unsigned long flags, i = 0;
-
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
-	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
-
-	iommu->need_sync = 0;
-
-	spin_lock_irqsave(&iommu->lock, flags);
-
-	ret = __iommu_queue_command(iommu, &cmd);
-
-	if (ret)
-		goto out;
+	unsigned long i = 0;
 
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
@@ -232,6 +215,46 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
 		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+}
+
+/*
+ * This function queues a completion wait command into the command
+ * buffer of an IOMMU
+ */
+static int __iommu_completion_wait(struct amd_iommu *iommu)
+{
+
+	struct iommu_cmd cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
+	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
+
+	return __iommu_queue_command(iommu, &cmd);
+}
+
+/*
+ * This function is called whenever we need to ensure that the IOMMU has
+ * completed execution of all commands we sent. It sends a
+ * COMPLETION_WAIT command and waits for it to finish. The IOMMU informs
+ * us about that by writing a value to a physical address we pass with
+ * the command.
+ */
+static int iommu_completion_wait(struct amd_iommu *iommu)
+{
+	int ret;
+	unsigned long flags;
+
+	iommu->need_sync = 0;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+
+	ret = __iommu_completion_wait(iommu);
+
+	if (ret)
+		goto out;
+
+	__iommu_wait_for_completion(iommu);
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
-- 
1.5.6.4


