Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYICJp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYICJp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYICJpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:45:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56359 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYICJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:45:11 -0400
Date: Wed, 3 Sep 2008 11:48:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       torvalds@osdl.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-ID: <20080903094815.GQ18288@one.firstfloor.org>
References: <20080902349.573187695@firstfloor.org> <200809031602.37658.nickpiggin@yahoo.com.au> <20080903065924.GO18288@one.firstfloor.org> <200809031937.46328.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809031937.46328.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm... that does pull in significantly more code yes...
> 
> It should be fixed. I guess a quickfix is to add a new call in
> kernel/smp.c for use by panic code.

Or just a new vector.  I'll take a look later.
> 
> > an IPI?
> 
> Oh. I thought the actual function call structure itself should be the
> nice cleanup part that everyone would like...

I fail to see how much more complex code is a cleanup to be honest.

> > And are there really benchmarks that show the 
> > queueing does actually improve something significantly?
> 
> For the call_function_mask case, I did see a benefit of queueing when
> testing vmap scalability on a bigish system, yes. I had since done

Does that improve anything real-world?

> For call_function_single, queueing could really help with high interrupt
> loads like the block completion migration that Jens has been looking at.

But does it or not?

> In that case, queueing will act like interrupt mitigation when the target
> CPU becomes saturated so it will help keep performance from degrading,
> and it also allows multiple source CPUs to target a single destination
> without losing too much scalability.
> 
> Also there was some straight-line benefit of queueing due to the source
> CPU not having to wait for an ack from the destination before continuing.
> Basically that would previously put a hard upper limit of remote function
> call to the interrupt latency.
> 
> Benchmarks for "real" things unfortunately not easy to come by yet,
> simply because it was so crap before that it was unusable for anything
> remotely performance oriented. After the rewrite, I hope to see some

At least the "industry standard benchmark" Intel spends a lot of time
one used IPIs and iirc didn't run into too big issues. It was far
less a problem than the endless sl[au]b regressions at least.


> It was certianly tried. It's not a simple problem to do this with any
> reasonable scalability, however.

Well just not having a big lock is a big step forward. But that 
doesn't need that much code, it's ~10-20 lines of new code
as you can see in the scalable tlb flush.

The queueing seems to add all the complexity and so far I haven't
seen much evidence that the queueing actually helps enough
to pay for its costs in complexity and maintenance overhead
(and bugginess as the panic case and the earlier crash issue shows) 

> > > It is reasonable I think, but I don't like testing symbolic constants
> > > with inequalities like in your patch 2/2. Can you just make it
> > > system_state != SYSTEM_PANIC ?
> >
> > Well I like it.
> 
> How is it better than system_state != SYSTEM_PANIC? It breaks if
> SYSTEM_PANIC gets something in front of it, and even when it is

No it will not break in that case.

> correct it makes you double check the definition of SYSTEM_PANIC
> to see what it does (is there any state above SYSTEM_PANIC?)

The system states are already ordered and it would make
a lot of sense to keep it that way. 

Anyways the code will go anyways I guess because we have 
established that it's not enough to fix panic.

-Andi

-- 
ak@linux.intel.com
