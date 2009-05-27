Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZE0XFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZE0XFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZE0XFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:05:10 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:49144 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbZE0XFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gBDZ2kJERjJQ/hh5+5Oqtoeu0s0z8hnJE5ealr3eXCaOX5dsxbJVkKhSPlZwQR6VjW
         mC2xWhrev9Be75zdVcpW5AgiusFL1BPga+gtfEewV/6SrF0Sdn0fQufw9v8bhbFDjS5j
         Xwb2/K6c/srgm2Gt32XKVcuf0rHknXxiuS/pM=
Date: Thu, 28 May 2009 01:05:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Don't convert function's local variable name
	in macro
Message-ID: <20090527230505.GG5982@nowhere>
References: <4A1D41C2.2010903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D41C2.2010903@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:36:02PM +0800, Zhaolei wrote:
> "call" is a argument of macro, but it is also used as a local variable name of
> function in macro.
> We should keep this local variable name static although it haven't cause
> problem now.
> 
> [ Impact: cleanup, no functionality changed ]


I'm applying it.

Note, I'm also changing the impact line. This is more than a
cleanup, it's a real fix to prevent from possible CPP side effects.

So I'll put instead:

[ Impact: prevent from accidental CPP substitution ]

Thanks.



> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
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

