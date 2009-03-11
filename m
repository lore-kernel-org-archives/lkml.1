Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZCKOBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZCKOBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZCKOAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZCKOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:00:54 -0400
Date: Wed, 11 Mar 2009 10:00:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] tracing: use raw spinlocks for trace_vprintk
In-Reply-To: <20090311071808.GA5090@nowhere>
Message-ID: <alpine.DEB.2.00.0903110958000.16494@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903102125250.16494@gandalf.stny.rr.com> <1236754764.22914.3680.camel@twins> <20090311071808.GA5090@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Mar 2009, Frederic Weisbecker wrote:

> On Wed, Mar 11, 2009 at 07:59:24AM +0100, Peter Zijlstra wrote:
> > On Tue, 2009-03-10 at 21:26 -0400, Steven Rostedt wrote:
> > 
> > > commit 80370cb758e7ca2692cd9fb5e413d970b1f4b2b2
> > > Author: Steven Rostedt <srostedt@redhat.com>
> > > Date:   Tue Mar 10 17:16:35 2009 -0400
> > > 
> > >     tracing: use raw spinlocks for trace_vprintk
> > >     
> > >     Impact: prevent locking up by lockdep tracer
> > >     
> > >     The lockdep tracer uses trace_vprintk and thus trace_vprintk can not
> > >     call back into lockdep without locking up.
> > 
> > Hmm, I did this when I posted the lockdep tracepoints, so someone then
> > did a bad copy/paste job when renaming ftrace_printk or something?
> > 
> > See efed792d6738964f399a508ef9e831cd60fa4657
> 
> 
> 
> Must be my bad :-s
> I think I lost this modification that was done on the old trace_vprintf
> between two iterations of the bprintk patchset.
> 
> BTW, Ingo reported one or two monthes ago that ftrace_printk was not NMI safe
> because of this spinlock.
> 
> He suggested to drop the spinlock and then make trace_buf per_cpu.
> 
> By disabling the irq we prevent from race with maskable irqs. And in
> case of racy accesses to trace_buf because of an nmi, then the buffer
> might be mixed up but it must be harmless compared to a hardlockup that
> can occur now. On the worst case, the trace will be weird and that's it.

But the lock is only used in this function, and the function can not 
recurse. It is NMI safe. see below.

> 
> Frederic.
> 
> 
> > >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > > index 8c6a902..4c97947 100644
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -1176,7 +1176,8 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
> > >   */
> > >  int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
> > >  {
> > > -	static DEFINE_SPINLOCK(trace_buf_lock);
> > > +	static raw_spinlock_t trace_buf_lock =
> > > +		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> > >  	static u32 trace_buf[TRACE_BUF_SIZE];
> > >  
> > >  	struct ring_buffer_event *event;
> > > @@ -1201,7 +1202,9 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
> > >  	if (unlikely(atomic_read(&data->disabled)))
> > >  		goto out;

The above disable is exactly for NMIs. We should have preemption disabled 
here, and we disable this per cpu. If an NMI comes in after this point, it 
will exit the function without taking the lock. If it runs on another CPU, 
we really don't care. That's what NMIs are for ;-)

-- Steve



> > >  
> > > -	spin_lock_irqsave(&trace_buf_lock, flags);
> > > +	/* Lockdep uses trace_printk for lock tracing */
> > > +	local_irq_save(flags);
> > 
> > Shouldn't you also use raw_local_irq_save() and friends?
> > 
> > > +	__raw_spin_lock(&trace_buf_lock);
> > >  	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
> > >  
> > >  	if (len > TRACE_BUF_SIZE || len < 0)
> > > @@ -1220,7 +1223,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
> > >  	ring_buffer_unlock_commit(tr->buffer, event);
> > >  
> > >  out_unlock:
> > > -	spin_unlock_irqrestore(&trace_buf_lock, flags);
> > > +	__raw_spin_unlock(&trace_buf_lock);
> > > +	local_irq_restore(flags);
> > >  
> > >  out:
> > >  	ftrace_preempt_enable(resched);
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
