Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbXJHOeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbXJHOeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXJHOd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:33:56 -0400
Received: from mx1.suse.de ([195.135.220.2]:50252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbXJHOd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:33:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [3/6] scheduler: Do devirtualization for sched_fair
Date: Mon, 8 Oct 2007 16:33:52 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710071059.126674000@suse.de> <200710081432.24776.ak@suse.de> <20071008123933.GA4582@elte.hu>
In-Reply-To: <20071008123933.GA4582@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081633.52467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 14:39:33 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > > hm, i'm not convinced about this one. It increases the code size a 
> > > bit
> > 
> > Tiny bit (<200 bytes) and the wait_for/sleep_on refactor patch in the 
> > series saves over 1K so I should have some room for code size 
> > increase. Overall it will be still considerable smaller.
> 
> there's no forced dependency between those two patches :-) 

I did that .text reduction only to make up for the text increase
from the other patch.  Your approach is asking for keeping them both
in a single patch next time, which surely cannot be what you really
want.

> So for now   
> i've applied the one that saves text and skipped the one that bloats it.

Ok, but I trust I have at least 0.5kb bloat budget for future changes now.

> 
> > > and it's a sched.c local hack. If then this should be done on a 
> > > generic infrastructure level - lots of other code (VFS, networking, 
> > > etc.) could benefit from it i suspect - and then should be 
> > > .configurable as well.
> > 
> > Unfortunately not -- for this to work (especially for inlining) 
> > requires to
> > #include files implementing the sub calls. Except for the scheduler 
> > #that
> > is pretty uncommon unfortunately. Also the situation regarding which 
> > call target is the common one is typically much less clear than with 
> > sched_fair / other scheduling classes.
> 
> some workloads would call sched_fair uncommon too. To me this seems like 
> a workaround for the lack of a particular hardware feature.

That's like saying all optimizations are a workaround for lack of hardware
with infinite IPC. Yes sure. But that doesn't seem like a very fruitful way to 
reason.

Besides even on CPUs with indirect branch predictor it is probably a win --
they tend to have much less memory to store indirect branch prediction (requires
an address) than for conditional jumps (requires just a bit) 

> > > Then the benefit might become measurable too.
> > 
> > It might have been measurable if the context switch was measurable at 
> > all. Unfortunately the lmbench3 lat_ctx test I tired fluctuated by 
> > itself over 50%. Ok I suppose it would be possible to instrument the 
> > kernel itself to measure cycles. Would that convince you?
> 
> dunno, it would depend on the numbers. But really, in most workloads we 
> do a lot more VFS indirect calls than scheduler indirect calls. So if 
> this was an issue i'd really suggest to attack it in a generic way.

The difference is that the VFS always did indirect calls; but the scheduler
didn't. And again it's much less clear for the VFS in general what
are the common paths. To do it fully generic would probably require
a JIT and reoptimization at run time -- i don't think that's a path
we should go.

But if generic solutions are not possible doing it for important
special cases where it happens to be possible is certainly a valid approach.

But given that I couldn't come up with clear numbers it's reasonable to not
apply it yet. I'll try to come up with some better way to measure this.

-Andi
