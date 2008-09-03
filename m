Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYICG42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYICG42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYICG4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:56:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53920 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYICG4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:56:19 -0400
Date: Wed, 3 Sep 2008 08:59:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       torvalds@osdl.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-ID: <20080903065924.GO18288@one.firstfloor.org>
References: <20080902349.573187695@firstfloor.org> <1220366717.8609.65.camel@twins> <20080902150031.GN18288@one.firstfloor.org> <200809031602.37658.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809031602.37658.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 04:02:37PM +1000, Nick Piggin wrote:
> > > Neither remote cpu will handle the IPI due to irqs being disabled, so
> > > we'll wait at-infinitum for completion.
> >
> > First smp_send_stop does not wait (or at least not pass the
> > wait flag, it will still wait for the first ack like everyone else)
> 
> It won't wait, but it may have to wait for an ack as you say (but now
> this is a very rare case when kmalloc fails rather than always having
> to wait for so long).

kmalloc is actually not safe in panic. panic could happen inside
kmalloc(). Hmm I missed it does that unconditionally.
If yes the code is more broken than I thought.

> So yes, it does wait in some cases. If interrupts are disabled then it
> will stop processing IPIs which are sent to it from another CPU, which
> might be also calling smp_send_stop and which itself is not processing
> IPIs from the CPU. This is the deadlock.
> 
> We could serialise smp_send_stop (using a simple xchg, in case we panic
> in lockdep), and then it is possible to get away without deadlocking.

Yes we need to get rid of the kmalloc too. Either use a static data 
structure or a special path :/

> > I don't claim to understand the new kernel/smp.c code (it seems to me quite
> > overdesigned and complicated and I admit I got lost in it somewhere),
> > but I think your scenario would rely on a global lock and presumably there
> > is none in the new code?
> 
> Overdesigned? Well the old code was horribly slow and synchronized, and
> made it useless for doing anything except things like smp_send_stop so
> I would say it was under designed ;)

It just seems quite complicated. Do you really need four layers 
of function calls just to ask the low level code to trigger
an IPI? And are there really benchmarks that show the 
queueing does actually improve something significantly? Ok I can see the point
of having distributed locks (did that on my own for the x86-64
TLB flusher), but that really doesn't need that much code !
And the queueing has bad side effects like breaking panic
and adding hard to test fallback paths.

Perhaps I'm old fashioned, but somehow my feeling is noone tries
to keep code simple anymore :/


> > > > Besides do you prefer to not allow panic from interrupts/machine
> > > > checks etc. anymore?
> > >
> > > However did I imply that, I just said your fix looked iffy.
> >
> > Well it would be the only alternative. Or have a timeout (I had
> > such a hack a long time ago) but that has also other issues.
> >
> > In fact for smp_send_stop() it would be far better to just use an NMI,
> > but we unfortunately have a few BIOS that do not support NMI properly.
> >
> > I think for 2.6.27 at least this is the best fix. At least keeping
> > panic that broken is no option I would say.
> 
> It is reasonable I think, but I don't like testing symbolic constants
> with inequalities like in your patch 2/2. Can you just make it
> system_state != SYSTEM_PANIC ?

Well I like it.

> 
> Also... is it really a regression? The old code definitely had deadlock
> warnings too, but maybe they were made more complete in the new code?

Yes 2.6.26 did panic without these endless warnings.

-Andi
