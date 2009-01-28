Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZA1XVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZA1XVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZA1XV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:21:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZA1XVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:21:25 -0500
Date: Wed, 28 Jan 2009 15:20:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, peterz@infradead.org, arjan@infradead.org,
       rusty@rustcorp.com.au, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
Message-Id: <20090128152048.40ac3526.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901281741310.7408@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	<20090128131202.21757da6.akpm@linux-foundation.org>
	<20090128131327.417b01e1.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0901281621450.25359@gandalf.stny.rr.com>
	<20090128140725.782f5cc1.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0901281741310.7408@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 17:47:55 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 28 Jan 2009, Andrew Morton wrote:
> > 
> > So if we're going to use per-cpu data then we'd need to protect it with
> > a lock.  We could (should?) have a separate lock for each destination
> > CPU.
> > 
> > We could make smp_call_function_single() block until the IPI handler
> > has consumed the call_single_data, in which case we might as well put
> > the call_single_data, onto the caller's stack, as you've done.
> > 
> > Or we could take the per-cpu spinlock in smp_call_function_single(),
> > and release it in the IPI handler, after the call_single_data has been
> > consumed, which is a bit more efficient.  But I have a suspicion that
> > this is AB/BA deadlockable.
> > 
> > <tries to think of any scenarios>
> > 
> > <fails>
> > 
> > So we have
> > 
> > smp_call_function_single(int cpu)
> > {
> > 	spin_lock(per_cpu(cpu, locks));
> > 	per_cpu(cpu, call_single_data) = <stuff>
> > 	send_ipi(cpu);
> > 	return;
> > }
> > 
> > ipi_handler(...)
> > {
> > 	int cpu = smp_processor_id();
> > 	call_single_data csd = per_cpu(cpu, call_single_data);
> > 
> > 	spin_unlock(per_cpu(cpu, locks));
> > 	use(csd);
> > }
> > 
> > does that work?
> 
> I don't think so. With ticket spinlocks and such, that just looks like it 
> is destine to crash. Also, spinlocks disable preemption, and we would need 
> to enable it again otherwise we have a dangling preempt_disable.

Well that sucks.

I think the model of taking a lock, passing the data across to another
thread of control and having that thread of control release the lock
once the data has been consumed is a good one.  It's faster and in this
case it means that we can now (maybe) perform (wait=0) IPI calls with local
interrupts disabled, which wasn't the case before.

It's a shame that irrelevant-other-stuff prevents us from implementing
such a thing.  Of course, we can still do it, via some ad-hoc locking
thing using raw_spin_lock/atomic_t's/bitops/cpu_relax/etc.

> > 
> > Dunno if it's any better than what you have now.  It does however
> > remove the unpleasant "try kmalloc and if that failed, try something
> > else" mess.
> 
> We could have a percpu for single data and still use the lock. Keep the 
> method of the IPI handler signaling to the caller that they copied it to 
> their stack. Then the caller could release the lock.

Yeah, spose so.  That separates the signalling from the locking, rather
than using the lock as the signal.  But it's an inferior solution
because it a) makes the caller hang around until the consumer has
executed and it b) requires that callers still have local interrupts
enabled.

Now, maybe we can never implement b) at all - maybe we'll still require
that callers have local interrupts enabled.  Because there might be
arch_send_call_function_single_ipi() which has to loop around until it
sees that the target CPU has accepted the interrupt, dunno.

> We can keep this only for the non wait case. Most users set the wait bit, 
> so it will only slow down the non waiters.

It would be good to avoid separate sync and async code paths as much
as possible, of course.

> Of course this will only work with the single cpu function callers. I 
> think the all cpu function callers still need to alloc.

I haven't really thought about the smp_call_function_many()
common case.  
