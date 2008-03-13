Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYCMJNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYCMJNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYCMJM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:12:56 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:26567
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYCMJMz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:12:55 -0400
Message-Id: <47D8FE4A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 13 Mar 2008 09:13:30 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <fujita.tomonori@lab.ntt.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] avoid endless loops in lib/swiotlb.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 681cc5cd3efbeafca6386114070e0bfb5012e249 introduced two
possibilities for entering an endless loop in lib/swiotlb.c:

- if max_slots is zero (possible if mask is ~0UL)
- if the number of slots requested fits into a swiotlb segment, but is
  too large for the part of a segment which remains after considering
  offset_slots

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 lib/swiotlb.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- linux-2.6.25-rc5/lib/swiotlb.c	2008-03-13 09:53:50.000000000 +0100
+++ 2.6.25-rc5-swiotlb-endless-loop/lib/swiotlb.c	2008-03-12 15:17:49.000000000 +0100
@@ -310,7 +310,9 @@ map_single(struct device *hwdev, char *b
 	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	max_slots = ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	max_slots = mask + 1
+		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
+		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than a page, we limit the stride (and
@@ -333,16 +335,18 @@ map_single(struct device *hwdev, char *b
 		index = ALIGN(io_tlb_index, stride);
 		if (index >= io_tlb_nslabs)
 			index = 0;
-
-		while (is_span_boundary(index, nslots, offset_slots,
-					max_slots)) {
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
-		}
 		wrap = index;
 
 		do {
+			while (is_span_boundary(index, nslots, offset_slots,
+						max_slots)) {
+				index += stride;
+				if (index >= io_tlb_nslabs)
+					index = 0;
+				if (index == wrap)
+					goto not_found;
+			}
+
 			/*
 			 * If we find a slot that indicates we have 'nslots'
 			 * number of contiguous buffers, we allocate the
@@ -367,14 +371,12 @@ map_single(struct device *hwdev, char *b
 
 				goto found;
 			}
-			do {
-				index += stride;
-				if (index >= io_tlb_nslabs)
-					index = 0;
-			} while (is_span_boundary(index, nslots, offset_slots,
-						  max_slots));
+			index += stride;
+			if (index >= io_tlb_nslabs)
+				index = 0;
 		} while (index != wrap);
 
+  not_found:
 		spin_unlock_irqrestore(&io_tlb_lock, flags);
 		return NULL;
 	}



