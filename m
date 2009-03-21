Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZCUM7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZCUM7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCUM7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:59:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963AbZCUM7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:59:34 -0400
Date: Sat, 21 Mar 2009 05:52:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled
 for each counter
Message-Id: <20090321055252.eb0673ea.akpm@linux-foundation.org>
In-Reply-To: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 23:04:16 +1100 Paul Mackerras <paulus@samba.org> wrote:

>

{innocent civilian mode}

> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 98f5990..b1224f9 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -83,6 +83,16 @@ enum perf_counter_record_type {
>  };
>  
>  /*
> + * Bits that can be set in hw_event.read_format to request that
> + * reads on the counter should return the indicated quantities,
> + * in increasing order of bit value, after the counter value.
> + */
> +enum perf_counter_read_format {
> +	PERF_FORMAT_TIME_ENABLED	=  1,
> +	PERF_FORMAT_TIME_RUNNING	=  2,
> +};
> +
> +/*
>   * Hardware event to monitor via a performance monitoring counter:
>   */
>  struct perf_counter_hw_event {
> @@ -234,6 +244,12 @@ struct perf_counter {
>  	enum perf_counter_active_state	prev_state;
>  	atomic64_t			count;
>  
> +	u64				time_enabled;
> +	u64				time_running;

These look like times.  I see no indication (here) as to the units.

> +	u64				start_enabled;

This looks like a boolean, but it's u64.

> +	u64				start_running;

hard to say.

> +	u64				last_stopped;

probably a time, unknown units.


Perhaps one of the reasons why this code is confusing is the blurring
between the "time" at which an event occured and the "time" between the
occurrence of two events.  A weakness in English, I guess.  Using the term
"interval" in the latter case will help a lot.


>  	struct perf_counter_hw_event	hw_event;
>  	struct hw_perf_counter		hw;
>  
> @@ -243,6 +259,8 @@ struct perf_counter {
>  
>  	struct perf_counter		*parent;
>  	struct list_head		child_list;
> +	atomic64_t			child_time_enabled;
> +	atomic64_t			child_time_running;

These read like booleans, but why are they atomic64_t's?

>  	/*
>  	 * Protect attach/detach and child_list:
> @@ -290,6 +308,8 @@ struct perf_counter_context {
>  	int			nr_active;
>  	int			is_active;
>  	struct task_struct	*task;
> +	u64			time_now;
> +	u64			time_lost;
>  #endif
>  };

I don't have a copy of this header file handy, but from the snippet I see
here, it doesn't look as though it is as clear and as understadable as we
can possibly make it?

Painstaking documentation of the data structures is really really valuable.

> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index f054b8c..cabc820 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -109,6 +109,7 @@ counter_sched_out(struct perf_counter *counter,
>  		return;
>  
>  	counter->state = PERF_COUNTER_STATE_INACTIVE;
> +	counter->last_stopped = ctx->time_now;
>  	counter->hw_ops->disable(counter);
>  	counter->oncpu = -1;
>  
> @@ -245,6 +246,59 @@ retry:
>  }
>  
>  /*
> + * Get the current time for this context.
> + * If this is a task context, we use the task's task clock,
> + * or for a per-cpu context, we use the cpu clock.
> + */
> +static u64 get_context_time(struct perf_counter_context *ctx, int update)
> +{
> +	struct task_struct *curr = ctx->task;
> +
> +	if (!curr)
> +		return cpu_clock(smp_processor_id());
> +
> +	return __task_delta_exec(curr, update) + curr->se.sum_exec_runtime;
> +}
> +
> +/*
> + * Update the record of the current time in a context.
> + */
> +static void update_context_time(struct perf_counter_context *ctx, int update)
> +{
> +	ctx->time_now = get_context_time(ctx, update) - ctx->time_lost;
> +}
> +
> +/*
> + * Update the time_enabled and time_running fields for a counter.
> + */
> +static void update_counter_times(struct perf_counter *counter)
> +{
> +	struct perf_counter_context *ctx = counter->ctx;
> +	u64 run_end;
> +
> +	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {

This is a plain old state machine?

Placing significance in this manner on the ordinal value of particular
states is unusual and unexpected.  Also a bit fragile, as people would
_expect_ to be able to insert new states in any old place.

Hopefully the comments at the definition site clear all this up ;)

> +		counter->time_enabled = ctx->time_now - counter->start_enabled;
> +		if (counter->state == PERF_COUNTER_STATE_INACTIVE)
> +			run_end = counter->last_stopped;
> +		else
> +			run_end = ctx->time_now;
> +		counter->time_running = run_end - counter->start_running;
> +	}
> +}
> +
> +/*
> + * Update time_enabled and time_running for all counters in a group.
> + */
> +static void update_group_times(struct perf_counter *leader)
> +{
> +	struct perf_counter *counter;
> +
> +	update_counter_times(leader);
> +	list_for_each_entry(counter, &leader->sibling_list, list_entry)
> +		update_counter_times(counter);
> +}

The locking for the list walk is?  It _looks_ like
spin_lock_irq(ctx->lock), but I wasn't able to verify all callsites.

>  
>  	/*
>  	 * Return end-of-file for a read on a counter that is in
> @@ -1202,10 +1296,27 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
>  		return 0;
>  
>  	mutex_lock(&counter->mutex);
> -	cntval = perf_counter_read(counter);
> +	values[0] = perf_counter_read(counter);
> +	n = 1;
> +	if (counter->hw_event.read_format & PERF_FORMAT_TIME_ENABLED)
> +		values[n++] = counter->time_enabled +
> +			atomic64_read(&counter->child_time_enabled);
> +	if (counter->hw_event.read_format & PERF_FORMAT_TIME_RUNNING)
> +		values[n++] = counter->time_running +
> +			atomic64_read(&counter->child_time_running);
>  	mutex_unlock(&counter->mutex);
>  
> -	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
> +	if (count != n * sizeof(u64))
> +		return -EINVAL;
> +
> +	if (!access_ok(VERIFY_WRITE, buf, count))
> +		return -EFAULT;
> +	

<panics>

Oh.

It would be a lot more reassuring to verify `uptr', rather than `buf' here.

The patch adds new trailing whitespace.  checkpatch helps.

> +	for (i = 0; i < n; ++i)
> +		if (__put_user(values[i], uptr + i))
> +			return -EFAULT;

And here we iterate across `n', whereas we verified `count'.

Can this be cleaned up a bit?  Bear in mind that any maintenance errors
which result from this coding will cause security holes.

> +	return count;
>  }

