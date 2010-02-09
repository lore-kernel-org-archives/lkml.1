Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0BIR50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:57:26 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47698 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab0BIR5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:57:24 -0500
Date: Tue, 9 Feb 2010 17:57:08 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, npiggin@suse.de
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100209175707.GB5098@csn.ul.ie>
References: <4B225B9E.2020702@linux.vnet.ibm.com> <4B2B85C7.80502@linux.vnet.ibm.com> <20091218174250.GC21194@csn.ul.ie> <4B4F0E60.1020601@linux.vnet.ibm.com> <20100119113306.GA23881@csn.ul.ie> <4B6C3E6E.6050303@linux.vnet.ibm.com> <20100205174917.GB11512@csn.ul.ie> <4B70192C.3070601@linux.vnet.ibm.com> <20100208152131.GC23680@csn.ul.ie> <4B7184B5.6040400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B7184B5.6040400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> How reproducible are these results with patch e084b reverted? i.e. I know
> >>> it does not work now, but did reverting on the old kernel always fix it
> >>> or were there occasions where the figures would be still bad?
> >>>   
> >> Reverting e084b in the past showed something like +40%, so I thought it  
> >> helps.
> >> Afterwards I found out it wasn't a good testcase for reproducibility and  
> >> when looking at a series it had +5%,-7%,+20%,...
> >> So by far too noisy to be useful for bisect, discussion or fix testing.
> >> Thats why I made my big round reinventing the testcases in a more  
> >> reproducible way like described above.
> >> In those the original issue is still very visible - which means 4 runs  
> >> comparing 2.6.32 vs 2.6.32-Reve084b being each max +/-1%.
> >> While gitid-e084b vs. the one just before (51fbb) gives ~-60% all the time.
> > 
> > About all e084b can be affecting is cache hotness when fallback is occuring
> > but 60% regression still seems way too high for just that.
> 
> Yes, most the ideas you, I an a few others so far had went for cache
> hotness - but always the summary was "couldn't be that much".

Well, it's cache hotness or the driver or hardware doing automatic merging
of requests (which you say is not happening). There are two other
possibilties but their effect should be very low as well.

> On the other hand we have to consider that it could be a small timing due
> to cache or whatever else which leads into congestion_wait and then it waits
> HZ/50. That way a 1µs cause can lead to 20001µs lost which then cause 60%.

Maybe although it would imply the window where it can go wrong is
very small. It seems unlikely that it would be hit every time.

> Another important thing is that "cold page" afaik means the page content,
> and not the management struct etc. As the time lost is in management only
> (=> before accessing the actual 4k page content) it should not be important
> if a page is cold/hot for the mm code itself.

True. Even the zeroing should be a non-temporal store so the timing
should not be affected.

> That much for direct_reclaim that either runs into progress, but !page
> (BAD case) or not (GOOD case) - there only cache effects of struct page,
> pcp lists etc should have an effect.

There are only two other possibilities I can think of.

1. The extra parameter to rmqueue_bulk() means that your platform
   generates particularly bad code to pass a 6th parameter.
2. The branch inside the for loop is causing serious problems somehow

Causing a 60% slowdown from either of these seems unlikely but there isn't
much choice than to eliminate them as possibilities. The attached patch is
for "option 1" above. I'll think more on how to best handle "option 2"

> >>>> Another bisect (keepign e084b reverted) brought up git id 5f8dcc21 
> >>>> which  came in later. Both patches unapplied individually don't 
> >>>> improve  anything. But both patches reverted at the same time on git 
> >>>> v2.6.32  bring us back to our old values (remember that is more than 
> >>>> 2Gb/s  improvement in throughput)!
> >>>>
> >>>> Unfortunately 5f8dcc21 is as unobvious as e84b in explaining how this 
> >>>>  can cause so much trouble.
> >>>>     
> >>> There is a bug in commit 5f8dcc21. One consequence of it is that swap-based
> >>> workloads can suffer. A second is that users of high-order allocations can
> >>> enter direct reclaim a lot more than previously. This was fixed in commit
> >>> a7016235a61d520e6806f38129001d935c4b6661 but you say that's not the fix in
> >>> your case. 
> >>>
> >>> The only other interesting thing in commit 5f8dcc21 is that it increases
> >>> the memory overhead of a per-cpu structure. If your memory usage is really
> >>> borderline, it might have been just enough to push it over the edge.
> >>>   
> >> I had this thoughts too, but as it only shows an effect with 5f8dcc21  
> >> and e084b reverted at the same time I'm wondering if it can be that.
> >> But I agree that this should be considered too until a verification can  
> >> be done.
> > 
> > Another consequence of 5f8dcc is that pages are on the per-cpu lists that
> > it is possible for pages to be on the per-cpu lists when the page allocator
> > is called. There is potential that page reclaim is being entered as a
> > result even though pages were free on the per-cpu lists.
> > 
> > It would not explain why reverting e084b makes such a difference but I
> > can prototype a patch that falls back to other per-cpu lists before
> > calling the page allocator as it used to do but without linear searching
> > the per-cpu lists.
> 
> I tested these patch you submitted in another reply.
> Short - it only gives it ~+4% by probably speeding up things a bit but
> not touching the issue in any way.
> Some more detail below at the other test result.
> 

You mention it gains 4% which is not great, but what impact, if any, had
it on the number of calls to direct reclaim?

> <SNIP>
> > Ok. Two avenues of attack then although both are focused on 5f8dcc21.
> > The first is the prototype below that should avoid congestion_wait. The
> > second is to reintroduce a fallback to other per-cpu lists and see if
> > that was a big factor.
> 
> I tested both of your patches, btw thanks for the quick work!
> 

Thanks for persisting with this! I know it's dragging on a lot longer
than anyone would like.

> > Hmm, the patch as it currently stands is below. However, I warn you that
> > it has only been boot-tested on qemu with no proper testing doing, either
> > functional or performance testing. It may just go mad, drink your beer and
> > chew on your dog.
> 
> In opposition to all your warnings it worked pretty well.

Nice one.

> The patch replacing congestion_wait calls - which we know re futile in my scenario
> anyway - by zone_wait calls helps a lot. But so far as you suggested only by alleviating the symptoms.
> 
> From a throughput perspective alone it looks almost fixed:
>                                                     4 thread      8 thread    16 thread
> plain 2.6.32                                        100%          100%        100%
> 2.6.32 avoid direct reclaim                         103.85%       103.60%     104.04%
> 2.6.32 zone wait                                    125.46%       140.87%     131.89%
> 2.6.32 zone wait + 5f8dcc21 and e084b reverted      124.46%       143.35%     144.21%
> 

Ok, the fact that the congestion_wait-avoidance patch makes such a large
difference is very interesting although if the direct reclaim calls were
lower, it would be less pronounced. I will be having those patches on the
back-burner for another while unless we cannot resolve this problem a better
way but it's nice to know they may have some potential.

> Looking at the counters this theory (only fixing symptoms) seems to be
> confirmed. Before the ratio of perf_count_pages_direct_reclaim calls that
> ended in perf_count_failed_pages_direct_reclaim_but_progress was ~2% in the
> good cases and ~30% in bad cases. As congestion_wait in my case almost always
> waits the full HZ/50 this is a lot.

> With the zone wait patch I see a huge throughput win, most probably by
> all the (still ~30%!) waits that don't have to wait for the full timeout.

That would be my expectation. The underlying problem of
too-many-direct-reclaims is not solved.

> But still reverting 5f8dcc21 and e084b fix the issue of so much direct
> reclaims running in into that condition and that way giving throughput
> another last push.
>                                                       % ran into try_to_free did progress but get_page got !page
> plain 2.6.32                                          30.16%
> 2.6.32 zone wait                                      29.05%
> 2.6.32 zone wait + 5f8dcc21 and e084b reverted        2.93%
> 

And what impact did "Fallback to other per-cpu lists when the target list
is empty and memory is low" have on the number of calls to direct reclaim?

> Note - with the zone wait patch there are also almost twice as much
> direct_reclaim calls. Probably by several waiters coming of the list when
> the watermark is restored and allocating too much.

It could be either a thundering herd problem or just the fact that the
processes are not asleep.

> Another good side note - 5f8dcc21 and e084b reverted plus your zone wait
> patch is better than anything I have seen so far :-)

Well, that's something positive out of all this. The congestion_wait() patch
was developed in response to this thread. Even though I knew it was treating
symptons and not problems, the congestion_wait() was identified as a bad
idea some time ago because the lack of pages may have nothing to do with IO.

> Maybe its worth to measure  both of your patches plus 5f8dcc21 and e084b
> reverted with 64 threads (the effect grows with # threads) just to rejoice
> in huge throughput values for a short time.

:)

> > <SNIP>
> > 
> > There is a good chance that 5f8dcc is causing direct reclaim to be entered
> > when it could have been avoided as pages were on the per-cpu lists but
> > I don't think the difference in cache hotness is enough to explain a 60%
> > loss on your machine.
> > 
> 
> As far as I get it thats what your patch #2 fixed (page allocator: Fallback
> to other per-cpu lists when the target list is empty and memory is low),
> but as mentioned below that gave me +4%.

I need to know what effect, if any, it had on the direct reclaim
figures. If it does drop them, but not by enough, then fallback can be
allowed to occur in more cirsumstances - for example, by changing

+	if (pcp->count && free_pages <= low_wmark_pages(zone)) {

with

+	if (pcp->count && free_pages <= high_wmark_pages(zone)) {

> Which is actually a fine win, but not for the issue currently in discussion.
> As bonus I can give you now a little tested-by for both patches :-)
> 

Thanks :)

Still, the grind continues to try resolve this :(

1. If the "Fallback to other per-cpu lists" does reduce the number of
	calls to direct reclaim, but not by enough, please replace the
	comparison of low_wmark_pages with high_wmark_pages and let me know a)
	how much it affects throughput and b) how much it affects the number
	of calls to direct reclaim

	This is addressing potential problems in 5f8dcc

2. Test with the patch below rmqueue_bulk-fewer-parameters to see if the
	number of parameters being passed is making some unexpected large
	difference

	This is trying to figure out more what the problem with e084b is

==== CUT HERE ====
rmqueue_bulk-fewer-parameters

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7021c68..180bab2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -936,7 +936,7 @@ retry_reserve:
  * a single hold of the lock, for efficiency.  Add them to the supplied list.
  * Returns the number of new pages which were placed at *list.
  */
-static int rmqueue_bulk(struct zone *zone, unsigned int order, 
+static int rmqueue_bulk(struct zone *zone,
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
@@ -944,7 +944,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order, migratetype);
+		struct page *page = __rmqueue(zone, 0, migratetype);
 		if (unlikely(page == NULL))
 			break;
 
@@ -964,7 +964,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		set_page_private(page, migratetype);
 		list = &page->lru;
 	}
-	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
+	__mod_zone_page_state(zone, NR_FREE_PAGES, -1);
 	spin_unlock(&zone->lock);
 	return i;
 }
@@ -1231,7 +1231,7 @@ again:
 		list = &pcp->lists[migratetype];
 		local_irq_save(flags);
 		if (list_empty(list)) {
-			pcp->count += rmqueue_bulk(zone, 0,
+			pcp->count += rmqueue_bulk(zone,
 					pcp->batch, list,
 					migratetype, cold);
 			if (unlikely(list_empty(list)))
