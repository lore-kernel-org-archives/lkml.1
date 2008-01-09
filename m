Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYAITQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYAITQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYAITQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:16:52 -0500
Received: from waste.org ([66.93.16.53]:48823 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYAITQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:16:51 -0500
Subject: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 13:15:51 -0600
Message-Id: <1199906151.6245.57.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 20:06 +0200, Pekka J Enberg wrote:
> Hi Matt,
> 
> On Sun, 6 Jan 2008, Matt Mackall wrote:
> > I don't have any particular "terrible" workloads for SLUB. But my
> > attempts to simply boot with all three allocators to init=/bin/bash in,
> > say, lguest show a fair margin for SLOB.
> 
> Sorry, I once again have bad news ;-). I did some testing with
> 
>   lguest --block=<rootfile> 32 /boot/vmlinuz-2.6.24-rc6 root=/dev/vda init=doit
> 
> where rootfile is
> 
>   http://uml.nagafix.co.uk/BusyBox-1.5.0/BusyBox-1.5.0-x86-root_fs.bz2
> 
> and the "doit" script in the guest passed as init= is just
> 
>   #!/bin/sh
>   mount -t proc proc /proc
>   cat /proc/meminfo | grep MemTotal
>   cat /proc/meminfo | grep MemFree
>   cat /proc/meminfo | grep Slab
> 
> and the results are:
> 
> [ the minimum, maximum, and average are of captured from 10 individual runs ]
> 
>                                  Free (kB)             Used (kB)
>                     Total (kB)   min   max   average   min  max  average
>   SLUB (no debug)   26536        23868 23892 23877.6   2644 2668 2658.4
>   SLOB              26548        23472 23640 23579.6   2908 3076 2968.4
>   SLAB (no debug)   26544        23316 23364 23343.2   3180 3228 3200.8
>   SLUB (with debug) 26484        23120 23136 23127.2   3348 3364 3356.8
> 
> So it seems that on average SLUB uses 300 kilobytes *less memory* (!) (which is
> roughly 1% of total memory available) after boot than SLOB for my
> configuration.
> 
> One possible explanation is that the high internal fragmentation (space
> allocated but not used) of SLUB kmalloc() only affects short-lived allocations
> and thus does not show up in the more permanent memory footprint.  Likewise, it
> could be that SLOB has higher external fragmentation (small blocks that are
> unavailable for allocation) of which SLUB does not suffer from.  Dunno, haven't
> investigated as my results are contradictory to yours.

Yep, you we definitely onto something here. Here's what I got with 10
runs of SLUB on my setup:

MemFree:         55780 kB
MemFree:         55780 kB
MemFree:         55780 kB
MemFree:         55784 kB
MemFree:         55788 kB
MemFree:         55788 kB
MemFree:         55788 kB
MemFree:         55792 kB
MemFree:         55796 kB
MemFree:         55800 kB
Avg:             55787.6

And with SLOB + my defrag fix:

MemFree:         55236 kB
MemFree:         55284 kB
MemFree:         55292 kB
MemFree:         55304 kB
MemFree:         55384 kB
MemFree:         55388 kB
MemFree:         55412 kB
MemFree:         55420 kB
MemFree:         55436 kB
MemFree:         55444 kB
Avg:             55360.0            

Ouch!

So I added a bunch of statistics gathering:

counted pages 409 unused 185242 biggest 1005 fragments 1416
slob pages 410 allocs 22528 frees 12109 active 10419 allocated 932647
      page scans 11249 block scans 40650
kmallocs 10247 active 5450 allocated 3484680 overhead 48836
bigpages 827 active 17
total 427 used 245

The first line tells us about SLOB's free list, which has 409 pages,
185k unused, spread into 1416 fragments. The average fragment is 130
bytes.

The next tells us that we've got 410 total SLOB pages (1 is fully
allocated), we've done 22k allocs, 12k frees, have 10k allocations
active, and 932k total memory allocated (including kmallocs). That means
our average SLOB allocation is ~90 bytes.

The kmallocs line tells us we've done 10k allocs, and 5k of them are not
yet freed. Since boot, we requested 3.48MiB of kmalloc (without padding)
and added on 49k of padding. Thus the average kmalloc is 340 bytes and
has 4.77 bytes of padding (1.2% overhead, quite good!).

SLAB and kmalloc objects => 4k are handed straight to the page allocator
(same as SLUB), of which there are 17 active pages.

So in total, SLOB is using 427 pages for what optimally could fit in 245
pages. In other words, external fragmentation is horrible.

I kicked this around for a while, slept on it, and then came up with
this little hack first thing this morning:

------------
slob: split free list by size

diff -r 6901ca355181 mm/slob.c
--- a/mm/slob.c	Tue Jan 08 21:01:15 2008 -0600
+++ b/mm/slob.c	Wed Jan 09 12:31:59 2008 -0600
@@ -112,7 +112,9 @@ static inline void free_slob_page(struct
 /*
  * All (partially) free slob pages go on this list.
  */
-static LIST_HEAD(free_slob_pages);
+#define SLOB_BREAK_POINT 300
+static LIST_HEAD(free_slob_pages_big);
+static LIST_HEAD(free_slob_pages_small);
 
 /*
  * slob_page: True for all slob pages (false for bigblock pages)
@@ -140,9 +142,9 @@ static inline int slob_page_free(struct 
 	return test_bit(PG_private, &sp->flags);
 }
 
-static inline void set_slob_page_free(struct slob_page *sp)
+static inline void set_slob_page_free(struct slob_page *sp, struct list_head *list)
 {
-	list_add(&sp->list, &free_slob_pages);
+	list_add(&sp->list, list);
 	__set_bit(PG_private, &sp->flags);
 }
 
@@ -294,12 +296,18 @@ static void *slob_alloc(size_t size, gfp
 {
 	struct slob_page *sp;
 	struct list_head *prev;
+	struct list_head *slob_list;
 	slob_t *b = NULL;
 	unsigned long flags;
 
+	slob_list = &free_slob_pages_small;
+	if (size > SLOB_BREAK_POINT)
+		slob_list = &free_slob_pages_big;
+
 	spin_lock_irqsave(&slob_lock, flags);
 	/* Iterate through each partially free page, try to find room */
-	list_for_each_entry(sp, &free_slob_pages, list) {
+
+	list_for_each_entry(sp, slob_list, list) {
 #ifdef CONFIG_NUMA
 		/*
 		 * If there's a node specification, search for a partial
@@ -321,9 +329,9 @@ static void *slob_alloc(size_t size, gfp
 		/* Improve fragment distribution and reduce our average
 		 * search time by starting our next search here. (see
 		 * Knuth vol 1, sec 2.5, pg 449) */
-		if (prev != free_slob_pages.prev &&
-				free_slob_pages.next != prev->next)
-			list_move_tail(&free_slob_pages, prev->next);
+		if (prev != slob_list->prev &&
+				slob_list->next != prev->next)
+			list_move_tail(slob_list, prev->next);
 		break;
 	}
 	spin_unlock_irqrestore(&slob_lock, flags);
@@ -341,7 +349,7 @@ static void *slob_alloc(size_t size, gfp
 		sp->free = b;
 		INIT_LIST_HEAD(&sp->list);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
-		set_slob_page_free(sp);
+		set_slob_page_free(sp, slob_list);
 		b = slob_page_alloc(sp, size, align);
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
@@ -357,6 +365,7 @@ static void slob_free(void *block, int s
 static void slob_free(void *block, int size)
 {
 	struct slob_page *sp;
+	struct list_head *slob_list;
 	slob_t *prev, *next, *b = (slob_t *)block;
 	slobidx_t units;
 	unsigned long flags;
@@ -364,6 +373,10 @@ static void slob_free(void *block, int s
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 	BUG_ON(!size);
+
+	slob_list = &free_slob_pages_small;
+	if (size > SLOB_BREAK_POINT)
+		slob_list = &free_slob_pages_big;
 
 	sp = (struct slob_page *)virt_to_page(block);
 	units = SLOB_UNITS(size);
@@ -387,7 +400,7 @@ static void slob_free(void *block, int s
 		set_slob(b, units,
 			(void *)((unsigned long)(b +
 					SLOB_UNITS(PAGE_SIZE)) & PAGE_MASK));
-		set_slob_page_free(sp);
+		set_slob_page_free(sp, slob_list);
 		goto out;
 	}
------------

And the results are fairly miraculous, so please double-check them on
your setup. The resulting statistics change to this:

small list pages 107 unused 39622 biggest 1516 fragments 3511
big list pages 129 unused 23264 biggest 2076 fragments 232
slob pages 243 allocs 22528 frees 12108 active 10420 allocated 932079
     page scans 8074 block scans 481530
kmallocs 10248 active 5451 allocated 3484220 overhead 42054
bigpages 825 active 16
total 259 used 244

and 10 runs looks like this:

MemFree:         56056 kB
MemFree:         56064 kB
MemFree:         56064 kB
MemFree:         56068 kB
MemFree:         56068 kB
MemFree:         56076 kB
MemFree:         56084 kB
MemFree:         56084 kB
MemFree:         56088 kB
MemFree:         56092 kB
Avg:             56074.4

So the average jumped by 714k from before the patch, became much more
stable, and beat SLUB by 287k. There are also 7 perfectly filled pages
now, up from 1 before. And we can't get a whole lot better than this:
we're using 259 pages for 244 pages of actual data, so our total
overhead is only 6%! For comparison, SLUB's using about 70 pages more
for the same data, so its total overhead appears to be about 35%.

By the way, the break at 300 bytes was just the first number that came
to my head but moving it around didn't seem to help. It might want to
change with page size. Knuth suggests that empirically, arena size/10 is
about the maximum allocation size to avoid fragmentation.

-- 
Mathematics is the supreme nostalgia of our time.

