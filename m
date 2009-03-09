Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZCIUs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZCIUs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZCIUr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:47:58 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:59292 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZCIUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RtQmsDchylqpHEeRQA8RkT8Rcw+I4qee3CySrRWjc0BW+XG28N939GL6HaRK8TAr+r
         KyQeLhO/rvKAmMie7F39v6qtgQFGUHWd1D7ert/hW+o8i/1llkNhApz9zlxMCzJsbwWQ
         NKVZ8HdrLC6qvUlvx2FWakdBhqZaYO4NkUGto=
Date: Mon, 9 Mar 2009 21:47:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090309204748.GD5010@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <20090307074917.GA5749@nowhere> <alpine.DEB.2.00.0903090947450.2203@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903090947450.2203@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 09:52:20AM -0400, Steven Rostedt wrote:
> 
> On Sat, 7 Mar 2009, Frederic Weisbecker wrote:
> > +
> > +
> > +static atomic_t refcount;
> > +
> > +enum print_line_t
> > +print_syscall_enter(struct trace_iterator *iter, int flags)
> > +{
> > +	struct trace_seq *s = &iter->seq;
> > +	struct trace_entry *ent = iter->ent;
> > +	struct syscall_trace_enter *trace;
> > +	enum syscall_trace_nr syscall;
> > +	const struct syscall_trace_entry *entry;
> > +	char *str = NULL;
> > +	int i, ret;
> > +
> > +	trace_assign_type(trace, ent);
> > +
> > +	syscall = trace->nr;
> > +
> > +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> 
> You still need to print a "\n" otherwise the output of the next line
> will start on the current line.

Are you sure?
This entry will be ignored. And the previous one did print a newline.
So the next one should not have any problem.

 
> > +		return TRACE_TYPE_HANDLED;
> > +
> > +	entry = &syscall_trace_entries[syscall];
> > +	if (!entry->simple_format) {
> > +		ret = entry->output.print(trace->args);
> > +		if (!ret)
> > +			return TRACE_TYPE_PARTIAL_LINE;
> > +		return TRACE_TYPE_HANDLED;
> > +	}
> > +
> > +	ret = trace_seq_printf(s, "syscall %s :", entry->name);
> > +	if (!ret)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +
> > +	for (i = 0; i < entry->nb_args; i++) {
> > +		/*
> > +		 * FIXME: the string comes from the user, but on tracing
> > +		 * output time, it may have disappeared from the memory.
> > +		 * May be better to strdup it on tracing time.
> > +		 */
> > +		if (entry->output.string_mask & (1 << i)) {
> > +			/* 128 is enough for most path */
> > +			str = strndup_user((char *)trace->args[i], 128);
> > +
> > +			/* If it faulted badly, the error shoud have been
> > +			 * handled while servicing the syscall, just ignore.
> > +			 */
> > +			if (str == ERR_PTR(-EFAULT) || str == ERR_PTR(-EINVAL)
> > +			    || str == ERR_PTR(-ENOMEM))
> > +				return TRACE_TYPE_HANDLED;
> > +
> > +			ret = trace_seq_printf(s, " %s", str);
> > +		} else {
> > +			ret = trace_seq_printf(s, " 0x%lx", trace->args[i]);
> > +		}
> > +		if (!ret)
> > +			goto end_partial;
> > +	}
> > +	if (!trace_seq_printf(s, "\n"))
> > +		goto end_partial;
> > +
> > +	kfree(str);
> > +	return TRACE_TYPE_HANDLED;
> > +
> > +end_partial:
> > +	kfree(str);
> > +	return TRACE_TYPE_PARTIAL_LINE;
> > +}
> > +
> > +enum print_line_t
> > +print_syscall_exit(struct trace_iterator *iter, int flags)
> > +{
> > +	struct trace_seq *s = &iter->seq;
> > +	struct trace_entry *ent = iter->ent;
> > +	struct syscall_trace_exit *trace;
> > +	enum syscall_trace_nr syscall;
> > +	const struct syscall_trace_entry *entry;
> > +	int ret;
> > +
> > +	trace_assign_type(trace, ent);
> > +
> > +	syscall = trace->nr;
> > +
> > +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> > +		return TRACE_TYPE_HANDLED;
> > +
> > +	entry = &syscall_trace_entries[syscall];
> > +
> > +	ret = trace_seq_printf(s, "syscall %s -> 0x%lx\n", entry->name,
> > +				trace->ret);
> > +	if (!ret)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +
> > +	return TRACE_TYPE_HANDLED;
> > +}
> > +
> > +void start_ftrace_syscalls(void)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +
> > +	if (atomic_inc_return(&refcount) != 1)
> > +		goto out;
> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +	do_each_thread(g, t) {
> > +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +
> > +	return;
> > +out:
> > +	atomic_dec(&refcount);
> > +}
> > +
> > +void stop_ftrace_syscalls(void)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +
> > +	if (atomic_dec_return(&refcount))
> > +		return;
> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +	do_each_thread(g, t) {
> > +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +}
> > +
> > +void ftrace_syscall_enter(struct pt_regs *regs)
> > +{
> > +	struct trace_array *tr = __get_global_trace();
> > +	struct syscall_trace_enter *entry;
> > +	const struct syscall_trace_entry *sys_data;
> > +	struct ring_buffer_event *event;
> > +	struct trace_array_cpu *data;
> > +	int size;
> > +	int syscall_nr;
> > +	int nr_offset;
> > +	int cpu;
> > +
> > +	syscall_nr = syscall_get_nr(current, regs);
> > +	nr_offset = arch_syscall_trace_nr[syscall_nr];
> > +	if (!nr_offset || nr_offset >= __SYSCALL_TRACE_END)
> > +		return;
> > +
> > +	cpu = raw_smp_processor_id();
> > +	data = tr->data[cpu];
> > +
> > +	if (unlikely(atomic_read(&data->disabled)))
> > +		return;
> > +
> > +	sys_data = &syscall_trace_entries[nr_offset];
> > +	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
> > +
> > +	event = trace_buffer_lock_reserve(tr, TRACE_SYSCALL_ENTER, size, 0, 0);
> > +	if (!event)
> > +		return;
> > +
> > +	entry = ring_buffer_event_data(event);
> > +	entry->nr = nr_offset;
> > +	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
> > +
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> 
> BTW, you should always use the matching lock. Above you used 
> trace_buffer_lock_reserve, and here you use ring_buffer_unlock_commit. 
> This may not work in the future. There is a trace_buffer_unlock_commit 
> too.

Ok. I just wondered a bit about the tests against stacktraces flags
which are unecessary here.

> 
> But you are going to change these to trace_current_buffer_lock_reserve and 
> trace_current_buffer_unlock_commit anyway ;-)
> 


Exactly :-)

Thanks!

Frederic.


> > +	trace_wake_up();
> > +}
> > +
> > +void ftrace_syscall_exit(struct pt_regs *regs)
> > +{
> > +	struct trace_array *tr = __get_global_trace();
> > +	struct syscall_trace_exit *entry;
> > +	const struct syscall_trace_entry *sys_data;
> > +	struct ring_buffer_event *event;
> > +	struct trace_array_cpu *data;
> > +	int syscall_nr;
> > +	int nr_offset;
> > +	int cpu;
> > +
> > +	syscall_nr = syscall_get_nr(current, regs);
> > +	nr_offset = arch_syscall_trace_nr[syscall_nr];
> > +	if (!nr_offset || nr_offset >= __SYSCALL_TRACE_END)
> > +		return;
> > +
> > +	cpu = raw_smp_processor_id();
> > +	data = tr->data[cpu];
> > +
> > +	if (unlikely(atomic_read(&data->disabled)))
> > +		return;
> > +
> > +	sys_data = &syscall_trace_entries[nr_offset];
> > +
> > +	event = trace_buffer_lock_reserve(tr, TRACE_SYSCALL_EXIT,
> > +				sizeof(*entry), 0, 0);
> > +	if (!event)
> > +		return;
> > +
> > +	entry = ring_buffer_event_data(event);
> > +	entry->nr = nr_offset;
> > +	entry->ret = syscall_get_return_value(current, regs);
> > +
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> 
> Same here.
> 
> -- Steve
> 
> > +	trace_wake_up();
> > +}
> > +
> > +static int init_syscall_tracer(struct trace_array *tr)
> > +{
> > +	start_ftrace_syscalls();
> > +
> > +	return 0;
> > +}
> > +
> > +static void reset_syscall_tracer(struct trace_array *tr)
> > +{
> > +	stop_ftrace_syscalls();
> > +}
> > +
> > +static struct trace_event syscall_enter_event = {
> > +	.type	 	= TRACE_SYSCALL_ENTER,
> > +	.trace		= print_syscall_enter,
> > +};
> > +
> > +static struct trace_event syscall_exit_event = {
> > +	.type	 	= TRACE_SYSCALL_EXIT,
> > +	.trace		= print_syscall_exit,
> > +};
> > +
> > +static struct tracer syscall_tracer __read_mostly = {
> > +	.name	     	= "syscall",
> > +	.init		= init_syscall_tracer,
> > +	.reset		= reset_syscall_tracer
> > +};
> > +
> > +__init int register_ftrace_syscalls(void)
> > +{
> > +	int ret;
> > +
> > +	ret = register_ftrace_event(&syscall_enter_event);
> > +	if (!ret) {
> > +		printk(KERN_WARNING "event %d failed to register\n",
> > +		       syscall_enter_event.type);
> > +		WARN_ON_ONCE(1);
> > +	}
> > +
> > +	ret = register_ftrace_event(&syscall_exit_event);
> > +	if (!ret) {
> > +		printk(KERN_WARNING "event %d failed to register\n",
> > +		       syscall_exit_event.type);
> > +		WARN_ON_ONCE(1);
> > +	}
> > +
> > +	return register_tracer(&syscall_tracer);
> > +}
> > +device_initcall(register_ftrace_syscalls);
> > -- 
> > 1.6.1
> > 
> > 
> > 

