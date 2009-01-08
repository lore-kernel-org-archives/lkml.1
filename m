Return-Path: <linux-kernel-owner+w=401wt.eu-S1762442AbZAHTzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442AbZAHTzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZAHTza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:55:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226AbZAHTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:55:28 -0500
Date: Thu, 8 Jan 2009 11:54:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <1231441350.14304.48.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, Chris Mason wrote:
> 
> The patch below isn't quite what Linus suggested, but it is working here
> at least.  In every test I've tried so far, this is faster than the ugly
> btrfs spin.

Sadly, I don't think it's really working.

I was pretty sure that adding the unlocked loop should provably not change 
the mutex lock semantics. Why? Because it's just basically equivalent to 
just doing the mutex_trylock() without really changing anything really 
fundamental in the mutex logic.

And that argument is sadly totally bogus. 

The thing is, we used to have this guarantee that any contention would 
always go into the slowpath, and then in the slow-path we serialize using 
the spinlock. 

So I think the bug is still there, we just hid it better by breaking out 
of the loop with that "if (need_resched())" always eventually triggering. 
And it would be ok if it really is guaranteed to _eventually_ trigger, and 
I guess with timeslices it eventually always will, but I suspect we could 
have some serious latency spikes.

The problem? Setting "lock->count" to 0. That will mean that the next 
"mutex_unlock()" will not necessarily enter the slowpath at all, and won't 
necessarily wake things up like it should.

Normally we set lock->count to 0 after getting the lock, and only _inside_ 
the spinlock, and then we check the waiters after that. The comment says 
it all:

        /* set it to 0 if there are no waiters left: */
        if (likely(list_empty(&lock->wait_list)))
                atomic_set(&lock->count, 0);

and the spinning case violates that rule. 

Now, the spinning case only sets it to 0 if we saw it set to 1, so I think 
the argument can go something like:

 - if it was 1, and we _have_ seen contention, then we know that at 
   least _one_ person that set it to 1 must have gone through the unlock 
   slowpath (ie it wasn't just a normal "locked increment".

 - So even if _we_ (in the spinning part of stealing that lock) didn't 
   wake the waiter up, the slowpath wakeup case (that did _not_ wake 
   us up, since we were spinning and hadn't added ourselves to the wait 
   list) must have done so.

So maybe it's all really really safe, and we're still guaranteed to have 
as many wakeups as we had go-to-sleeps. But I have to admit that my brain 
hurts a bit from worrying about this.

Sleeping mutexes are not ever simple. 

			Linus
