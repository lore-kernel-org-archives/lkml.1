Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbYHDVKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbYHDVKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbYHDVKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:10:03 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:53244
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921AbYHDVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:10:00 -0400
Date: Mon, 4 Aug 2008 23:09:54 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080804210954.GC12464@duo.random>
References: <20080804145318.GA17867@redhat.com> <1217861763.3589.13.camel@twins> <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins> <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217882242.3589.90.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 10:37:22PM +0200, Peter Zijlstra wrote:
> You're so wrong it not even funny. It reports about deadlocks before
> they happen. All it needs is to observe a lock order violation and it

Now tell me how it helps to report them... It tells me the system has
crashed and where, it's not like I couldn't figure it out by myself
but just noticing nothing works and all cpus are spinning in some
spinlock slow path and pressing sysrq+t/p.

> will report it. In order for the dead-lock to happen, you need to
> actually hit the violation concurrently with the normal order. 

The point is that this is a runtime evaluation of lock orders, if
runtime isn't the lucky one that reproduces the deadlock, it'll find
nothing at all.

> IOW, lockdep can even spot deadlocks on a non-preempt single cpu setup
> where they can never actually happen.

Ask the preempt-RT folks, advertising infinite-cpu-smp on UP. No need
of lockdep to reproduce deadlocks that couldn't be found without it in
UP. Infact lockdep only avoids to optimize away the spinlock, you
don't need preempt-RT to reproduce at zero-runtime-cost in a equally
easily debuggable way whatever the lockdep can reproduced on a UP
compile. You've only to run a SMP kernel on UP, big deal that lockdep
is solving to prevent you to run a smp kernel in up...

> Furthermore, it does more than the simple lock deadlocks, it also takes
> IRQ state into account. So it can tell about hard or soft irq recursion
> deadlocks.

Ok this gets just a bit more interesting but my understanding is that
again this only "reports" stuff that crashes hard and is trivially
debuggable by other means.

> Having lockdep on while developing saves a lot of trouble - in fact it
> _has_ caught many real bugs before they could be introduced to mainline,
> ask Arjan who has supervised driver development.

Are you saying those bugs weren't trivially debuggable anyway by
kernel-hackers with a simple sysrq+p/t or kgdb stack trace?

If yes, I can only imagine that nobody takes care of setting up
debugging options that actually are _zero_ runtime cost and don't
pollute the kernel common code.

> Not only that, it caught plenty of real bugs in mainline as well as -rt.
> These days it appears to not catch many because the tree is in such good
> shape, but that is fully thanks to lockdep.
> 
> That is not to say it's perferct - lockdep certainly does have it
> limitations. But your portrail is very in-accurate.

I've an hard time to believe you, the only thing I can agree is that
if you don't want to run smp kernel on UP (or even better preempt-RT
on UP) you can run lockdep to find recursion.

smp-preempt-RT on UP is a real feature that is useful debugging,
because it makes bugs visible that weren't, lockdep is useless as far
as I can tell.
