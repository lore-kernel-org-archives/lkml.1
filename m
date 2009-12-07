Return-Path: <linux-kernel-owner+w=401wt.eu-S965002AbZLGUrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbZLGUrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935253AbZLGUrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:47:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935185AbZLGUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:47:06 -0500
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091207201829.GG8073@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org>
	 <1259849726.12870.123.camel@gandalf.stny.rr.com>
	 <20091203193549.GA18664@hmsreliant.think-freely.org>
	 <1260216282.4845.3.camel@gandalf.stny.rr.com>
	 <20091207201829.GG8073@hmsreliant.think-freely.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 07 Dec 2009 15:47:11 -0500
Message-Id: <1260218831.3518.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 15:18 -0500, Neil Horman wrote:
> On Mon, Dec 07, 2009 at 03:04:42PM -0500, Steven Rostedt wrote:
> > On Thu, 2009-12-03 at 14:35 -0500, Neil Horman wrote:
> > 
> > > Fix tracing infrastructure to allow multiple header files with TRACE_EVENTS to
> > > be included with CREATE_TRACE_EVENTS defined
> > > 
> > > I've been workingon adding a few tracepoints to the network stack, and in so
> > > doing it was convienient for me to add a second include file to
> > > net/core/net-traces.c with TRACE_EVENTS defined in them.  net-traces.c defines
> > > CREATE_TRACE_EVENTS, and during the build it was failing, complaining about
> > > duplicate definitions of __tpstrtab_<name>.  I tracked down the bug to find that
> > > define_trace.h redefined DECLARE_TRACE to be DEFINE_TRACE, so after the first
> > > run through define_trace.h (which is included from skb.h, included in
> > > net-trace.c first), the DECLARE_TRACE macro was left with an improper definition
> > > to start a new cycle with the next header.
> > > 
> > > The fix I came up with was to make sure that DECLARE_TRACE was undefined at the
> > > end of define_trace.h, and to add a conditional re-definition in tracepoint.h.
> > > This places us back in the proper state to define a new set of tracepoints in a
> > > subsequent header file.
> > > 
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > 
> > 
> > By itself, this patch breaks the build (for me). I take it that you
> > converted the napi.h file to use TRACE_EVENT. Currently it uses a
> > DECLARE_TRACE, which will break with this patch. We need a patch that
> > removes that DECLARE_TRACE before we can apply this patch.
> > 
> Yes, I did that conversion, sorry, wasn't thinking about how that might affect
> the build.  Given that converting to a TRACE_EVENT shouldn't be noticible to any
> of the users of that tracepoint (it can still be hooked in an identical
> fashion), I'd vote for just doing a monolitic patch.  please find that below.
> 
> Regards
> Neil
> 
> 
> 
> Fix tracing infrastructure to allow multiple header files with TRACE_EVENTS to
> be included with CREATE_TRACE_EVENTS defined
> 
> I've been workingon adding a few tracepoints to the network stack, and in so
> doing it was convienient for me to add a second include file to
> net/core/net-traces.c with TRACE_EVENTS defined in them.  net-traces.c defines
> CREATE_TRACE_EVENTS, and during the build it was failing, complaining about
> duplicate definitions of __tpstrtab_<name>.  I tracked down the bug to find that
> define_trace.h redefined DECLARE_TRACE to be DEFINE_TRACE, so after the first
> run through define_trace.h (which is included from skb.h, included in
> net-trace.c first), the DECLARE_TRACE macro was left with an improper definition
> to start a new cycle with the next header.
> 
> The fix I came up with was to make sure that DECLARE_TRACE was undefined at the
> end of define_trace.h, and to add a conditional re-definition in tracepoint.h.
> This places us back in the proper state to define a new set of tracepoints in a
> subsequent header file.
> 
> 
> Note this patch also converts the napi_poll tracepoint to a TRACE_EVENT.  This
> is done so that the TRACE_EVENT fix doesn't break the build, and because its
> rather pointless I think given the current tracing infrastructure to not have
> napi_poll be an independent event.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Thanks, I'll give it a test. But because this now touches networking
code, I need an Acked-by from David Miller before I can pull it in.

-- Steve



> 
> 
> linux/tracepoint.h   |   45 +++++++++++++++++++++++----------------------
> trace/define_trace.h |    1 +
> trace/events/napi.h  |   25 ++++++++++++++++++++++---
> 3 files changed, 46 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 2aac8a8..311abbf 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -58,28 +58,6 @@ struct tracepoint {
>  		rcu_read_unlock_sched_notrace();			\
>  	} while (0)
>  
> -/*
> - * Make sure the alignment of the structure in the __tracepoints section will
> - * not add unwanted padding between the beginning of the section and the
> - * structure. Force alignment to the same alignment as the section start.
> - */
> -#define DECLARE_TRACE(name, proto, args)				\
> -	extern struct tracepoint __tracepoint_##name;			\
> -	static inline void trace_##name(proto)				\
> -	{								\
> -		if (unlikely(__tracepoint_##name.state))		\
> -			__DO_TRACE(&__tracepoint_##name,		\
> -				TP_PROTO(proto), TP_ARGS(args));	\
> -	}								\
> -	static inline int register_trace_##name(void (*probe)(proto))	\
> -	{								\
> -		return tracepoint_probe_register(#name, (void *)probe);	\
> -	}								\
> -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> -	{								\
> -		return tracepoint_probe_unregister(#name, (void *)probe);\
> -	}
> -
>  
>  #define DEFINE_TRACE_FN(name, reg, unreg)				\
>  	static const char __tpstrtab_##name[]				\
> @@ -173,6 +151,29 @@ static inline void tracepoint_synchronize_unregister(void)
>   *  trace event headers under one "CREATE_TRACE_POINTS" the first include
>   *  will override the TRACE_EVENT and break the second include.
>   */
> +#if defined(CONFIG_TRACEPOINTS) && !defined(DECLARE_TRACE)
> +/*
> + * Make sure the alignment of the structure in the __tracepoints section will
> + * not add unwanted padding between the beginning of the section and the
> + * structure. Force alignment to the same alignment as the section start.
> + */
> +#define DECLARE_TRACE(name, proto, args)                                \
> +	extern struct tracepoint __tracepoint_##name;                   \
> +	static inline void trace_##name(proto)                          \
> +	{                                                               \
> +		if (unlikely(__tracepoint_##name.state))                \
> +			__DO_TRACE(&__tracepoint_##name,                \
> +				TP_PROTO(proto), TP_ARGS(args));        \
> +	}                                                               \
> +	static inline int register_trace_##name(void (*probe)(proto))   \
> +	{                                                               \
> +		return tracepoint_probe_register(#name, (void *)probe); \
> +	}                                                               \
> +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> +	{                                                               \
> +		return tracepoint_probe_unregister(#name, (void *)probe);\
> +	}
> +#endif
>  
>  #ifndef TRACE_EVENT
>  /*
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index 2a4b3bf..a3e0095 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -64,6 +64,7 @@
>  #undef TRACE_EVENT
>  #undef TRACE_EVENT_FN
>  #undef TRACE_HEADER_MULTI_READ
> +#undef DECLARE_TRACE
>  
>  /* Only undef what we defined in this file */
>  #ifdef UNDEF_TRACE_INCLUDE_FILE
> diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
> index a8989c4..25a1709 100644
> --- a/include/trace/events/napi.h
> +++ b/include/trace/events/napi.h
> @@ -1,11 +1,30 @@
> -#ifndef _TRACE_NAPI_H_
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM napi
> +
> +#if !defined(_TRACE_NAPI_H_) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_NAPI_H_
>  
>  #include <linux/netdevice.h>
>  #include <linux/tracepoint.h>
>  
> -DECLARE_TRACE(napi_poll,
> +TRACE_EVENT(napi_poll,
> +
>  	TP_PROTO(struct napi_struct *napi),
> -	TP_ARGS(napi));
> +
> +	TP_ARGS(napi),
> +
> +	TP_STRUCT__entry(
> +		__field(        struct napi_struct *,	napi)
> +        ),
> +
> +        TP_fast_assign(
> +                __entry->napi = napi;
> +        ),
> +
> +        TP_printk("napi poll on napi struct %p for device %s",
> +		__entry->napi, __entry->napi->dev->name)
> +);
>  
>  #endif
> +
> +#include <trace/define_trace.h>

