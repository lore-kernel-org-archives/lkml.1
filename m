Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZEVMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZEVMXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbZEVMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:26 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:50737 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbZEVMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:22 -0400
X-BigFish: VPS5(z39a1jzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1P10-01-JRA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/12] amd-iommu: enlarge the aperture dynamically
Date: Fri, 22 May 2009 14:21:29 +0200
Message-ID: <1242994893-28902-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0314 (UTC) FILETIME=[D7FAEE20:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: enable the new extended dma address allocator ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 59ee1b9..d129d8f 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1403,10 +1403,26 @@ static dma_addr_t __map_single(struct device *dev,
 	if (align)
 		align_mask = (1UL << get_order(size)) - 1;
 
+retry:
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages, align_mask,
 					  dma_mask);
-	if (unlikely(address == bad_dma_address))
-		goto out;
+	if (unlikely(address == bad_dma_address)) {
+		/*
+		 * setting next_address here will let the address
+		 * allocator only scan the new allocated range in the
+		 * first run. This is a small optimization.
+		 */
+		dma_dom->next_address = dma_dom->aperture_size;
+
+		if (alloc_new_range(iommu, dma_dom, false, GFP_ATOMIC))
+			goto out;
+
+		/*
+		 * aperture was sucessfully enlarged by 128 MB, try
+		 * allocation again
+		 */
+		goto retry;
+	}
 
 	start = address;
 	for (i = 0; i < pages; ++i) {
-- 
1.6.3.1


