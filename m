Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZF0EMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZF0EMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZF0ELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:11:55 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:46097 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZF0ELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=oyrqXH+v6qXkjGGnGjaPKv7Zt84y2QWYxxSRVfTFGqYaKMVI7dxMey/Rq+zPm2c0DX
         qO7XIs5w6GrwooapjMSt7jZQNc0HVMBtQKR+furAxu3MDNGz7OMnsDJGjGrMGN+dKhWz
         Q0BU5bHgevrviabPbiZ6gxXk6HH0D89v7kdUo=
Date: Sat, 27 Jun 2009 13:11:52 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2][mmotm-2009-0625-1549]  prevent to reclaim anon page of
 lumpy reclaim for no swap space
Message-Id: <20090627131152.519b86ed.minchan.kim@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v1. 
 * fix - prevent anon page which already don't have swap slot
	 (by Rik van Riel suggestion)
 * change some comment

== CUT HERE ==

This patch prevent to reclaim anon page in case of no swap space.

VM already prevent to reclaim anon page in various place.
But it doesnt't prevent it for lumpy reclaim.

It shuffles lru list unnecessary so that it is pointless.

__isolate_lru_page is called on slow path so that some condition
check could be not critical about performance.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

--- mm/vmscan.c.orig	2009-06-27 12:30:41.000000000 +0900
+++ mm/vmscan.c	2009-06-27 12:32:00.000000000 +0900
@@ -830,7 +830,13 @@ int __isolate_lru_page(struct page *page
 	 * When this function is being called for lumpy reclaim, we
 	 * initially look into all LRU pages, active, inactive and
 	 * unevictable; only give shrink_page_list evictable pages.
+	 *
+	 * If we don't have enough swap space, reclaiming of anon page
+	 * which don't already have a swap slot is pointless.
 	 */
+	if (nr_swap_pages <= 0 && (PageAnon(page) && !PageSwapCache(page)))
+		return ret;
+
 	if (PageUnevictable(page))
 		return ret;
 

-- 
Kinds Regards,
Minchan Kim 
