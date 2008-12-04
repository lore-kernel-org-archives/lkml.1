Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYLDKbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYLDKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYLDKbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:31:43 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:43540 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYLDKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:31:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HFP+lhgksFnFiP5Q7SzYk9Fn8KLz9uoqwgTwot9mHJe85KZoCSyAeOXBwjEBtv16uc
         kmOnSWCIQhYRYDhLf3uBfijE4EnQoqURgLeOs6xF2QYTGRalnHctxfnjHhQJ/Q1gpuSA
         5ufJXsuYrveBj54Vci6/oMIABn6fajEwrnUSc=
Message-ID: <c62985530812040231v26d1f543l4487186e69fba2e7@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:31:40 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: handle ftrace_printk entries
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Tim Bird" <tim.bird@am.sony.com>, "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812032113260.28153@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49370BF7.6040108@gmail.com>
	 <alpine.DEB.1.10.0812032113260.28153@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/4 Steven Rostedt <rostedt@goodmis.org>:
> I wonder if we should add a new flag called "NOTRACE" to the new
> current->trace flags. When set, tracing is stopped for the task. Then we
> can still use spinlock here. We only want to use raw if the tracing will
> cause lockdep to fail, not just to prevent traces.
>
> We could do something like:
>
>  pause_trace(current); /* sets the "notrace" flag */
>
>  unpause_trace(current); /* clears the "notrace" flag */


You're right, I took a kind of insane approach.
I think such a flag would be useful here and probably for further uses too.
I will send a patch.

>>
>>       len = min(len, TRACE_BUF_SIZE-1);
>> @@ -3601,13 +3609,15 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>>       tracing_generic_entry_update(&entry->ent, flags, pc);
>>       entry->ent.type                 = TRACE_PRINT;
>>       entry->ip                       = ip;
>> +     entry->depth                    = depth;
>>
>>       memcpy(&entry->buf, trace_buf, len);
>>       entry->buf[len] = 0;
>>       ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
>>
>>   out_unlock:
>> -     spin_unlock_irqrestore(&trace_buf_lock, flags);
>> +     __raw_spin_unlock(&trace_buf_lock);
>> +     local_irq_restore(flags);
>>
>>   out:
>>       preempt_enable_notrace();
>> @@ -3625,7 +3635,13 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
>>               return 0;
>>
>>       va_start(ap, fmt);
>> -     ret = trace_vprintk(ip, fmt, ap);
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +     ret = trace_vprintk(ip, current->curr_ret_stack, fmt, ap);
>> +#else
>> +     ret = trace_vprintk(ip, -1, fmt, ap);
>> +#endif
>
> Could you make a macro task_curr_ret_stack(task) and in the ftrace header
> file have:
>
> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> static inline int task_curr_ret_stack(struct task_struct *task)
> {
>        return task->curr_ret_stack;
> }
> #else
> static inline int task_curr_ret_stack(struct task_struct *task)
> {
>        return -1;
> }
> #endif
>
> And then you could get rid of the #ifdefs in the code and just use:
>
>        ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
>

Ok.

>> +
>>       va_end(ap);
>>       return ret;
>>  }
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index 0565ae9..fce9889 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -117,6 +117,7 @@ struct userstack_entry {
>>  struct print_entry {
>>       struct trace_entry      ent;
>>       unsigned long           ip;
>> +     int                     depth;
>>       char                    buf[];
>>  };
>>
>> @@ -498,7 +499,8 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
>>  extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
>>                                size_t cnt);
>>  extern long ns2usecs(cycle_t nsec);
>> -extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
>> +extern int
>> +trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
>>
>>  extern unsigned long trace_flags;
>>
>> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
>> index c66578f..32b7fb9 100644
>> --- a/kernel/trace/trace_functions_graph.c
>> +++ b/kernel/trace/trace_functions_graph.c
>> @@ -173,7 +173,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu)
>>
>>   */
>>       ret = trace_seq_printf(s,
>> -             "\n ------------------------------------------\n |");
>> +             " ------------------------------------------\n");
>>       if (!ret)
>>               TRACE_TYPE_PARTIAL_LINE;
>>
>> @@ -477,6 +477,71 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>>       return TRACE_TYPE_HANDLED;
>>  }
>>
>> +static enum print_line_t
>> +print_graph_comment(struct print_entry *trace, struct trace_seq *s,
>> +                struct trace_entry *ent, struct trace_iterator *iter)
>> +{
>> +     int i;
>> +     int ret;
>> +
>> +     /* Pid */
>> +     if (verif_pid(s, ent->pid, iter->cpu) == TRACE_TYPE_PARTIAL_LINE)
>> +             return TRACE_TYPE_PARTIAL_LINE;
>> +
>> +     /* Cpu */
>> +     if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
>> +             ret = print_graph_cpu(s, iter->cpu);
>> +             if (ret == TRACE_TYPE_PARTIAL_LINE)
>> +                     return TRACE_TYPE_PARTIAL_LINE;
>> +     }
>> +
>> +     /* Proc */
>> +     if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
>> +             ret = print_graph_proc(s, ent->pid);
>> +             if (ret == TRACE_TYPE_PARTIAL_LINE)
>> +                     return TRACE_TYPE_PARTIAL_LINE;
>> +
>> +             ret = trace_seq_printf(s, " | ");
>> +             if (!ret)
>> +                     return TRACE_TYPE_PARTIAL_LINE;
>> +     }
>> +
>> +     /* No overhead */
>> +     if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
>> +             ret = trace_seq_printf(s, "  ");
>> +             if (!ret)
>> +                     return TRACE_TYPE_PARTIAL_LINE;
>> +     }
>> +
>> +     /* No time */
>> +     ret = trace_seq_printf(s, "            |  ");
>> +     if (!ret)
>> +             return TRACE_TYPE_PARTIAL_LINE;
>> +
>> +     /* Indentation */
>> +     if (trace->depth > 0)
>> +             for (i = 0; i < (trace->depth + 1) * TRACE_GRAPH_INDENT; i++) {
>> +                     ret = trace_seq_printf(s, " ");
>> +                     if (!ret)
>> +                             return TRACE_TYPE_PARTIAL_LINE;
>> +             }
>> +
>> +     /* The comment */
>> +     ret = trace_seq_printf(s, "/* %s", trace->buf);
>> +     if (!ret)
>> +             return TRACE_TYPE_PARTIAL_LINE;
>> +
>> +     if (ent->flags & TRACE_FLAG_CONT)
>> +             trace_seq_print_cont(s, iter);
>> +
>> +     ret = trace_seq_printf(s, " */\n");
>> +     if (!ret)
>> +             return TRACE_TYPE_PARTIAL_LINE;
>> +
>> +     return TRACE_TYPE_HANDLED;
>> +}
>> +
>> +
>>  enum print_line_t
>>  print_graph_function(struct trace_iterator *iter)
>>  {
>> @@ -495,6 +560,11 @@ print_graph_function(struct trace_iterator *iter)
>>               trace_assign_type(field, entry);
>>               return print_graph_return(&field->ret, s, entry, iter->cpu);
>>       }
>> +     case TRACE_PRINT: {
>> +             struct print_entry *field;
>> +             trace_assign_type(field, entry);
>> +             return print_graph_comment(field, s, entry, iter);
>> +     }
>>       default:
>>               return TRACE_TYPE_UNHANDLED;
>>       }
>> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
>> index 2a98a20..2fb6da6 100644
>> --- a/kernel/trace/trace_mmiotrace.c
>> +++ b/kernel/trace/trace_mmiotrace.c
>> @@ -366,5 +366,5 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
>>
>>  int mmio_trace_printk(const char *fmt, va_list args)
>>  {
>> -     return trace_vprintk(0, fmt, args);
>> +     return trace_vprintk(0, -1, fmt, args);
>>  }
>> --
>
>
> Other than what I commented above.
>
> Acked-by: Steven Rostedt <srostedt@redhat.com>


Thanks!
