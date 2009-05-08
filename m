Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZEHIQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZEHIQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZEHIQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:16:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:26269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZEHIQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:16:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,315,1239001200"; 
   d="scan'208";a="140612306"
Date: Fri, 8 May 2009 16:16:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090508081608.GA25117@localhost>
References: <20090430181340.6f07421d.akpm@linux-foundation.org> <20090430215034.4748e615@riellaptop.surriel.com> <20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507134410.0618b308.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 04:44:10AM +0800, Andrew Morton wrote:
> On Thu, 7 May 2009 17:10:39 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > +++ linux/mm/nommu.c
> > > @@ -1224,6 +1224,8 @@ unsigned long do_mmap_pgoff(struct file 
> > >  			added_exe_file_vma(current->mm);
> > >  			vma->vm_mm = current->mm;
> > >  		}
> > > +		if (vm_flags & VM_EXEC)
> > > +			set_bit(AS_EXEC, &file->f_mapping->flags);
> > >  	}
> > 
> > I find it a bit ugly that it applies an attribute of the memory area
> > (per mm) to the page cache mapping (shared).  Because this in turn
> > means that the reference through a non-executable vma might get the
> > pages rotated just because there is/was an executable mmap around.
> 
> Yes, it's not good.  That AS_EXEC bit will hang around for arbitrarily
> long periods in the inode cache.  So we'll have AS_EXEC set on an
> entire file because someone mapped some of it with PROT_EXEC half an
> hour ago.  Where's the sense in that?

Yes that nonsense case is possible, but should be rare.

AS_EXEC means "this is (likely) an executable file".
It has broader coverage in both space and time:

- it protects the whole file instead of only the text section
- it allows to further protect the many executables/libraries that
  typically runs short in time but maybe frequently, eg. ls, cat,
  git, gcc, perl, python, ...

But none of the above cases are as important in user experience as the
currently running code, so here goes the new patch (which applies after
vmscan: report vm_flags in page_referenced()).

Thanks,
Fengguang
---
vmscan: make mapped executable pages the first class citizen

Protect referenced PROT_EXEC mapped pages from being deactivated.

PROT_EXEC(or its internal presentation VM_EXEC) pages normally belong to some
currently running executables and their linked libraries, they shall really be
cached aggressively to provide good user experiences.

CC: Elladan <elladan@eskimo.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- linux.orig/mm/vmscan.c
+++ linux/mm/vmscan.c
@@ -1233,6 +1233,7 @@ static void shrink_active_list(unsigned 
 	unsigned long pgscanned;
 	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
+	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct pagevec pvec;
@@ -1272,8 +1273,13 @@ static void shrink_active_list(unsigned 
 
 		/* page_referenced clears PageReferenced */
 		if (page_mapping_inuse(page) &&
-		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags))
+		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			pgmoved++;
+			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
+				list_add(&page->lru, &l_active);
+				continue;
+			}
+		}
 
 		list_add(&page->lru, &l_inactive);
 	}
@@ -1282,7 +1288,6 @@ static void shrink_active_list(unsigned 
 	 * Move the pages to the [file or anon] inactive list.
 	 */
 	pagevec_init(&pvec, 1);
-	lru = LRU_BASE + file * LRU_FILE;
 
 	spin_lock_irq(&zone->lru_lock);
 	/*
@@ -1294,6 +1299,7 @@ static void shrink_active_list(unsigned 
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	pgmoved = 0;  /* count pages moved to inactive list */
+	lru = LRU_BASE + file * LRU_FILE;
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
 		prefetchw_prev_lru_page(page, &l_inactive, flags);
@@ -1316,6 +1322,29 @@ static void shrink_active_list(unsigned 
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgmoved);
+
+	pgmoved = 0;  /* count pages moved back to active list */
+	lru = LRU_ACTIVE + file * LRU_FILE;
+	while (!list_empty(&l_active)) {
+		page = lru_to_page(&l_active);
+		prefetchw_prev_lru_page(page, &l_active, flags);
+		VM_BUG_ON(PageLRU(page));
+		SetPageLRU(page);
+		VM_BUG_ON(!PageActive(page));
+
+		list_move(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_add_lru_list(page, lru);
+		pgmoved++;
+		if (!pagevec_add(&pvec, page)) {
+			spin_unlock_irq(&zone->lru_lock);
+			if (buffer_heads_over_limit)
+				pagevec_strip(&pvec);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+
 	spin_unlock_irq(&zone->lru_lock);
 	if (buffer_heads_over_limit)
 		pagevec_strip(&pvec);
