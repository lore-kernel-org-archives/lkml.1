Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbYJKUpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbYJKUpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYJKUph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:45:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYJKUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:45:36 -0400
Date: Sat, 11 Oct 2008 16:45:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] tracing/fastboot: Add a time field on the sched_switch
 entry
In-Reply-To: <48F10A9D.3030705@gmail.com>
Message-ID: <alpine.DEB.1.10.0810111644440.19507@gandalf.stny.rr.com>
References: <48F10A9D.3030705@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 11 Oct 2008, Frederic Weisbecker wrote:

> Add a time field on the sched_switch entry to have a better
> view of the sched events during initcalls.
> Also make the boot tracer able to handle the sched_switches
> events.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c      |    4 +-
>  kernel/trace/trace.h      |    2 +
>  kernel/trace/trace_boot.c |  101 +++++++++++++++++++++++++++++++++++---------
>  3 files changed, 85 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index acc21bb..e7d659a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -622,7 +622,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
>  	spin_unlock(&trace_cmdline_lock);
>  }
>  
> -static char *trace_find_cmdline(int pid)
> +char *trace_find_cmdline(int pid)
>  {
>  	char *cmdline = "<...>";
>  	unsigned map;
> @@ -799,6 +799,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  	entry->next_prio		= next->prio;
>  	entry->next_state		= next->state;
>  	entry->next_cpu	= task_cpu(next);
> +	entry->time			= cpu_clock(raw_smp_processor_id());
>  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>  	ftrace_trace_stack(tr, data, flags, 5, pc);

NACK.  We already have a time field in the trace buffer.

>  }
> @@ -828,6 +829,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  	entry->next_prio		= wakee->prio;
>  	entry->next_state		= wakee->state;
>  	entry->next_cpu			= task_cpu(wakee);
> +	entry->time			= cpu_clock(raw_smp_processor_id());
>  	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>  	ftrace_trace_stack(tr, data, flags, 6, pc);
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index d45a3cd..707620c 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -63,6 +63,7 @@ struct ctx_switch_entry {
>  	unsigned char		next_prio;
>  	unsigned char		next_state;
>  	unsigned int		next_cpu;
> +	unsigned long long	time;
>  };
>  
>  /*
> @@ -392,6 +393,7 @@ extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
>  				 size_t cnt);
>  extern long ns2usecs(cycle_t nsec);
>  extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
> +extern char *trace_find_cmdline(int pid);
>  
>  extern unsigned long trace_flags;
>  
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index 20d326b..316085e 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -3,6 +3,8 @@
>   *
>   * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
>   *
> + * Some parts of code (IE: sched_switch_print_line function)
> + * have been borrowed from trace.c
>   */
>  
>  #include <linux/init.h>
> @@ -14,6 +16,7 @@
>  
>  static struct trace_array *boot_trace;
>  static bool pre_initcalls_finished;
> +static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
>  
>  /* Tells the boot tracer that the pre_smp_initcalls are finished.
>   * So we are ready .
> @@ -71,26 +74,82 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)

iter->ts has the time value already for you.

-- Steve

>  	unsigned long sec, nsec_rem;
>  	unsigned long long duration = it->rettime - it->calltime;
>  
> -	if (entry->type == TRACE_BOOT) {
> -		nsec_rem = do_div(it->calltime, 1000000000);
> -		sec = (unsigned long) it->calltime;
> -		ret = trace_seq_printf(s, "[%5lu.%09lu] calling  %s @ %i\n",
> -					  sec, nsec_rem, it->func, it->caller);
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -
> -		nsec_rem = do_div(it->rettime, 1000000000);
> -		sec = (unsigned long) it->rettime;
> -		do_div(duration, 1000);
> -		ret = trace_seq_printf(s, "[%5lu.%09lu] initcall %s "
> -					  "returned %d after %lld msecs\n",
> -					  sec, nsec_rem, it->func, it->result,
> -					  duration);
> -
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -		return TRACE_TYPE_HANDLED;
> -	}
> +	nsec_rem = do_div(it->calltime, 1000000000);
> +	sec = (unsigned long) it->calltime;
> +	ret = trace_seq_printf(s, "[%5lu.%09lu] calling  %s @ %i\n",
> +				  sec, nsec_rem, it->func, it->caller);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	nsec_rem = do_div(it->rettime, 1000000000);
> +	sec = (unsigned long) it->rettime;
> +	do_div(duration, 1000);
> +	ret = trace_seq_printf(s, "[%5lu.%09lu] initcall %s "
> +				  "returned %d after %llu msecs\n",
> +				  sec, nsec_rem, it->func, it->result,
> +				  duration);
> +
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return TRACE_TYPE_HANDLED;
> +}
> +
> +static enum print_line_t sched_switch_print_line(struct trace_iterator *iter)
> +{
> +	int ret;
> +	struct trace_entry *entry = iter->ent;
> +	struct ctx_switch_entry *field;
> +	struct trace_seq *s = &iter->seq;
> +	int S, T;
> +	char *comm;
> +	unsigned long sec, nsec_rem;
> +
> +	trace_assign_type(field, entry);
> +	nsec_rem = do_div(field->time, 1000000000);
> +	sec = (unsigned long) field->time;
> +
> +	comm = trace_find_cmdline(iter->ent->pid);
> +
> +	ret = trace_seq_printf(s, "[%5lu.%09lu] ",
> +				  sec, nsec_rem);
> +
> +	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	S = field->prev_state < sizeof(state_to_char) ?
> +		state_to_char[field->prev_state] : 'X';
> +	T = field->next_state < sizeof(state_to_char) ?
> +		state_to_char[field->next_state] : 'X';
> +	ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
> +			       field->prev_pid,
> +			       field->prev_prio,
> +			       S,
> +			       entry->type == TRACE_CTX ? "==>" : "  +",
> +			       field->next_cpu,
> +			       field->next_pid,
> +			       field->next_prio,
> +			       T);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	return TRACE_TYPE_HANDLED;
> +}
> +
> +static enum print_line_t boot_trace_print_line(struct trace_iterator *iter)
> +{
> +	struct trace_entry *entry = iter->ent;
> +
> +	if (entry->type == TRACE_BOOT)
> +		return initcall_print_line(iter);
> +	if (entry->type == TRACE_CTX || entry->type == TRACE_WAKE)
> +		return sched_switch_print_line(iter);
>  	return TRACE_TYPE_UNHANDLED;
>  }
>  
> @@ -100,7 +159,7 @@ struct tracer boot_tracer __read_mostly =
>  	.init		= boot_trace_init,
>  	.reset		= reset_boot_trace,
>  	.ctrl_update	= boot_trace_ctrl_update,
> -	.print_line	= initcall_print_line,
> +	.print_line	= boot_trace_print_line,
>  };
>  
>  void trace_boot(struct boot_trace *it, initcall_t fn)
> 
> 
