Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYKRAHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYKRAHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYKRAGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:06:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYKRAGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:06:54 -0500
Date: Mon, 17 Nov 2008 19:06:42 -0500
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: [PATCH] vmscan: evict streaming IO first
Message-ID: <20081117190642.3aabd3ff@bree.surriel.com>
In-Reply-To: <alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081115210039.537f59f5.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org>
	<49208E9A.5080801@redhat.com>
	<20081116204720.1b8cbe18.akpm@linux-foundation.org>
	<20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com>
	<20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Count the insertion of new pages in the statistics used to drive the
pageout scanning code.  This should help the kernel quickly evict
streaming file IO.

We count on the fact that new file pages start on the inactive file
LRU and new anonymous pages start on the active anon list.  This
means streaming file IO will increment the recent scanned file
statistic, while leaving the recent rotated file statistic alone,
driving pageout scanning to the file LRUs.

Pageout activity does its own list manipulation.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 mm/swap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

On Mon, 17 Nov 2008 08:22:13 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> .. or how about just considering the act of adding a new page to the LRU 
> to be a "scan" event? IOW, "scanning" is not necessarily just an act of 
> the VM looking for pages to free, but would be a more general "activity" 
> meter.

Linus, this should implement your idea.  

Gene, does this patch resolve the problem for you?

Index: linux-2.6.28-rc5/mm/swap.c
===================================================================
--- linux-2.6.28-rc5.orig/mm/swap.c	2008-11-16 17:47:13.000000000 -0500
+++ linux-2.6.28-rc5/mm/swap.c	2008-11-17 18:58:32.000000000 -0500
@@ -445,6 +445,7 @@ void ____pagevec_lru_add(struct pagevec 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 		struct zone *pagezone = page_zone(page);
+		int file;
 
 		if (pagezone != zone) {
 			if (zone)
@@ -456,8 +457,12 @@ void ____pagevec_lru_add(struct pagevec 
 		VM_BUG_ON(PageUnevictable(page));
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
-		if (is_active_lru(lru))
+		file = is_file_lru(lru);
+		zone->recent_scanned[file]++;
+		if (is_active_lru(lru)) {
 			SetPageActive(page);
+			zone->recent_rotated[file]++;
+		}
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)

