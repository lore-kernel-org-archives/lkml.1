Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbZIDJqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbZIDJqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbZIDJpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:50 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:5092 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933567AbZIDJpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:43 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPFXS2-02-2EW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/8] x86/amd-iommu: Reset command buffer if wait loop fails
Date: Fri, 4 Sep 2009 11:44:42 +0200
Message-ID: <1252057482-32207-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0445 (UTC) FILETIME=[55D3CB50:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of a panic on an comletion wait loop failure, try to
recover from that event from resetting the command buffer.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b62a2f6..cfca80b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -318,8 +318,11 @@ static void __iommu_wait_for_completion(struct amd_iommu *iommu)
 	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
 	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	if (unlikely(i == EXIT_LOOP_COUNT))
-		panic("AMD IOMMU: Completion wait loop failed\n");
+	if (unlikely(i == EXIT_LOOP_COUNT)) {
+		spin_unlock(&iommu->lock);
+		reset_iommu_command_buffer(iommu);
+		spin_lock(&iommu->lock);
+	}
 }
 
 /*
-- 
1.6.3.3


