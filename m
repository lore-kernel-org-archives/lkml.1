Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZBEWRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZBEWRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZBEWRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:17:10 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:61610 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZBEWRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=j6GCnWjPSDTe/uZdno7sG9+tMUTSYrBbxZBQt9cT0HYGNOJ8sqSQ2ZtJu6zmBocok7
         2mUTo9GT4uO4dqxLUrCkvUD9ETXfOzM6JQu65woolR7dzeCyiX0UwgN38U9qJZydqoOc
         DJk/mV8vDfvDdcli5xtELWXph3BB9wlmYm4tU=
Date: Thu, 5 Feb 2009 23:17:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
Message-ID: <20090205221701.GA23999@nowhere>
References: <20090205181256.GH17653@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090205181256.GH17653@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 04:12:56PM -0200, Arnaldo Carvalho de Melo wrote:
> Impact: API change, cleanup
> 
> From ring_buffer_{lock_reserve,unlock_commit}.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  block/blktrace.c                 |    8 +++---
>  include/linux/ring_buffer.h      |    9 ++----
>  kernel/trace/kmemtrace.c         |   12 +++-----
>  kernel/trace/ring_buffer.c       |    9 +-----
>  kernel/trace/trace.c             |   56 +++++++++++++------------------------
>  kernel/trace/trace_boot.c        |   12 +++-----
>  kernel/trace/trace_branch.c      |    7 ++---
>  kernel/trace/trace_hw_branches.c |    6 ++--
>  kernel/trace/trace_mmiotrace.c   |   12 +++-----
>  kernel/trace/trace_power.c       |   12 +++-----
>  10 files changed, 51 insertions(+), 92 deletions(-)
> 
> $ codiff /tmp/vmlinux.before /tmp/vmlinux.after
> linux-2.6-tip/kernel/trace/trace.c:
>   trace_vprintk              |  -14
>   trace_graph_return         |  -14
>   trace_graph_entry          |  -10
>   trace_function             |   -8
>   __ftrace_trace_stack       |   -8
>   ftrace_trace_userstack     |   -8
>   tracing_sched_switch_trace |   -8
>   ftrace_trace_special       |  -12
>   tracing_sched_wakeup_trace |   -8
>  9 functions changed, 90 bytes removed, diff: -90
> 
> linux-2.6-tip/block/blktrace.c:
>   __blk_add_trace |   -1
>  1 function changed, 1 bytes removed, diff: -1
> 
> /tmp/vmlinux.after:
>  10 functions changed, 91 bytes removed, diff: -91


codiff... I didn't know this great tool! :-)

 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index d9d7146..8e52f24 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -165,7 +165,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  	struct task_struct *tsk = current;
>  	struct ring_buffer_event *event = NULL;
>  	struct blk_io_trace *t;
> -	unsigned long flags;
> +	unsigned long flags = 0;
>  	unsigned long *sequence;
>  	pid_t pid;
>  	int cpu, pc = 0;
> @@ -191,7 +191,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  		tracing_record_cmdline(current);
>  
>  		event = ring_buffer_lock_reserve(blk_tr->buffer,
> -						 sizeof(*t) + pdu_len, &flags);
> +						 sizeof(*t) + pdu_len);
>  		if (!event)
>  			return;
>  
> @@ -241,11 +241,11 @@ record_it:
>  			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
>  
>  		if (blk_tr) {
> -			ring_buffer_unlock_commit(blk_tr->buffer, event, flags);
> +			ring_buffer_unlock_commit(blk_tr->buffer, event);
>  			if (pid != 0 &&
>  			    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) &&
>  			    (trace_flags & TRACE_ITER_STACKTRACE) != 0)
> -				__trace_stack(blk_tr, flags, 5, pc);
> +				__trace_stack(blk_tr, 0, 5, pc);
>  			trace_wake_up();
>  			return;
>  		}
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index b3b3596..3110d92 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -74,13 +74,10 @@ void ring_buffer_free(struct ring_buffer *buffer);
>  
>  int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
>  
> -struct ring_buffer_event *
> -ring_buffer_lock_reserve(struct ring_buffer *buffer,
> -			 unsigned long length,
> -			 unsigned long *flags);
> +struct ring_buffer_event *ring_buffer_lock_reserve(struct ring_buffer *buffer,
> +						   unsigned long length);
>  int ring_buffer_unlock_commit(struct ring_buffer *buffer,
> -			      struct ring_buffer_event *event,
> -			      unsigned long flags);
> +			      struct ring_buffer_event *event);
>  int ring_buffer_write(struct ring_buffer *buffer,
>  		      unsigned long length, void *data);
>  
> diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
> index f04c062..256749d 100644
> --- a/kernel/trace/kmemtrace.c
> +++ b/kernel/trace/kmemtrace.c
> @@ -272,13 +272,11 @@ void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
>  	struct ring_buffer_event *event;
>  	struct kmemtrace_alloc_entry *entry;
>  	struct trace_array *tr = kmemtrace_array;
> -	unsigned long irq_flags;
>  
>  	if (!kmem_tracing_enabled)
>  		return;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -292,7 +290,7 @@ void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
>  	entry->gfp_flags = gfp_flags;
>  	entry->node	=	node;
>  
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  }
> @@ -305,13 +303,11 @@ void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
>  	struct ring_buffer_event *event;
>  	struct kmemtrace_free_entry *entry;
>  	struct trace_array *tr = kmemtrace_array;
> -	unsigned long irq_flags;
>  
>  	if (!kmem_tracing_enabled)
>  		return;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -322,7 +318,7 @@ void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
>  	entry->call_site = call_site;
>  	entry->ptr = ptr;
>  
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  }
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index b36d737..aee76b3 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1257,7 +1257,6 @@ static DEFINE_PER_CPU(int, rb_need_resched);
>   * ring_buffer_lock_reserve - reserve a part of the buffer
>   * @buffer: the ring buffer to reserve from
>   * @length: the length of the data to reserve (excluding event header)
> - * @flags: a pointer to save the interrupt flags
>   *
>   * Returns a reseverd event on the ring buffer to copy directly to.
>   * The user of this interface will need to get the body to write into
> @@ -1270,9 +1269,7 @@ static DEFINE_PER_CPU(int, rb_need_resched);
>   * If NULL is returned, then nothing has been allocated or locked.
>   */
>  struct ring_buffer_event *
> -ring_buffer_lock_reserve(struct ring_buffer *buffer,
> -			 unsigned long length,
> -			 unsigned long *flags)
> +ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct ring_buffer_event *event;
> @@ -1339,15 +1336,13 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
>   * ring_buffer_unlock_commit - commit a reserved
>   * @buffer: The buffer to commit to
>   * @event: The event pointer to commit.
> - * @flags: the interrupt flags received from ring_buffer_lock_reserve.
>   *
>   * This commits the data to the ring buffer, and releases any locks held.
>   *
>   * Must be paired with ring_buffer_lock_reserve.
>   */
>  int ring_buffer_unlock_commit(struct ring_buffer *buffer,
> -			      struct ring_buffer_event *event,
> -			      unsigned long flags)
> +			      struct ring_buffer_event *event)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	int cpu = raw_smp_processor_id();
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 3536ef4..eb453a2 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -783,14 +783,12 @@ trace_function(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct ftrace_entry *entry;
> -	unsigned long irq_flags;
>  
>  	/* If we are reading the ring buffer, don't trace */
>  	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
>  		return;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -798,7 +796,7 @@ trace_function(struct trace_array *tr,
>  	entry->ent.type			= TRACE_FN;
>  	entry->ip			= ip;
>  	entry->parent_ip		= parent_ip;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  }
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> @@ -809,20 +807,18 @@ static void __trace_graph_entry(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct ftrace_graph_ent_entry *entry;
> -	unsigned long irq_flags;
>  
>  	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
>  		return;
>  
> -	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, flags, pc);
>  	entry->ent.type			= TRACE_GRAPH_ENT;
>  	entry->graph_ent			= *trace;
> -	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(global_trace.buffer, event);
>  }
>  
>  static void __trace_graph_return(struct trace_array *tr,
> @@ -832,20 +828,18 @@ static void __trace_graph_return(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct ftrace_graph_ret_entry *entry;
> -	unsigned long irq_flags;
>  
>  	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
>  		return;
>  
> -	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, flags, pc);
>  	entry->ent.type			= TRACE_GRAPH_RET;
>  	entry->ret				= *trace;
> -	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(global_trace.buffer, event);
>  }
>  #endif
>  
> @@ -866,10 +860,8 @@ static void __ftrace_trace_stack(struct trace_array *tr,
>  	struct ring_buffer_event *event;
>  	struct stack_entry *entry;
>  	struct stack_trace trace;
> -	unsigned long irq_flags;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -884,7 +876,7 @@ static void __ftrace_trace_stack(struct trace_array *tr,
>  	trace.entries		= entry->caller;
>  
>  	save_stack_trace(&trace);
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  #endif
>  }
>  
> @@ -912,13 +904,11 @@ static void ftrace_trace_userstack(struct trace_array *tr,
>  	struct ring_buffer_event *event;
>  	struct userstack_entry *entry;
>  	struct stack_trace trace;
> -	unsigned long irq_flags;
>  
>  	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
>  		return;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -933,7 +923,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
>  	trace.entries		= entry->caller;
>  
>  	save_stack_trace_user(&trace);
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  #endif
>  }
>  
> @@ -950,10 +940,8 @@ ftrace_trace_special(void *__tr,
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr = __tr;
>  	struct special_entry *entry;
> -	unsigned long irq_flags;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -962,9 +950,9 @@ ftrace_trace_special(void *__tr,
>  	entry->arg1			= arg1;
>  	entry->arg2			= arg2;
>  	entry->arg3			= arg3;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> -	ftrace_trace_stack(tr, irq_flags, 4, pc);
> -	ftrace_trace_userstack(tr, irq_flags, pc);
> +	ring_buffer_unlock_commit(tr->buffer, event);
> +	ftrace_trace_stack(tr, 0, 4, pc);
> +	ftrace_trace_userstack(tr, 0, pc);
>  
>  	trace_wake_up();
>  }
> @@ -984,10 +972,8 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct ctx_switch_entry *entry;
> -	unsigned long irq_flags;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					   &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -1000,7 +986,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  	entry->next_prio		= next->prio;
>  	entry->next_state		= next->state;
>  	entry->next_cpu	= task_cpu(next);
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  	ftrace_trace_stack(tr, flags, 5, pc);
>  	ftrace_trace_userstack(tr, flags, pc);
>  }
> @@ -1013,10 +999,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct ctx_switch_entry *entry;
> -	unsigned long irq_flags;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					   &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		return;
>  	entry	= ring_buffer_event_data(event);
> @@ -1029,7 +1013,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  	entry->next_prio		= wakee->prio;
>  	entry->next_state		= wakee->state;
>  	entry->next_cpu			= task_cpu(wakee);
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  	ftrace_trace_stack(tr, flags, 6, pc);
>  	ftrace_trace_userstack(tr, flags, pc);
>  
> @@ -2841,7 +2825,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  	trace_buf[len] = 0;
>  
>  	size = sizeof(*entry) + len + 1;
> -	event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, size);
>  	if (!event)
>  		goto out_unlock;
>  	entry = ring_buffer_event_data(event);
> @@ -2852,7 +2836,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>  
>  	memcpy(&entry->buf, trace_buf, len);
>  	entry->buf[len] = 0;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>   out_unlock:
>  	spin_unlock_irqrestore(&trace_buf_lock, irq_flags);
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index 1f07895..4e08deb 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -132,7 +132,6 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_boot_call *entry;
> -	unsigned long irq_flags;
>  	struct trace_array *tr = boot_trace;
>  
>  	if (!tr || !pre_initcalls_finished)
> @@ -144,15 +143,14 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
>  	sprint_symbol(bt->func, (unsigned long)fn);
>  	preempt_disable();
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, 0, 0);
>  	entry->ent.type = TRACE_BOOT_CALL;
>  	entry->boot_call = *bt;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  
> @@ -164,7 +162,6 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_boot_ret *entry;
> -	unsigned long irq_flags;
>  	struct trace_array *tr = boot_trace;
>  
>  	if (!tr || !pre_initcalls_finished)
> @@ -173,15 +170,14 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
>  	sprint_symbol(bt->func, (unsigned long)fn);
>  	preempt_disable();
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, 0, 0);
>  	entry->ent.type = TRACE_BOOT_RET;
>  	entry->boot_ret = *bt;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 027e836..770e52a 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -33,7 +33,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  	struct trace_array *tr = branch_tracer;
>  	struct ring_buffer_event *event;
>  	struct trace_branch *entry;
> -	unsigned long flags, irq_flags;
> +	unsigned long flags;
>  	int cpu, pc;
>  	const char *p;
>  
> @@ -52,8 +52,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>  		goto out;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		goto out;
>  
> @@ -75,7 +74,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  	entry->line = f->line;
>  	entry->correct = val == expect;
>  
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>   out:
>  	atomic_dec(&tr->data[cpu]->disabled);
> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> index fff3545..e720c00 100644
> --- a/kernel/trace/trace_hw_branches.c
> +++ b/kernel/trace/trace_hw_branches.c
> @@ -175,7 +175,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	struct trace_array *tr = hw_branch_trace;
>  	struct ring_buffer_event *event;
>  	struct hw_branch_entry *entry;
> -	unsigned long irq1, irq2;
> +	unsigned long irq1;
>  	int cpu;
>  
>  	if (unlikely(!tr))
> @@ -189,7 +189,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>  		goto out;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq2);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
> @@ -198,7 +198,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	entry->ent.cpu = cpu;
>  	entry->from = from;
>  	entry->to   = to;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq2);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>   out:
>  	atomic_dec(&tr->data[cpu]->disabled);
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index ec78e24..104ddeb 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -307,10 +307,8 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_mmiotrace_rw *entry;
> -	unsigned long irq_flags;
>  
> -	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					   &irq_flags);
> +	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event) {
>  		atomic_inc(&dropped_count);
>  		return;
> @@ -319,7 +317,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
>  	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
>  	entry->ent.type			= TRACE_MMIO_RW;
>  	entry->rw			= *rw;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  }
> @@ -337,10 +335,8 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_mmiotrace_map *entry;
> -	unsigned long irq_flags;
>  
> -	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					   &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event) {
>  		atomic_inc(&dropped_count);
>  		return;
> @@ -349,7 +345,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
>  	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
>  	entry->ent.type			= TRACE_MMIO_MAP;
>  	entry->map			= *map;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  }
> diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
> index faa6ab7..3b1a292 100644
> --- a/kernel/trace/trace_power.c
> +++ b/kernel/trace/trace_power.c
> @@ -115,7 +115,6 @@ void trace_power_end(struct power_trace *it)
>  	struct ring_buffer_event *event;
>  	struct trace_power *entry;
>  	struct trace_array_cpu *data;
> -	unsigned long irq_flags;
>  	struct trace_array *tr = power_trace;
>  
>  	if (!trace_power_enabled)
> @@ -125,15 +124,14 @@ void trace_power_end(struct power_trace *it)
>  	it->end = ktime_get();
>  	data = tr->data[smp_processor_id()];
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, 0, 0);
>  	entry->ent.type = TRACE_POWER;
>  	entry->state_data = *it;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  
> @@ -148,7 +146,6 @@ void trace_power_mark(struct power_trace *it, unsigned int type,
>  	struct ring_buffer_event *event;
>  	struct trace_power *entry;
>  	struct trace_array_cpu *data;
> -	unsigned long irq_flags;
>  	struct trace_array *tr = power_trace;
>  
>  	if (!trace_power_enabled)
> @@ -162,15 +159,14 @@ void trace_power_mark(struct power_trace *it, unsigned int type,
>  	it->end = it->stamp;
>  	data = tr->data[smp_processor_id()];
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> -					 &irq_flags);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
>  	if (!event)
>  		goto out;
>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, 0, 0);
>  	entry->ent.type = TRACE_POWER;
>  	entry->state_data = *it;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +	ring_buffer_unlock_commit(tr->buffer, event);
>  
>  	trace_wake_up();
>  
> -- 
> 1.6.0.6
> 


I don't what Steven planned (or not) with this flag.
If it's not related to his lockless ring buffer project or anything, this
cleanup is welcome.

