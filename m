Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755533AbYLQPyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYLQPyv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYLQPyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:54:37 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41946 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYLQPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:54:36 -0500
X-BigFish: VPS-12(z21eWzzzzzz32i6bh43j62h)
X-FB-SS: 5,
X-WSS-ID: 0KC12UC-03-23L-01
Date: Wed, 17 Dec 2008 16:54:15 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] more AMD IOMMU fixes for 2.6.28-rc8
Message-ID: <20081217155415.GV3407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 17 Dec 2008 15:54:15.0801 (UTC) FILETIME=[B692E690:01C9605F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 83fd5cc6481c6b7fa8b45f8a7e0aa7120213430b:
  Joerg Roedel (1):
        AMD IOMMU: allocate rlookup_table with __GFP_ZERO

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28

Joerg Roedel (2):
      AMD IOMMU: set cmd buffer pointers to zero manually
      AMD IOMMU: panic if completion wait loop fails

 arch/x86/kernel/amd_iommu.c      |    5 +++--
 arch/x86/kernel/amd_iommu_init.c |    4 ++++
 2 files changed, 7 insertions(+), 2 deletions(-)

They fix another problem discovered in long-running reboot tests. Please
pull. The diff is attached.

Joerg


diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a7b6dec..0a60d60 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -235,8 +235,9 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
 	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
-		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+	if (unlikely(i == EXIT_LOOP_COUNT))
+		panic("AMD IOMMU: Completion wait loop failed\n");
+
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c90a15e..c6cc228 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -427,6 +427,10 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
 			&entry, sizeof(entry));
 
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
 	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
 
 	return cmd_buf;
-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

