Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZILT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZILT4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 15:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZILT4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 15:56:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZILT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 15:56:51 -0400
Subject: Re: [PATCH] tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event
 macro
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <1238478556.6749.14.camel@bookworm>
References: <1238478556.6749.14.camel@bookworm>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 12 Sep 2009 15:56:52 -0400
Message-Id: <1252785412.18996.760.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 00:49 -0500, Tom Zanussi wrote:
> Frederic Weisbecker suggested that the trace_special event shouldn't be
> filterable; this patch adds a TRACE_EVENT_FORMAT_NOFILTER event macro
> that allows an event format to be exported without having a filter
> attached, and removes filtering from the trace_special event.
> 

Frederic,

Do you remember why trace_special should not be filtered? I think
earlier we use to use it for lots of special markings, but now that we
have trace_printk, at least I have not used it in a long time.

Reason why I'm asking, is that I've wrote a patch that automates the
format of the debugfs/tracing/events/ftrace/* files. I'm using macros
like we have in include/trace/events/ to create the ftrace internal
structures. This way we get rid of the manual exporting of that
directory and now the formats will be automatically match the ring
buffer internals.

This also adds some entries that were not ported, just because it is
automated we get all of them. I'm thinking it would be more powerful to
let all ftrace entries be filtered. Even the trace_printks.

What do you think?

-- Steve

> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  kernel/trace/trace.c             |    2 --
>  kernel/trace/trace.h             |    2 ++
>  kernel/trace/trace_event_types.h |    2 +-
>  kernel/trace/trace_export.c      |   33 +++++++++++++++++++++++++++++++++
>  4 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 39b5de1..5e4163d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1064,7 +1064,6 @@ ftrace_trace_special(void *__tr,
>  		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
>  		     int pc)
>  {
> -	struct ftrace_event_call *call = &event_special;
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr = __tr;
>  	struct special_entry *entry;
> @@ -1077,7 +1076,6 @@ ftrace_trace_special(void *__tr,
>  	entry->arg1			= arg1;
>  	entry->arg2			= arg2;
>  	entry->arg3			= arg3;
> -	filter_check_discard(call, entry, event);
>  	trace_buffer_unlock_commit(tr, event, 0, pc);
>  }
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index f56c628..0d2973c 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -909,6 +909,8 @@ do {									\
>  #undef TRACE_EVENT_FORMAT
>  #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
>  	extern struct ftrace_event_call event_##call;
> +#undef TRACE_EVENT_FORMAT_NOFILTER
> +#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct, tpfmt)
>  #include "trace_event_types.h"
>  
>  #endif /* _LINUX_KERNEL_TRACE_H */
> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
> index 95b147a..cfcecc4 100644
> --- a/kernel/trace/trace_event_types.h
> +++ b/kernel/trace/trace_event_types.h
> @@ -57,7 +57,7 @@ TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
>  	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
>  );
>  
> -TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
> +TRACE_EVENT_FORMAT_NOFILTER(special, TRACE_SPECIAL, special_entry, ignore,
>  	TRACE_STRUCT(
>  		TRACE_FIELD(unsigned long, arg1, arg1)
>  		TRACE_FIELD(unsigned long, arg2, arg2)
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 47989be..a16a29d 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -65,6 +65,22 @@ ftrace_format_##call(struct trace_seq *s)				\
>  	return ret;							\
>  }
>  
> +#undef TRACE_EVENT_FORMAT_NOFILTER
> +#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
> +				    tpfmt)				\
> +static int								\
> +ftrace_format_##call(struct trace_seq *s)				\
> +{									\
> +	struct args field;						\
> +	int ret;							\
> +									\
> +	tstruct;							\
> +									\
> +	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
> +									\
> +	return ret;							\
> +}
> +
>  #include "trace_event_types.h"
>  
>  #undef TRACE_ZERO_CHAR
> @@ -109,6 +125,19 @@ static int ftrace_raw_init_event_##call(void)				\
>  	return 0;							\
>  }									\
>  
> +#undef TRACE_EVENT_FORMAT_NOFILTER
> +#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
> +				    tpfmt)				\
> +									\
> +struct ftrace_event_call __used						\
> +__attribute__((__aligned__(4)))						\
> +__attribute__((section("_ftrace_events"))) event_##call = {		\
> +	.name			= #call,				\
> +	.id			= proto,				\
> +	.system			= __stringify(TRACE_SYSTEM),		\
> +	.show_format		= ftrace_format_##call,			\
> +};
> +
>  #include "trace_event_types.h"
>  
>  #undef TRACE_FIELD
> @@ -150,4 +179,8 @@ ftrace_define_fields_##call(void)					\
>  	return ret;							\
>  }
>  
> +#undef TRACE_EVENT_FORMAT_NOFILTER
> +#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
> +				    tpfmt)
> +
>  #include "trace_event_types.h"

