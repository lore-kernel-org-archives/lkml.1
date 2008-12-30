Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYL3K4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYL3K4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 05:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYL3Kzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 05:55:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42453 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYL3Kzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 05:55:51 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, wassim dagash <wassim.dagash@gmail.com>
Subject: [PATCH] mm: stop kswapd's infinite loop at high order allocation
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081230195006.1286.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 30 Dec 2008 19:55:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ok, wassim confirmed this patch works well.


==
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] mm: kswapd stop infinite loop at high order allocation

Wassim Dagash reported following kswapd infinite loop problem.

  kswapd runs in some infinite loop trying to swap until order 10 of zone
  highmem is OK, While zone higmem (as I understand) has nothing to do
  with contiguous memory (cause there is no 1-1 mapping) which means
  kswapd will continue to try to balance order 10 of zone highmem
  forever (or until someone release a very large chunk of highmem).

He proposed remove contenious checking on highmem at all.
However hugepage on highmem need contenious highmem page.

To add infinite loop stopper is simple and good.



Reported-by: wassim dagash <wassim.dagash@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1872,6 +1872,17 @@ out:
 
 		try_to_freeze();
 
+		/*
+		 * When highmem is very fragmented,
+		 * alloc_pages(GFP_KERNEL, very-high-order) can cause
+		 * infinite loop because zone_watermark_ok(highmem) failed.
+		 * However, alloc_pages(GFP_KERNEL..) indicate highmem memory
+		 * continuousness isn't necessary.
+		 * Therefore we don't want contenious check at 2nd loop.
+		 */
+		if (nr_reclaimed < SWAP_CLUSTER_MAX)
+			order = sc.order = 0;
+
 		goto loop_again;
 	}
 


