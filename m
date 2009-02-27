Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZB0Qoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZB0Qoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 11:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbZB0Qoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 11:44:32 -0500
Received: from www.tglx.de ([62.245.132.106]:32909 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356AbZB0Qoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 11:44:30 -0500
Date: Fri, 27 Feb 2009 17:43:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       arjan@infradead.org, rostedt@goodmis.org, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt
 handlers
In-Reply-To: <20090226153216.5db66bc3.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0902271712240.29264@localhost.localdomain>
References: <20090226131336.423054348@linutronix.de> <20090226131719.760899560@linutronix.de> <20090226153216.5db66bc3.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Andrew Morton wrote:
> > The threaded handler allows to integrate hardware related
> > functionality and softirq/tasklet functions in the handler
> > thread.
> > 
> 
> A typical device driver will do:
> 
> some_function(...)
> {
> 	spin_lock_irqsave(&dev->lock);
> }
> 
> irq_handler(...)
> {
> 	spin_lock(&dev->lock);
> }
> 
> and this does not deadlock, because the driver "knows" that the IRQ is
> disabled during the execution of the IRQ handler.
> 
> But how is this optimisation supported with IRQ threads?  Do we leave
> the IRQ disabled during the thread execution?  Or does the driver need
> to be changed?
> 
> Bearing in mind that the driver might choose to split the IRQ handling
> between hard-irq context fastpath and process-context slowpath (I
> hope), and that each path might want to take the same lock.

The hard-irq fastpath still can do spin_lock(), but the process
context slowpath needs to disable irqs when it locks something which
is shared with the fast path handler.
 
> >
> > ...
> >
> > @@ -96,6 +122,13 @@ extern int __must_check devm_request_irq
> >  			    const char *devname, void *dev_id);
> >  extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
> >  
> > +static inline int irq_thread_should_run(struct irqaction *action)
> > +{
> > +	return test_and_clear_bit(IRQTF_RUNTHREAD, &action->flags);
> > +}
> 
> I don't think this needs to be placed in a header file?

This is not only for the generic irq code, also threaded handlers need
it to figure out whether there is further work to do.
 
> >  
> > +	/* IRQ handler threads */
> > +	struct irqaction *irqaction;
> > +
> 
> If this field always used?  Perhaps CONFIG_GENERIC_HARDIRQS=n kernels
> could save some space?

Forgot, that CONFIG_GENERIC_HARDIRQS=n archs still exist :)
 
> 
> >  	/* Protection of the PI data structures: */
> >  	spinlock_t pi_lock;
> >  
> > Index: linux-2.6-tip/kernel/exit.c
> > ===================================================================
> > --- linux-2.6-tip.orig/kernel/exit.c
> > +++ linux-2.6-tip/kernel/exit.c
> > @@ -1040,6 +1040,8 @@ NORET_TYPE void do_exit(long code)
> >  		schedule();
> >  	}
> >  
> > +	exit_irq_thread(tsk);
> > +
> 
> Did we just break CONFIG_GENERIC_HARDIRQS=n builds?

Yup, will fix.

> >  	exit_signals(tsk);  /* sets PF_EXITING */
> >  	/*
> >  	 * tsk->flags are checked in the futex code to protect against
> > Index: linux-2.6-tip/kernel/irq/handle.c
> > ===================================================================
> > --- linux-2.6-tip.orig/kernel/irq/handle.c
> > +++ linux-2.6-tip/kernel/irq/handle.c
> > @@ -360,13 +360,46 @@ irqreturn_t handle_IRQ_event(unsigned in
> >  			ret = IRQ_NEEDS_HANDLING;
> >  
> >  		switch (ret) {
> > -		default:
> > +		case IRQ_NEEDS_HANDLING:
> > +			if (!(action->flags & IRQF_THREADED)) {
> > +				ret = action->handler(irq, action->dev_id);
> > +				if (ret == IRQ_HANDLED)
> > +					status |= action->flags;
> > +				break;
> > +			}
> > +			/*
> > +			 * Warn once when a quick check handler asked
> 
> s/quick check/quickcheck/
> 
> > +			 * for invoking the threaded (main) handler
> > +			 * directly
> > +			 */
> 
> It would be nice if the comment were to explain why this is considered
> bad.

Fair enough.
 
> > +			 * disabled the device interrupt, so no irq
> > +			 * storm is lurking.
> > +			 */
> 
> The quickcheck handler has disabled the device interrupt?  Where did
> this factoid come from?  What linkage is there between the crashing of
> a kernel thread and a quickcheck handler knowing to disable the
> interrupt source?  How is a driver writer to know that his quickcheck
> handler is to disable the interrupt, and under what circustances?
> 
> etc.  Head is spinning a bit.

If we want the slow path handler run threaded then we need to make
sure in the quickcheck handler that interrupts are disabled on the
device level. Otherwise we could reeenter the hardirq
immediately. I'll whip up some docu for that.
 
> > +	while (action) {
> > +		if (action->thread)
> > +			set_cpus_allowed_ptr(action->thread, cpumask);
> > +		action = action->next;
> > +	}
> > +}
> 
> Is all this code cpu-hotplug-friendly?

It should and I did not see any problems when I offlined/onlined CPUs
during testing.
 
> > +	printk(KERN_ERR
> > +	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
> > +	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
> 
> task_struct.comm is an array, and testing it for NULL makes no sense.
> 
> The `tsk' argument is a holdover from the old days when accessing
> `current' was considered to be slow.  It would be better if this
> fuction were to take no argumetns and were to operate on `current'.

tsk should always be current. I just followed the other exit_xxx() ones.
 
> If we _really_ want this function to be able to operate on tasks other
> than `current' then we have a whole buncha races to fix first.
> 
> > +	/*
> > +	 * Set the THREAD DIED flag to prevent further wakeups of the
> > +	 * soon to be gone threaded handler.
> > +	 */
> > +	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
> > +	tsk->irqaction = NULL;
> 
> Why do we need to do both?  It would be clearer if irq_thread() were to
> test IRQTF_DIED.

irq_thread does not test IRQTF_DIED, irq_thread is the one which
died. tsk->irqaction does not need to be cleared.
 
> > +/*
> >   * Internal function to register an irqaction - typically used to
> >   * allocate special interrupts that are part of the architecture.
> >   */
> > @@ -402,6 +477,11 @@ __setup_irq(unsigned int irq, struct irq
> >  
> >  	if (desc->chip == &no_irq_chip)
> >  		return -ENOSYS;
> > +
> > +	/* Threaded interrupts need a quickcheck handler */
> > +	if ((new->flags & IRQF_THREADED) && !new->quick_check_handler)
> > +		return -EINVAL;
> 
> Seems redundant.  (new->flags & IRQF_THREADED) and
> !!new->quick_check_handler both contain the same information?

The idea was to allow driver developers a two stage approach for threaded:

1) split out the quickcheck handler and make it work, while still
calling the real handler right after that from hardirq context

2) make the real handler threaded
 
> >  	/*
> >  	 * Some drivers like serial.c use request_irq() heavily,
> >  	 * so we have to be careful not to interfere with a
> > @@ -420,6 +500,26 @@ __setup_irq(unsigned int irq, struct irq
> >  	}
> >  
> >  	/*
> > +	 * Threaded handler ?
> > +	 */
> > +	if (new->flags & IRQF_THREADED) {
> > +		struct task_struct *t;
> > +
> > +		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
> > +				   new->name);
> 
> Seems there's a big risk of overrunning task_struct.comm[] here.

good point.
 
> > +		if (IS_ERR(t))
> > +			return PTR_ERR(t);
> > +		/*
> > +		 * We keep the reference to the task struct even if
> > +		 * the thread dies to avoid that the interrupt code
> > +		 * references an already gone task_struct.
> 
> Sentence needs help.  "to prevent the interrupt code from referencing a
> freed task_struct"?

I know that my english sucks.

Thanks,

	tglx
