Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZHRXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZHRXxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZHRXxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:53:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbZHRXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:53:17 -0400
Date: Tue, 18 Aug 2009 16:52:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       peterz@infradead.org
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for
 UP
In-Reply-To: <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org> <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain> <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Aug 2009, Steven Rostedt wrote:
>
> > The thing is, some people may assert that a lock is held, but others could 
> > easily be looping until it's not held using something like
> > 
> > 	while (spin_is_locked(lock))
> > 		cpu_relax();
> 
> Wouldn't something like that be really racey? And anyone doing such a 
> thing had better have that code within an #ifdef CONFIG_SMP.

Sure, it's hopefully inside a #ifdef CONFIG_SMP.

And no, it's not necessarily racy. Sure, it's race in itself if that's all 
you are doing, but I could imagine writing that kind of code if I knew 
some lock was likely held, and I wanted to avoid doing a "try_lock()" 
until it got released.

The point is, "spin_is_locked()" is simply not a well-defined operation in 
this case. It could go either way.

And for the original case, we actually have a function for that:

	assert_spin_locked(x)

which goes away on UP. Exactly because

	BUG_ON(!spin_is_locked(x))

is not a good thing to do!

> > so it's hard to tell whether it should return true or false in the case 
> > where spin-locking simply doesn't exist.
> 
> Actually, I did have a case where I would use it and would expect a return 
> of 0. That was in the experimental printk code to see if it was safe to 
> wakeup the klogd. I once had a check of the current cpu runqueue lock is 
> locked, and if it was, not to wake up klogd. I'm sure there's other cases 
> like this as well.

Yeah, "spin_is_locked()" can be useful for those kinds of things. A 
heuristic for whether we should do something based on whether some other 
CPU holds it (or we migth have recursion).

Exactly like it can be useful for doing the BUG_ON thing. But in both 
cases it's a bit iffy.

> Thinking about it, UP probably should have spin_is_locked always return 
> false, but if you want to make sure you are not in a critical section 
> with the lock not held, then use assert_spin_locked, which on UP should be 
> a nop.

That's what we do. That said, I also think we should generally try to 
avoid the kind of code that depends on spin_is_locked always returning 
false, for the same reason we should try to avoid any code that depends on 
it always returning true. 

		Linus
