Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYLECx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYLECx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYLECxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:53:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42608 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYLECxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:53:18 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>, wassim dagash <wassim.dagash@gmail.com>
Subject: Re: KSWAPD Algorithm - 100% CPU
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081204140200.GA22631@wotan.suse.de>
References: <20081203163740.1D4D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081204140200.GA22631@wotan.suse.de>
Message-Id: <20081205095905.1D83.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  5 Dec 2008 11:53:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kswapd_max_order check and reset should probably go inside
> balance_pgdat:loop_again loop.
> 
> It is possible we could have a kswapd_max_order[MAX_NR_ZONES] or
> something, but I don't know if the complexity would be worth while
> given that huge order allocations aren't too common, and resetting
> kswapd_max_order inside the loop should be a reasonable fix.

It seems excellent.

wassim, Could you please test this patch?



==
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] kswapd: add infinite loop stopper

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
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1921,6 +1921,16 @@ out:
 
 		try_to_freeze();
 
+		/*
+		  When highmem is very fragmented,
+		  alloc_pages(GFP_KERNEL, very-high-order) can cause
+		  infinite loop because zone_watermark_ok(highmem) failed.
+		  However, (alloc_pages(GFP_KERNEL..) indicate highmem memory
+		  continuousness isn't necessary.
+		  Therefore 2nd loop or after stop contenious check.
+		*/
+		order = sc->order = 0;
+
 		goto loop_again;
 	}
 




