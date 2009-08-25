Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbZHYNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbZHYNaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZHYNai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:30:38 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63678 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZHYNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NrWeYgxpGlBn7KCMP9P2UIVXFafPmjTj8xzQaoOnjKEEtVM7Q6At0CfDAvMwmwKLLE
         BnUfM0acyEj9Rc9V2+3LK/KEzkoo36EyOc9afrbpWgFDEX4v0D/QfGx4ANFDLKCjCwSd
         KBc6sMGUiBUPqdc14UshzaV31dbGqNmbejAt8=
Date: Tue, 25 Aug 2009 15:30:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Neil Horman <nhorman@tuxdriver.com>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace_events: fix the include file dependencies
Message-ID: <20090825133029.GB6114@nowhere>
References: <4A937EF5.4040505@cn.fujitsu.com> <4A937F5E.3020802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A937F5E.3020802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 02:06:22PM +0800, Xiao Guangrong wrote:
> The TRACE_EVENT depend on the include/linux/tracepoint.h first
> and include/trace/ftrace.h later, if we include the ftrace.h early,
> It'll occur building error, like blow:
> 
> Both define TRACE_EVENT in trace_a.h and trace_b.h, if we include
> those in .c file, like this:
> 
> #define CREATE_TRACE_POINTS
> include <trace/events/trace_a.h>
> include <trace/events/trace_b.h>
> 
> There are can't work,  because the TRACE_EVENT has re-defined by
> the previous .h file
> 
> Reported-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/linux/tracepoint.h   |    3 +--
>  include/trace/define_trace.h |    1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 5984ed0..8170985 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -180,6 +180,7 @@ static inline void tracepoint_synchronize_unregister(void)
>  }
>  
>  #define PARAMS(args...) args
> +#endif


Please add a comment to explain what your endifs are closing, that helps
for reviews. Especially while walking on such complicated header files,
it's a crutch.

I guess this one closes _LINUX_TRACEPOINT_H, right?


>  
>  #ifndef TRACE_EVENT
>  /*
> @@ -287,5 +288,3 @@ static inline void tracepoint_synchronize_unregister(void)
>  #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
>  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
>  #endif
> -
> -#endif
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index 76e93bf..202cecd 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -52,6 +52,7 @@
>  #include <trace/ftrace.h>
>  #endif
>  
> +#undef TRACE_EVENT
>  #undef TRACE_HEADER_MULTI_READ
>  
>  /* Only undef what we defined in this file */


Well, hopefully we are not missing something subtle, but
yeah that seems to solve the problem, for both CONFIG_EVENT_TRACING
and !CONFIG_EVENT_TRACING cases.
And that seems to also fit well whenever CREATE_TRACE_POINTS is
defined or not.

Other than the missing comment:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.

