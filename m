Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZLCOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZLCOPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbZLCOPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:15:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37770 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZLCOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:15:22 -0500
Subject: Re: [PATCH] Fix tracing infrastructure to support multiple
 includes when defining CREATE_TRACE_POINTS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20091202191916.GA7589@hmsreliant.think-freely.org>
References: <20091202191916.GA7589@hmsreliant.think-freely.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 03 Dec 2009 09:15:26 -0500
Message-Id: <1259849726.12870.123.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 14:19 -0500, Neil Horman wrote:
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
> subsequent header file.  Not sure if theres a better way to handle this, but
> this worked well for me, allowing me to include multiple headers with
> TRACE_EVENT macros in a c file with CREATE_TRACE_POINTS defined.
> 

Nice, just some comments below.

> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
> linux/tracepoint.h   |   18 ++++++++++++++++++
> trace/define_trace.h |    1 +
> 2 files changed, 19 insertions(+)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 2aac8a8..562d8ba 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -173,6 +173,24 @@ static inline void tracepoint_synchronize_unregister(void)
>   *  trace event headers under one "CREATE_TRACE_POINTS" the first include
>   *  will override the TRACE_EVENT and break the second include.
>   */
> +#ifndef DECLARE_TRACE
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

You duplicate the DECLARE_TRACE from above and place it into an
unprotected area. Why not move it instead of duplicating it. This is
just a bug waiting to happen if we ever need to modify DECLARE_TRACE.

If you change it to:

#if !defined(CONFIG_TRACEPOINTS) && !defined(DECLARE_TRACE)

#define DECLARE_TRACE(...) ....

#endif

Then you can remove the first definition of it. The first time
processing the file, when it hits the #ifndef DECLARE_TRACE in the
_LINUX_TRACEPOINT_H conditional, it still does not define DECLARE_TRACE,
and then when it exits that conditional, it does.

-- Steve


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

