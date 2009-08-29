Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZH2KVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZH2KVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 06:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZH2KVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 06:21:05 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40979 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZH2KVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 06:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ClItSdXQtBstCCEYb4smTa0YI2tbefGTLrheYL4ovPe8pcv7ADClDI67ITpLrefM7b
         Mz3HuIrurjPEwPBfCEjYq+CJ2NLbqLp275wFnADzMTKe0nJdz18VsPZ/JwbhMmYsxhrL
         GxnyZNSN+ytFgAwyxpF/7PqVftwkXRZ8QsQw0=
Date: Sat, 29 Aug 2009 12:21:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: block-able ring_buffer consumer
Message-ID: <20090829102100.GB6418@nowhere>
References: <4A95F768.7070701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A95F768.7070701@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 11:03:04AM +0800, Lai Jiangshan wrote:
> 
> makes consumer side(per_cpu/cpu#/trace_pipe_raw) block-able,
> which is a TODO in trace.c
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


No need to use signed, it's implicit in the long type.



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



Hmm, that looks really not a good idea. The tracing shouldn't ever impact
the system when it is inactive.
Especially in such a fast path like the timer interrupt.



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


That seems a too generic name. May be consumer_queue?


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


ACCESS_ONCE makes sense if you loop, to ensure the value
is not cached through iteration, but there I'm not sure this is
useful.



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



This may need a small comment to explain you are checking that the reader
is not completely consumed.


