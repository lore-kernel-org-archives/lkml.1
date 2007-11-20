Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXKTUpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXKTUpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXKTUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:44:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40191 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757401AbXKTUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:44:56 -0500
Date: Tue, 20 Nov 2007 12:44:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 04/45] cpu alloc: Use in SLUB
In-Reply-To: <20071120124202.GA10127@Krystal>
Message-ID: <Pine.LNX.4.64.0711201240160.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011332.652677710@sgi.com>
 <20071120124202.GA10127@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> >  {
> > -#ifdef CONFIG_SMP
> >  	on_each_cpu(flush_cpu_slab, s, 1, 1);
> > -#else
> > -	unsigned long flags;
> > -
> > -	local_irq_save(flags);
> > -	flush_cpu_slab(s);
> > -	local_irq_restore(flags);
> > -#endif
> >  }
> >  
> 
> Normally :
> 
> You can't use on_each_cpu if interrupts are already disabled. Therefore,
> the implementation using "local_irq_disable/enable" in smp.h for the UP
> case is semantically correct and there is no need to use a save/restore.
> So just using on_each_cpu should be enough here.

The on_each_cpu is only used in the smp case.

> I also wonder about flush_cpu_slab execution on _other_ cpus. I am not
> convinced interrupts are disabled when it executes.. have I missing
> something ?

flush_cpu_slab only flushes the local cpu slab. keventd threads are pinned 
to each processor so it should be safe.

> > -#ifdef CONFIG_FAST_CMPXCHG_LOCAL
> > -	c = get_cpu_slab(s, get_cpu());
> > +#ifdef CONFIG_FAST_CPU_OPS
> 
> I wonder.. are there some architectures that would provide fast
> cmpxchg_local but not fast cpu ops ?

If you have a fast cmpxchg_local then you can use that to implement fast 
cpu ops.

> > +	} while (CPU_CMPXCHG(c->freelist, object,
> > +			object[__CPU_READ(c->offset)]) != object);
> 
> Hrm. What happens here if we call __slab_alloc, get a valid object, then
> have a CPU_CMPXCHG that fails, restart the loop.. is this case taken
> care of or do we end up having an unreferenced object ? Maybe there is
> some logic in freelist that takes care of it ?

If we fail then we have done nothing....

> Also, we have to be aware that we can now change CPU between the
> 
> __CPU_READ and the CPU_CMPXCHG. (also : should it be a __CPU_CMPXCHG ?)
> 
> But since "object" contains information specific to the local CPU, the
> cmpxchg should fail if we are migrated and everything should be ok.

Right.
 
> Hrm, actually, the 
> 
> c = s->cpu_slab;
> 
> should probably be after the object = __CPU_READ(c->freelist); ?

No. c is invariant in respect to cpus.

> The cpu_read acts as a safeguard checking that we do not change CPU
> between the read and the cmpxchg. If we are preempted between the "c"
> read and the cpu_read, we could do a !cpu_node_match(c, node) check that
> would apply to the wrong cpu.

C is not pointing to a specific cpu. It can only be used in CPU_xx ops to
address the currrent cpu.

> > @@ -1800,19 +1792,19 @@ static void __always_inline slab_free(st
> >  		 * then any change of cpu_slab will cause the cmpxchg to fail
> >  		 * since the freelist pointers are unique per slab.
> >  		 */
> > -		if (unlikely(page != c->page || c->node < 0)) {
> > -			__slab_free(s, page, x, addr, c->offset);
> > +		if (unlikely(page != __CPU_READ(c->page) ||
> > +					__CPU_READ(c->node) < 0)) {
> > +			__slab_free(s, page, x, addr, __CPU_READ(c->offset));
> 
> And same question as above : what happens if we fail after executing the
> __slab_free.. is it valid to do it twice ?

__slab_free is always successful and will never cause a repeat of the 
loop.
