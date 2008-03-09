Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbYCIMs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbYCIMs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYCIMst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:48:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34605 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYCIMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:48:48 -0400
Date: Sun, 09 Mar 2008 21:47:43 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: quicklists confuse meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20080309120940.GA1695@elte.hu>
References: <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu>
Message-Id: <20080309212043.C6E1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > IMHO we need shrink pgtable cache mecanism.
> 
> ouch! Could you try the patch below? How large is the quicklist cache 
> with this applied?

I porting to IA64, applied, and tested.
but no change behavior.

because quicklist.c::max_pages() formula is strange.
my freememory is about 5GB, thus this function calculate 5GB/16 ~= 300MB,
my machine has 8cpu, thus 300MB x 8 ~= 2.5GB consume at worst case.
(because this variable is per cpu variable)

IMHO FRACTION_OF_NODE_MEM(16) is too small.

after change FRACTION_OF_NODE_MEM to 256,
i got following result.


---------------------------------------------------
MemTotal:      7683328 kB
MemFree:       5904704 kB
Buffers:         28672 kB
Cached:         168384 kB
SwapCached:       1344 kB
Active:         173376 kB
Inactive:       126016 kB
SwapTotal:     2031488 kB
SwapFree:      2030144 kB
Dirty:              64 kB
Writeback:           0 kB
AnonPages:      101120 kB
Mapped:          34496 kB
Slab:          1332608 kB
SReclaimable:    21824 kB
SUnreclaim:    1310784 kB
PageTables:      12480 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5873152 kB
Committed_AS:   383744 kB
VmallocTotal: 17592177655808 kB
VmallocUsed:     28864 kB
VmallocChunk: 17592177623040 kB
Quicklists:      61888 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB
-----------------------------------------------

the following patch is explain to my shrink plan and change to 
FRACTION_OF_NODE_MEM value.
of cource, this is only base of discussion.

I don't tested performance regression test yet.




Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 fs/drop_caches.c           |    3 +++
 include/asm-ia64/pgalloc.h |    9 ++++++++-
 include/linux/quicklist.h  |    7 +++++++
 mm/quicklist.c             |    2 +-
 mm/vmscan.c                |    8 ++++++++
 5 files changed, 27 insertions(+), 2 deletions(-)

Index: b/fs/drop_caches.c
===================================================================
--- a/fs/drop_caches.c  2008-03-09 16:04:14.000000000 +0900
+++ b/fs/drop_caches.c  2008-03-09 20:38:44.000000000 +0900
@@ -8,6 +8,7 @@
 #include <linux/writeback.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
+#include <asm/pgalloc.h>

 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
@@ -63,6 +64,8 @@ int drop_caches_sysctl_handler(ctl_table
                        drop_pagecache();
                if (sysctl_drop_caches & 2)
                        drop_slab();
+               if (sysctl_drop_caches & 4)
+                       drop_pgtable_cache();
        }
        return 0;
 }
Index: b/include/linux/quicklist.h
===================================================================
--- a/include/linux/quicklist.h 2008-03-09 19:45:58.000000000 +0900
+++ b/include/linux/quicklist.h 2008-03-09 21:49:07.000000000 +0900
@@ -87,6 +87,13 @@ static inline unsigned long quicklist_to
        return 0;
 }

+static inline void quicklist_trim(int nr, void (*dtor)(void *),
+                                 unsigned long min_pages,
+                                 unsigned long max_free)
+{
+}
+
+
 #endif

 #endif /* LINUX_QUICKLIST_H */
Index: b/mm/quicklist.c
===================================================================
--- a/mm/quicklist.c    2008-03-09 16:04:53.000000000 +0900
+++ b/mm/quicklist.c    2008-03-09 21:35:18.000000000 +0900
@@ -21,7 +21,7 @@

 DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];

-#define FRACTION_OF_NODE_MEM   16
+#define FRACTION_OF_NODE_MEM   256

 static unsigned long max_pages(unsigned long min_pages)
 {
Index: b/include/asm-ia64/pgalloc.h
===================================================================
--- a/include/asm-ia64/pgalloc.h        2008-03-09 21:53:14.000000000 +0900
+++ b/include/asm-ia64/pgalloc.h        2008-03-09 21:53:53.000000000 +0900
@@ -114,9 +114,16 @@ static inline void pte_free_kernel(struc

 static inline void check_pgt_cache(void)
 {
-       quicklist_trim(0, NULL, 25, 16);
+       quicklist_trim(0, NULL, 25, 1024);
 }

 #define __pte_free_tlb(tlb, pte)       pte_free((tlb)->mm, pte)

+#define HAVE_ARCH_DROP_PGTABLE_CACHE
+static inline void drop_pgtable_cache(void)
+{
+       quicklist_trim(0, NULL, 25, ULONG_MAX);
+}
+
+
 #endif                         /* _ASM_IA64_PGALLOC_H */
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c       2008-03-09 19:42:47.000000000 +0900
+++ b/mm/vmscan.c       2008-03-09 20:45:24.000000000 +0900
@@ -42,6 +42,7 @@

 #include <asm/tlbflush.h>
 #include <asm/div64.h>
+#include <asm/pgalloc.h>

 #include <linux/swapops.h>

@@ -1362,6 +1363,7 @@ static unsigned long do_try_to_free_page
                 * over limit cgroups
                 */
                if (scan_global_lru(sc)) {
+                       drop_pgtable_cache();
                        shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
                        if (reclaim_state) {
                                nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -1589,6 +1591,7 @@ loop_again:
                        if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
                                                end_zone, 0))
                                nr_reclaimed += shrink_zone(priority, zone, &sc);
+                       drop_pgtable_cache();
                        reclaim_state->reclaimed_slab = 0;
                        nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
                                                lru_pages);
@@ -1831,6 +1834,7 @@ unsigned long shrink_all_memory(unsigned
        nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
        /* If slab caches are huge, it's better to hit them first */
        while (nr_slab >= lru_pages) {
+               drop_pgtable_cache();
                reclaim_state.reclaimed_slab = 0;
                shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
                if (!reclaim_state.reclaimed_slab)
@@ -1868,6 +1872,7 @@ unsigned long shrink_all_memory(unsigned
                        if (ret >= nr_pages)
                                goto out;

+                       drop_pgtable_cache();
                        reclaim_state.reclaimed_slab = 0;
                        shrink_slab(sc.nr_scanned, sc.gfp_mask,
                                        count_lru_pages());
@@ -1880,6 +1885,7 @@ unsigned long shrink_all_memory(unsigned
                }
        }

+       drop_pgtable_cache();
        /*
         * If ret = 0, we could not shrink LRUs, but there may be something
         * in slab caches
@@ -2038,6 +2044,8 @@ static int __zone_reclaim(struct zone *z
                } while (priority >= 0 && nr_reclaimed < nr_pages);
        }

+       drop_pgtable_cache();
+
        slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
        if (slab_reclaimable > zone->min_slab_pages) {
                /*

