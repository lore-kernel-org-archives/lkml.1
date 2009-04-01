Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbZDANcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbZDANcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZDANcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:32:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45830 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbZDANcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:32:24 -0400
Date: Wed, 1 Apr 2009 14:32:20 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090401133220.GB6406@csn.ul.ie>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie> <20090401131713.GQ12966@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090401131713.GQ12966@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 03:17:13PM +0200, Ingo Molnar wrote:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Wed, Apr 01, 2009 at 01:15:40PM +0200, Ingo Molnar wrote:
> > > > <VAST AMOUNTS OF SNIPPAGE>
> > > >
> > > > +static inline void __stack_trace(struct page *page, unsigned long *stack,
> > > > +			unsigned long bp)
> > > > +{
> > > > +	int i = 0;
> > > > +	unsigned long addr;
> > > > +	struct thread_info *tinfo = (struct thread_info *)
> > > > +		((unsigned long)stack & (~(THREAD_SIZE - 1)));
> > > > +
> > > > +	memset(page->trace, 0, sizeof(long) * 8);
> > > > +
> > > > +#ifdef CONFIG_FRAME_POINTER
> > > > +	if (bp) {
> > > > +		while (valid_stack_ptr(tinfo, (void *)bp)) {
> > > > +			addr = *(unsigned long *)(bp + sizeof(long));
> > > > +			page->trace[i] = addr;
> > > > +			if (++i >= 8)
> > > > +				break;
> > > > +			bp = *(unsigned long *)bp;
> > > > +		}
> > > > +		return;
> > > > +	}
> > > > +#endif /* CONFIG_FRAME_POINTER */
> > > > +	while (valid_stack_ptr(tinfo, stack)) {
> > > > +		addr = *stack++;
> > > > +		if (__kernel_text_address(addr)) {
> > > > +			page->trace[i] = addr;
> > > > +			if (++i >= 8)
> > > > +				break;
> > > > +		}
> > > > +	}
> > > > +}
> > > 
> > > Uhm, this is not acceptable and broken, we have generic stacktrace 
> > > saving facilities for this precise purpose. It has other problems 
> > > too.
> > > 
> > > The purpose of the patch seems genuinely useful and i support the 
> > > concept, but the current design is limiting (we could do much 
> > > better) and the implementation is awful. Please.
> > > 
> > > Has this patch been reviewed by or Cc:-ed to anyone versed in kernel 
> > > instrumentation details, before it was applied to -mm? Those folks 
> > > hang around the tracing tree usually so they are easy to find. :)
> > > 
> > 
> > This patch is ancient, predating most of the instrumentation stuff 
> > by years. It was dropped from -mm a few months ago because of 
> > changes in proc and this is a rebase because it came up as being 
> > potentially useful pinning down memory leaks when they occur.
> > 
> > I'm not sure when exactly it was introduced to -mm, but I see 
> > references going back as far as 2.6.12-rc1 so it's no surprise 
> > this is now extremly odd looking. However, there is no plan to 
> > merge this to mainline making the effort of redoing it from 
> > scratch a questionable expenditure of time.
> 
> Hm, why not merge the concept upstream?
> 

I suspect at the time the patch was put together, it was not merged upstream
because it severely bloated struct page and would be something that was never
enabled by default in distros. Anyone wanted it for debugging could easily
apply the patch. It's a decision that simply has never been revisited as
it's not used that often - it's just seriously useful when you do need it.

I'm guessing though, I wasn't active in kernel development at the time
and I haven't dug through the archives to see the history.

> I'm sure the kmemtrace maintainers (Eduardo and Pekka) would be 
> interested in this too: they are already tracking slab allocation 
> events in a very finegrained way, extending that scheme to the page 
> allocator seems genuinely useful to me.
> 

In light of kmemtrace's success, it does make sense to revisit if someone
has the cycles to spare. Again bear in mind that this owner patch was in
-mm long before kmemtrace came along so it was a good idea at the time whose
implementation has not quite stood the test of time.

> And that way the rather ugly bloating of struct page by this patch 
> would be solved too: it's not needed and there's no need to actually 
> save the callchain permanently, it's usually enough to _trace_ it - 
> user-space can then save it into a permanent map if it's interested. 
> 

It's picky but you lose details from boot-time allocations that way but
that's a relatively small detail. If it's leaks you really care about though,
then tracing is probably sufficient.

> So this feature could go into Linux distros, available by default 
> and integrated into the user-space side of kmemtrace.
> 
> ( You could trace the gfp-type like kmemtrace does already - that 
>   way user-space can do GFP_MOVABLE / GFP_RECLAIMABLE summary counts 
>   (and more). )
> 

I concede that there is overlap but GFP_MOVABLE and GFP_RECLAIMABLE tracking
would be useful I have to say. In the past, I modified this patch to track
that information so I could figure out what was going on in the system. It'd
be nice to do similar in the field.

> So hooking up this info into tracepoints and ftrace seems genuinely 
> useful to me. You could trace the whole system, or you could use 
> filter expressions to do things like:
> 
>    echo "comm == Xorg" > /debug/tracing/events/mm/page_alloc/filter
> 
> To only track the memory allocations of Xorg task(s) for example. 
> 
> Later on a tracepoint based sw event could be made out of it too, 
> hooked up to sw-perfcounters, to dynamically profile page usage by 
> owning function(s) and task(s).
> 
> Later on we could add more info to the tracepoints - for example the 
> d_path() of the vma that is attached to the page could be traced (if 
> it's not an anonymous vma and not a kernel-internal allocation).
> 
> etc.
> 

Ok, I fully concede that this would all be great to have and I've taken
note to investigate it at some time in the future but it won't be any
time soon I'm afraid. Maybe this thread will prod someone familiar with
tracing with some time to spare to take a look at what that provides
reimplement in a sensible manner as you suggest?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
