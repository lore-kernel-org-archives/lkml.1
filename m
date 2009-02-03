Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZBCXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZBCXIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZBCXIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:08:10 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:61655 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZBCXII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=b7zsk3N/PkE7yIbpQmaeXWDhUTal42TSTU+x3R5nFKtyWWyaEovnDaydBD3iaJ5eo1
         9/i2oENEdpQz6Vk/VK0w1DHPuumqcKjAICBYA5gm4MIBb5GqunI7G61W88zZq2yB/5lE
         2GHWG5M4SYAlDgRJ73XvQH7KP4VAE1CSIKaf8=
Date: Tue, 3 Feb 2009 23:49:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH tip 1/1] trace: judicious error checking of trace_seq
	results
Message-ID: <20090203224933.GG6344@nowhere>
References: <20090203222041.GE3440@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090203222041.GE3440@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 08:20:41PM -0200, Arnaldo Carvalho de Melo wrote:
> Impact: bugfix/cleanup
> 
> Some callsites were returning either TRACE_ITER_PARTIAL_LINE if the
> trace_seq routines (trace_seq_printf, etc) returned 0 meaning its buffer
> was full, or zero otherwise.
> 
> But...
> 
> /* Return values for print_line callback */
> enum print_line_t {
>         TRACE_TYPE_PARTIAL_LINE = 0,    /* Retry after flushing the seq */
>         TRACE_TYPE_HANDLED      = 1,
>         TRACE_TYPE_UNHANDLED    = 2     /* Relay to other output functions */
> };
> 
> In other cases the return value was not being relayed at all.
> 
> Most of the time it didn't hurt because the page wasn't get filled, but
> for correctness sake, handle the return values everywhere.


Looks like a good cleanup.
Just a small comment below..

 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  block/blktrace.c            |    2 +-
>  kernel/trace/trace.c        |   75 ++++++++++++--------------
>  kernel/trace/trace_branch.c |    2 +-
>  kernel/trace/trace_output.c |  123 ++++++++++++++++++-------------------------
>  4 files changed, 87 insertions(+), 115 deletions(-)
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index 8f5c37b..12df276 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -1165,7 +1165,7 @@ static int blk_trace_event_print(struct trace_iterator *iter, int flags)
>  	const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
>  	int ret;
>  
> -	if (trace_print_context(iter))
> +	if (!trace_print_context(iter))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index bbdfaa2..5822ff4 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1402,27 +1402,25 @@ static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
>  	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
>  	struct trace_event *event;
>  	struct trace_entry *entry = iter->ent;
> -	int ret;
>  
>  	test_cpu_buff_start(iter);
>  
>  	event = ftrace_find_event(entry->type);
>  
>  	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> -		ret = trace_print_lat_context(iter);
> -		if (ret)
> -			return ret;
> +		if (!trace_print_lat_context(iter))
> +			goto partial;
>  	}
>  
> -	if (event && event->latency_trace) {
> -		ret = event->latency_trace(iter, sym_flags);
> -		if (ret)
> -			return ret;
> -		return TRACE_TYPE_HANDLED;
> -	}
> +	if (event && event->latency_trace)
> +		return event->latency_trace(iter, sym_flags);
> +
> +	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
> +		goto partial;
>  
> -	trace_seq_printf(s, "Unknown type %d\n", entry->type);
>  	return TRACE_TYPE_HANDLED;
> +partial:
> +	return TRACE_TYPE_PARTIAL_LINE;
>  }
>  
>  static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
> @@ -1431,7 +1429,6 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
>  	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
>  	struct trace_entry *entry;
>  	struct trace_event *event;
> -	int ret;
>  
>  	entry = iter->ent;
>  
> @@ -1440,22 +1437,19 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
>  	event = ftrace_find_event(entry->type);
>  
>  	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> -		ret = trace_print_context(iter);
> -		if (ret)
> -			return ret;
> +		if (!trace_print_context(iter))
> +			goto partial;
>  	}
>  
> -	if (event && event->trace) {
> -		ret = event->trace(iter, sym_flags);
> -		if (ret)
> -			return ret;
> -		return TRACE_TYPE_HANDLED;
> -	}
> -	ret = trace_seq_printf(s, "Unknown type %d\n", entry->type);
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	if (event && event->trace)
> +		return event->trace(iter, sym_flags);
> +
> +	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
> +		goto partial;
>  
>  	return TRACE_TYPE_HANDLED;
> +partial:
> +	return TRACE_TYPE_PARTIAL_LINE;
>  }
>  
>  static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
> @@ -1463,29 +1457,25 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry;
>  	struct trace_event *event;
> -	int ret;
>  
>  	entry = iter->ent;
>  
>  	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> -		ret = trace_seq_printf(s, "%d %d %llu ",
> -			entry->pid, iter->cpu, iter->ts);
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> +		if (!trace_seq_printf(s, "%d %d %llu ",
> +				      entry->pid, iter->cpu, iter->ts))
> +			goto partial;
>  	}
>  
>  	event = ftrace_find_event(entry->type);
> -	if (event && event->raw) {
> -		ret = event->raw(iter, 0);
> -		if (ret)
> -			return ret;
> -		return TRACE_TYPE_HANDLED;
> -	}
> -	ret = trace_seq_printf(s, "%d ?\n", entry->type);
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	if (event && event->raw)
> +		return event->raw(iter, 0);
> +
> +	if (!trace_seq_printf(s, "%d ?\n", entry->type))
> +		goto partial;
>  
>  	return TRACE_TYPE_HANDLED;
> +partial:
> +	return TRACE_TYPE_PARTIAL_LINE;
>  }
>  
>  static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
> @@ -1504,8 +1494,11 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
>  	}
>  
>  	event = ftrace_find_event(entry->type);
> -	if (event && event->hex)
> -		event->hex(iter, 0);
> +	if (event && event->hex) {
> +		int ret = event->hex(iter, 0);
> +		if (ret != TRACE_TYPE_HANDLED)
> +			return ret;
> +	}
>  
>  	SEQ_PUT_FIELD_RET(s, newline);
>  
> @@ -1544,7 +1537,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
>  
>  	event = ftrace_find_event(entry->type);
>  	if (event && event->binary)
> -		event->binary(iter, 0);
> +		return event->binary(iter, 0);
>  
>  	return TRACE_TYPE_HANDLED;
>  }
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index ea62f10..f6b35e1 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -173,7 +173,7 @@ static int trace_branch_print(struct trace_iterator *iter, int flags)
>  			     field->line))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index c24503b..5b3c914 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -286,55 +286,41 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
>  	return ret;
>  }
>  
> -static void
> +static int
>  lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
>  {
>  	int hardirq, softirq;
>  	char *comm;
>  
>  	comm = trace_find_cmdline(entry->pid);
> -
> -	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
> -	trace_seq_printf(s, "%3d", cpu);
> -	trace_seq_printf(s, "%c%c",
> -			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
> -			 (entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' : '.',
> -			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
> -
>  	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
>  	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
> -	if (hardirq && softirq) {
> -		trace_seq_putc(s, 'H');
> -	} else {
> -		if (hardirq) {
> -			trace_seq_putc(s, 'h');
> -		} else {
> -			if (softirq)
> -				trace_seq_putc(s, 's');
> -			else
> -				trace_seq_putc(s, '.');
> -		}
> -	}
> +
> +	if (!trace_seq_printf(s, "%8.8s-%-5d %3d%c%c%c",
> +			      comm, entry->pid, cpu,
> +			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
> +				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
> +				  'X' : '.',
> +			      (entry->flags & TRACE_FLAG_NEED_RESCHED) ?
> +				'N' : '.',
> +			      (hardirq && softirq) ? 'H' :
> +				hardirq ? 'h' : softirq ? 's' : '.'))
> +		return 0;
>  
>  	if (entry->preempt_count)
> -		trace_seq_printf(s, "%x", entry->preempt_count);
> -	else
> -		trace_seq_puts(s, ".");
> +		return trace_seq_printf(s, "%x", entry->preempt_count);
> +	return trace_seq_puts(s, ".");
>  }
>  
>  static unsigned long preempt_mark_thresh = 100;
>  
> -static void
> +static int
>  lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
>  		    unsigned long rel_usecs)
>  {
> -	trace_seq_printf(s, " %4lldus", abs_usecs);
> -	if (rel_usecs > preempt_mark_thresh)
> -		trace_seq_puts(s, "!: ");
> -	else if (rel_usecs > 1)
> -		trace_seq_puts(s, "+: ");
> -	else
> -		trace_seq_puts(s, " : ");
> +	return trace_seq_printf(s, " %4lldus%c: ", abs_usecs,
> +				rel_usecs > preempt_mark_thresh ? '!' :
> +				  rel_usecs > 1 ? '+' : ' ');
>  }
>  
>  int trace_print_context(struct trace_iterator *iter)
> @@ -346,22 +332,14 @@ int trace_print_context(struct trace_iterator *iter)
>  	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
>  	unsigned long secs = (unsigned long)t;
>  
> -	if (!trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid))
> -		goto partial;
> -	if (!trace_seq_printf(s, "[%03d] ", entry->cpu))
> -		goto partial;
> -	if (!trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem))
> -		goto partial;
> -
> -	return 0;
> -
> -partial:
> -	return TRACE_TYPE_PARTIAL_LINE;
> +	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
> +				comm, entry->pid, entry->cpu, secs, usec_rem);
>  }
>  
>  int trace_print_lat_context(struct trace_iterator *iter)
>  {
>  	u64 next_ts;
> +	int ret;
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry = iter->ent,
>  			   *next_entry = trace_find_next_entry(iter, NULL,
> @@ -376,21 +354,22 @@ int trace_print_lat_context(struct trace_iterator *iter)
>  
>  	if (verbose) {
>  		char *comm = trace_find_cmdline(entry->pid);
> -		trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
> -				 " %ld.%03ldms (+%ld.%03ldms): ",
> -				 comm,
> -				 entry->pid, entry->cpu, entry->flags,
> -				 entry->preempt_count, iter->idx,
> -				 ns2usecs(iter->ts),
> -				 abs_usecs/1000,
> -				 abs_usecs % 1000, rel_usecs/1000,
> -				 rel_usecs % 1000);
> +		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
> +				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
> +				       entry->pid, entry->cpu, entry->flags,
> +				       entry->preempt_count, iter->idx,
> +				       ns2usecs(iter->ts),
> +				       abs_usecs / USEC_PER_MSEC,
> +				       abs_usecs % USEC_PER_MSEC,
> +				       rel_usecs / USEC_PER_MSEC,
> +				       rel_usecs % USEC_PER_MSEC);
>  	} else {
> -		lat_print_generic(s, entry, entry->cpu);
> -		lat_print_timestamp(s, abs_usecs, rel_usecs);
> +		ret = lat_print_generic(s, entry, entry->cpu);
> +		if (ret)
> +			ret = lat_print_timestamp(s, abs_usecs, rel_usecs);
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
> @@ -486,7 +465,7 @@ int unregister_ftrace_event(struct trace_event *event)
>  
>  int trace_nop_print(struct trace_iterator *iter, int flags)
>  {
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  /* TRACE_FN */
> @@ -506,7 +485,7 @@ static int trace_fn_latency(struct trace_iterator *iter, int flags)
>  	if (!trace_seq_puts(s, ")\n"))
>  		goto partial;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  
>   partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
> @@ -533,7 +512,7 @@ static int trace_fn_trace(struct trace_iterator *iter, int flags)
>  	if (!trace_seq_printf(s, "\n"))
>  		goto partial;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  
>   partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
> @@ -550,7 +529,7 @@ static int trace_fn_raw(struct trace_iterator *iter, int flags)
>  			      field->parent_ip))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_fn_hex(struct trace_iterator *iter, int flags)
> @@ -563,7 +542,7 @@ static int trace_fn_hex(struct trace_iterator *iter, int flags)
>  	SEQ_PUT_HEX_FIELD_RET(s, field->ip);
>  	SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_fn_bin(struct trace_iterator *iter, int flags)
> @@ -576,7 +555,7 @@ static int trace_fn_bin(struct trace_iterator *iter, int flags)
>  	SEQ_PUT_FIELD_RET(s, field->ip);
>  	SEQ_PUT_FIELD_RET(s, field->parent_ip);
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static struct trace_event trace_fn_event = {
> @@ -611,7 +590,7 @@ static int trace_ctxwake_print(struct trace_iterator *iter, char *delim)
>  			      T, comm))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_ctx_print(struct trace_iterator *iter, int flags)
> @@ -644,7 +623,7 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
>  			      T))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_ctx_raw(struct trace_iterator *iter, int flags)
> @@ -678,7 +657,7 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
>  	SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
>  	SEQ_PUT_HEX_FIELD_RET(s, T);
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_ctx_hex(struct trace_iterator *iter, int flags)
> @@ -705,7 +684,7 @@ static int trace_ctxwake_bin(struct trace_iterator *iter, int flags)
>  	SEQ_PUT_FIELD_RET(s, field->next_prio);
>  	SEQ_PUT_FIELD_RET(s, field->next_state);
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static struct trace_event trace_ctx_event = {
> @@ -739,7 +718,7 @@ static int trace_special_print(struct trace_iterator *iter, int flags)
>  			      field->arg3))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_special_hex(struct trace_iterator *iter, int flags)
> @@ -753,7 +732,7 @@ static int trace_special_hex(struct trace_iterator *iter, int flags)
>  	SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
>  	SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static int trace_special_bin(struct trace_iterator *iter, int flags)
> @@ -767,7 +746,7 @@ static int trace_special_bin(struct trace_iterator *iter, int flags)
>  	SEQ_PUT_FIELD_RET(s, field->arg2);
>  	SEQ_PUT_FIELD_RET(s, field->arg3);
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static struct trace_event trace_special_event = {
> @@ -801,7 +780,7 @@ static int trace_stack_print(struct trace_iterator *iter, int flags)
>  			goto partial;
>  	}
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  
>   partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
> @@ -830,7 +809,7 @@ static int trace_user_stack_print(struct trace_iterator *iter, int flags)
>  	if (!trace_seq_putc(s, '\n'))
>  		goto partial;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  
>   partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
> @@ -859,7 +838,7 @@ static int trace_print_print(struct trace_iterator *iter, int flags)
>  	if (!trace_seq_printf(s, ": %s", field->buf))
>  		goto partial;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  
>   partial:
>  	return TRACE_TYPE_PARTIAL_LINE;
> @@ -874,7 +853,7 @@ static int trace_print_raw(struct trace_iterator *iter, int flags)
>  	if (!trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf))
>  		goto partial;
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;
>  
>   partial:
>  	return TRACE_TYPE_PARTIAL_LINE;


Shouldn't these callbacks be converted into enum print_line_t ?
Perhaps for the future users who will define their own callbacks, giving
more hints about the return type...even if an enum is still an int.


> -- 
> 1.6.0.6
> 

