Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZFIN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZFIN5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZFIN5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:57:42 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42829
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751463AbZFIN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:57:41 -0400
X-SpamScore: 4
X-BigFish: VPS4(zzzz1202hzz5a6ciz32i17ch43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KKZ5FV-03-LAU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/4] amd_iommu: fix lock imbalance
Date: Tue, 9 Jun 2009 15:57:17 +0200
Message-ID: <1244555840-3855-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
References: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jun 2009 13:57:31.0392 (UTC) FILETIME=[3B7F6800:01C9E90A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

In alloc_coherent there is an omitted unlock on the path where mapping
fails. Add the unlock.

[ Impact: fix lock imbalance in alloc_coherent ]

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d689883..9f89bb6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1541,8 +1541,10 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
-	if (*dma_addr == bad_dma_address)
+	if (*dma_addr == bad_dma_address) {
+		spin_unlock_irqrestore(&domain->lock, flags);
 		goto out_free;
+	}
 
 	iommu_completion_wait(iommu);
 
-- 
1.6.3.1


