Return-Path: <linux-kernel-owner+w=401wt.eu-S1762141AbZAHUNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbZAHUNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:13:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZAHUMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:12:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbZAHUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:12:49 -0500
Date: Thu, 8 Jan 2009 15:12:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901081506460.24688@gandalf.stny.rr.com>
References: <1231441350.14304.48.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The problem? Setting "lock->count" to 0. That will mean that the next 
> "mutex_unlock()" will not necessarily enter the slowpath at all, and won't 
> necessarily wake things up like it should.
> 
> Normally we set lock->count to 0 after getting the lock, and only _inside_ 
> the spinlock, and then we check the waiters after that. The comment says 
> it all:
> 
>         /* set it to 0 if there are no waiters left: */
>         if (likely(list_empty(&lock->wait_list)))
>                 atomic_set(&lock->count, 0);
> 
> and the spinning case violates that rule. 

The difference is that here we have it set to -1 (in the non patched 
code), and we have to decide if we should change that to 0. To change from 
-1 to 0 needs the protection of the spin locks.

In the loop, we only change from 1 to 0 which is the same as the fast 
path, and should not cause any problems.


> 
> Now, the spinning case only sets it to 0 if we saw it set to 1, so I think 
> the argument can go something like:

Yep.

> 
>  - if it was 1, and we _have_ seen contention, then we know that at 
>    least _one_ person that set it to 1 must have gone through the unlock 
>    slowpath (ie it wasn't just a normal "locked increment".

Correct.

> 
>  - So even if _we_ (in the spinning part of stealing that lock) didn't 
>    wake the waiter up, the slowpath wakeup case (that did _not_ wake 
>    us up, since we were spinning and hadn't added ourselves to the wait 
>    list) must have done so.

Agreed.

> 
> So maybe it's all really really safe, and we're still guaranteed to have 
> as many wakeups as we had go-to-sleeps. But I have to admit that my brain 
> hurts a bit from worrying about this.

I do not think that the issue with the previous bug that Chris showed had 
anything to do with the actual sleepers. The slow path never changes the 
lock to '1', so it should not affect the spinners. We can think of the 
spinners as not having true contention with the lock, and are just like a:

	while (cond) {
		if (mutex_trylock(lock))
			goto got_the_lock;
	}

> 
> Sleeping mutexes are not ever simple. 

Now you see why in -rt we did all this in the slow path ;-)

-- Steve

