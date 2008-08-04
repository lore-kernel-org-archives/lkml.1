Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbYHDUhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbYHDUhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYHDUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:37:22 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:60289 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbYHDUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:37:21 -0400
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Dave Jones <davej@redhat.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       arjan <arjan@infradead.org>
In-Reply-To: <20080804201514.GB12464@duo.random>
References: <aday73cua99.fsf@cisco.com> <1217860332.3589.11.camel@twins>
	 <20080804145318.GA17867@redhat.com> <1217861763.3589.13.camel@twins>
	 <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins>
	 <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random>
	 <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
	 <20080804201514.GB12464@duo.random>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 22:37:22 +0200
Message-Id: <1217882242.3589.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 22:15 +0200, Andrea Arcangeli wrote:
> On Mon, Aug 04, 2008 at 08:48:59PM +0200, Peter Zijlstra wrote:
> > On Mon, 2008-08-04 at 19:57 +0200, Andrea Arcangeli wrote:
> > > From: Andrea Arcangeli <andrea@qumranet.com>
> > > 
> > > Lockdep can't recognize if spinlocks are at a different address. So
> > > using trylock in a loop is one way to avoid lockdep to generate false
> > > positives. After lockdep will be fixed this change can and should be
> > > reverted.
> > > 
> > > Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
> > 
> > NAK, come-on, you didn't even bother to look at the available
> > annotations..
> 
> Let's say when I hear prove-locking my instinct tells me to walk away
> as fast as I can. I'll try to explain why I prefer the trylock loop
> (which btw is the only one that will hide the lockdep false positives
> here and I welcome you to fix it in another way, well another way that
> comes to mind is to call __raw_spin_lock which I didn't do because I
> don't like those lowlevel details in common code).
> 
> So about prove-locking:
> 
> 1) in production is disabled so when I get bugreports I've to grab
>    locking deadlock information as usual (sysrq+t/p or preferably
>    lkcd/kdump)
> 
> 2) while coding it's useless as well because I don't need this thing
>    to debug and fix any deadlocks
> 
> 3) this only finds bugs after the system is hung and I can fix it by
>    other means then

You're so wrong it not even funny. It reports about deadlocks before
they happen. All it needs is to observe a lock order violation and it
will report it. In order for the dead-lock to happen, you need to
actually hit the violation concurrently with the normal order. 

IOW, lockdep can even spot deadlocks on a non-preempt single cpu setup
where they can never actually happen.

Furthermore, it does more than the simple lock deadlocks, it also takes
IRQ state into account. So it can tell about hard or soft irq recursion
deadlocks.

Having lockdep on while developing saves a lot of trouble - in fact it
_has_ caught many real bugs before they could be introduced to mainline,
ask Arjan who has supervised driver development.

Not only that, it caught plenty of real bugs in mainline as well as -rt.
These days it appears to not catch many because the tree is in such good
shape, but that is fully thanks to lockdep.

That is not to say it's perferct - lockdep certainly does have it
limitations. But your portrail is very in-accurate.


