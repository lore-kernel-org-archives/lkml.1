Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZGPKtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZGPKtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZGPKtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:49:21 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:37562 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZGPKtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=w0DQIThBUKNSzRfKTy6CYim7ZYnIdO5HpWpwNso6DZ/g6Ov6CPdKDfa6Z9IVngaZ2c
         fr69wmXBW8LydPuueZDyBIzKQ6AgwgfD/RDSnCaNn0jEG7jBDLj3OgsD3ZUz4Gqf4Nls
         sgh9pP48DeUj6sN9eDMNnDK0Zxm0f3HxxbvA4=
Date: Thu, 16 Jul 2009 19:49:10 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>
Subject: [PATCH] [mmotm] don't attempt to reclaim anon page in lumpy reclaim
 when no swap space is avilable
Message-Id: <20090716194910.602446a4.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is based on mmotm 2009-07-15-20-57

This version is better than old one.
That's because enough swap space check is done in case of only lumpy reclaim.
so it can't degrade performance in normal case.

== CUT HERE ==

VM already avoids attempting to reclaim anon pages in various places, But
it doesn't avoid it for lumpy reclaim.

It shuffles lru list unnecessary so that it is pointless.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 543596e..8b1132f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -930,6 +930,15 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
+
+			/*
+			 * If we don't have enough swap space, reclaiming of anon page
+			 * which don't already have a swap slot is pointless.
+			 */
+			if (nr_swap_pages <= 0 && (PageAnon(cursor_page) &&
+									!PageSwapCache(cursor_page)))
+				continue;
+
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-- 
1.5.4.3


-- 
Kind regards,
Minchan Kim
