Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZHKPnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZHKPnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZHKPnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:43:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15425 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZHKPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:43:08 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KO7YBI-03-PUN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] dma-debug: Allow archs to override check_for_illegal_area
Date: Tue, 11 Aug 2009 17:43:01 +0200
Message-ID: <1250005381-17903-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 11 Aug 2009 15:42:56.0518 (UTC) FILETIME=[65974A60:01CA1A9A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some architectures (like sparc32) the default
check_for_illegal_area function does not work reliable. This patch
makes this function a weak symbol allowing architectures to override
it if necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 65b0d99..4f6ad34 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -866,7 +866,9 @@ static inline bool overlap(void *addr, unsigned long len, void *start, void *end
 	return !(b1 <= a2 || a1 >= b2);
 }
 
-static void check_for_illegal_area(struct device *dev, void *addr, unsigned long len)
+void __weak dma_debug_check_for_illegal_area(struct device *dev,
+					     void *addr,
+					     unsigned long len)
 {
 	if (overlap(addr, len, _text, _etext) ||
 	    overlap(addr, len, __start_rodata, __end_rodata))
@@ -971,7 +973,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 		void *addr = page_address(page) + offset;
 
 		check_for_stack(dev, addr);
-		check_for_illegal_area(dev, addr, size);
+		dma_debug_check_for_illegal_area(dev, addr, size);
 	}
 
 	add_dma_entry(entry);
@@ -1025,7 +1027,8 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 
 		if (!PageHighMem(sg_page(s))) {
 			check_for_stack(dev, sg_virt(s));
-			check_for_illegal_area(dev, sg_virt(s), sg_dma_len(s));
+			dma_debug_check_for_illegal_area(dev, sg_virt(s),
+							 sg_dma_len(s));
 		}
 
 		add_dma_entry(entry);
-- 
1.6.3.3


