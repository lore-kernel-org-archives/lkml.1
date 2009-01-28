Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZA1WsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZA1WsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZA1Wr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:47:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZA1Wr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:47:57 -0500
Date: Wed, 28 Jan 2009 17:47:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, peterz@infradead.org, arjan@infradead.org,
       rusty@rustcorp.com.au, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <20090128140725.782f5cc1.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901281741310.7408@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <20090128131202.21757da6.akpm@linux-foundation.org> <20090128131327.417b01e1.akpm@linux-foundation.org> <alpine.DEB.1.10.0901281621450.25359@gandalf.stny.rr.com>
 <20090128140725.782f5cc1.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Andrew Morton wrote:
> 
> So if we're going to use per-cpu data then we'd need to protect it with
> a lock.  We could (should?) have a separate lock for each destination
> CPU.
> 
> We could make smp_call_function_single() block until the IPI handler
> has consumed the call_single_data, in which case we might as well put
> the call_single_data, onto the caller's stack, as you've done.
> 
> Or we could take the per-cpu spinlock in smp_call_function_single(),
> and release it in the IPI handler, after the call_single_data has been
> consumed, which is a bit more efficient.  But I have a suspicion that
> this is AB/BA deadlockable.
> 
> <tries to think of any scenarios>
> 
> <fails>
> 
> So we have
> 
> smp_call_function_single(int cpu)
> {
> 	spin_lock(per_cpu(cpu, locks));
> 	per_cpu(cpu, call_single_data) = <stuff>
> 	send_ipi(cpu);
> 	return;
> }
> 
> ipi_handler(...)
> {
> 	int cpu = smp_processor_id();
> 	call_single_data csd = per_cpu(cpu, call_single_data);
> 
> 	spin_unlock(per_cpu(cpu, locks));
> 	use(csd);
> }
> 
> does that work?

I don't think so. With ticket spinlocks and such, that just looks like it 
is destine to crash. Also, spinlocks disable preemption, and we would need 
to enable it again otherwise we have a dangling preempt_disable.

> 
> Dunno if it's any better than what you have now.  It does however
> remove the unpleasant "try kmalloc and if that failed, try something
> else" mess.

We could have a percpu for single data and still use the lock. Keep the 
method of the IPI handler signaling to the caller that they copied it to 
their stack. Then the caller could release the lock.

We can keep this only for the non wait case. Most users set the wait bit, 
so it will only slow down the non waiters.

Of course this will only work with the single cpu function callers. I 
think the all cpu function callers still need to alloc.

-- Steve

