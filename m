Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbZE0SMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbZE0SMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762632AbZE0SMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:12:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40747 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762470AbZE0SMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:12:15 -0400
Date: Wed, 27 May 2009 14:12:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Don't convert function's local variable name in
 macro
In-Reply-To: <4A1D41C2.2010903@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905271411390.15653@gandalf.stny.rr.com>
References: <4A1D41C2.2010903@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 May 2009, Zhaolei wrote:

> "call" is a argument of macro, but it is also used as a local variable name of
> function in macro.
> We should keep this local variable name static although it haven't cause
> problem now.
> 
> [ Impact: cleanup, no functionality changed ]
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/trace/ftrace.h |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index edb02bc..6f1218e 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -375,19 +375,19 @@ static void ftrace_profile_##call(proto)				\
>  	perf_tpcounter_event(event_##call.id);				\
>  }									\
>  									\
> -static int ftrace_profile_enable_##call(struct ftrace_event_call *call) \
> +static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
>  {									\
>  	int ret = 0;							\
>  									\
> -	if (!atomic_inc_return(&call->profile_count))			\
> +	if (!atomic_inc_return(&event_call->profile_count))		\
>  		ret = register_trace_##call(ftrace_profile_##call);	\
>  									\
>  	return ret;							\
>  }									\
>  									\
> -static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
> +static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
>  {									\
> -	if (atomic_add_negative(-1, &call->profile_count))		\
> +	if (atomic_add_negative(-1, &event_call->profile_count))	\
>  		unregister_trace_##call(ftrace_profile_##call);		\
>  }
>  
> @@ -411,9 +411,9 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
>  #define __array(type, item, len)
>  
>  #undef __string
> -#define __string(item, src)						       \
> -	__str_offsets.item = __str_size +				       \
> -			     offsetof(typeof(*entry), __str_data);	       \
> +#define __string(item, src)						\
> +	__str_offsets.item = __str_size +				\
> +			     offsetof(typeof(*entry), __str_data);	\
>  	__str_size += strlen(src) + 1;
>  
>  #undef __assign_str
> @@ -429,8 +429,8 @@ static struct ftrace_event_call event_##call;				\
>  									\
>  static void ftrace_raw_event_##call(proto)				\
>  {									\
> -	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;  \
> -	struct ftrace_event_call *call = &event_##call;			\
> +	struct ftrace_str_offsets_##call __maybe_unused __str_offsets;	\
> +	struct ftrace_event_call *event_call = &event_##call;		\
>  	struct ring_buffer_event *event;				\
>  	struct ftrace_raw_##call *entry;				\
>  	unsigned long irq_flags;					\
> @@ -451,7 +451,7 @@ static void ftrace_raw_event_##call(proto)				\
>  									\
>  	assign;								\
>  									\
> -	if (!filter_current_check_discard(call, entry, event))		\
> +	if (!filter_current_check_discard(event_call, entry, event))	\
>  		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
>  }									\
>  									\
> -- 
> 1.5.5.3
> 
> 
> 
