Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459Ab0A0MIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab0A0MIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370Ab0A0MIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:08:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57670 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab0A0MId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:08:33 -0500
Date: Wed, 27 Jan 2010 12:08:20 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
Message-ID: <20100127120820.GB25750@csn.ul.ie>
References: <4B5FA147.5040802@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B5FA147.5040802@teksavvy.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 09:13:27PM -0500, Mark Lord wrote:
> I recently upgraded our 24/7 server from 2.6.31.5 to 2.6.32.5.
>
> Now, suddenly the logs are full of "page allocation failure. order:1",
> and the odd "page allocation failure. order:4" failures.
>
> Wow.  WTF happened in 2.6.32 ???
>

There was one bug related to MIGRATE_RESERVE that might be affecting
you. It reported as impacting swap-orientated workloads but it could
easily affect drivers that depend on high-order atomic allocations.
Unfortunately, the fix is not signed-off yet but I expect it to make its
way towards mainline when it is.

Here is the patch with a slightly-altered changelog. Can you test if it
makes a difference please?

==== CUT HERE ====
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Fix 2.6.32 slowdown in heavy swapping

There is a problem with simply building kernels as part of a tmpfs loop
swapping tests, and it's only obvious on the PowerPC G5. The problem
is that those swapping builds run about 20% slower in 2.6.32 than
2.6.31 (and look as if they run increasingly slowly, though I'm not
certain of that); and surprisingly it bisected down to your commit
5f8dcc21211a3d4e3a7a5ca366b469fb88117f61 page-allocator: split per-cpu list
into one-list-per-migrate-type

The problem was down to MIGRATE_RESERVE pages are being put on the
MIGRATE_MOVABLE list, then freed as MIGRATE_MOVABLE. While it is not clear
why this has such a severe impact, it may be down to how many short-lived
high-order allocations are taking place. On machines making large numbers of
short-lived-high-order allocations, they may be depending on MIGRATE_RESERVE
to allocate in a timely fashion. In the case where they are GFP_ATOMIC,
they may be depending on MIGRATE_RESERVE to just work.

The simplest, straight bugfix, patch is the one below: rely on
page_private instead of migratetype when freeing.

Unfortunately-not-signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Mel Gorman <mel@csn.ul.ie>

---
 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 2.6.33-rc1/mm/page_alloc.c	2009-12-18 11:42:54.000000000 +0000
+++ linux/mm/page_alloc.c	2009-12-20 19:10:50.000000000 +0000
@@ -555,8 +555,9 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
-			__free_one_page(page, zone, 0, migratetype);
-			trace_mm_page_pcpu_drain(page, 0, migratetype);
+			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
+			__free_one_page(page, zone, 0, page_private(page));
+			trace_mm_page_pcpu_drain(page, 0, page_private(page));
 		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);

