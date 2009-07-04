Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZGDFSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZGDFSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 01:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZGDFSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 01:18:22 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:37965 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZGDFSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 01:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=oVhTO1Fl0rIqDL7jLzKMhxYtDJ3/5cCvtWRMvIPxHTv+9D+Rr5lnAd3rxPYLIXN4OS
         ec9tbl/A8mLMPD4uD0BwYsr0f9l4Lq6xi6JnHLcGrW7GEc60aiKaD0eGF3+clVfLyoEK
         TEBToYsIdexwax6NAlNKEDeGgBPCuzv5yQ2jQ=
Date: Sat, 4 Jul 2009 14:18:18 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH][mmotm] don't attempt to reclaim anon page in lumpy reclaim
 when no swap space is available
Message-Id: <20090704141818.0afa877a.minchan.kim@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is based on mmotm 2009-07-02-19-57 reverted 
'vmscan: don't attempt to reclaim anon page in lumpy reclaim when no swap space is available.'

This verssion is better than old one.
That's because enough swap space check is done in case of only lumpy reclaim. 
so it can't degrade performance in normal case.

== CUT HERE ==

VM already avoids attempting to reclaim anon pages in various places, But
it doesn't avoid it for lumpy reclaim.

It shuffles lru list unnecessary so that it is pointless.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 27558aa..977af15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -930,6 +930,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
+			/*
+			 * If we don't have enough swap space, reclaiming of anon page
+			 * which don't already have a swap slot is pointless.
+			 */
+			if (nr_swap_pages <= 0 && (PageAnon(cursor_page) &&
+						!PageSwapCache(cursor_page)))
+				continue;
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-- 
1.5.4.3



-- 
Kind regards,
Minchan Kim 
