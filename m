Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbYGKPTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbYGKPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbYGKPPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:15:22 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26649 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbYGKPPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:15:20 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3UL0F-03-1OP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/16] AMD IOMMU: add an emergency exit to the completion wait loop
Date: Fri, 11 Jul 2008 17:14:27 +0200
Message-ID: <1215789275-20975-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:36.0149 (UTC) FILETIME=[D4829250:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the loop waiting for the completion wait command not wait forever this
patch adds a limit of cycles that loop.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9098f04..7fa2d5d 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -32,6 +32,8 @@
 #define to_pages(addr, size) \
 	 (round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
 
+#define EXIT_LOOP_COUNT 10000000
+
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
 /*
@@ -106,6 +108,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	struct command cmd;
 	volatile u64 ready = 0;
 	unsigned long ready_phys = virt_to_phys(&ready);
+	unsigned long i = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.data[0] = LOW_U32(ready_phys) | CMD_COMPL_WAIT_STORE_MASK;
@@ -120,8 +123,13 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (ret)
 		return ret;
 
-	while (!ready)
+	while (!ready && (i < EXIT_LOOP_COUNT)) {
+		++i;
 		cpu_relax();
+	}
+
+	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
+		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
 
 	return 0;
 }
-- 
1.5.3.7


