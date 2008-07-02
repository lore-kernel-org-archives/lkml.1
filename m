Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYGBLD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYGBLD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYGBLC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:02:58 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:24047 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYGBLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:02:55 -0400
To: benh@kernel.crashing.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Andi Kleen <andi@firstfloor.org>
References: <1214916335.20711.141.camel@pasglop>
	<486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
Date: Wed, 02 Jul 2008 13:02:50 +0200
In-Reply-To: <1214977447.21182.33.camel@pasglop> (Benjamin Herrenschmidt's message of "Wed, 02 Jul 2008 15:44:07 +1000")
Message-ID: <87zlp0sg4l.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jul 2008 10:55:29.0444 (UTC) FILETIME=[243BE640:01C8DC32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> how much of this would be obsoleted if we had irqthreads ?
>
> I'm not sure irqthreads is what I want...
>
> First, can they call handle_mm_fault ? (ie, I'm not sure precisely what
> kind of context those operate into).

Interrupt threads would be kernel threads and kernel threads
run with lazy (= random) mm and calling handle_mm_fault on that
wouldn't be very useful because you would affect a random mm.

Ok you could force them to run with a specific MM, but that would
cause first live time issues with the original MM (how could you
ever free it?) and also increase the interrupt handling latency
because the interrupt would be a nearly full blown VM context
switch then.

I also think interrupts threads are a bad idea in many cases because
their whole "advantage" over classical interrupts is that they can
block. Now blocking can be usually take a unbounded potentially long
time.

What do you do when there are more interrupts in that unbounded time?

Create more interrupt threads?  At some point you'll have hundreds
of threads doing nothing when you're unlucky.

Keep the interrupt event blocked? Then you'll not be handling
any events for a long time.

The usual Linux design that you design that interrupt to be fast
and run in a bounded time seems far more sane to me.

RT Linux has interrupt threads and they work around this problem
by assuming that the block events are only short (only 
what would be normally spinlocks).  If someone took a lock there
long enough then the bad things described above would happen.

Given if a spinlock is taken too long then a non RT kernel
is usually also not too happy so it's usually ensured that
that this is not the case.

But for your case these guarantees (only short lock regions 
block) would not be the case (handle_mm_fault can block for 
a long time in some cases) and then all hell could break lose.

So in short I don't think interrupts are a solution to your
problem or that they even solve any problem in a non RT kernel.

-Andi 

