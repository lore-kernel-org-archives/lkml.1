Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZHaSDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZHaSDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZHaSDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:03:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39499 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZHaSDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:03:32 -0400
Date: Mon, 31 Aug 2009 14:03:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
 TRACE_EVENT
In-Reply-To: <4A9B6AA7.5020508@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908311402150.13931@gandalf.stny.rr.com>
References: <4A9B6AA7.5020508@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 31 Aug 2009, Xiao Guangrong wrote:

> - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
>   like below:
> 
>    sshd-2503  [000]    71.920846: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
>    sshd-2503  [000]    72.020291: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
>    sshd-2503  [000]    72.020418: napi_poll: ifname=eth0 state=NAPI_STATE_SCHED weigth=16 poll=pcnet32_poll
> 
> - Remove the "DECLARE_TRACE" definiens in include/trace/define_trace.h,
>   because TRACE_EVENT not use it

The above really needs to be in a separate patch, since it is a tracing 
infrastructure change.

-- Steve

> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/trace/define_trace.h |    4 ---
>  include/trace/events/napi.h  |   43 +++++++++++++++++++++++++++++++++++++----
>  2 files changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index 2a4b3bf..6158741 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -31,10 +31,6 @@
>  		assign, print, reg, unreg)			\
>  	DEFINE_TRACE_FN(name, reg, unreg)
>  
> -#undef DECLARE_TRACE
> -#define DECLARE_TRACE(name, proto, args)	\
> -	DEFINE_TRACE(name)
> -
>  #undef TRACE_INCLUDE
>  #undef __TRACE_INCLUDE
>  
> diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
> index a8989c4..5c7a192 100644
> --- a/include/trace/events/napi.h
> +++ b/include/trace/events/napi.h
> @@ -1,11 +1,44 @@
> -#ifndef _TRACE_NAPI_H_
> -#define _TRACE_NAPI_H_
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM napi
> +
> +#if !defined(_TRACE_NAPI_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_NAPI_H
>  
>  #include <linux/netdevice.h>
>  #include <linux/tracepoint.h>
>  
> -DECLARE_TRACE(napi_poll,
> +#define show_napi_state(state) state ? __print_flags(state, "|",	\
> +	{ (1UL << NAPI_STATE_SCHED),	"NAPI_STATE_SCHED"	},	\
> +	{ (1UL << NAPI_STATE_DISABLE),	"NAPI_STATE_DISABLE"	},	\
> +	{ (1UL << NAPI_STATE_NPSVC),	"NAPI_STATE_NPSVC"	}) : "0"
> +
> +TRACE_EVENT(napi_poll,
> +
>  	TP_PROTO(struct napi_struct *napi),
> -	TP_ARGS(napi));
>  
> -#endif
> +	TP_ARGS(napi),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	state		)
> +		__field(	int,		weight		)
> +		__field(	void *,		poll		)
> +		__string(	ifname,		(napi->dev ?
> +				napi->dev->name : "backlog")	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->state	= napi->state;
> +		__entry->weight	= napi->weight;
> +		__entry->poll	= napi->poll;
> +		__assign_str(ifname, napi->dev ? napi->dev->name : "backlog")
> +	),
> +
> +	TP_printk("ifname=%s state=%s weight=%d poll=%pf",
> +		  __get_str(ifname), show_napi_state(__entry->state),
> +		  __entry->weight, __entry->poll)
> +);
> +
> +#endif /* _TRACE_NAPI_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> -- 
> 1.6.1.2
> 
> 
