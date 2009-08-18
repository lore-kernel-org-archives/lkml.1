Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZHRXgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZHRXgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZHRXgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:36:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZHRXgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:36:35 -0400
Date: Tue, 18 Aug 2009 19:36:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       peterz@infradead.org
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for
 UP
In-Reply-To: <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org> <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Aug 2009, Linus Torvalds wrote:

> 
> 
> On Tue, 18 Aug 2009, Kumar Gala wrote:
> >
> > For some reason __raw_spin_is_locked() has been returning false for the
> > uni-processor, non-CONFIG_DEBUG_SPINLOCK.  The UP + CONFIG_DEBUG_SPINLOCK
> > handles this correctly.
> > 
> > Found this by enabling CONFIG_DEBUG_VM on PPC and hitting always hitting
> > a BUG_ON that was testing to make sure the pte_lock was held.
> > 
> > Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> > ---
> > 
> > Linus, a fix for 2.6.31
> 
> This really isn't all that clear.
> 
> The thing is, some people may assert that a lock is held, but others could 
> easily be looping until it's not held using something like
> 
> 	while (spin_is_locked(lock))
> 		cpu_relax();

Wouldn't something like that be really racey? And anyone doing such a 
thing had better have that code within an #ifdef CONFIG_SMP.

> 
> so it's hard to tell whether it should return true or false in the case 
> where spin-locking simply doesn't exist.

Actually, I did have a case where I would use it and would expect a return 
of 0. That was in the experimental printk code to see if it was safe to 
wakeup the klogd. I once had a check of the current cpu runqueue lock is 
locked, and if it was, not to wake up klogd. I'm sure there's other cases 
like this as well.

Thinking about it, UP probably should have spin_is_locked always return 
false, but if you want to make sure you are not in a critical section 
with the lock not held, then use assert_spin_locked, which on UP should be 
a nop.

-- Steve

