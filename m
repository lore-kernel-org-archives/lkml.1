Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZE1IAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZE1IAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZE1IA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:00:29 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:56533 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZE1IA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:00:29 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] x86: amd_iommu, fix lock imbalance
Date: Thu, 28 May 2009 09:54:48 +0200
Message-Id: <1243497289-18591-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In alloc_coherent there is an omitted unlock on the path where mapping
fails. Add the unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a97db99..b123e20 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1537,8 +1537,10 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
-	if (*dma_addr == bad_dma_address)
+	if (*dma_addr == bad_dma_address) {
+		spin_unlock_irqrestore(&domain->lock, flags);
 		goto out_free;
+	}
 
 	iommu_completion_wait(iommu);
 
-- 
1.6.3

