Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZENUeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZENUeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZENUd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:33:57 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:59474 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZENUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=okgXtO5SAtAt0Pvf+XiBpjr+w7t8gChpTlP5xuSDBDt37WolLA5FmBCtBhksqmZI9T
         m6RVj1SbSJ60eCIoo6OAObcDKZ9wapH1EbiRjx5BsuA7MxUlaP25BTYZlSh7/UuYHvea
         cJD2E1NsPbEbmaMVnJZnV8o4lvcad04S78ze4=
Date: Thu, 14 May 2009 22:33:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
Message-ID: <20090514203351.GA5969@nowhere>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 03:45:48PM -0400, Steven Rostedt wrote:
> 
> Christoph has been asking about processing flags in the output. He rather 
> not see c2, and rather see what those three bits are. This patch is 
> an RFC to do just that. To test it out, I added the previous task state to 
> sched switch and used the flag processing to the printk of the 
> sched_switch event.
> 
> 
> To add a flag, just add __print_flags to the TP_printk arguments.
> 
> 	TP_STRUCT__entry(
> 		__field(	unsigned int,	flags		)
> 	),
> 
> 	TP_printk("flags are %s", __print_flags(__entry->flags,
> 			0, "BIT0", 1, "BIT1", 2, "BIT2", -1))
> 


Nice idea!

Also, I wonder if that would be possible to get compounded
bits such as GFP_KERNEL instead of __GFP_WAIT | __GFP_IO | __GFP_FS.

To perform that, we could just add two fields:

//__b for byte, __m for mask

#define __b(b)	(1 << b)
#define __m(m)  m

And then you can compare using a mask.
It also requires to clear the mask from the flags to avoid
duplicate matches such as GFP_KERNEL | __GFP_WAIT | __GFP_IO | __GFP_FS
and only have GFP_KERNEL, eg:

const char *
ftrace_print_flags_seq(struct trace_seq *p, unsigned long flags, ...)
{
	const char *str;
	va_list args;
	long mask;

	trace_seq_init(p);
	va_start(args, flags);
	for (mask = va_arg(args, long) ; mask >= 0; mask = va_arg(args, long)) {
		str = va_arg(args, const char *);

		if (flags & mask != mask)
			continue;

		flags &= ~mask;
		if (p->len)
			trace_seq_putc(p, '|');
		trace_seq_puts(p, str);
	}
	va_end(args);
	trace_seq_putc(p, 0);

	return p->buffer;
}





 
> Thus __print_flags prototype would look like:
> 
> const char *__print_flags(long flags, ...);
> 
> But it is actually converted to other helper functions to handle the 
> string. The trick that ftrace does, is disables preemption before calling 
> the printk, uses a percpu buffer, and passes that in to a helper function 
> that will print out the flags.
> 
>  You could see "flags are BIT1|BIT2"  if flags was 6 in the above case.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index bae51dd..10da87a 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -3,12 +3,16 @@
>  
>  #include <linux/trace_seq.h>
>  #include <linux/ring_buffer.h>
> -
> +#include <linux/percpu.h>
>  
>  struct trace_array;
>  struct tracer;
>  struct dentry;
>  
> +DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
> +const char *ftrace_print_flags_seq(struct trace_seq *p,
> +				   unsigned long flags, ...);
> +
>  /*
>   * The trace entry - the most basic unit of tracing. This is what
>   * is printed in the end as a single line in the trace output, such as:
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index dd4033c..b4fcd40 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -156,6 +156,7 @@ TRACE_EVENT(sched_switch,
>  		__array(	char,	prev_comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	prev_pid			)
>  		__field(	int,	prev_prio			)
> +		__field(	long,	prev_state			)
>  		__array(	char,	next_comm,	TASK_COMM_LEN	)
>  		__field(	pid_t,	next_pid			)
>  		__field(	int,	next_prio			)
> @@ -165,13 +166,18 @@ TRACE_EVENT(sched_switch,
>  		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
>  		__entry->prev_pid	= prev->pid;
>  		__entry->prev_prio	= prev->prio;
> +		__entry->prev_state	= prev->state;
>  		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
>  		__entry->next_pid	= next->pid;
>  		__entry->next_prio	= next->prio;
>  	),
>  
> -	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
> +	TP_printk("task %s:%d [%d] (%s) ==> %s:%d [%d]",
>  		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> +		__entry->prev_state ?
> +		  __print_flags(__entry->prev_state,
> +				0, "S", 1, "D", 2, "T", 3, "t",
> +				4, "Z", 5, "X", 6, "x", 7, "W") : "R",
>  		__entry->next_comm, __entry->next_pid, __entry->next_prio)
>  );
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index edb02bc..1b1e6e8 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -87,6 +87,7 @@
>   *	struct trace_seq *s = &iter->seq;
>   *	struct ftrace_raw_<call> *field; <-- defined in stage 1
>   *	struct trace_entry *entry;
> + *	struct trace_seq *p;
>   *	int ret;
>   *
>   *	entry = iter->ent;
> @@ -98,7 +99,9 @@
>   *
>   *	field = (typeof(field))entry;
>   *
> + *	p = get_cpu_var(ftrace_event_seq);
>   *	ret = trace_seq_printf(s, <TP_printk> "\n");
> + *	put_cpu();
>   *	if (!ret)
>   *		return TRACE_TYPE_PARTIAL_LINE;
>   *
> @@ -119,6 +122,8 @@
>  #undef __get_str
>  #define __get_str(field)	((char *)__entry + __entry->__str_loc_##field)
>  
> +#define __print_flags(flag, x...) ftrace_print_flags_seq(p, flag, x)
> +
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
>  enum print_line_t							\
> @@ -127,6 +132,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  	struct trace_seq *s = &iter->seq;				\
>  	struct ftrace_raw_##call *field;				\
>  	struct trace_entry *entry;					\
> +	struct trace_seq *p;						\
>  	int ret;							\
>  									\
>  	entry = iter->ent;						\
> @@ -138,7 +144,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  									\
>  	field = (typeof(field))entry;					\
>  									\
> +	p = &get_cpu_var(ftrace_event_seq);				\
>  	ret = trace_seq_printf(s, #call ": " print);			\
> +	put_cpu();							\



I don't understand the role of this per-cpu trace_seq variable.
It doesn't seem to be used.


Frederic.



>  	if (!ret)							\
>  		return TRACE_TYPE_PARTIAL_LINE;				\
>  									\
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 8bd9a2c..29af794 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -14,6 +14,8 @@
>  /* must be a power of 2 */
>  #define EVENT_HASHSIZE	128
>  
> +DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
> +
>  static DEFINE_MUTEX(trace_event_mutex);
>  static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
>  
> @@ -212,6 +214,31 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
>  	return 0;
>  }
>  
> +const char *
> +ftrace_print_flags_seq(struct trace_seq *p, unsigned long flags, ...)
> +{
> +	const char *str;
> +	va_list args;
> +	long bit;
> +
> +	trace_seq_init(p);
> +	va_start(args, flags);
> +	for (bit = va_arg(args, long) ; bit >= 0; bit = va_arg(args, long)) {
> +		str = va_arg(args, const char *);
> +
> +		if (!(flags & (1<<bit)))
> +			continue;
> +
> +		if (p->len)
> +			trace_seq_putc(p, '|');
> +		trace_seq_puts(p, str);
> +	}
> +	va_end(args);
> +	trace_seq_putc(p, 0);
> +
> +	return p->buffer;
> +}
> +
>  #ifdef CONFIG_KRETPROBES
>  static inline const char *kretprobed(const char *name)
>  {
> 

