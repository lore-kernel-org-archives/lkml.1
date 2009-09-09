Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZIIVGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZIIVGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZIIVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:06:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZIIVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:06:12 -0400
Subject: Re: [PATCH 2/3] tracing: block-able ring_buffer consumer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A95F768.7070701@cn.fujitsu.com>
References: <4A95F768.7070701@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 17:06:14 -0400
Message-Id: <1252530374.27001.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 11:03 +0800, Lai Jiangshan wrote:
> makes consumer side(per_cpu/cpu#/trace_pipe_raw) block-able,
> which is a TODO in trace.c

I'd break this up into two patches. One that adds the ring buffer notify
infrastructure to the ring buffer. The other that adds the ftrace user.

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index dc3b132..b5dcf34 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -512,4 +512,10 @@ static inline void trace_hw_branch_oops(void) {}
>  
>  #endif /* CONFIG_HW_BRANCH_TRACER */
>  
> +#ifdef CONFIG_TRACING
> +void tracing_notify(void);
> +#else
> +static inline void tracing_notify(void) {}
> +#endif
> +
>  #endif /* _LINUX_FTRACE_H */
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index 7fca716..b81ceed 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -185,6 +185,10 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
>  int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
>  			  size_t len, int cpu, int full);
>  
> +void ring_buffer_notify(struct ring_buffer *buffer);
> +signed long ring_buffer_wait_page(struct ring_buffer *buffer, int cpu,
> +		signed long timeout);
> +
>  struct trace_seq;
>  
>  int ring_buffer_print_entry_header(struct trace_seq *s);
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 6e712df..79f5596 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -39,6 +39,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/perf_counter.h>
>  #include <linux/sched.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -1178,6 +1179,7 @@ void update_process_times(int user_tick)
>  	printk_tick();
>  	scheduler_tick();
>  	run_posix_cpu_timers(p);
> +	tracing_notify();
>  }
>  
>  /*
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index f1e1533..db82b38 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -443,6 +443,7 @@ struct ring_buffer_per_cpu {
>  	u64				write_stamp;
>  	u64				read_stamp;
>  	atomic_t			record_disabled;
> +	wait_queue_head_t		sleepers;

I prefer "waiters".

>  };
>  
>  struct ring_buffer {
> @@ -999,6 +999,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
>  	spin_lock_init(&cpu_buffer->reader_lock);
>  	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
>  	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> +	init_waitqueue_head(&cpu_buffer->sleepers);
>  
>  	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
>  			    GFP_KERNEL, cpu_to_node(cpu));
> @@ -3318,6 +3319,77 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
>  EXPORT_SYMBOL_GPL(ring_buffer_read);
>  
>  /**
> + * ring_buffer_notify - notify the sleepers when there is any available page
> + * @buffer: The ring buffer.
> + */
> +void ring_buffer_notify(struct ring_buffer *buffer)
> +{
> +	unsigned long flags;
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +
> +	cpu_buffer = buffer->buffers[smp_processor_id()];
> +
> +	if (!spin_trylock_irqsave(&cpu_buffer->reader_lock, flags))
> +		return;
> +
> +	if (waitqueue_active(&cpu_buffer->sleepers)) {
> +		struct buffer_page *reader_page;
> +		struct buffer_page *commit_page;
> +
> +		reader_page = cpu_buffer->reader_page;
> +		commit_page = ACCESS_ONCE(cpu_buffer->commit_page);
> +
> +		/*
> +		 * ring_buffer_notify() is fast path, so we don't use the slow
> +		 * rb_get_reader_page(cpu_buffer, 1) to detect available pages.
> +		 */
> +		if (reader_page == commit_page)
> +			goto out;
> +
> +		if (reader_page->read < rb_page_commit(reader_page)
> +				|| rb_set_head_page(cpu_buffer) != commit_page)
> +			wake_up(&cpu_buffer->sleepers);
> +	}
> +
> +out:
> +	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> +}
> +
> +static
> +int rb_page_available(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	struct buffer_page *reader_page;
> +
> +	spin_lock_irq(&cpu_buffer->reader_lock);
> +	reader_page = rb_get_reader_page(cpu_buffer, 1);
> +	spin_unlock_irq(&cpu_buffer->reader_lock);
> +
> +	return !!reader_page;
> +}
> +
> +/**
> + * ring_buffer_wait_page - wait until there are available pages to read
> + * @buffer: The ring buffer.
> + * @cpu: The CPU buffer to be wait
> + * @timeout: timeout value in jiffies
> + *
> + * Make the current task sleep until there are available pages to read or
> + * until @timeout jiffies have elapsed or until it is interrupted by signals.
> + *
> + * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
> + * was interrupted by a signal, and the remaining jiffies otherwise
> + * if there are available pages to read before the timeout elapsed.
> + */
> +signed long
> +ring_buffer_wait_page(struct ring_buffer *buffer, int cpu, signed long timeout)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
> +
> +	return wait_event_interruptible_timeout(cpu_buffer->sleepers,
> +			rb_page_available(cpu_buffer), timeout);
> +}
> +
> +/**
>   * ring_buffer_size - return the size of the ring buffer (in bytes)
>   * @buffer: The ring buffer.
>   */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b7d873b..ee435ed 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2457,6 +2457,12 @@ int tracing_update_buffers(void)
>  	return ret;
>  }
>  
> +void tracing_notify(void)
> +{
> +	if (global_trace.buffer)
> +		ring_buffer_notify(global_trace.buffer);
> +}
> +
>  struct trace_option_dentry;
>  
>  static struct trace_option_dentry *
> @@ -3232,12 +3237,30 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
>  
>  	info->read = 0;
>  
> +	/*
> +	 * We try our best to read from full page,
> +	 * but we wait 2 seconds at most.
> +	 */
> +	if (count >= PAGE_SIZE && !(filp->f_flags & O_NONBLOCK))
> +		ring_buffer_wait_page(info->tr->buffer, info->cpu, HZ * 2);

Why do we always wait if count >= PAGE_SIZE. I don't see any check to
see if we don't already have data available.

> +
> +again:
>  	ret = ring_buffer_read_page(info->tr->buffer,
>  				    &info->spare,
>  				    count,
>  				    info->cpu, 0);
> -	if (ret < 0)
> -		return 0;
> +
> +	if (ret < 0) {
> +		ret = 0;
> +		if (!(filp->f_flags & O_NONBLOCK)) {
> +			ret = ring_buffer_wait_page(info->tr->buffer,
> +					info->cpu, MAX_SCHEDULE_TIMEOUT);
> +			if (ret > 0)
> +				goto again;
> +		}
> +
> +		return ret;
> +	}
>  
>  	pos = ring_buffer_page_len(info->spare);
>  
> @@ -3363,6 +3386,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  		len &= PAGE_MASK;
>  	}
>  
> +again:
>  	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
>  
>  	for (i = 0; i < PIPE_BUFFERS && len && entries; i++, len -= PAGE_SIZE) {
> @@ -3416,9 +3440,13 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  	if (!spd.nr_pages) {
>  		if (flags & SPLICE_F_NONBLOCK)
>  			ret = -EAGAIN;
> -		else
> -			ret = 0;
> -		/* TODO: block */
> +		else {
> +			ret = ring_buffer_wait_page(info->tr->buffer,
> +					info->cpu, MAX_SCHEDULE_TIMEOUT);
> +			if ((ssize_t)ret > 0)
> +				goto again;
> +		}
> +
>  		return ret;
>  	}

Other than my comments, I like this patch.

-- Steve


