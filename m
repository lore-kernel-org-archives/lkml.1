Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYLBGvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYLBGvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYLBGvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:51:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbYLBGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:51:00 -0500
Date: Mon, 1 Dec 2008 22:50:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Swappiness fix?
Message-Id: <20081201225057.06088ccb.akpm@linux-foundation.org>
In-Reply-To: <200812010435.41540.gene.heskett@gmail.com>
References: <200812010435.41540.gene.heskett@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 04:35:41 -0500 Gene Heskett <gene.heskett@gmail.com> wrote:

> Greetings;
> 
> Has that patch someone pointed me to made it into -rc6?  I have a bit under 9 
> hours uptime on a 4Gb machine, with a gimp session, email and web browsing, 
> and I see I'm 27 megs into swap.  I do not have the patch now, a drive died.
> However, I may still have the email that contained it, I'll check that.

This?

From: Rik van Riel <riel@redhat.com>

Count the insertion of new pages in the statistics used to drive the
pageout scanning code.  This should help the kernel quickly evict
streaming file IO.

We count on the fact that new file pages start on the inactive file LRU
and new anonymous pages start on the active anon list.  This means
streaming file IO will increment the recent scanned file statistic, while
leaving the recent rotated file statistic alone, driving pageout scanning
to the file LRUs.

Pageout activity does its own list manipulation.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Gene Heskett <gene.heskett@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~vmscan-evict-streaming-io-first mm/swap.c
--- a/mm/swap.c~vmscan-evict-streaming-io-first
+++ a/mm/swap.c
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
_

> That patch, IMO should be fast lane'd to make it to .28.

I have it sitting here marked "awaits Gene testing" ;)
