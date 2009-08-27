Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZH0Bzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZH0Bzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 21:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZH0Bzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 21:55:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51105 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZH0Bze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:55:34 -0400
Message-ID: <4A95E737.5080805@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 09:53:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
References: <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter is correct that he should not need to worry about modules, he 
> doesn't build kernels with them ;-)
> 
> Here's another patch that moves the module ref count administration to the 
> trace events themselves. This should satisfy both you and Peter.
> 

In fact I had this patch in my mind, but I thought Peter insist
on fixing it in tracepoint. So I'm fine with this. :)

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 1b1f742..3f7c5dc 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -390,6 +390,20 @@ static inline int ftrace_get_offsets_##call(				\
>   *
>   */
>  
> +#ifdef MODULE
> +# define event_trace_up_ref()					\
> +	do {							\
> +		if (!try_module_get(THIS_MODULE)) {		\
> +			atomic_dec(&event_call->profile_count);	\
> +			return -1;				\

Should return -1 or -errno like -ENOENT?

> +		}						\
> +	} while (0)
> +# define event_trace_down_ref() module_put(THIS_MODULE)
> +#else
> +# define event_trace_up_ref() do { } while (0)
> +# define event_trace_down_ref() do { } while (0)
> +#endif
> +		
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
>  									\
> @@ -399,16 +413,20 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
>  {									\
>  	int ret = 0;							\
>  									\
> -	if (!atomic_inc_return(&event_call->profile_count))		\
> +	if (!atomic_inc_return(&event_call->profile_count)) {		\
> +		event_trace_up_ref();					\
>  		ret = register_trace_##call(ftrace_profile_##call);	\
> +	}								\
>  									\
>  	return ret;							\
>  }									\
>  									\
>  static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
>  {									\
> -	if (atomic_add_negative(-1, &event_call->profile_count))	\
> +	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
>  		unregister_trace_##call(ftrace_profile_##call);		\
> +		event_trace_down_ref();					\
> +	}								\
>  }
>  
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> 
> 
