Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbZA1RTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbZA1RTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZA1RTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:19:33 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57774 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751403AbZA1RTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:19:31 -0500
Message-ID: <4980939C.6010102@sgi.com>
Date: Wed, 28 Jan 2009 09:19:24 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901271735.12034.rusty@rustcorp.com.au> <20090126232519.44f2943c.akpm@linux-foundation.org> <200901282332.29429.rusty@rustcorp.com.au>
In-Reply-To: <200901282332.29429.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I'm testing this now on x86_64 and one question comes up.  The
initialization of the woc_wq thread happens quite late.  Might it
be better to initialize it earlier?

(I haven't tested all work_on_cpu callers yet, plus there are a
couple that are waiting in the queue that I'm also testing.)

Oops, one problem just popped up.  After running a couple of
offline/online tests, this came up:

[ 1080.185022] INFO: task kwork_on_cpu:491 blocked for more than 480 seconds.
[ 1080.205849] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1080.229745] kwork_on_cpu  D 0000000000000000  3432   491      2
[ 1080.229750]  ffff88012e043ec0 0000000000000046 000000002e043e60 ffffffff81d5ef00
[ 1080.229754]  ffffffff81d5ef00 ffffffff81d5ef00 ffffffff81d5ef00 ffffffff81d5ef00
[ 1080.229757]  ffffffff81d5ef00 ffffffff81d58580 ffffffff81d5ef00 ffff88012e03ab40
[ 1080.229760] Call Trace:
[ 1080.229770]  [<ffffffff8106e241>] ? trace_hardirqs_on+0xd/0xf
[ 1080.229774]  [<ffffffff810a6bc5>] do_work_on_cpu+0x72/0x13d
[ 1080.229778]  [<ffffffff8105d994>] ? autoremove_wake_function+0x0/0x3d
[ 1080.229781]  [<ffffffff810a6b53>] ? do_work_on_cpu+0x0/0x13d
[ 1080.229783]  [<ffffffff810a6b53>] ? do_work_on_cpu+0x0/0x13d
[ 1080.229786]  [<ffffffff8105d809>] kthread+0x4e/0x7d
[ 1080.229790]  [<ffffffff8100d7ba>] child_rip+0xa/0x20
[ 1080.229793]  [<ffffffff8100d1bc>] ? restore_args+0x0/0x30
[ 1080.229795]  [<ffffffff8105d796>] ? kthreadd+0x167/0x18c
[ 1080.229798]  [<ffffffff8105d7bb>] ? kthread+0x0/0x7d
[ 1080.229801]  [<ffffffff8100d7b0>] ? child_rip+0x0/0x20
[ 1080.229802] INFO: lockdep is turned off.

Thanks,
Mike

Rusty Russell wrote:
> On Tuesday 27 January 2009 17:55:19 Andrew Morton wrote:
> [ lots of good stuff ]
> 
>> Making work_on_cu() truly generic is quite hard!
> 
> Yes.  What do you think of this workqueue-less approach?
> 
> Subject: work_on_cpu: non-workqueue solution.
> 
> work_on_cpu was designed to replace the meme of:
> 
> 	cpumask_t saved = current->cpus_allowed;
> 	set_cpus_allowed(cpumask_of(dst));
> 	    ... do something on cpu dst ...
> 	set_cpus_allowed(saved);
> 
> It should have been a trivial routine, and a trivial conversion.
> 
> The original version did a get_online_cpus(), then put the work on the
> kevent queue, called flush_work(), then put_online_cpus().  See
> 2d3854a37e8b767a51aba38ed6d22817b0631e33.
> 
> Several locking warnings resulted from different users being converted
> over the months this patch was used leading up to 2.6.29.  One was
> fixed to use smp_call_function_single
> (b2bb85549134c005e997e5a7ed303bda6a1ae738), but it's always risky to
> convert code which was running in user context into interrupt context.
> When another one was reported, we dropped the get_online_cpus() and
> relied on the callers to do that (as they should have been doing
> before) as seen in 31ad9081200c06ccc350625d41d1f8b2d1cef29f.
> 
> But there was still a locking issue with
> arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c, so that conversion was
> reverted in Ingo's tree.  Turns out that it the conversion caused
> work_on_cpu to be called from inside keventd in some paths.
> 
> The obvious solution was to change to using our own workqueue, so we
> could use it in ACPI and so it would actually be a generically useful
> function as intended.
> 
> Andrew Morton complained about NR_CPUS new threads.  Which I happen to
> agree with.  (He also bitched about the comment being too short, so
> this one is a fucking novel).
> 
> While I was at linux.conf.au and avoiding reading my mail, a long
> discussion ensued (See lkml "[PATCH 2/3] work_on_cpu: Use our own
> workqueue."), including useful advice such as not ever grabbing a lock
> inside a work function.  Or something; it gets a bit confusing.
> 
> To make the pain stop, this attempts to create work_on_cpu without
> using workqueues at all.  It does create one new thread.  But as long
> as you don't call work_on_cpu inside work_on_cpu, or create normal
> locking inversions, it should work just peachy.
> 
> FIXME: It includes work_on_cpu.h from workqueue.h to avoid chasing all
> the users, but they should include it directly.
> 
> I tested it lightly (as seen in this patch), but my test machine
> doesn't hit any work_on_cpu paths.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/include/linux/work_on_cpu.h b/include/linux/work_on_cpu.h
> new file mode 100644
> --- /dev/null
> +++ b/include/linux/work_on_cpu.h
> @@ -0,0 +1,13 @@
> +#ifndef _LINUX_WORK_ON_CPU_H
> +#define _LINUX_WORK_ON_CPU_H
> +
> +#ifndef CONFIG_SMP
> +static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> +{
> +	return fn(arg);
> +}
> +#else
> +long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
> +#endif /* CONFIG_SMP */
> +
> +#endif /* _LINUX_WORK_ON_CPU_H */
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -9,6 +9,7 @@
>  #include <linux/linkage.h>
>  #include <linux/bitops.h>
>  #include <linux/lockdep.h>
> +#include <linux/work_on_cpu.h>
>  #include <asm/atomic.h>
>  
>  struct workqueue_struct;
> @@ -251,13 +252,4 @@ void cancel_rearming_delayed_work(struct
>  {
>  	cancel_delayed_work_sync(work);
>  }
> -
> -#ifndef CONFIG_SMP
> -static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> -{
> -	return fn(arg);
> -}
> -#else
> -long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
> -#endif /* CONFIG_SMP */
>  #endif
> diff --git a/kernel/Makefile b/kernel/Makefile
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -92,6 +92,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
>  obj-$(CONFIG_FUNCTION_TRACER) += trace/
>  obj-$(CONFIG_TRACING) += trace/
>  obj-$(CONFIG_SMP) += sched_cpupri.o
> +obj-$(CONFIG_SMP) += work_on_cpu.o
>  
>  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
> diff --git a/kernel/work_on_cpu.c b/kernel/work_on_cpu.c
> new file mode 100644
> --- /dev/null
> +++ b/kernel/work_on_cpu.c
> @@ -0,0 +1,108 @@
> +#include <linux/work_on_cpu.h>
> +#include <linux/kthread.h>
> +#include <linux/mutex.h>
> +#include <linux/completion.h>
> +#include <linux/cpumask.h>
> +#include <linux/module.h>
> +
> +/* The thread waits for new work on this waitqueue. */
> +static DECLARE_WAIT_QUEUE_HEAD(woc_wq);
> +/* The lock ensures only one job is done at a time. */
> +static DEFINE_MUTEX(woc_mutex);
> +
> +/* The details of the current job. */
> +struct work_for_cpu {
> +	unsigned int cpu;
> +	long (*fn)(void *);
> +	void *arg;
> +	long ret;
> +	struct completion done;
> +};
> +
> +/* The pointer to the current job.  NULL if nothing pending. */
> +static struct work_for_cpu *current_work;
> +
> +/* We leave our thread on whatever cpu it was on last.  We can get
> + * batted onto another CPU by move_task_off_dead_cpu if that cpu goes
> + * down, but the caller of work_on_cpu() was supposed to ensure that
> + * doesn't happen, so it should only happen when idle. */
> +static int do_work_on_cpu(void *unused)
> +{
> +	for (;;) {
> +		struct completion *done;
> +
> +		wait_event(woc_wq, current_work != NULL);
> +
> +		set_cpus_allowed_ptr(current, cpumask_of(current_work->cpu));
> +		WARN_ON(smp_processor_id() != current_work->cpu);
> +
> +		current_work->ret = current_work->fn(current_work->arg);
> +		/* Make sure ret is set before we complete().  Paranoia. */
> +		wmb();
> +
> +		/* Reset current_work so we don't spin. */
> +		done = &current_work->done;
> +		current_work = NULL;
> +
> +		/* Reset current_work for next work_on_cpu(). */
> +		complete(done);
> +	}
> +}
> +
> +/**
> + * work_on_cpu - run a function in user context on a particular cpu
> + * @cpu: the cpu to run on
> + * @fn: the function to run
> + * @arg: the function arg
> + *
> + * This will return the value @fn returns.
> + * It is up to the caller to ensure that the cpu doesn't go offline.
> + */
> +long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> +{
> +	struct work_for_cpu work;
> +
> +	work.cpu = cpu;
> +	work.fn = fn;
> +	work.arg = arg;
> +	init_completion(&work.done);
> +
> +	mutex_lock(&woc_mutex);
> +	/* Make sure all is in place before it sees fn set. */
> +	wmb();
> +	current_work = &work;
> +	wake_up(&woc_wq);
> +
> +	wait_for_completion(&work.done);
> +	BUG_ON(current_work);
> +	mutex_unlock(&woc_mutex);
> +
> +	return work.ret;
> +}
> +EXPORT_SYMBOL_GPL(work_on_cpu);
> +
> +#if 1
> +static long test_fn(void *arg)
> +{
> +	printk("%u: %lu\n", smp_processor_id(), (long)arg);
> +	return (long)arg + 100;
> +}
> +#endif
> +
> +static int __init init(void)
> +{
> +	unsigned int i;
> +
> +	kthread_run(do_work_on_cpu, NULL, "kwork_on_cpu");
> +
> +#if 1
> +	for_each_online_cpu(i) {
> +		long ret = work_on_cpu(i, test_fn, (void *)i);
> +		printk("CPU %i returned %li\n", i, ret);
> +		BUG_ON(ret != i + 100);
> +	}
> +#endif
> +
> +	return 0;
> +}
> +module_init(init);
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -970,47 +970,6 @@ undo:
>  	return ret;
>  }
>  
> -#ifdef CONFIG_SMP
> -static struct workqueue_struct *work_on_cpu_wq __read_mostly;
> -
> -struct work_for_cpu {
> -	struct work_struct work;
> -	long (*fn)(void *);
> -	void *arg;
> -	long ret;
> -};
> -
> -static void do_work_for_cpu(struct work_struct *w)
> -{
> -	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
> -
> -	wfc->ret = wfc->fn(wfc->arg);
> -}
> -
> -/**
> - * work_on_cpu - run a function in user context on a particular cpu
> - * @cpu: the cpu to run on
> - * @fn: the function to run
> - * @arg: the function arg
> - *
> - * This will return the value @fn returns.
> - * It is up to the caller to ensure that the cpu doesn't go offline.
> - */
> -long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
> -{
> -	struct work_for_cpu wfc;
> -
> -	INIT_WORK(&wfc.work, do_work_for_cpu);
> -	wfc.fn = fn;
> -	wfc.arg = arg;
> -	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
> -	flush_work(&wfc.work);
> -
> -	return wfc.ret;
> -}
> -EXPORT_SYMBOL_GPL(work_on_cpu);
> -#endif /* CONFIG_SMP */
> -
>  void __init init_workqueues(void)
>  {
>  	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
> @@ -1021,8 +980,4 @@ void __init init_workqueues(void)
>  	hotcpu_notifier(workqueue_cpu_callback, 0);
>  	keventd_wq = create_workqueue("events");
>  	BUG_ON(!keventd_wq);
> -#ifdef CONFIG_SMP
> -	work_on_cpu_wq = create_workqueue("work_on_cpu");
> -	BUG_ON(!work_on_cpu_wq);
> -#endif
>  }
>  

