Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbZBZXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbZBZXdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZBZXdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:33:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759297AbZBZXdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:33:22 -0500
Date: Thu, 26 Feb 2009 15:32:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       arjan@infradead.org, rostedt@goodmis.org, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
Message-Id: <20090226153216.5db66bc3.akpm@linux-foundation.org>
In-Reply-To: <20090226131719.760899560@linutronix.de>
References: <20090226131336.423054348@linutronix.de>
	<20090226131719.760899560@linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 13:28:23 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Add suppport for threaded interrupt handlers. This is a more strict
> separation of the primary interrupt handler, which runs in hard
> interrupt context, and the real interrupt handler, which handles the
> real device functionality, than the existing hardirq/softirq
> separation.
> 
> The primary hard interrupt context handler solely checks whether the
> interrupt originates from the device or not. In case the interrupt is
> asserted by the device the handler disables the interrupt on the
> device level. This must be the only functionality of the primary
> handler and this restriction has to be carefully monitored to avoid
> unresolvable locking scenarios with a fully preemptible kernel.
> 
> The threaded handler allows to integrate hardware related
> functionality and softirq/tasklet functions in the handler
> thread.
> 

A typical device driver will do:

some_function(...)
{
	spin_lock_irqsave(&dev->lock);
}

irq_handler(...)
{
	spin_lock(&dev->lock);
}

and this does not deadlock, because the driver "knows" that the IRQ is
disabled during the execution of the IRQ handler.

But how is this optimisation supported with IRQ threads?  Do we leave
the IRQ disabled during the thread execution?  Or does the driver need
to be changed?

Bearing in mind that the driver might choose to split the IRQ handling
between hard-irq context fastpath and process-context slowpath (I
hope), and that each path might want to take the same lock.

>
> ...
>
> @@ -96,6 +122,13 @@ extern int __must_check devm_request_irq
>  			    const char *devname, void *dev_id);
>  extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
>  
> +static inline int irq_thread_should_run(struct irqaction *action)
> +{
> +	return test_and_clear_bit(IRQTF_RUNTHREAD, &action->flags);
> +}

I don't think this needs to be placed in a header file?

> +extern void exit_irq_thread(struct task_struct *tsk);
> +
>  /*
>   * On lockdep we dont want to enable hardirqs in hardirq
>   * context. Use local_irq_enable_in_hardirq() to annotate
> Index: linux-2.6-tip/include/linux/irqreturn.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/irqreturn.h
> +++ linux-2.6-tip/include/linux/irqreturn.h
> @@ -6,11 +6,13 @@
>   * @IRQ_NONE		interrupt was not from this device
>   * @IRQ_HANDLED		interrupt was handled by this device
>   * @IRQ_NEEDS_HANDLING	quick check handler requests to run real handler
> + * @IRQ_WAKE_THREAD	quick check handler requests to wake the handler thread
>   */
>  enum irqreturn {
>  	IRQ_NONE,
>  	IRQ_HANDLED,
>  	IRQ_NEEDS_HANDLING,
> +	IRQ_WAKE_THREAD,
>  };
>  
>  typedef enum irqreturn irqreturn_t;
> Index: linux-2.6-tip/include/linux/sched.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/sched.h
> +++ linux-2.6-tip/include/linux/sched.h
> @@ -1307,6 +1307,9 @@ struct task_struct {
>  /* Protection of (de-)allocation: mm, files, fs, tty, keyrings */
>  	spinlock_t alloc_lock;
>  
> +	/* IRQ handler threads */
> +	struct irqaction *irqaction;
> +

If this field always used?  Perhaps CONFIG_GENERIC_HARDIRQS=n kernels
could save some space?


>  	/* Protection of the PI data structures: */
>  	spinlock_t pi_lock;
>  
> Index: linux-2.6-tip/kernel/exit.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/exit.c
> +++ linux-2.6-tip/kernel/exit.c
> @@ -1040,6 +1040,8 @@ NORET_TYPE void do_exit(long code)
>  		schedule();
>  	}
>  
> +	exit_irq_thread(tsk);
> +

Did we just break CONFIG_GENERIC_HARDIRQS=n builds?

>  	exit_signals(tsk);  /* sets PF_EXITING */
>  	/*
>  	 * tsk->flags are checked in the futex code to protect against
> Index: linux-2.6-tip/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/handle.c
> +++ linux-2.6-tip/kernel/irq/handle.c
> @@ -360,13 +360,46 @@ irqreturn_t handle_IRQ_event(unsigned in
>  			ret = IRQ_NEEDS_HANDLING;
>  
>  		switch (ret) {
> -		default:
> +		case IRQ_NEEDS_HANDLING:
> +			if (!(action->flags & IRQF_THREADED)) {
> +				ret = action->handler(irq, action->dev_id);
> +				if (ret == IRQ_HANDLED)
> +					status |= action->flags;
> +				break;
> +			}
> +			/*
> +			 * Warn once when a quick check handler asked

s/quick check/quickcheck/

> +			 * for invoking the threaded (main) handler
> +			 * directly
> +			 */

It would be nice if the comment were to explain why this is considered
bad.

> +			WARN(!test_and_set_bit(IRQTF_WARNED,
> +					       &action->thread_flags),
> +			     "IRQ %d requested to run threaded handler "
> +			     "in hard interrupt context\n", irq);
> +
> +			/* Fall through and wake the thread */
> +		case IRQ_WAKE_THREAD:
> +			/*
> +			 * In case the thread crashed and was killed
> +			 * we just pretend that we handled the
> +			 * interrupt. The quick check handler has

s/quick check/quickcheck/.  Given that "quickcheck" now enters the
kernel nomenclature, let us use it consistently.

> +			 * disabled the device interrupt, so no irq
> +			 * storm is lurking.
> +			 */

The quickcheck handler has disabled the device interrupt?  Where did
this factoid come from?  What linkage is there between the crashing of
a kernel thread and a quickcheck handler knowing to disable the
interrupt source?  How is a driver writer to know that his quickcheck
handler is to disable the interrupt, and under what circustances?

etc.  Head is spinning a bit.


> +			if (likely(!test_bit(IRQTF_DIED,
> +					     &action->thread_flags))) {
> +				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
> +				wake_up_process(action->thread);
> +			}
> +
> +			/*
> +			 * Set it to handled so the spurious check
> +			 * does not trigger.
> +			 */
> +			ret = IRQ_HANDLED;
>  			break;
>  
> -		case IRQ_NEEDS_HANDLING:
> -			ret = action->handler(irq, action->dev_id);
> -			if (ret == IRQ_HANDLED)
> -				status |= action->flags;
> +		default:
>  			break;
>
> ...
>
> +static void
> +irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
> +{
> +	struct irqaction *action = desc->action;
> +
> +	while (action) {
> +		if (action->thread)
> +			set_cpus_allowed_ptr(action->thread, cpumask);
> +		action = action->next;
> +	}
> +}

Is all this code cpu-hotplug-friendly?

>  /**
>   *	irq_set_affinity - Set the irq affinity of a given irq
>   *	@irq:		Interrupt to set affinity
> @@ -100,6 +120,7 @@ int irq_set_affinity(unsigned int irq, c
>  	cpumask_copy(desc->affinity, cpumask);
>  	desc->chip->set_affinity(irq, cpumask);
>  #endif
> +	irq_set_thread_affinity(desc, cpumask);
>  	desc->status |= IRQ_AFFINITY_SET;
>  	spin_unlock_irqrestore(&desc->lock, flags);
>  	return 0;
> @@ -150,6 +171,8 @@ int irq_select_affinity_usr(unsigned int
>  
>  	spin_lock_irqsave(&desc->lock, flags);
>  	ret = setup_affinity(irq, desc);
> +	if (!ret)
> +		irq_set_thread_affinity(desc, &desc->affinity);
>  	spin_unlock_irqrestore(&desc->lock, flags);
>  
>  	return ret;
> @@ -385,6 +408,58 @@ int __irq_set_trigger(struct irq_desc *d
>  }
>  
>  /*
> + * Interrupt handler thread
> + */
> +static int irq_thread(void *data)
> +{
> +	struct irqaction *action = data;
> +	struct sched_param param = { 0, };
> +
> +	/*
> +	 * Set irq thread priority to SCHED_FIFO prio 50:
> +	 */
> +	param.sched_priority = MAX_USER_RT_PRIO/2;

It might be a wee bit more efficient to do

	struct sched_param param = {
		.sched_priority = MAX_USER_RT_PRIO/2,
	};

It would be even more efficient to build this struct at compile time,
but sched_setscheduler() forgot the `const'.

> +	sched_setscheduler(current, SCHED_FIFO, &param);
> +
> +	current->irqaction = action;
> +
> +	while (!kthread_should_stop()) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (irq_thread_should_run(action) && current->irqaction) {
> +			__set_current_state(TASK_RUNNING);
> +			action->handler(action->irq, action->dev_id);
> +		} else
> +			schedule();
> +	}
> +	/*
> +	 * Clear irqaction. Otherwise exit_irq_thread() would make
> +	 * fuzz about an active irq thread going into nirvana.
> +	 */
> +	current->irqaction = NULL;
> +	return 0;
> +}
> +
> +/*
> + * Called from do_exit()
> + */
> +void exit_irq_thread(struct task_struct *tsk)
> +{
> +	if (!tsk->irqaction)
> +		return;
> +
> +	printk(KERN_ERR
> +	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
> +	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);

task_struct.comm is an array, and testing it for NULL makes no sense.

The `tsk' argument is a holdover from the old days when accessing
`current' was considered to be slow.  It would be better if this
fuction were to take no argumetns and were to operate on `current'.

If we _really_ want this function to be able to operate on tasks other
than `current' then we have a whole buncha races to fix first.

> +	/*
> +	 * Set the THREAD DIED flag to prevent further wakeups of the
> +	 * soon to be gone threaded handler.
> +	 */
> +	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
> +	tsk->irqaction = NULL;

Why do we need to do both?  It would be clearer if irq_thread() were to
test IRQTF_DIED.

> +}
> +
> +/*
>   * Internal function to register an irqaction - typically used to
>   * allocate special interrupts that are part of the architecture.
>   */
> @@ -402,6 +477,11 @@ __setup_irq(unsigned int irq, struct irq
>  
>  	if (desc->chip == &no_irq_chip)
>  		return -ENOSYS;
> +
> +	/* Threaded interrupts need a quickcheck handler */
> +	if ((new->flags & IRQF_THREADED) && !new->quick_check_handler)
> +		return -EINVAL;

Seems redundant.  (new->flags & IRQF_THREADED) and
!!new->quick_check_handler both contain the same information?

>  	/*
>  	 * Some drivers like serial.c use request_irq() heavily,
>  	 * so we have to be careful not to interfere with a
> @@ -420,6 +500,26 @@ __setup_irq(unsigned int irq, struct irq
>  	}
>  
>  	/*
> +	 * Threaded handler ?
> +	 */
> +	if (new->flags & IRQF_THREADED) {
> +		struct task_struct *t;
> +
> +		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
> +				   new->name);

Seems there's a big risk of overrunning task_struct.comm[] here.

> +		if (IS_ERR(t))
> +			return PTR_ERR(t);
> +		/*
> +		 * We keep the reference to the task struct even if
> +		 * the thread dies to avoid that the interrupt code
> +		 * references an already gone task_struct.

Sentence needs help.  "to prevent the interrupt code from referencing a
freed task_struct"?

> +		 */
> +		get_task_struct(t);
> +		new->thread = t;
> +		wake_up_process(t);
> +	}
> +
> +	/*
>  	 * The following block of code has to be executed atomically
>  	 */
>  	spin_lock_irqsave(&desc->lock, flags);
>
> ...
>

