Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab0BEOI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:08:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0BEOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:08:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=I-JJUczq-h8A:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hGzw-44bAAAA:8 a=cb3sZfbRAAAA:8 a=omOdbC7AAAAA:8 a=yPCof4ZbAAAA:8 a=Ns7IHowyBkSJVfe8dngA:9 a=whN-lFRYT4x9E5BrxLMA:7 a=AkcPv0TUfZEKNjpVvxzXkt8bdzMA:4 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=dowx1zmaLagA:10 a=7DSvI1NPTFQA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Feb 2010 09:08:20 -0500
Message-ID: <1265378900.24386.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> TRACE_EVENT_INJECT macro is the same as TRACE_EVENT but takes one
> more parameter that defines an "inject" callback to be called when
> the event is enabled.

I was just talking with Johannes about this.

> This is useful when we need to catch up with events that have
> already occured but that are required for the user.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/linux/ftrace_event.h |    1 +
>  include/linux/tracepoint.h   |    3 +++
>  include/trace/define_trace.h |    6 ++++++
>  include/trace/ftrace.h       |   31 ++++++++++++++++++++++++++++++-
>  kernel/trace/trace_events.c  |    3 +++
>  5 files changed, 43 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index cd95919..026d39b 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -126,6 +126,7 @@ struct ftrace_event_call {
>  	int			(*show_format)(struct ftrace_event_call *,
>  					       struct trace_seq *);
>  	int			(*define_fields)(struct ftrace_event_call *);
> +	void			(*inject)(void);
>  	struct list_head	fields;
>  	int			filter_active;
>  	struct event_filter	*filter;
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index f59604e..f114aec 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -291,5 +291,8 @@ static inline void tracepoint_synchronize_unregister(void)
>  #define TRACE_EVENT_FN(name, proto, args, struct,		\
>  		assign, print, reg, unreg)			\
>  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +#define TRACE_EVENT_INJECT(name, proto, args, struct,		\
> +		assign, print, inject)				\

I would much rather not add this macro and instead make a
register_event_callback() that a process could register.

Actually, I was thinking of something even a bit more functional:

Creating a command file in the event directory along with format,filter
and id.

It would default with: trace, or ftrace if you want it to be specific to
ftrace. Then we could add:

echo perf > command

which would make the call back call the perf command instead of the
ftrace one.  Or use >> to call both commands.

So instead of making an unique MACRO that is very stale, I would rather
change the structure to be much more generic.

This way you could do something like:

	register_event_command(event, "perf_inject", perf_inject, data);

And when the event is enabled, it would call the perf_inject function.

How does this sound to you?

Note, this may also clean up some of ftrace.h too.

-- Steve

> +	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
>  
>  #endif /* ifdef TRACE_EVENT (see note above) */
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index 5acfb1e..41f7ce3 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -31,6 +31,11 @@
>  		assign, print, reg, unreg)			\
>  	DEFINE_TRACE_FN(name, reg, unreg)
>  
> +#undef TRACE_EVENT_INJECT
> +#define TRACE_EVENT_INJECT(name, proto, args, tstruct,		\
> +		assign, print, inject)				\
> +	DEFINE_TRACE(name)
> +
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, name, proto, args) \
>  	DEFINE_TRACE(name)
> @@ -71,6 +76,7 @@
>  
>  #undef TRACE_EVENT
>  #undef TRACE_EVENT_FN
> +#undef TRACE_EVENT_INJECT
>  #undef DECLARE_EVENT_CLASS
>  #undef DEFINE_EVENT
>  #undef DEFINE_EVENT_PRINT
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index f2c09e4..869da37 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -37,6 +37,26 @@
>  			     PARAMS(print));		       \
>  	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
>  
> +/*
> + * TRACE_EVENT_INJECT creates an event that has an injector callback
> + * to call when the trace event is enabled, usually to trigger
> + * automatically some necessary initial traces.
> + */
> +#undef TRACE_EVENT_INJECT
> +#define TRACE_EVENT_INJECT(name, proto, args, tstruct,			\
> +		assign, print, inject)					\
> +		DECLARE_EVENT_CLASS(name,				\
> +			     PARAMS(proto),				\
> +			     PARAMS(args),		       		\
> +			     PARAMS(tstruct),		       		\
> +			     PARAMS(assign),		       		\
> +			     PARAMS(print));		       		\
> +	DEFINE_EVENT_INJECT(name, name, PARAMS(proto), PARAMS(args), inject);
> +
> +#undef DEFINE_EVENT_INJECT
> +#define DEFINE_EVENT_INJECT(template, name, proto, args, inject)	\
> +	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args));
> +
>  
>  #undef __field
>  #define __field(type, item)		type	item;
> @@ -726,7 +746,11 @@ static struct trace_event ftrace_event_type_##call = {			\
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
>  
>  #undef DEFINE_EVENT
> -#define DEFINE_EVENT(template, call, proto, args)			\
> +#define DEFINE_EVENT(template, call, proto, args)	\
> +	DEFINE_EVENT_INJECT(template, call, PARAMS(proto), PARAMS(proto), NULL)
> +
> +#undef DEFINE_EVENT_INJECT
> +#define DEFINE_EVENT_INJECT(template, call, proto, args, injector)	\
>  									\
>  static struct ftrace_event_call __used					\
>  __attribute__((__aligned__(4)))						\
> @@ -739,6 +763,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.unregfunc		= ftrace_raw_unreg_event_##call,	\
>  	.show_format		= ftrace_format_##template,		\
>  	.define_fields		= ftrace_define_fields_##template,	\
> +	.inject			= injector,				\
>  	_TRACE_PROFILE_INIT(call)					\
>  }
>  
> @@ -877,6 +902,10 @@ ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
>  			       __count, irq_flags);			\
>  }
>  
> +#undef DEFINE_EVENT_INJECT
> +#define DEFINE_EVENT_INJECT(template, call, proto, args, inject)	\
> +	DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args))
> +
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, call, proto, args)		\
>  static void ftrace_profile_##call(proto)			\
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 189b09b..5c75cc7 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -142,6 +142,9 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>  				break;
>  			}
>  			call->enabled = 1;
> +
> +			if (call->inject)
> +				call->inject();
>  		}
>  		break;
>  	}


