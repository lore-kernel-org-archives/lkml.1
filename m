Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYH0K40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYH0K40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYH0K4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:56:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:52848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYH0K4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:56:16 -0400
Date: Wed, 27 Aug 2008 12:56:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
Message-ID: <20080827105615.GB5818@wotan.suse.de>
References: <20080826173131.16413.17862.stgit@dev.haskins.net> <20080826173500.16413.40514.stgit@dev.haskins.net> <1219825295.6462.54.camel@twins> <20080827102646.GA5818@wotan.suse.de> <1219833668.6462.72.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219833668.6462.72.camel@twins>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:41:08PM +0200, Peter Zijlstra wrote:
> On Wed, 2008-08-27 at 12:26 +0200, Nick Piggin wrote:
> > On Wed, Aug 27, 2008 at 10:21:35AM +0200, Peter Zijlstra wrote:
> 
> > > I suppose one could then write it like:
> > > 
> > >   if (spin_is_contended(&this_rq->lock) || !spin_trylock(&busiest->lock)) {
> > >     spin_unlock(&this_rq->lock);
> > >     double_rq_lock(this_rq, busiest);
> > >   }
> > > 
> > > But, I'm not sure that's worth the effort at that point..
> > 
> > Yeah, that could work, but hmm it might cause 2 cache coherency transactions
> > anyway even in the fastpath, so it might even be slower than just unlocking
> > unconditionally and taking both locks :(
> 
> right,..
 

Although I guess we could prefetch it... But OTOH I don't know exactly
what Intel CPUs do with prefetch -- I don't think they have a prefetchw.

I would support your idea if it is faster, of course ;)


> > > Anyway - I think all this is utterly defeated on CONFIG_PREEMPT by the
> > > spin with IRQs enabled logic in kernel/spinlock.c.
> > > 
> > > Making this an -rt only patch...
> > 
> > Hmm, and also on x86 with ticket locks we don't spin with preempt or
> > interrupts enabled any more (although we still do of course on other
> > architectures)
> 
> Aah, we don't do CONFIG_GENERIC_LOCKBREAK anymore?
 
Right. My reasoning said that if our critical sections are short enough,
*and not subject to starvation*, then we should not really need it, and
at any rate often it is just luck if it helps because in other cases
we might be taking the lock under an irq save region so it wouldn't help
there...


> Does it make sense to make this _double_lock_balance() thing depend on
> that too?

Hmm, you might have a good point there. Greg?

BTW. I wonder about other architectures that are of interest to -rt? Like
mips or arm perhaps... Any plans to implement ticket locks on those, or
do they not tend to be used in SMP configurations on -rt yte?

