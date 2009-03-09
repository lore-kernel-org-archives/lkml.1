Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZCIUne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZCIUne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZCIUnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:43:07 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:34535 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZCIUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hvDnNRwREr/qKVxkeqk82eqDigu2S6Rh7plDQo2TK3vxEUSotYmNR/idustrkWr8aU
         mHF/BCNkiWpALnZSxM1+32C24XfQ98+13q2/qUhWnoz8CJFk7D7ykVGqTJ0aOsuVJ5SO
         d9wsrTK6TjLSsA/lQhOLMTuMq+vTJO9pEMXYQ=
Date: Mon, 9 Mar 2009 21:42:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090309204255.GC5010@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903090942030.2203@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903090942030.2203@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 09:44:35AM -0400, Steven Rostedt wrote:
> 
> On Sat, 7 Mar 2009, Frederic Weisbecker wrote:
> >  
> >  libftrace-y := ftrace.o
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index cc94f86..5152be3 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -242,6 +242,12 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
> >  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> >  	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
> >  
> > +
> > +struct trace_array *__get_global_trace(void)
> > +{
> > +	return &global_trace;
> > +}
> > +
> 
> 
> Don't do that. It's opening up a can of worms ;-)



That's right. I just wanted to have the insertion done in the dedicated file.

 
> >  
> > @@ -568,6 +587,7 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
> >  #endif /* CONFIG_FTRACE_STARTUP_TEST */
> >  
> >  extern void *head_page(struct trace_array_cpu *data);
> > +extern struct trace_array *__get_global_trace(void);
> 
> Remove that too.
> 
> > +void ftrace_syscall_enter(struct pt_regs *regs)
> > +{
> > +	struct trace_array *tr = __get_global_trace();
> 
> Don't do that.
> 
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
> 
> Here you want:
> 
> 	trace_current_buffer_lock_reserve(TRACE_SYSCALL_ENTER, size, 0, 0);
> 
> 
> -- Steve


Heh! I didn't know this one! :-)
Thanks!


> 
> > +	if (!event)
> > +		return;
> > +
> > +	entry = ring_buffer_event_data(event);
> > +	entry->nr = nr_offset;
> > +	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
> > +
> > +	ring_buffer_unlock_commit(tr->buffer, event);
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
> 
> Same here.
> 
> > +	if (!event)
> > +		return;
> > +
> > +	entry = ring_buffer_event_data(event);
> > +	entry->nr = nr_offset;
> > +	entry->ret = syscall_get_return_value(current, regs);
> > +
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> > +	trace_wake_up();
> > +}
> > +
> 
> -- Steve
> 

