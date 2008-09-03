Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYICJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYICJiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYICJh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:37:56 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:21456 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750877AbYICJhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:37:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NKWV8d6OWWbbII/aXonwMWjgpHwtE/jzGACwj4EA+hOIB8gnlyQ8kevinhwcZUY8PemHowgm9VcD0MsnQ9TESryVaouCZUg7lJpqCA+wiuSQjJKrKt4qs5DqM60NClK8bN3Qq0qThiMV9rBOyIrvjUEt+HhA5CJOD5Zo1+qSHr8=  ;
X-YMail-OSG: IYdVq8QVM1mp.y5WoXvugxVaFsGimP00aPCl48AkxIPkA9xDtaK7yRD2SR8Tt5Ts8uL.Gokn.Pfzn7IxWHVEaZi4YtWaYuNtsYkJDtLiHeS7nAAJeZaur.t.h81sjNNAtw4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Date: Wed, 3 Sep 2008 19:37:46 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080902349.573187695@firstfloor.org> <200809031602.37658.nickpiggin@yahoo.com.au> <20080903065924.GO18288@one.firstfloor.org>
In-Reply-To: <20080903065924.GO18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031937.46328.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 16:59, Andi Kleen wrote:
> On Wed, Sep 03, 2008 at 04:02:37PM +1000, Nick Piggin wrote:
> > > > Neither remote cpu will handle the IPI due to irqs being disabled, so
> > > > we'll wait at-infinitum for completion.
> > >
> > > First smp_send_stop does not wait (or at least not pass the
> > > wait flag, it will still wait for the first ack like everyone else)
> >
> > It won't wait, but it may have to wait for an ack as you say (but now
> > this is a very rare case when kmalloc fails rather than always having
> > to wait for so long).
>
> kmalloc is actually not safe in panic. panic could happen inside
> kmalloc(). Hmm I missed it does that unconditionally.
> If yes the code is more broken than I thought.

Hmm... that does pull in significantly more code yes...

It should be fixed. I guess a quickfix is to add a new call in
kernel/smp.c for use by panic code.

smp_send_stop is not a very precise heuristic when used at panic time,
though, so I prefer not to slow down anything just for that case.


> > > I don't claim to understand the new kernel/smp.c code (it seems to me
> > > quite overdesigned and complicated and I admit I got lost in it
> > > somewhere), but I think your scenario would rely on a global lock and
> > > presumably there is none in the new code?
> >
> > Overdesigned? Well the old code was horribly slow and synchronized, and
> > made it useless for doing anything except things like smp_send_stop so
> > I would say it was under designed ;)
>
> It just seems quite complicated. Do you really need four layers
> of function calls just to ask the low level code to trigger
> an IPI?

Oh. I thought the actual function call structure itself should be the
nice cleanup part that everyone would like...

- call_function->call_function_mask pre existing code
New:
- arch IPI function allows most logic to be implemented generically
- new API that allows deadlock-free operation with irqs disabled in
  some cases.

Queueing for smp_call_function_mask I understand if it is less liked ;)


> And are there really benchmarks that show the 
> queueing does actually improve something significantly?

For the call_function_mask case, I did see a benefit of queueing when
testing vmap scalability on a bigish system, yes. I had since done
vunmap batching in the vmap layer so the IPI costs don't really show
up at all there anymore. But the code was already implemented, and I
still don't want a smp_call_function from CPU0 to CPUs 1 and 2 to hold
up an smp_call_function from CPU4 to CPUs 5 and 6 for example.

For call_function_single, queueing could really help with high interrupt
loads like the block completion migration that Jens has been looking at.
In that case, queueing will act like interrupt mitigation when the target
CPU becomes saturated so it will help keep performance from degrading,
and it also allows multiple source CPUs to target a single destination
without losing too much scalability.

Also there was some straight-line benefit of queueing due to the source
CPU not having to wait for an ack from the destination before continuing.
Basically that would previously put a hard upper limit of remote function
call to the interrupt latency.

Benchmarks for "real" things unfortunately not easy to come by yet,
simply because it was so crap before that it was unusable for anything
remotely performance oriented. After the rewrite, I hope to see some
more interesting uses popping up slowly.


> Ok I can see the 
> point of having distributed locks (did that on my own for the x86-64
> TLB flusher), but that really doesn't need that much code !
> And the queueing has bad side effects like breaking panic
> and adding hard to test fallback paths.
>
> Perhaps I'm old fashioned, but somehow my feeling is noone tries
> to keep code simple anymore :/

It was certianly tried. It's not a simple problem to do this with any
reasonable scalability, however.


> > > I think for 2.6.27 at least this is the best fix. At least keeping
> > > panic that broken is no option I would say.
> >
> > It is reasonable I think, but I don't like testing symbolic constants
> > with inequalities like in your patch 2/2. Can you just make it
> > system_state != SYSTEM_PANIC ?
>
> Well I like it.

How is it better than system_state != SYSTEM_PANIC? It breaks if
SYSTEM_PANIC gets something in front of it, and even when it is
correct it makes you double check the definition of SYSTEM_PANIC
to see what it does (is there any state above SYSTEM_PANIC?)


> > Also... is it really a regression? The old code definitely had deadlock
> > warnings too, but maybe they were made more complete in the new code?
>
> Yes 2.6.26 did panic without these endless warnings.

OK that should be fixed I agree.
