Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968227Ab0B1OOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 09:14:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968032Ab0B1OOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 09:14:04 -0500
Date: Sun, 28 Feb 2010 15:11:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
Message-ID: <20100228141135.GB5495@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Tejun Heo wrote:
>
> +static int stop_cpu(void *unused)
>  {
>  	enum stopmachine_state curstate = STOPMACHINE_NONE;
> -	struct stop_machine_data *smdata = &idle;
> +	struct stop_machine_data *smdata;
>  	int cpu = smp_processor_id();
>  	int err;
>
> +repeat:
> +	/* Wait for __stop_machine() to initiate */
> +	while (true) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		/* <- kthread_stop() and __stop_machine()::smp_wmb() */
> +		if (kthread_should_stop()) {
> +			__set_current_state(TASK_RUNNING);
> +			return 0;
> +		}
> +		if (state == STOPMACHINE_PREPARE)
> +			break;

Cosmetic nit: this doesn't matter at all, but perhaps it makes sense
to set TASK_RUNNING here too.

Actually, I was a bit confused by this "while (true)" loop. It looks
as if a spurious wakeup is possible. It is not, and more importantly,
if it was possible stop_machine_cpu_callback(CPU_POST_DEAD) (which is
called after cpu_hotplug_done()) could race with stop_machine().
stop_machine_cpu_callback(CPU_POST_DEAD) relies on fact that this thread
has already called schedule() and it can't be woken until kthread_stop()
sets ->should_stop.

> +		schedule();
> +	}
> +	smp_rmb();	/* <- __stop_machine()::set_state() */
> +
> +	/* Okay, let's go */
> +	smdata = &idle;
>  	if (!active_cpus) {
>  		if (cpu == cpumask_first(cpu_online_mask))
>  			smdata = &active;

I never understood why do we need "struct stop_machine_data idle".
stop_cpu() just needs a "bool should_call_active_fn" ?

>  int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  {
> ...
>  	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
>  	 * doesn't hit this CPU until we're ready. */
>  	get_cpu();
> +	for_each_online_cpu(i)
> +		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));

I think the comment is wrong, and we need preempt_disable() instead
of get_cpu(). We shouldn't worry about this CPU, but we need to ensure
the woken real-time thread can't preempt us until we wake up them all.

Oleg.

