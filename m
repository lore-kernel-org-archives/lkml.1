Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZLGUEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZLGUEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbZLGUEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:04:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351AbZLGUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:04:38 -0500
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20091203193549.GA18664@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org>
	 <1259849726.12870.123.camel@gandalf.stny.rr.com>
	 <20091203193549.GA18664@hmsreliant.think-freely.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 07 Dec 2009 15:04:42 -0500
Message-Id: <1260216282.4845.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 14:35 -0500, Neil Horman wrote:

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
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 

By itself, this patch breaks the build (for me). I take it that you
converted the napi.h file to use TRACE_EVENT. Currently it uses a
DECLARE_TRACE, which will break with this patch. We need a patch that
removes that DECLARE_TRACE before we can apply this patch.

To keep bisectablity, we either need to make one patch that converts the
napi to TRACE_EVENT and this patch, or we need to first remove the
napi.h DECLARE_TRACE, add this patch, and then one that adds
TRACE_EVENT.

-- Steve

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

