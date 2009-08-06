Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZHFQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZHFQiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbZHFQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:38:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZHFQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:38:13 -0400
Subject: Re: [RFC][PATCH] fixup pi_state in futex_requeue on lock steal
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <4A7A1D48.7040309@us.ibm.com>
References: <4A7A1D48.7040309@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Aug 2009 18:37:40 +0200
Message-Id: <1249576660.32113.585.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-05 at 17:01 -0700, Darren Hart wrote:
> NOT FOR INCLUSION
> 
> Fixup the uval and pi_state owner in futex_requeue(requeue_pi=1) in the event
> of a lock steal or owner died.  I had hoped to leave it up to the new owner to
> fix up the userspace value since we can't really handle a fault here
> gracefully.  This should be safe as the lock is contended and should force all
> userspace attempts to lock or unlock into the kernel where they'll block on the
> hb lock.  However, when I don't update the uaddr, I hit the WARN_ON(pid !=
> pi_state->owner->pid) as expected, and the userspace testcase deadlocks.
> 
> I need to try and better understand what's happening to hang userspace.  In the
> meantime I thought I'd share what I'm working with atm.  This is a complete HACK
> and is ugly, non-modular, etc etc.  However, it currently works.  It would explode
> in a most impressive fashion should we happen to fault.  So the remaining questions
> are:
> 
> o Why does userspace deadlock if we leave the uval updating to the new owner
>   waking up in futex_wait_requeue_pi()?
> 
> o If we have to handle a fault in futex_requeue(), how can we best cleanup the
>   proxy lock acquisition and get things back into a sane state.  We faulted, so
>   determinism is out the window anyway, we just need to recover gracefully.


Do you have a trace of the thing going down?

Tglx and me usually use sched_switch and a few trace_printk()s sprinkled
around, the typical one would be in sys_futex, printing the futex cmd
and arg.

OK, so run me through this one more time.

A condvar has two futexes, an inner and an outer. The inner futex is
always locked and the waiting threads are stacked on that.

Then on signal/broadcast, we lock the outer lock and requeue all the
blocked tasks from the inner to the outer, then we release the outer
lock and let them rip.

Since we're seeing lock steals, I'm thinking the outer lock isn't taken
when we're doing the requeue?

Anyway, during the requeue we lock-steal because the owner isn't running
yet and we iterate a higher prio task in the requeue loop?

This leaves the outer lock's futex field messed up because it points to
the wrong TID.

After we finish the requeue loop, we unlock the HBs.


So far so good?


Now, normally the waking thread will find itself owner and will check
the futex variable and fix her up -- while holding the HB lock.

However, in case the outer lock gets contended again, we can get
interrupted between requeue and wakeup/fixup and observe this messed up
futex value, which is causing this WARN to trigger.


So where do we deadlock, after this all goes down? Do we perhaps lookup
the wrong pi_state using that wrong TID?



Since its only the outer futex's value that matters, right? Can't we pin
that using get_user_pages() before we take the HB lock and go into the
requeue loop? That way we're sure to be able to change it without
faulting.


