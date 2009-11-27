Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZK0N6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZK0N6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:58:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZK0N4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:04 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:38350
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753024AbZK0Nz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:57 -0500
X-SpamScore: 13
X-BigFish: VPS13(z1857rzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD6-01-6RU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 33/34] x86/amd-iommu: Move reset_iommu_command_buffer out of locked code
Date: Fri, 27 Nov 2009 14:55:44 +0100
Message-ID: <1259330145-14865-34-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0623 (UTC) FILETIME=[52E159F0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the ugly contruct where the
iommu->lock must be released while before calling the
reset_iommu_command_buffer function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0eafca5..b75fcd9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -285,6 +285,7 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		iommu->reset_in_progress = true;
 		reset_iommu_command_buffer(iommu);
 		dump_command(address);
 		break;
@@ -407,11 +408,8 @@ static void __iommu_wait_for_completion(struct amd_iommu *iommu)
 	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
 	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	if (unlikely(i == EXIT_LOOP_COUNT)) {
-		spin_unlock(&iommu->lock);
-		reset_iommu_command_buffer(iommu);
-		spin_lock(&iommu->lock);
-	}
+	if (unlikely(i == EXIT_LOOP_COUNT))
+		iommu->reset_in_progress = true;
 }
 
 /*
@@ -458,6 +456,9 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
+	if (iommu->reset_in_progress)
+		reset_iommu_command_buffer(iommu);
+
 	return 0;
 }
 
@@ -649,8 +650,6 @@ static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 	if (iommu->reset_in_progress)
 		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
 
-	iommu->reset_in_progress = true;
-
 	amd_iommu_reset_cmd_buffer(iommu);
 	amd_iommu_flush_all_devices();
 	amd_iommu_flush_all_domains();
-- 
1.6.5.3


