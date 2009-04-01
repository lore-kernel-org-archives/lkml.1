Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbZDANy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbZDANy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbZDANw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:52:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbZDANwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:52:24 -0400
Date: Wed, 1 Apr 2009 15:49:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>, Jason Baron <jbaron@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090401134917.GC18677@elte.hu>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie> <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401133220.GB6406@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, Apr 01, 2009 at 03:17:13PM +0200, Ingo Molnar wrote:
> > 
> > * Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > On Wed, Apr 01, 2009 at 01:15:40PM +0200, Ingo Molnar wrote:
> > > > > <VAST AMOUNTS OF SNIPPAGE>
> > > > >
> > > > > +static inline void __stack_trace(struct page *page, unsigned long *stack,
> > > > > +			unsigned long bp)
> > > > > +{
> > > > > +	int i = 0;
> > > > > +	unsigned long addr;
> > > > > +	struct thread_info *tinfo = (struct thread_info *)
> > > > > +		((unsigned long)stack & (~(THREAD_SIZE - 1)));
> > > > > +
> > > > > +	memset(page->trace, 0, sizeof(long) * 8);
> > > > > +
> > > > > +#ifdef CONFIG_FRAME_POINTER
> > > > > +	if (bp) {
> > > > > +		while (valid_stack_ptr(tinfo, (void *)bp)) {
> > > > > +			addr = *(unsigned long *)(bp + sizeof(long));
> > > > > +			page->trace[i] = addr;
> > > > > +			if (++i >= 8)
> > > > > +				break;
> > > > > +			bp = *(unsigned long *)bp;
> > > > > +		}
> > > > > +		return;
> > > > > +	}
> > > > > +#endif /* CONFIG_FRAME_POINTER */
> > > > > +	while (valid_stack_ptr(tinfo, stack)) {
> > > > > +		addr = *stack++;
> > > > > +		if (__kernel_text_address(addr)) {
> > > > > +			page->trace[i] = addr;
> > > > > +			if (++i >= 8)
> > > > > +				break;
> > > > > +		}
> > > > > +	}
> > > > > +}
> > > > 
> > > > Uhm, this is not acceptable and broken, we have generic stacktrace 
> > > > saving facilities for this precise purpose. It has other problems 
> > > > too.
> > > > 
> > > > The purpose of the patch seems genuinely useful and i support the 
> > > > concept, but the current design is limiting (we could do much 
> > > > better) and the implementation is awful. Please.
> > > > 
> > > > Has this patch been reviewed by or Cc:-ed to anyone versed in kernel 
> > > > instrumentation details, before it was applied to -mm? Those folks 
> > > > hang around the tracing tree usually so they are easy to find. :)
> > > > 
> > > 
> > > This patch is ancient, predating most of the instrumentation stuff 
> > > by years. It was dropped from -mm a few months ago because of 
> > > changes in proc and this is a rebase because it came up as being 
> > > potentially useful pinning down memory leaks when they occur.
> > > 
> > > I'm not sure when exactly it was introduced to -mm, but I see 
> > > references going back as far as 2.6.12-rc1 so it's no surprise 
> > > this is now extremly odd looking. However, there is no plan to 
> > > merge this to mainline making the effort of redoing it from 
> > > scratch a questionable expenditure of time.
> > 
> > Hm, why not merge the concept upstream?
> > 
> 
> I suspect at the time the patch was put together, it was not 
> merged upstream because it severely bloated struct page and would 
> be something that was never enabled by default in distros. Anyone 
> wanted it for debugging could easily apply the patch. It's a 
> decision that simply has never been revisited as it's not used 
> that often - it's just seriously useful when you do need it.
> 
> I'm guessing though, I wasn't active in kernel development at the 
> time and I haven't dug through the archives to see the history.

it sounds plausible. The reason i replied is that i saw this patch 
pop up freshly with a lot of MM signoffs. There's been a few weird 
instrumentation patches from -mm to mainline lately so i'm more 
cautious ...

A [not-for-upstream] tag would be useful for such cases.

> > I'm sure the kmemtrace maintainers (Eduardo and Pekka) would be 
> > interested in this too: they are already tracking slab 
> > allocation events in a very finegrained way, extending that 
> > scheme to the page allocator seems genuinely useful to me.
> 
> In light of kmemtrace's success, it does make sense to revisit if 
> someone has the cycles to spare. Again bear in mind that this 
> owner patch was in -mm long before kmemtrace came along so it was 
> a good idea at the time whose implementation has not quite stood 
> the test of time.

it popped up new. And i commented on it a few months ago.

> > And that way the rather ugly bloating of struct page by this 
> > patch would be solved too: it's not needed and there's no need 
> > to actually save the callchain permanently, it's usually enough 
> > to _trace_ it - user-space can then save it into a permanent map 
> > if it's interested.
> 
> It's picky but you lose details from boot-time allocations that 
> way but that's a relatively small detail. If it's leaks you really 
> care about though, then tracing is probably sufficient.

You can build a full map from scratch as well via:

    echo 3 > /proc/sys/vm/drop_caches

Anything that is not flushed out by that is probably not that 
interesting from a tracking perspective.

> [...] Maybe this thread will prod someone familiar with tracing 
> with some time to spare to take a look at what that provides 
> reimplement in a sensible manner as you suggest?

Yeah - i've added tracing Cc:s.

There's a proposed set of MM tracepoints by Jason Baron. Not sure 
how far it got in terms of getting Ack's and Reviewed-by's from MM 
folks though.

And this info could be added to that, and it would sure be nice to 
hook it up to kmemtrace primarily, which does a lot of similar 
looking work in the slab space. (but Eduard and Pekka will know how 
feasible/interesting this is to them.)

	Ingo
