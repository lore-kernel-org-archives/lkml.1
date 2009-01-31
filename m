Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZAaIq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZAaIq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 03:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZAaIqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 03:46:19 -0500
Received: from brick.kernel.dk ([93.163.65.50]:27201 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZAaIqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 03:46:19 -0500
Date: Sat, 31 Jan 2009 09:44:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -v3] use per cpu data for single cpu ipi calls
Message-ID: <20090131084426.GU30821@kernel.dk>
References: <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain> <1233253380.4495.123.camel@laptop> <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain> <1233254680.4495.126.camel@laptop> <20090130112310.GI30821@kernel.dk> <1233318733.4495.174.camel@laptop> <alpine.LFD.2.00.0901300800350.3150@localhost.localdomain> <1233332170.4495.200.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233332170.4495.200.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30 2009, Peter Zijlstra wrote:
> > If another CPU hasn't even received its IPI before the same CPU sends the 
> > next one, I'm not sure we _want_ to send one, in fact.
> 
> I think the intent was to re-route IO-completion interrupts to whatever
> cpu/node issued the IO with the idea that that cpu/node has the page
> hottest etc. and transferring the completion is cheaper than bouncing
> the page.

Correct

> Since that would be relaying hardware interrupts, there's nothing much
> you can do about the rate, or something, that's up to the firmware on
> $$$ scsi thing.
> 
> But Jens already said that that path was using the __ variant and
> providing its own csds, the kmalloc isn't needed there, so it might all
> be moot.

In fact the block layer already does attempt to do what Linus describes.
We queue the events for the target cpu, and then do:

        local_irq_save(flags);
        list = &__get_cpu_var(blk_cpu_done);
        list_add_tail(&rq->csd.list, list);

        if (list->next == &rq->csd.list)
                raise_softirq_irqoff(BLOCK_SOFTIRQ);

thus only triggering a new softirq interrupt, if the preceeding one
hasn't run already. So this is done for the block layer
trigger_softirq() part, but could be provided by the lower layer as well
instead.

> > But that's a secondary issue, and isn't a correctness thing, just a "do we 
> > really need three different allocations?" musing..
> 
> Nick, Jens, I was under the presumption that the kmalloc was needed for
> something other than failing to deadlock, happen to remember what?

As far as I remember, it was just the way to allocate memory for the
non-wait case. The per-cpu single csd will limit you to a single pending
entry on the cpu queue, you could have more (like the block layer will
do) and get a nice batching effect for ipi busy workloads instead of a
1:1 mapping between work and ipi's fired.

-- 
Jens Axboe

