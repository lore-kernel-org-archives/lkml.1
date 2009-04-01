Return-Path: <linux-kernel-owner+w=401wt.eu-S1764949AbZDANW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764949AbZDANW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763698AbZDANWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:22:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbZDANWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:22:44 -0400
Date: Wed, 1 Apr 2009 15:17:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, alexn@dsv.su.se,
       akpm@linux-foundation.org, alexn@telia.com, apw@shadowen.org,
       cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090401131713.GQ12966@elte.hu>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401125506.GA6406@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, Apr 01, 2009 at 01:15:40PM +0200, Ingo Molnar wrote:
> > > <VAST AMOUNTS OF SNIPPAGE>
> > >
> > > +static inline void __stack_trace(struct page *page, unsigned long *stack,
> > > +			unsigned long bp)
> > > +{
> > > +	int i = 0;
> > > +	unsigned long addr;
> > > +	struct thread_info *tinfo = (struct thread_info *)
> > > +		((unsigned long)stack & (~(THREAD_SIZE - 1)));
> > > +
> > > +	memset(page->trace, 0, sizeof(long) * 8);
> > > +
> > > +#ifdef CONFIG_FRAME_POINTER
> > > +	if (bp) {
> > > +		while (valid_stack_ptr(tinfo, (void *)bp)) {
> > > +			addr = *(unsigned long *)(bp + sizeof(long));
> > > +			page->trace[i] = addr;
> > > +			if (++i >= 8)
> > > +				break;
> > > +			bp = *(unsigned long *)bp;
> > > +		}
> > > +		return;
> > > +	}
> > > +#endif /* CONFIG_FRAME_POINTER */
> > > +	while (valid_stack_ptr(tinfo, stack)) {
> > > +		addr = *stack++;
> > > +		if (__kernel_text_address(addr)) {
> > > +			page->trace[i] = addr;
> > > +			if (++i >= 8)
> > > +				break;
> > > +		}
> > > +	}
> > > +}
> > 
> > Uhm, this is not acceptable and broken, we have generic stacktrace 
> > saving facilities for this precise purpose. It has other problems 
> > too.
> > 
> > The purpose of the patch seems genuinely useful and i support the 
> > concept, but the current design is limiting (we could do much 
> > better) and the implementation is awful. Please.
> > 
> > Has this patch been reviewed by or Cc:-ed to anyone versed in kernel 
> > instrumentation details, before it was applied to -mm? Those folks 
> > hang around the tracing tree usually so they are easy to find. :)
> > 
> 
> This patch is ancient, predating most of the instrumentation stuff 
> by years. It was dropped from -mm a few months ago because of 
> changes in proc and this is a rebase because it came up as being 
> potentially useful pinning down memory leaks when they occur.
> 
> I'm not sure when exactly it was introduced to -mm, but I see 
> references going back as far as 2.6.12-rc1 so it's no surprise 
> this is now extremly odd looking. However, there is no plan to 
> merge this to mainline making the effort of redoing it from 
> scratch a questionable expenditure of time.

Hm, why not merge the concept upstream?

I'm sure the kmemtrace maintainers (Eduardo and Pekka) would be 
interested in this too: they are already tracking slab allocation 
events in a very finegrained way, extending that scheme to the page 
allocator seems genuinely useful to me.

And that way the rather ugly bloating of struct page by this patch 
would be solved too: it's not needed and there's no need to actually 
save the callchain permanently, it's usually enough to _trace_ it - 
user-space can then save it into a permanent map if it's interested. 

So this feature could go into Linux distros, available by default 
and integrated into the user-space side of kmemtrace.

( You could trace the gfp-type like kmemtrace does already - that 
  way user-space can do GFP_MOVABLE / GFP_RECLAIMABLE summary counts 
  (and more). )

So hooking up this info into tracepoints and ftrace seems genuinely 
useful to me. You could trace the whole system, or you could use 
filter expressions to do things like:

   echo "comm == Xorg" > /debug/tracing/events/mm/page_alloc/filter

To only track the memory allocations of Xorg task(s) for example. 

Later on a tracepoint based sw event could be made out of it too, 
hooked up to sw-perfcounters, to dynamically profile page usage by 
owning function(s) and task(s).

Later on we could add more info to the tracepoints - for example the 
d_path() of the vma that is attached to the page could be traced (if 
it's not an anonymous vma and not a kernel-internal allocation).

etc.

	Ingo
