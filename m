Return-Path: <linux-kernel-owner+w=401wt.eu-S1762360AbZA2AaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360AbZA2AaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbZA1XuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:50:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188AbZA1XuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:50:10 -0500
Date: Wed, 28 Jan 2009 18:50:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, peterz@infradead.org, arjan@infradead.org,
       rusty@rustcorp.com.au, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <20090128152048.40ac3526.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901281841330.7408@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <20090128131202.21757da6.akpm@linux-foundation.org> <20090128131327.417b01e1.akpm@linux-foundation.org> <alpine.DEB.1.10.0901281621450.25359@gandalf.stny.rr.com>
 <20090128140725.782f5cc1.akpm@linux-foundation.org> <alpine.DEB.1.10.0901281741310.7408@gandalf.stny.rr.com> <20090128152048.40ac3526.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Andrew Morton wrote:
> > 
> > I don't think so. With ticket spinlocks and such, that just looks like it 
> > is destine to crash. Also, spinlocks disable preemption, and we would need 
> > to enable it again otherwise we have a dangling preempt_disable.
> 
> Well that sucks.
> 
> I think the model of taking a lock, passing the data across to another
> thread of control and having that thread of control release the lock
> once the data has been consumed is a good one.  It's faster and in this
> case it means that we can now (maybe) perform (wait=0) IPI calls with local
> interrupts disabled, which wasn't the case before.

I think that model is nice too. Just not for spinlocks ;-)

> 
> It's a shame that irrelevant-other-stuff prevents us from implementing
> such a thing.  Of course, we can still do it, via some ad-hoc locking
> thing using raw_spin_lock/atomic_t's/bitops/cpu_relax/etc.

It should not be too hackish. I don't even think we need raw or atomic.

cpu caller:

 again:
	spin_lock(&data_lock);
	if (per_cpu(data, cpu).lock) {
		spin_unlock(&data_lock);
		cpu_relax();
		goto again;
	}

	per_cpu(data, cpu).lock = 1;
	spin_unlock(&data_lock);

	call ipi functions


cpu callee:
		
	func();

	smp_wmb();
	per_cpu(data, cpu).lock = 0;


Here we can only call an ipi on a funcion if the data lock is cleared.
If it is set, we wait for the ipi function to clear it and then we set it.

Thus we synchronize the callers, but the callers do not need to wait on 
the callees. And since the callers can only call a ipi on a cpu that is 
finished, we do not need to worry about corrupted data.
	
> 
> > Of course this will only work with the single cpu function callers. I 
> > think the all cpu function callers still need to alloc.
> 
> I haven't really thought about the smp_call_function_many()
> common case.  

We can keep the original code that still does the malloc for the many 
cpus. But falls back to the single version that does not use malloc if the 
malloc fails.


current code for smp_call_function_many():

        data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
        if (unlikely(!data)) {
                /* Slow path. */
                for_each_online_cpu(cpu) {
                        if (cpu == smp_processor_id())
                                continue;
                        if (cpumask_test_cpu(cpu, mask))
                                smp_call_function_single(cpu, func, info, wait);
                }
                return;
        }

I think this would work.

/me goes and tries it out

-- Steve
