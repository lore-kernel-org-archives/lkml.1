Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZIAMxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZIAMxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZIAMxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:53:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbZIAMxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:53:04 -0400
Message-ID: <4A9D192F.8080907@cn.fujitsu.com>
Date: Tue, 01 Sep 2009 20:53:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing: block-able ring_buffer consumer
References: <4A95F768.7070701@cn.fujitsu.com> <20090829102100.GB6418@nowhere>
In-Reply-To: <20090829102100.GB6418@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 27, 2009 at 11:03:04AM +0800, Lai Jiangshan wrote:
>> makes consumer side(per_cpu/cpu#/trace_pipe_raw) block-able,
>> which is a TODO in trace.c
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
>> index dc3b132..b5dcf34 100644
>> --- a/include/linux/ftrace.h
>> +++ b/include/linux/ftrace.h
>> @@ -512,4 +512,10 @@ static inline void trace_hw_branch_oops(void) {}
>>  
>>  #endif /* CONFIG_HW_BRANCH_TRACER */
>>  
>> +#ifdef CONFIG_TRACING
>> +void tracing_notify(void);
>> +#else
>> +static inline void tracing_notify(void) {}
>> +#endif
>> +
>>  #endif /* _LINUX_FTRACE_H */
>> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
>> index 7fca716..b81ceed 100644
>> --- a/include/linux/ring_buffer.h
>> +++ b/include/linux/ring_buffer.h
>> @@ -185,6 +185,10 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
>>  int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
>>  			  size_t len, int cpu, int full);
>>  
>> +void ring_buffer_notify(struct ring_buffer *buffer);
>> +signed long ring_buffer_wait_page(struct ring_buffer *buffer, int cpu,
> 
> 
> No need to use signed, it's implicit in the long type.

Ouch, I tried my best to make it returns the same type as
schedule_timeout() returns and forgot "long" == "signed long"

> 
> 
> 
>> +		signed long timeout);
>> +
>>  struct trace_seq;
>>  
>>  int ring_buffer_print_entry_header(struct trace_seq *s);
>> diff --git a/kernel/timer.c b/kernel/timer.c
>> index 6e712df..79f5596 100644
>> --- a/kernel/timer.c
>> +++ b/kernel/timer.c
>> @@ -39,6 +39,7 @@
>>  #include <linux/kallsyms.h>
>>  #include <linux/perf_counter.h>
>>  #include <linux/sched.h>
>> +#include <linux/ftrace.h>
>>  
>>  #include <asm/uaccess.h>
>>  #include <asm/unistd.h>
>> @@ -1178,6 +1179,7 @@ void update_process_times(int user_tick)
>>  	printk_tick();
>>  	scheduler_tick();
>>  	run_posix_cpu_timers(p);
>> +	tracing_notify();
> 
> 
> 
> Hmm, that looks really not a good idea. The tracing shouldn't ever impact
> the system when it is inactive.
> Especially in such a fast path like the timer interrupt.

It do nothing at most time.
It just calls tracing_notify() and then returns, but...
it still has several mb()s, I can remove this mb()s in next patch.

We cannot call wake_up() and the tracing write side, so we delay
the wake_up() until next timer interrupt.


> 
> 
> 
>>  }
>>  
>>  /*
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index f1e1533..db82b38 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -443,6 +443,7 @@ struct ring_buffer_per_cpu {
>>  	u64				write_stamp;
>>  	u64				read_stamp;
>>  	atomic_t			record_disabled;
>> +	wait_queue_head_t		sleepers;
> 
> 
> That seems a too generic name. May be consumer_queue?
> 
> 
>>  };
>>  
>>  struct ring_buffer {
>> @@ -999,6 +999,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
>>  	spin_lock_init(&cpu_buffer->reader_lock);
>>  	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
>>  	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>> +	init_waitqueue_head(&cpu_buffer->sleepers);
>>  
>>  	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
>>  			    GFP_KERNEL, cpu_to_node(cpu));
>> @@ -3318,6 +3319,77 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
>>  EXPORT_SYMBOL_GPL(ring_buffer_read);
>>  
>>  /**
>> + * ring_buffer_notify - notify the sleepers when there is any available page
>> + * @buffer: The ring buffer.
>> + */
>> +void ring_buffer_notify(struct ring_buffer *buffer)
>> +{
>> +	unsigned long flags;
>> +	struct ring_buffer_per_cpu *cpu_buffer;
>> +
>> +	cpu_buffer = buffer->buffers[smp_processor_id()];
>> +
>> +	if (!spin_trylock_irqsave(&cpu_buffer->reader_lock, flags))
>> +		return;
>> +
>> +	if (waitqueue_active(&cpu_buffer->sleepers)) {
>> +		struct buffer_page *reader_page;
>> +		struct buffer_page *commit_page;
>> +
>> +		reader_page = cpu_buffer->reader_page;
>> +		commit_page = ACCESS_ONCE(cpu_buffer->commit_page);
> 
> 
> ACCESS_ONCE makes sense if you loop, to ensure the value
> is not cached through iteration, but there I'm not sure this is
> useful.
> 

commit_page is used twice here, It needs to be loaded only once.

> 
> 
>> +
>> +		/*
>> +		 * ring_buffer_notify() is fast path, so we don't use the slow
>> +		 * rb_get_reader_page(cpu_buffer, 1) to detect available pages.
>> +		 */
>> +		if (reader_page == commit_page)
>> +			goto out;
>> +
>> +		if (reader_page->read < rb_page_commit(reader_page)
>> +				|| rb_set_head_page(cpu_buffer) != commit_page)
> 
> 
> 
> This may need a small comment to explain you are checking that the reader
> is not completely consumed.
> 
> 

Yes, it needs.

Thank a lot.

Lai.


