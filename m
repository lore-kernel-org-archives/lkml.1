Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbZEZVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbZEZVlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZEZVlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:41:03 -0400
Received: from www.tglx.de ([62.245.132.106]:38692 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZEZVlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:41:01 -0400
Date: Tue, 26 May 2009 23:40:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A167615.7050208@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain>
References: <4A167615.7050208@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Xiao Guangrong wrote:

> This patch is modify from Mathieu's patch base on ingo's suggestion, the original patch
> can be found here: 
> 	http://marc.info/?l=linux-kernel&m=123791201816247&w=2

  I have a hard time to connect this patch to the original one.
 
> +TRACE_EVENT(timer_start,
> +
> +	TP_PROTO(struct timer_list *timer, int cpu),
> +
> +	TP_ARGS(timer, cpu),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)
> +		__field( unsigned long,	expires		)
> +		__field( int,		cpu		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->timer		= timer;
> +		__entry->function	= timer->function;
> +		__entry->expires	= timer->expires;
> +		__entry->cpu		= cpu;
> +	),
> +
> +	TP_printk("timer=%p func=%pf expires=%lu cpu=%d", __entry->timer,
> +		  __entry->function, __entry->expires, __entry->cpu)
> +);

  How do we connect the trace to the jiffies value when the timer
  was started ?

> +
> +TRACE_EVENT(timer_expire,
> +
> +	TP_PROTO(struct timer_list *timer),
> +
> +	TP_ARGS(timer),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,        function	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->timer		= timer;
> +		__entry->function       = timer->function;
> +	),
> +
> +	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
> +);

  Ditto.

> +TRACE_EVENT(timer_cancel,
> +
> +	TP_PROTO(struct timer_list *timer),
> +
> +	TP_ARGS(timer),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,        function        )
> +	),
> +
> +	TP_fast_assign(
> +		__entry->timer		= timer;
> +		__entry->function	= timer->function;
> +	),
> +
> +	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
> +);

  Same here.

> @@ -547,6 +550,7 @@ void init_timer_key(struct timer_list *timer,
>  {
>  	debug_timer_init(timer);
>  	__init_timer(timer, name, key);
> +	trace_timer_init(timer);

  Can we please avoid to have two debug calls in one 2 line function ?

>  }
>  EXPORT_SYMBOL(init_timer_key);
>  
> @@ -565,6 +569,7 @@ static inline void detach_timer(struct timer_list *timer,
>  	struct list_head *entry = &timer->entry;
>  
>  	debug_timer_deactivate(timer);
> +	trace_timer_cancel(timer);

  Ditto. Please create one debug entity which covers both.

  ....

Thanks,

	tglx
