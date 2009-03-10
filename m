Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZCJJyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZCJJyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZCJJyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:54:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53319 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZCJJyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:54:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/7] tracing: new format for specialized trace points
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090310045811.279394388@goodmis.org>
References: <20090310045710.286915983@goodmis.org> <20090310045811.279394388@goodmis.org>
Message-Id: <20090310181355.475E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 18:54:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have few comment.


> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
> index d94179a..5cca4c9 100644
> --- a/kernel/trace/trace_event_types.h
> +++ b/kernel/trace/trace_event_types.h
> @@ -106,9 +106,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
>  	TRACE_STRUCT(
>  		TRACE_FIELD(unsigned long, ip, ip)
>  		TRACE_FIELD(unsigned int, depth, depth)
> +		TRACE_FIELD(char *, fmt, fmt)
>  		TRACE_FIELD_ZERO_CHAR(buf)
>  	),
> -	TP_RAW_FMT("%08lx (%d) %s")
> +	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
>  );

I'm not sure about what mean /sys/kernel/debug/tracing/events/ftrace/print/format..

FWIW, I think the internal representation of trace_printk() is

struct print_entry {
        struct trace_entry      ent;
        unsigned long           ip;
        int                     depth;
        const char              *fmt;
        u32                     buf[];
};

then, buf doesn't gurantee NUL-termination, right?


> @@ -665,21 +534,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
>  				   "'%s/enable' entry\n", call->name);
>  	}
>  
> -	/* Only let type be writable, if we can change it */
> -	entry = debugfs_create_file("type",
> -				    call->raw_init ? 0644 : 0444,
> -				    call->dir, call,
> -				    &ftrace_type_fops);
> -	if (!entry)
> -		pr_warning("Could not create debugfs "
> -			   "'%s/type' entry\n", call->name);
> -
> -	entry = debugfs_create_file("available_types", 0444, call->dir, call,
> -				    &ftrace_available_types_fops);
> -	if (!entry)
> -		pr_warning("Could not create debugfs "
> -			   "'%s/available_types' entry\n", call->name);
> -
>  	/* A trace may not want to export its format */
>  	if (!call->show_format)
>  		return 0;

this code mean, the output type of event use debug/tracing/trace_options now, right?


> @@ -704,13 +558,6 @@ static __init int event_trace_init(void)
>  	if (!d_tracer)
>  		return 0;
>  
> -	entry = debugfs_create_file("available_events", 0444, d_tracer,
> -				    (void *)&show_event_seq_ops,
> -				    &ftrace_avail_fops);
> -	if (!entry)
> -		pr_warning("Could not create debugfs "
> -			   "'available_events' entry\n");
> -
>  	entry = debugfs_create_file("set_event", 0644, d_tracer,
>  				    (void *)&show_set_event_seq_ops,
>  				    &ftrace_set_event_fops);

Why do you remove available_events file?


> diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
> index 8e2e0f5..d91bf4c 100644
> --- a/kernel/trace/trace_events_stage_2.h
> +++ b/kernel/trace/trace_events_stage_2.h
> @@ -32,23 +32,14 @@
>   * in binary.
>   */
>  
> -#undef TRACE_STRUCT
> -#define TRACE_STRUCT(args...) args
> +#undef __entry
> +#define __entry field
>  
> -#undef TRACE_FIELD
> -#define TRACE_FIELD(type, item, assign) \
> -	field->item,
> +#undef TP_printk
> +#define TP_printk(fmt, args...) fmt "\n", args
>  
> -#undef TRACE_FIELD_SPECIAL
> -#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
> -	field->item,
> -
> -
> -#undef TP_RAW_FMT
> -#define TP_RAW_FMT(args...)	args
> -
> -#undef TRACE_EVENT_FORMAT
> -#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
> +#undef TRACE_EVENT
> +#define TRACE_EVENT(call, proto, args, tstruct, print, assign)		\
>  enum print_line_t							\
>  ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  {									\
> @@ -66,14 +57,76 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  									\
>  	field = (typeof(field))entry;					\
>  									\
> -	ret = trace_seq_printf(s, tpfmt "%s", tstruct "\n");		\
> +	ret = trace_seq_printf(s, print);				\
>  	if (!ret)							\
>  		return TRACE_TYPE_PARTIAL_LINE;				\
>  									\
>  	return TRACE_TYPE_HANDLED;					\
>  }

the header comment need the same chnge too.


>  #include <trace/trace_event_types.h>
> diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> index 41b82b9..8e398d8 100644
> --- a/kernel/trace/trace_events_stage_3.h
> +++ b/kernel/trace/trace_events_stage_3.h
> @@ -144,27 +144,15 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.unregfunc		= ftrace_unreg_event_##call,		\
>  }
>  
> -#undef TRACE_FIELD
> -#define TRACE_FIELD(type, item, assign)\
> -	entry->item = assign;
> -
> -#undef TRACE_FIELD
> -#define TRACE_FIELD(type, item, assign)\
> -	entry->item = assign;
> -
> -#undef TP_CMD
> -#define TP_CMD(cmd...)	cmd
> -
> -#undef TRACE_ENTRY
> -#define TRACE_ENTRY	entry
> +#undef TRACE_EVENT_FORMAT
> +#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, raw)	\
> +	TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))
>  
> -#undef TRACE_FIELD_SPECIAL
> -#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
> -	cmd;
> +#undef __entry
> +#define __entry entry
>  
> -#undef TRACE_EVENT_FORMAT
> -#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
> -_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
> +#undef TRACE_EVENT
> +#define TRACE_EVENT(call, proto, args, tstruct, print, assign)		\
>  									\
>  static struct ftrace_event_call event_##call;				\
>  									\
> @@ -185,7 +173,7 @@ static void ftrace_raw_event_##call(proto)				\
>  		return;							\
>  	entry	= ring_buffer_event_data(event);			\
>  									\
> -	tstruct;							\
> +	assign;								\
>  									\
>  	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
>  }									\

ditto

> @@ -226,10 +214,8 @@ __attribute__((__aligned__(4)))						\
>  __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name 			= #call,				\
>  	.system			= __stringify(TRACE_SYSTEM),		\
> -	.regfunc		= ftrace_reg_event_##call,		\
> -	.unregfunc		= ftrace_unreg_event_##call,		\
>  	.raw_init		= ftrace_raw_init_event_##call,		\
> -	.raw_reg		= ftrace_raw_reg_event_##call,		\
> -	.raw_unreg		= ftrace_raw_unreg_event_##call,	\
> +	.regfunc		= ftrace_raw_reg_event_##call,		\
> +	.unregfunc		= ftrace_raw_unreg_event_##call,	\
>  	.show_format		= ftrace_format_##call,			\
>  }

ditto



