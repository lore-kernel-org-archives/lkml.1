Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZIRCPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZIRCPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZIRCPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:15:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZIRCPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:15:02 -0400
Subject: Re: [PATCH 2/2] tracing: Allocate the ftrace event profile buffer
 dynamically
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1253237613-5589-3-git-send-email-fweisbec@gmail.com>
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
	 <1253237613-5589-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 17 Sep 2009 22:15:03 -0400
Message-Id: <1253240103.20020.253.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 03:33 +0200, Frederic Weisbecker wrote:
> Currently the trace event profile buffer is allocated in the stack. But
> this may be too much for the stack, as the events can have large
> statically defined field size and can also grow with dynamic arrays.
> 
> Allocate two per cpu buffer for each profiled events. The first cpu
> buffer is used to host every non-nmi context traces. It is protected
> by disabling the interrupts while writing and committing the trace.
> 
> The second buffer is reserved for nmi. So that there is no race between
> them and the first buffer.
> 
> The whole write/commit section is rcu protected because we release
> these buffers while deactivating a trace event for profiling.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/ftrace_event.h       |    5 ++
>  include/trace/ftrace.h             |   83 +++++++++++++++++++----------
>  kernel/trace/trace_event_profile.c |   50 +++++++++++++++++-
>  kernel/trace/trace_syscalls.c      |  103 +++++++++++++++++++++++++++++-------
>  4 files changed, 193 insertions(+), 48 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index bc103d7..497eb37 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -4,6 +4,7 @@
>  #include <linux/ring_buffer.h>
>  #include <linux/trace_seq.h>
>  #include <linux/percpu.h>
> +#include <linux/hardirq.h>
>  
>  struct trace_array;
>  struct tracer;
> @@ -132,8 +133,12 @@ struct ftrace_event_call {
>  	atomic_t		profile_count;
>  	int			(*profile_enable)(void);
>  	void			(*profile_disable)(void);
> +	char			*profile_buf;
> +	char			*profile_buf_nmi;
>  };
>  
> +#define FTRACE_MAX_PROFILE_SIZE	2048
> +
>  #define MAX_FILTER_PRED		32
>  #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index a822087..80864cf 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -648,11 +648,12 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>   *	struct ftrace_raw_##call *entry;
>   *	u64 __addr = 0, __count = 1;
>   *	unsigned long irq_flags;
> + *	struct trace_entry *ent;
>   *	int __entry_size;
>   *	int __data_size;
> + *	int __cpu
>   *	int pc;
>   *
> - *	local_save_flags(irq_flags);
>   *	pc = preempt_count();
>   *
>   *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
> @@ -663,25 +664,34 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>   *			     sizeof(u64));
>   *	__entry_size -= sizeof(u32);
>   *
> - *	do {
> - *		char raw_data[__entry_size]; <- allocate our sample in the stack
> - *		struct trace_entry *ent;
> + *	// Protect the non nmi buffer
> + *	// This also protects the rcu read side
> + *	local_irq_save(irq_flags);
> + *	__cpu = smp_processor_id();
> + *
> + *	if (in_nmi())
> + *		raw_data = rcu_dereference(event_call->profile_buf_nmi);
> + *	else
> + *		raw_data = rcu_dereference(event_call->profile_buf);
> + *
> + *	if (!raw_data)
> + *		goto end;
>   *
> - *		zero dead bytes from alignment to avoid stack leak to userspace:
> + *	raw_data = per_cpu_ptr(raw_data, __cpu);
>   *
> - *		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
> - *		entry = (struct ftrace_raw_<call> *)raw_data;
> - *		ent = &entry->ent;
> - *		tracing_generic_entry_update(ent, irq_flags, pc);
> - *		ent->type = event_call->id;
> + *	//zero dead bytes from alignment to avoid stack leak to userspace:
> + *	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
> + *	entry = (struct ftrace_raw_<call> *)raw_data;
> + *	ent = &entry->ent;
> + *	tracing_generic_entry_update(ent, irq_flags, pc);
> + *	ent->type = event_call->id;
>   *
> - *		<tstruct> <- do some jobs with dynamic arrays
> + *	<tstruct> <- do some jobs with dynamic arrays
>   *
> - *		<assign>  <- affect our values
> + *	<assign>  <- affect our values
>   *
> - *		perf_tpcounter_event(event_call->id, __addr, __count, entry,
> - *			     __entry_size);  <- submit them to perf counter
> - *	} while (0);
> + *	perf_tpcounter_event(event_call->id, __addr, __count, entry,
> + *		     __entry_size);  <- submit them to perf counter
>   *
>   * }
>   */
> @@ -704,11 +714,13 @@ static void ftrace_profile_##call(proto)				\
>  	struct ftrace_raw_##call *entry;				\
>  	u64 __addr = 0, __count = 1;					\
>  	unsigned long irq_flags;					\
> +	struct trace_entry *ent;					\
>  	int __entry_size;						\
>  	int __data_size;						\
> +	char *raw_data;							\
> +	int __cpu;							\
>  	int pc;								\
>  									\
> -	local_save_flags(irq_flags);					\
>  	pc = preempt_count();						\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> @@ -716,23 +728,38 @@ static void ftrace_profile_##call(proto)				\
>  			     sizeof(u64));				\
>  	__entry_size -= sizeof(u32);					\
>  									\
> -	do {								\
> -		char raw_data[__entry_size];				\
> -		struct trace_entry *ent;				\
> +	if (WARN_ONCE(__entry_size > FTRACE_MAX_PROFILE_SIZE,		\
> +		      "profile buffer not large enough"))		\
> +		return;							\
> +									\
> +	local_irq_save(irq_flags);					\
> +	__cpu = smp_processor_id();					\
>  									\
> -		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;	\
> -		entry = (struct ftrace_raw_##call *)raw_data;		\
> -		ent = &entry->ent;					\
> -		tracing_generic_entry_update(ent, irq_flags, pc);	\
> -		ent->type = event_call->id;				\
> +	if (in_nmi())							\
> +		raw_data = rcu_dereference(event_call->profile_buf_nmi);\
> +	else								\
> +		raw_data = rcu_dereference(event_call->profile_buf);	\
>  									\
> -		tstruct							\
> +	if (!raw_data)							\
> +		goto end;						\
>  									\
> -		{ assign; }						\
> +	raw_data = per_cpu_ptr(raw_data, __cpu);			\
>  									\
> -		perf_tpcounter_event(event_call->id, __addr, __count, entry,\
> +	*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;		\
> +	entry = (struct ftrace_raw_##call *)raw_data;			\
> +	ent = &entry->ent;						\
> +	tracing_generic_entry_update(ent, irq_flags, pc);		\
> +	ent->type = event_call->id;					\
> +									\
> +	tstruct								\
> +									\
> +	{ assign; }							\
> +									\
> +	perf_tpcounter_event(event_call->id, __addr, __count, entry,	\
>  			     __entry_size);				\
> -	} while (0);							\
> +									\
> +end:									\
> +	local_irq_restore(irq_flags);					\
>  									\
>  }
>  
> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> index df4a74e..48d9aec 100644
> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -8,12 +8,43 @@
>  #include <linux/module.h>
>  #include "trace.h"
>  
> +/*
> + * We can't use a size but a type in alloc_percpu()
> + * So let's create a dummy type that matches the desired size
> + */
> +typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
> +
>  static int ftrace_profile_enable_event(struct ftrace_event_call *event)
>  {
> +	char *buf;
> +	int ret;
> +
>  	if (atomic_inc_return(&event->profile_count))
>  		return 0;
>  
> -	return event->profile_enable();
> +	buf = (char *)alloc_percpu(profile_buf_t);

Is this allocating a buffer for every event? Why not just have one? All
events can share the same buffer. It's only a temp buffer, and can only
be used by one event at a time per cpu.

-- Steve

> +	if (!buf)
> +		return -ENOMEM;
> +
> +	rcu_assign_pointer(event->profile_buf, buf);
> +
> +	buf = (char *)alloc_percpu(profile_buf_t);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto fail_nmi;
> +	}
> +
> +	rcu_assign_pointer(event->profile_buf_nmi, buf);
> +
> +	ret = event->profile_enable();
> +	if (!ret)
> +		return 0;
> +
> +	kfree(event->profile_buf_nmi);
> +fail_nmi:
> +	kfree(event->profile_buf);
> +
> +	return ret;
>  }
>  
>  int ftrace_profile_enable(int event_id)
> @@ -36,10 +67,27 @@ int ftrace_profile_enable(int event_id)
>  
>  static void ftrace_profile_disable_event(struct ftrace_event_call *event)
>  {
> +	char *buf, *nmi_buf;
> +
>  	if (!atomic_add_negative(-1, &event->profile_count))
>  		return;
>  
>  	event->profile_disable();
> +
> +	buf = event->profile_buf;
> +	rcu_assign_pointer(event->profile_buf, NULL);
> +
> +	nmi_buf = event->profile_buf_nmi;
> +	rcu_assign_pointer(event->profile_buf_nmi, NULL);
> +
> +	/*
> +	 * Ensure every events in profiling have finished before
> +	 * releasing the buffers
> +	 */
> +	synchronize_sched();
> +
> +	free_percpu(buf);
> +	free_percpu(nmi_buf);
>  }
>  
>  void ftrace_profile_disable(int event_id)
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 8712ce3..a7ecc34 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -384,10 +384,13 @@ static int sys_prof_refcount_exit;
>  
>  static void prof_syscall_enter(struct pt_regs *regs, long id)
>  {
> -	struct syscall_trace_enter *rec;
>  	struct syscall_metadata *sys_data;
> +	struct ftrace_event_call *event;
> +	struct syscall_trace_enter *rec;
> +	char *raw_data;
>  	int syscall_nr;
>  	int size;
> +	int cpu;
>  
>  	syscall_nr = syscall_get_nr(current, regs);
>  	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
> @@ -397,25 +400,46 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
>  	if (!sys_data)
>  		return;
>  
> +	event = sys_data->enter_event;
> +
>  	/* get the size after alignment with the u32 buffer size field */
>  	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
>  	size = ALIGN(size + sizeof(u32), sizeof(u64));
>  	size -= sizeof(u32);
>  
> -	do {
> -		char raw_data[size];
> +	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
> +		      "profile buffer not large enough"))
> +		return;
>  
> -		/* zero the dead bytes from align to not leak stack to user */
> -		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
> +	/*
> +	 * We are not in nmi. Also we can't be preempted by a sysenter event
> +	 * from interrupt, so we can safely take this buffer without
> +	 * masking interrupts. But we still need rcu_read_lock to protect
> +	 * against concurrent buffer release.
> +	 */
> +	rcu_read_lock();
> +
> +	cpu = smp_processor_id();
> +	raw_data = rcu_dereference(event->profile_buf);
> +
> +	if (!raw_data)
> +		goto end;
>  
> -		rec = (struct syscall_trace_enter *) raw_data;
> -		tracing_generic_entry_update(&rec->ent, 0, 0);
> -		rec->ent.type = sys_data->enter_id;
> -		rec->nr = syscall_nr;
> -		syscall_get_arguments(current, regs, 0, sys_data->nb_args,
> -				       (unsigned long *)&rec->args);
> -		perf_tpcounter_event(sys_data->enter_id, 0, 1, rec, size);
> -	} while(0);
> +	raw_data = per_cpu_ptr(raw_data, cpu);
> +
> +	/* zero the dead bytes from align to not leak stack to user */
> +	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
> +
> +	rec = (struct syscall_trace_enter *) raw_data;
> +	tracing_generic_entry_update(&rec->ent, 0, 0);
> +	rec->ent.type = sys_data->enter_id;
> +	rec->nr = syscall_nr;
> +	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
> +			       (unsigned long *)&rec->args);
> +	perf_tpcounter_event(sys_data->enter_id, 0, 1, rec, size);
> +
> +end:
> +	rcu_read_unlock();
>  }
>  
>  int reg_prof_syscall_enter(char *name)
> @@ -460,8 +484,12 @@ void unreg_prof_syscall_enter(char *name)
>  static void prof_syscall_exit(struct pt_regs *regs, long ret)
>  {
>  	struct syscall_metadata *sys_data;
> -	struct syscall_trace_exit rec;
> +	struct ftrace_event_call *event;
> +	struct syscall_trace_exit *rec;
>  	int syscall_nr;
> +	char *raw_data;
> +	int size;
> +	int cpu;
>  
>  	syscall_nr = syscall_get_nr(current, regs);
>  	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
> @@ -471,12 +499,49 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
>  	if (!sys_data)
>  		return;
>  
> -	tracing_generic_entry_update(&rec.ent, 0, 0);
> -	rec.ent.type = sys_data->exit_id;
> -	rec.nr = syscall_nr;
> -	rec.ret = syscall_get_return_value(current, regs);
> +	event = sys_data->exit_event;
> +
> +	/* We can probably do that at build time */
> +	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
> +	size -= sizeof(u32);
> +
> +	/*
> +	 * Impossible, but be paranoid with the future
> +	 * How to put this check outside runtime?
> +	 */
> +	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
> +		"exit event has grown above profile buffer size"))
> +		return;
> +
> +	/*
> +	 * This buffer is safe against interrupt.
> +	 * But we still need rcu_read_lock to protect
> +	 * against concurrent buffer release.
> +	 */
> +	rcu_read_lock();
> +
> +	cpu = smp_processor_id();
> +	raw_data = rcu_dereference(event->profile_buf);
> +
> +	if (!raw_data)
> +		goto end;
>  
> -	perf_tpcounter_event(sys_data->exit_id, 0, 1, &rec, sizeof(rec));
> +	raw_data = per_cpu_ptr(raw_data, cpu);
> +
> +	/* zero the dead bytes from align to not leak stack to user */
> +	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
> +
> +	rec = (struct syscall_trace_exit *)raw_data;
> +
> +	tracing_generic_entry_update(&rec->ent, 0, 0);
> +	rec->ent.type = sys_data->exit_id;
> +	rec->nr = syscall_nr;
> +	rec->ret = syscall_get_return_value(current, regs);
> +
> +	perf_tpcounter_event(sys_data->exit_id, 0, 1, rec, size);
> +
> +end:
> +	rcu_read_unlock();
>  }
>  
>  int reg_prof_syscall_exit(char *name)

