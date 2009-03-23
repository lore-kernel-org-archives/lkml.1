Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZCWOff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZCWOff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZCWOf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:35:27 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:38928 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZCWOf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:35:26 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KGYR6G-02-BUK-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] dma-debug: make memory range checks more consistent
Date: Mon, 23 Mar 2009 15:35:08 +0100
Message-ID: <1237818908-26516-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 23 Mar 2009 14:35:09.0027 (UTC) FILETIME=[90EEAB30:01C9ABC4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: do range checks always when a page is mapped

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index f9e6d38..1a99208 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -722,10 +722,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	entry->size      = size;
 	entry->direction = direction;
 
-	if (map_single) {
-		void *addr = ((char *)page_address(page)) + offset;
-
+	if (map_single)
 		entry->type = dma_debug_single;
+
+	if (!PageHighMem(page)) {
+		void *addr = ((char *)page_address(page)) + offset;
 		check_for_stack(dev, addr);
 		check_for_illegal_area(dev, addr, size);
 	}
@@ -779,8 +780,10 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
 
-		check_for_stack(dev, sg_virt(s));
-		check_for_illegal_area(dev, sg_virt(s), s->length);
+		if (!PageHighMem(sg_page(s))) {
+			check_for_stack(dev, sg_virt(s));
+			check_for_illegal_area(dev, sg_virt(s), s->length);
+		}
 
 		add_dma_entry(entry);
 	}
-- 
1.5.6.4


