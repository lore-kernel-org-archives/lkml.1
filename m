Return-Path: <linux-kernel-owner+w=401wt.eu-S1765750AbXJQLwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765750AbXJQLwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXJQLwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:52:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42828 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbXJQLwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:52:45 -0400
Date: Wed, 17 Oct 2007 15:57:23 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: [RFC PATCH 4/4] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Message-ID: <20071017115723.GA143@tv-sign.ru>
References: <20071016103308.GA9907@in.ibm.com> <20071016103721.GD16570@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016103721.GD16570@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Gautham R Shenoy wrote:
>
> cleanup_workqueue_thread() in the CPU_DEAD and CPU_UP_CANCELLED path
> will cause a deadlock if the worker thread is executing a work item
> which is blocked on get_online_cpus(). This will lead to a irrecoverable
> hang.
>
> Solution is not to cleanup the worker thread. Instead let it remain
> even after the cpu goes offline. Since no one can queue any work
> on an offlined cpu, this thread will be forever sleeping, untill
> someone onlines the cpu.

Imho: not perfect, but acceptable. We can re-introduce cwq->should_stop
flag, so that cwq->thread eventually exits after it flushed ->worklist.
But see below.

> @@ -679,6 +680,7 @@ init_cpu_workqueue(struct workqueue_stru
>  	spin_lock_init(&cwq->lock);
>  	INIT_LIST_HEAD(&cwq->worklist);
>  	init_waitqueue_head(&cwq->more_work);
> +	cwq->thread = NULL;

Not needed, cwq->thread == NULL because alloc_percpu() uses GFP_ZERO.

>  	return cwq;
>  }
> @@ -712,7 +714,7 @@ static void start_workqueue_thread(struc
>
>  	if (p != NULL) {
>  		if (cpu >= 0)
> -			kthread_bind(p, cpu);
> +			set_cpus_allowed(p, cpumask_of_cpu(cpu));

OK, this is understandable, but see below...

>  		wake_up_process(p);
>  	}
>  }
> @@ -848,6 +850,9 @@ static int __devinit workqueue_cpu_callb
>
>  		switch (action) {
>  		case CPU_UP_PREPARE:
> +			if (likely(cwq->thread != NULL &&
> +					!IS_ERR(cwq->thread)))

IS_ERR(cwq->thread) is not possible. cwq->thread is either NULL, or
a valid task_struct.

> +				break;
>  			if (!create_workqueue_thread(cwq, cpu))
>  				break;
>  			printk(KERN_ERR "workqueue [%s] for %i failed\n",
> @@ -858,12 +863,6 @@ static int __devinit workqueue_cpu_callb
>  		case CPU_ONLINE:
>  			start_workqueue_thread(cwq, cpu);
>  			break;
> -
> -		case CPU_UP_CANCELED:
> -			start_workqueue_thread(cwq, -1);
> -		case CPU_DEAD:
> -			cleanup_workqueue_thread(cwq, cpu);
> -			break;
>  		}
>  	}

Unfortunately, this approach seem to have a sublte problem.

Suppose that CPU 0 goes down. Let's denote the corresponding cwq->thread as T.
When CPU goes offline, T is not bound to CPU 0 any longer. So far this is OK.

Now suppose that CPU 0 goes online again. There is a window before CPU_ONLINE
(note that CPU 0 is already online at this time) binds T back to CPU 0. It is
possible that another thread running on CPU 0 does schedule_work() in that window,
or it can run on any CPU but calls schedule_delayed_work_on(0).

In this case the work_struct may run on the wrong CPU because T is ready to
execute the work_struct, this is bug. work->func() has all rights to expect
that cwq->thread is bound to the right CPU.

Let's take cache_reap() as an example. It is critical that this function is
really "per cpu", otherwise it can use the wrong per-cpu data, and even the
last schedule_delayed_work() is not reliable.

(Sorry, have no time to read the other patches now, will do on weekend).

Oleg.

