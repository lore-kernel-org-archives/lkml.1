Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZGFUJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZGFUJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZGFUJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:09:16 -0400
Received: from www.tglx.de ([62.245.132.106]:51580 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbZGFUJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:09:16 -0400
Date: Mon, 6 Jul 2009 22:08:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A51C653.4040401@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0907062140010.19480@localhost.localdomain>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C653.4040401@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Xiao Guangrong wrote:
> Changelog v1->v2:
> 1: Add jiffies info into timer
> 2: Combine debugobjects and trace as Thomas's suggestion

I like it that way. Some minor nitpicks below.
 
> +TRACE_EVENT(timer_expire,
> +
> +	TP_PROTO(struct timer_list *timer),
> +
> +	TP_ARGS(timer),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)

  Do we really need the function here? It does not change between
  start and expiry.

> +TRACE_EVENT(timer_cancel,
> +
> +	TP_PROTO(struct timer_list *timer),
> +
> +	TP_ARGS(timer),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)

  Ditto.

> +
> +static inline void debug_and_trace_timer_expire(struct timer_list *timer)

  Technically not really necessary. The debug code does not care about
  it.

>  			timer = list_first_entry(head, struct timer_list,entry);
> +			debug_and_trace_timer_expire(timer);
>  			fn = timer->function;
>  			data = timer->data;
>  

Can you please add the tracepoint which was suggested by Anton (IIRC)
which allows us to measure the execution time of the callback function
? There is no need to dereference timer in the expiry tracepoint, we
just store the pointer. So we can safely move the tracepoints just
around the function call.

   trace_timer_expire(timer);
   fn(data);
   trace_timer_callback_done(timer);

Or whatever fancy name you come up with.

Thanks,

	tglx
