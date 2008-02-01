Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYBASyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYBASyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYBASyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:54:01 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57927 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbYBASyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:54:00 -0500
Date: Fri, 1 Feb 2008 18:53:57 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 Page Allocation Failure
Message-ID: <20080201185357.GH18688@csn.ul.ie>
References: <47A1EE15.6090507@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <47A1EE15.6090507@aol.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

On (31/01/08 10:49), AndrewL733 didst pronounce:
> My setup is Mandriva 2007 64-bit:
> 
> IntelS5000PSLSATA motherboard
> Single Dual Core 3 Ghz Xeon
> 2 GB ECC RAM
> Myricom 10 GbE Network Adapter (using out of kernel 1.4.0 driver 
> compiled with "MYRI10GE_ALLOC_ORDER=2")
> 
> 
> I have two identical systems doing data transfer via Myricom cards 
> connected directly to one another (in other words, not going through a 
> switch).
> 
> No problems hammering Myricom with 350 MB/sec NFS traffic while running 
> 2.6.20.15 and 2.6.22.9 (kernel.org "plain vanilla" kernels I compiled 
> and run, also with updated Myricom drivers). However, I just compiled 
> and installed 2.6.24 and get the following errors as soon as I begin 
> doing NFS I/O over the Myricom card. Maybe I missed something in the 
> kernel configuration? Throughput when running 2.6.24 is about 40 percent 
> lower than when running 2.6.22.9-- surely due to these errors.
> 

It's possible. Is there a stream of these errors coming through constantly?

> Jan 29 22:13:36 master kernel: nfsd: page allocation failure. order:2, mode:0x4020

So, that is a ZONE_NORMAL high-order atomic allocation (GFP_COMPOUND as well
which is a little surprise but should make no difference). Not exactly
recommended but there are a few drivers that do it and I guess yours is one.

> Jan 29 22:13:36 master kernel: Pid: 6586, comm: nfsd Not tainted 2.6.24 #1
> Jan 29 22:13:36 master kernel:
> Jan 29 22:13:36 master kernel: Call Trace:
> Jan 29 22:13:36 master kernel:  <IRQ>  [__alloc_pages+822/912] __alloc_pages+0x336/0x390
> Jan 29 22:13:36 master kernel:  <IRQ>  [<ffffffff80279d66>]    __alloc_pages+0x336/0x390
> Jan 29 22:13:36 master kernel:  [ip_local_deliver+37/112]      ip_local_deliver+0x25/0x70
> Jan 29 22:13:36 master kernel:  [<ffffffff80417bb5>]           ip_local_deliver+0x25/0x70
> Jan 29 22:13:36 master kernel:  [_end+130301422/2130457992]    :myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
> Jan 29 22:13:36 master kernel:  [<ffffffff88280866>]           :myri10ge:myri10ge_alloc_rx_pages+0x156/0x270
> Jan 29 22:13:36 master kernel:  [_end+130325174/2130457992]    :myri10ge:myri10ge_poll+0x57e/0xae0
> Jan 29 22:13:36 master kernel:  [<ffffffff8828652e>]           :myri10ge:myri10ge_poll+0x57e/0xae0

Coming from the driver in question so no suprise there
> <SNIP>
> Jan 29 22:13:36 master kernel: Mem-info:
> Jan 29 22:13:36 master kernel: DMA per-cpu:
> Jan 29 22:13:36 master kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 29 22:13:36 master kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 29 22:13:36 master kernel: DMA32 per-cpu:
> Jan 29 22:13:36 master kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 150   Cold: hi:   62, btch:  15 usd:  62
> Jan 29 22:13:36 master kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:  52
> Jan 29 22:13:36 master kernel: Active:41027 inactive:437314 dirty:29708 writeback:0 unstable:0
> Jan 29 22:13:36 master kernel:  free:3892 slab:19405 mapped:11793 pagetables:1512 bounce:0
> Jan 29 22:13:36 master kernel: DMA free:8008kB min:28kB low:32kB high:40kB active:0kB inactive:2384kB present:11100kB pages_scanned:0 all_unreclaimable? no
> Jan 29 22:13:36 master kernel: lowmem_reserve[]: 0 1998 1998 1998
> Jan 29 22:13:36 master kernel: DMA32 free:7560kB min:5704kB low:7128kB high:8556kB active:164108kB inactive:1746872kB present:2046800kB pages_scanned:32 all_unreclaimable? no
> Jan 29 22:13:36 master kernel: lowmem_reserve[]: 0 0 0 0

No apparent memory pressure there. We are not even below the low
watermark for order-0 allocations and the lowmem_reserve is not a factor
for DMA32 allocations.

> Jan 29 22:13:36 master kernel: DMA: 4*4kB 5*8kB 6*16kB 6*32kB 4*64kB 2*128kB 4*256kB 4*512kB 0*1024kB 0*2048kB 1*4096kB = 8024kB
> Jan 29 22:13:36 master kernel: DMA32: 1365*4kB 11*8kB 38*16kB 18*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 7756kB

There are sufficient numbers of order-2 and higher pages free there. It is
similar for the subsequent failures. This does not appear to be a fragmentation
problem at least so lets see what watermarks look like just for zone->low_pages
which should be relatively relaxed.

Zone watermarks in pages;
Low:                    1782
Free:                   1890
classzone_reserve:         0

Adjusted Low calculation
        low = 1782 - 4 + 1 == 1779
                ALLOC_HIGH for __GFP_HIGH so
        low -= (low / 2) == 890
                ALLOC_HARDER for !__GFP_WAIT so
        low -= (low / 4) == 668

Free pages at each order
DMA32: 1365*4kB 11*8kB 38*16kB 18*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 7756kB
Watermark check
        order 0: is free_pages(1890) < low(668) + class_rsrv(0) -- no, ok
        order 1: is free_pages(525)  < low(334)                 -- no, ok
        order 2: is free_pages(503)  < low(167)                 -- no. ok

Err, so it looks like we are not hitting the watermarks either. This does
not make sense, the allocation should not have failed. I have to be making
a mistake with the zone watermark calculation, can anyone spot it?

Is this definetly 2.6.24 and otherwise unpatched?

> Jan 29 22:13:36 master kernel: Swap cache: add 43, delete 43, find 0/0, race 0+0
> Jan 29 22:13:36 master kernel: Free swap  = 4088332kB
> Jan 29 22:13:36 master kernel: Total swap = 4088500kB
> Jan 29 22:13:36 master kernel: Free swap:       4088332kB
> Jan 29 22:13:36 master kernel: 523264 pages of RAM
> Jan 29 22:13:36 master kernel: 9510 reserved pages
> Jan 29 22:13:36 master kernel: 492885 pages shared
> Jan 29 22:13:36 master kernel: 0 pages swap cached
> Jan 29 22:13:44 master nmbd[3438]: [2008/01/29 22:13:44, 0] 
> <SNIP>
 
Few questions to try pinning down what is going wrong.

1. Is the stream of errors constant once they start?
2. If you increase /proc/sys/vm/min_free_kbytes to 16384 or 64738, do
   the allocation errors still occur? If the errors no longer occur,
   is the performance restored?
3. If you compile with MYRI10GE_ALLOC_ORDER=0 on the old and new
   kernels, do the allocations errors occur? If not, how does the throughput
   compare between kernel versions?
   (I am checking for changes in NFS/IO/writeback that causes a writeout
   performance regression. Such a slowdown may cause memory pressure
   later and then these allocation errors when watermarks are hit)
4. If you apply the patch below, do the allocation errors still occur?
   (The patch disables fragmentation avoidance. I don't think fragmentation
   is the problem here because ample memory is free and watermarks look
   ok)
5. Any chance you could test 2.6.23 in case the problem also happens there?

Thanks

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.24-clean/include/linux/mmzone.h linux-2.6.24-disable-antifrag/include/linux/mmzone.h
--- linux-2.6.24-clean/include/linux/mmzone.h	2008-01-24 22:58:37.000000000 +0000
+++ linux-2.6.24-disable-antifrag/include/linux/mmzone.h	2008-02-01 17:23:39.000000000 +0000
@@ -45,14 +45,11 @@
 	for (order = 0; order < MAX_ORDER; order++) \
 		for (type = 0; type < MIGRATE_TYPES; type++)
 
-extern int page_group_by_mobility_disabled;
+#define page_group_by_mobility_disabled (0)
 
 static inline int get_pageblock_migratetype(struct page *page)
 {
-	if (unlikely(page_group_by_mobility_disabled))
-		return MIGRATE_UNMOVABLE;
-
-	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
+	return MIGRATE_UNMOVABLE;
 }
 
 struct free_area {
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.24-clean/mm/page_alloc.c linux-2.6.24-disable-antifrag/mm/page_alloc.c
--- linux-2.6.24-clean/mm/page_alloc.c	2008-01-24 22:58:37.000000000 +0000
+++ linux-2.6.24-disable-antifrag/mm/page_alloc.c	2008-02-01 17:23:39.000000000 +0000
@@ -164,12 +164,9 @@ int nr_node_ids __read_mostly = MAX_NUMN
 EXPORT_SYMBOL(nr_node_ids);
 #endif
 
-int page_group_by_mobility_disabled __read_mostly;
-
 static void set_pageblock_migratetype(struct page *page, int migratetype)
 {
-	set_pageblock_flags_group(page, (unsigned long)migratetype,
-					PB_migrate, PB_migrate_end);
+	return;
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2354,17 +2351,6 @@ void build_all_zonelists(void)
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
-	/*
-	 * Disable grouping by mobility if the number of pages in the
-	 * system is too low to allow the mechanism to work. It would be
-	 * more accurate, but expensive to check per-zone. This check is
-	 * made on memory-hotadd so a system can start with mobility
-	 * disabled and enable it later
-	 */
-	if (vm_total_pages < (pageblock_nr_pages * MIGRATE_TYPES))
-		page_group_by_mobility_disabled = 1;
-	else
-		page_group_by_mobility_disabled = 0;
 
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
