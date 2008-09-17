Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYIQOYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYIQOYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYIQOYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:24:02 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:56735 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYIQOYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:24:00 -0400
X-BigFish: VPS-20(z21eWz936eQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7CFZC-03-MCW-01
Date: Wed, 17 Sep 2008 16:23:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU fixes for 2.6.27-rc6
Message-ID: <20080917142338.GA24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 17 Sep 2008 14:23:39.0288 (UTC) FILETIME=[FA919980:01C918D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

please pull two fixes for possible race conditions in the AMD IOMMU
command buffer handling code from

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-2.6.27

These patches should be merged into 2.6.27 because they are important
bugfixes. The diff is small enough so I attached it to this email.

Joerg Roedel (2):
      AMD IOMMU: set iommu sunc flag after command queuing
      AMD IOMMU: protect comletion wait loop with iommu lock

 arch/x86/kernel/amd_iommu.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 01c68c3..40509eb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -101,10 +101,10 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret, ready = 0;
+	int ret = 0, ready = 0;
 	unsigned status = 0;
 	struct iommu_cmd cmd;
-	unsigned long i = 0;
+	unsigned long flags, i = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
@@ -112,10 +112,12 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	iommu->need_sync = 0;
 
-	ret = iommu_queue_command(iommu, &cmd);
+	spin_lock_irqsave(&iommu->lock, flags);
+
+	ret = __iommu_queue_command(iommu, &cmd);
 
 	if (ret)
-		return ret;
+		goto out;
 
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
@@ -130,6 +132,8 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
 		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return 0;
 }
@@ -140,6 +144,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 {
 	struct iommu_cmd cmd;
+	int ret;
 
 	BUG_ON(iommu == NULL);
 
@@ -147,9 +152,11 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
 	cmd.data[0] = devid;
 
+	ret = iommu_queue_command(iommu, &cmd);
+
 	iommu->need_sync = 1;
 
-	return iommu_queue_command(iommu, &cmd);
+	return ret;
 }
 
 /*
@@ -159,6 +166,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 		u64 address, u16 domid, int pde, int s)
 {
 	struct iommu_cmd cmd;
+	int ret;
 
 	memset(&cmd, 0, sizeof(cmd));
 	address &= PAGE_MASK;
@@ -171,9 +179,11 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
 
+	ret = iommu_queue_command(iommu, &cmd);
+
 	iommu->need_sync = 1;
 
-	return iommu_queue_command(iommu, &cmd);
+	return ret;
 }
 
 /*

