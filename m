Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbZF1PKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbZF1PKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZF1PKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:10:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:25853 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZF1PKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:10:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,303,1243839600"; 
   d="scan'208";a="159337639"
Date: Sun, 28 Jun 2009 23:10:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090628151026.GB25076@localhost>
References: <2015.1245341938@redhat.com> <20090618095729.d2f27896.akpm@linux-foundation.org> <7561.1245768237@redhat.com> <26537.1246086769@redhat.com> <20090627125412.GA1667@cmpxchg.org> <20090628113246.GA18409@localhost> <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com> <28c262360906280636l93130ffk14086314e2a6dcb7@mail.gmail.com> <20090628142239.GA20986@localhost> <2f11576a0906280801w417d1b9fpe10585b7a641d41b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f11576a0906280801w417d1b9fpe10585b7a641d41b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 11:01:40PM +0800, KOSAKI Motohiro wrote:
> > Yes, smaller inactive_anon means smaller (pointless) nr_scanned,
> > and therefore less slab scans. Strictly speaking, it's not the fault
> > of your patch. It indicates that the slab scan ratio algorithm should
> > be updated too :)
> 
> I don't think this patch is related to minchan's patch.
> but I think this patch is good.

OK.

> 
> > We could refine the estimation of "reclaimable" pages like this:
> 
> hmhm, reasonable idea.

Thank you.

> >
> > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > index 416f748..e9c5b0e 100644
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -167,14 +167,7 @@ static inline unsigned long zone_page_state(struct zone *zone,
> >  }
> >
> >  extern unsigned long global_lru_pages(void);
> > -
> > -static inline unsigned long zone_lru_pages(struct zone *zone)
> > -{
> > -       return (zone_page_state(zone, NR_ACTIVE_ANON)
> > -               + zone_page_state(zone, NR_ACTIVE_FILE)
> > -               + zone_page_state(zone, NR_INACTIVE_ANON)
> > -               + zone_page_state(zone, NR_INACTIVE_FILE));
> > -}
> > +extern unsigned long zone_lru_pages(void);
> >
> >  #ifdef CONFIG_NUMA
> >  /*
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 026f452..4281c6f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2123,10 +2123,31 @@ void wakeup_kswapd(struct zone *zone, int order)
> >
> >  unsigned long global_lru_pages(void)
> >  {
> > -       return global_page_state(NR_ACTIVE_ANON)
> > -               + global_page_state(NR_ACTIVE_FILE)
> > -               + global_page_state(NR_INACTIVE_ANON)
> > -               + global_page_state(NR_INACTIVE_FILE);
> > +       int nr;
> > +
> > +       nr = global_page_state(zone, NR_ACTIVE_FILE) +
> > +            global_page_state(zone, NR_INACTIVE_FILE);
> > +
> > +       if (total_swap_pages)
> > +               nr += global_page_state(zone, NR_ACTIVE_ANON) +
> > +                     global_page_state(zone, NR_INACTIVE_ANON);
> > +
> > +       return nr;
> > +}
> 
> Please change function name too.
> Now, this function only account reclaimable pages.

Good suggestion - I did considered renaming them to *_relaimable_pages.

> Plus, total_swap_pages is bad. if we need to concern "reclaimable
> pages", we should use nr_swap_pages.

> I mean, swap-full also makes anon is unreclaimable althouth system
> have sone swap device.
 
Right, changed to (nr_swap_pages > 0).

Thanks,
Fengguang
---

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 416f748..8d8aa20 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -166,15 +166,8 @@ static inline unsigned long zone_page_state(struct zone *zone,
 	return x;
 }
 
-extern unsigned long global_lru_pages(void);
-
-static inline unsigned long zone_lru_pages(struct zone *zone)
-{
-	return (zone_page_state(zone, NR_ACTIVE_ANON)
-		+ zone_page_state(zone, NR_ACTIVE_FILE)
-		+ zone_page_state(zone, NR_INACTIVE_ANON)
-		+ zone_page_state(zone, NR_INACTIVE_FILE));
-}
+extern unsigned long global_reclaimable_pages(void);
+extern unsigned long zone_reclaimable_pages(void);
 
 #ifdef CONFIG_NUMA
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a91b870..74c3067 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -394,7 +394,8 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) + zone_lru_pages(z);
+		x += zone_page_state(z, NR_FREE_PAGES) +
+		     zone_reclaimable_pages(z);
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -418,7 +419,7 @@ unsigned long determine_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_lru_pages();
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 026f452..3768332 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1693,7 +1693,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 
-			lru_pages += zone_lru_pages(zone);
+			lru_pages += zone_reclaimable_pages(zone);
 		}
 	}
 
@@ -1910,7 +1910,7 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
-			lru_pages += zone_lru_pages(zone);
+			lru_pages += zone_reclaimable_pages(zone);
 		}
 
 		/*
@@ -1954,7 +1954,7 @@ loop_again:
 			if (zone_is_all_unreclaimable(zone))
 				continue;
 			if (nr_slab == 0 && zone->pages_scanned >=
-						(zone_lru_pages(zone) * 6))
+					(zone_reclaimable_pages(zone) * 6))
 					zone_set_flag(zone,
 						      ZONE_ALL_UNRECLAIMABLE);
 			/*
@@ -2121,12 +2121,33 @@ void wakeup_kswapd(struct zone *zone, int order)
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-unsigned long global_lru_pages(void)
+unsigned long global_reclaimable_pages(void)
 {
-	return global_page_state(NR_ACTIVE_ANON)
-		+ global_page_state(NR_ACTIVE_FILE)
-		+ global_page_state(NR_INACTIVE_ANON)
-		+ global_page_state(NR_INACTIVE_FILE);
+	int nr;
+
+	nr = global_page_state(zone, NR_ACTIVE_FILE) +
+	     global_page_state(zone, NR_INACTIVE_FILE);
+
+	if (total_swap_pages)
+		nr += global_page_state(zone, NR_ACTIVE_ANON) +
+		      global_page_state(zone, NR_INACTIVE_ANON);
+
+	return nr;
+}
+
+
+unsigned long zone_reclaimable_pages(struct zone *zone)
+{
+	int nr;
+
+	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
+	     zone_page_state(zone, NR_INACTIVE_FILE);
+
+	if (nr_swap_pages > 0)
+		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
+		      zone_page_state(zone, NR_INACTIVE_ANON);
+
+	return nr;
 }
 
 #ifdef CONFIG_HIBERNATION
@@ -2198,7 +2219,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 
 	current->reclaim_state = &reclaim_state;
 
-	lru_pages = global_lru_pages();
+	lru_pages = global_reclaimable_pages();
 	nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
@@ -2240,7 +2261,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					global_lru_pages());
+				    global_reclaimable_pages());
 			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
 			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
@@ -2257,7 +2278,8 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 	if (!sc.nr_reclaimed) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
+			shrink_slab(nr_pages, sc.gfp_mask,
+				    global_reclaimable_pages());
 			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
 		} while (sc.nr_reclaimed < nr_pages &&
 				reclaim_state.reclaimed_slab > 0);
