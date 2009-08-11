Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZHKMKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZHKMKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZHKMKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:10:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:1203 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZHKMKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RuPipIew+/qNjdnotNZYwWU3WXtk+xe6rfxt7Lq2CnSxn1ALEi9MAAeBLAnCa9DD1W
         kPHArGFDc/+jnLDAW/44S/sQF0Qn0wqKUAJlgYMaPFW449A6UEufhFaAH6yq+WYW7BX+
         73hdZAwPF4kkFzqdYnAXEfXcPD1T6sqCTcxao=
Date: Tue, 11 Aug 2009 12:09:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 07/12] add ftrace_event_call void * 'data' field
Message-ID: <20090811100904.GA4938@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <2f63f892c862efd4f58f9d3e72cb5bc55f2d0025.1249932670.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f63f892c862efd4f58f9d3e72cb5bc55f2d0025.1249932670.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:52:44PM -0400, Jason Baron wrote:
> add an optional * void pointer to 'ftrace_event_call' that is
> passed in for regfunc and unregfunc.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  include/linux/ftrace_event.h |    5 +++--
>  include/trace/ftrace.h       |    4 ++--
>  kernel/trace/trace_events.c  |    4 ++--
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index ac8c6f8..8544f12 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -112,8 +112,8 @@ struct ftrace_event_call {
>  	struct dentry		*dir;
>  	struct trace_event	*event;
>  	int			enabled;
> -	int			(*regfunc)(void);
> -	void			(*unregfunc)(void);
> +	int			(*regfunc)(void *);
> +	void			(*unregfunc)(void *);
>  	int			id;
>  	int			(*raw_init)(void);
>  	int			(*show_format)(struct trace_seq *s);
> @@ -122,6 +122,7 @@ struct ftrace_event_call {
>  	int			filter_active;
>  	struct event_filter	*filter;
>  	void			*mod;
> +	void			*data;
>  
>  	atomic_t		profile_count;
>  	int			(*profile_enable)(struct ftrace_event_call *);
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 80e5f6c..a0de384 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -568,7 +568,7 @@ static void ftrace_raw_event_##call(proto)				\
>  		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
>  }									\
>  									\
> -static int ftrace_raw_reg_event_##call(void)				\
> +static int ftrace_raw_reg_event_##call(void *ptr)			\


Shouldn't it have a __used attribute here, or something?


>  {									\
>  	int ret;							\
>  									\
> @@ -579,7 +579,7 @@ static int ftrace_raw_reg_event_##call(void)				\
>  	return ret;							\
>  }									\
>  									\
> -static void ftrace_raw_unreg_event_##call(void)				\
> +static void ftrace_raw_unreg_event_##call(void *ptr)			\



Same here.



>  {									\
>  	unregister_trace_##call(ftrace_raw_event_##call);		\
>  }									\
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index f95f847..1d289e2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -86,14 +86,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>  		if (call->enabled) {
>  			call->enabled = 0;
>  			tracing_stop_cmdline_record();
> -			call->unregfunc();
> +			call->unregfunc(call->data);
>  		}
>  		break;
>  	case 1:
>  		if (!call->enabled) {
>  			call->enabled = 1;
>  			tracing_start_cmdline_record();
> -			call->regfunc();
> +			call->regfunc(call->data);
>  		}
>  		break;
>  	}
> -- 
> 1.6.2.5
> 

