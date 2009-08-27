Return-Path: <linux-kernel-owner+w=401wt.eu-S1751227AbZH0G0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbZH0G0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZH0G0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:26:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZH0G0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:26:21 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com>
References: <1251197235.7538.1142.camel@twins>
	 <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com>
	 <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins>
	 <4A94DFF4.5030301@cn.fujitsu.com>
	 <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com>
	 <20090826164624.GA21456@Krystal>
	 <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com>
	 <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal>
	 <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Aug 2009 08:25:07 +0200
Message-Id: <1251354307.18584.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 15:48 -0400, Steven Rostedt wrote:

> Here's another patch that moves the module ref count administration to the 
> trace events themselves. This should satisfy both you and Peter.


> +#ifdef MODULE
> +# define event_trace_up_ref()					\
> +	do {							\
> +		if (!try_module_get(THIS_MODULE)) {		\
> +			atomic_dec(&event_call->profile_count);	\
> +			return -1;				\
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

Ha, almost, make that {un,}register_ftrace_##call() and stick the module
gunk in there, and I'm ok.
