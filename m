Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0BSPTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:19:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57987 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0BSPTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:19:49 -0500
Date: Fri, 19 Feb 2010 15:19:34 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100219151934.GA1445@csn.ul.ie>
References: <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com> <4B7E73BF.5030901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B7E73BF.5030901@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 12:19:27PM +0100, Christian Ehrhardt wrote:
> >>>>
> >>>> PAGES-FREED  fast path   slow path
> >>>> GOOD CASE      ~62       ~1.46
> >>>> BAD CASE       ~62       ~37
> >>> 5f8dcc21 introduced per migrate type pcp lists, is it possible that 
> >>> we  run in a scenario where try_to_free frees a lot of pages via, but 
> >>> of the  wrong migrate type?
> >>
> >> It's possible but the window is small. When a threshold is reached on the
> >> PCP lists, they get drained to the buddy lists and later picked up again
> >> by __rmqueue_fallback(). I had considered the possibility of pages of the
> >> wrong type being on the PCP lists which led to the patch "page-allocator:
> >> Fallback to other per-cpu lists when the target list is empty and 
> >> memory is
> >> low" but you reported it made no difference even when fallback was 
> >> allowed
> >> with high watermarks.
> >> [...]
> > 
> > Today I created rather huge debug logs - I'll spare everyone with too 
> > much detail.
> > Eventually it comes down to some kind of cat /proc/zoneinfo like output 
> > extended to list all things per migrate type too.
> > 
> >  From that I still think there should be plenty of pages to get the 
> > allocation through, as it was suggested by the high amount of pages 
> > freed by try_to_free.
> > > 
> [...]
> 
> > More about that tomorrow,
> 
> Well tomorrow is now, and I think I got some important new insights.
> 
> As mentioned before I realized that a second call still fails most of the
> time (>99%). Therefore I added a "debugme" parameter to get_page_from_freelist
> and buffered_rmqueue to see where the allocations exactly fails (patch
> attached).
> 
> Now with debugme active in a second call after it had progress&&!page in direct_reclaim I saw the following repeating pattern in most of the cases:
>    get_page_from_freelist - zone loop - current zone 'DMA'
>    get_page_from_freelist - watermark check due to !(alloc_flags & ALLOC_NO_WATERMARKS)
>    get_page_from_freelist - goto zone_full due to zone_reclaim_mode==0
>    get_page_from_freelist - return page '(null)'
> 
> Ok - now we at least exactly know why it gets no page.
> Remember there are plenty of pages like it was in my zoneinfo like report in the last mail.
> I didn't expect that, but actually watermarks are what stops the allocations here.

That is somewhat expected. We also don't want to go underneath them
beause that can lead to system deadlock.

> The zone_watermark_ok check reports that there are not enough pages for the current watermark and
> finally it ends with zone_reclaim_mode which is always zero on s390 as we are not CONFIG_NUMA.
> 
> Ok remember my scenario - several parallel iozone sequential read processes
> - theres not much allocation going on except for the page cache read ahead
> related to that read workload.
> The allocations for page cache seem to have no special watermarks selected
> via their GFP flags and therefore get stalled by congestion_wait - which in
> consequence of no available writes in flight consumes its full timeout.
>

Which I'd expect to some extent, but it still stuns me that e084b makes
a difference to any of this. The one-list-per-migratetype patch would
make some sense except restoring something similar to the old behaviour
didn't help either.

> As I see significant impacts to the iozone throughput and not only
> e.g. bad counters in direct_reclaim the congestion_wait stalling seems to
> be so often/long to stall the application I/O itself.
>
> That means from the time VFS starting a read ahead it seems to stall that
> page allocation long enough that the data is not ready when the application
> tries to read it, while it would be if the allocation would be fast enough.
>
> A simple test for this theory was to allow those failing allocations a
> second chance without watermark restrictions before putting them to sleep
> for such a long time.

> 
> Index: linux-2.6-git/mm/page_alloc.c
> ===================================================================
> --- linux-2.6-git.orig/mm/page_alloc.c  2010-02-19 09:53:14.000000000 +0100
> +++ linux-2.6-git/mm/page_alloc.c       2010-02-19 09:56:26.000000000 +0100
> @@ -1954,7 +1954,22 @@
> 
>         if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
>                 /* Wait for some write requests to complete then retry */
> -               congestion_wait(BLK_RW_ASYNC, HZ/50);
> +               /*
> +                * If it gets here try it without watermarks before going
> +                * to sleep.
> +                *
> +                * This will end up in alloc_high_priority and if that fails
> +                * once more direct_reclaim but this time without watermark
> +                * checks.
> +                *
> +                * FIXME: that is just for verification - a real fix needs to
> +                * ensure e.g. page cache allocations don't drain all pages
> +                * under watermark
> +                */
> +               if (!(alloc_flags & ALLOC_NO_WATERMARKS))
> +                       alloc_flags &= ALLOC_NO_WATERMARKS;
> +               else
> +                       congestion_wait(BLK_RW_ASYNC, HZ/50);
>                 goto rebalance;
>         }
> 
> This fixes all issues I have, but as stated in the FIXME it is unfortunately
> no fix for the real world.

It's possible to deadlock a system with this patch. It's also not acting
as you intended. I think you meant either |= or = there but anyway.

> Unfortunately even now knowing the place of the issue so well I don't see
> the connection to the commits e084b+5f8dcc21

Still a mystery.

>  - I couldn't find something but
> did they change the accounting somewhere or e.g. changed the timing/order
> of watermark updates and allocations?
>

Not that I can think of.

> Eventually it might come down to a discussion of allocation priorities and
> we might even keep them as is and accept this issue - I still would prefer
> a good second chance implementation, other page cache allocation flags or
> something else that explicitly solves this issue.
>

In that line, the patch that replaced congestion_wait() with a waitqueue
makes some sense.

> Mel's patch that replaces congestion_wait with a wait for the zone watermarks
> becoming available again is definitely a step in the right direction and
> should go into upstream and the long term support branches.

I'll need to do a number of tests before I can move that upstream but I
don't think it's a merge candidate. Unfortunately, I'll be offline for a
week starting tomorrow so I won't be able to do the testing.

When I get back, I'll revisit those patches with the view to pushing
them upstream. I hate to treat symptoms here without knowing the
underlying problem but this has been spinning in circles for ages with
little forward progress :(

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
