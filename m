Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYJ2IWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYJ2IWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYJ2IWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:22:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYJ2IW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:22:29 -0400
Date: Wed, 29 Oct 2008 17:21:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use
 schedule_on_each_cpu()
Message-Id: <20081029172157.080de70b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2f11576a0810290020i362441edkb494b10c10b17401@mail.gmail.com>
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	<2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	<20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081027145509.ebffcf0e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0810280914010.15939@quilx.com>
	<20081028134536.9a7a5351.akpm@linux-foundation.org>
	<2f11576a0810290020i362441edkb494b10c10b17401@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 16:20:24 +0900
"KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> > I guess we should document our newly discovered schedule_on_each_cpu()
> > problems before we forget about it and later rediscover it.
> 
> Now, schedule_on_each_cpu() is only used by lru_add_drain_all().
> and smp_call_function() is better way for cross call.
> 
> So I propose
>    1. lru_add_drain_all() use smp_call_function()
IMHO, smp_call_function() is not good, either.

The real problem in this lru_add_drain_all() around mlock() is handling of
pagevec. How about attached one ?(not tested at all..just an idea.)

>    2. remove schedule_on_each_cpu()
> 
I'm using schedule_on_each_cpu() from not dangerous context (in new memcg patch..)

Thanks,
-Kame

==
pagevec is used for avoidning lru_lock contention for add/remove pages to/from
LRU. But under split-lru/unevictable lru world, this delay in pagevec can
cause unexpected behavior.
  * A page scheduled to add to Unevictable lru is unlocked
    while it's in pagevec.
Because a page wrongly linked to Unevictable lru cannot come back to usual
lru, this is a problem. To avoid this kind of situation, lru_add_drain_all()
is called from mlock() path.


This patch remove "delay" of pagevec for Unevictable pages and remove
lru_add_drain_all(), which is a burtal function should not be called from
deep under the kernel.




---
 mm/mlock.c |   13 ++-----------
 mm/swap.c  |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 15 deletions(-)

Index: mmotm-2.6.27+/mm/mlock.c
===================================================================
--- mmotm-2.6.27+.orig/mm/mlock.c
+++ mmotm-2.6.27+/mm/mlock.c
@@ -66,14 +66,9 @@ void __clear_page_mlock(struct page *pag
 		putback_lru_page(page);
 	} else {
 		/*
-		 * Page not on the LRU yet.  Flush all pagevecs and retry.
+		 * Page not on the LRU yet.
+		 * pagevec will handle this in proper way.
 		 */
-		lru_add_drain_all();
-		if (!isolate_lru_page(page))
-			putback_lru_page(page);
-		else if (PageUnevictable(page))
-			count_vm_event(UNEVICTABLE_PGSTRANDED);
-
 	}
 }
 
@@ -187,8 +182,6 @@ static long __mlock_vma_pages_range(stru
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= GUP_FLAGS_WRITE;
 
-	lru_add_drain_all();	/* push cached pages to LRU */
-
 	while (nr_pages > 0) {
 		int i;
 
@@ -251,8 +244,6 @@ static long __mlock_vma_pages_range(stru
 		ret = 0;
 	}
 
-	lru_add_drain_all();	/* to update stats */
-
 	return ret;	/* count entire vma as locked_vm */
 }
 
Index: mmotm-2.6.27+/mm/swap.c
===================================================================
--- mmotm-2.6.27+.orig/mm/swap.c
+++ mmotm-2.6.27+/mm/swap.c
@@ -200,10 +200,19 @@ void __lru_cache_add(struct page *page, 
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs)[lru];
 
-	page_cache_get(page);
-	if (!pagevec_add(pvec, page))
-		____pagevec_lru_add(pvec, lru);
-	put_cpu_var(lru_add_pvecs);
+	if (likely(lru != LRU_UNEVICTABLE)) {
+		page_cache_get(page);
+		if (!pagevec_add(pvec, page))
+			____pagevec_lru_add(pvec, lru);
+		put_cpu_var(lru_add_pvecs);
+	} else {
+		/*
+		 * A page put into Unevictable List has no chance to come back
+  		 * to other LRU.(it can be unlocked while in pagevec.)
+  		 * We do add_to_lru in synchrous way.
+  		 */
+		add_page_to_unevictable_list(page);
+	}
 }
 
 /**

