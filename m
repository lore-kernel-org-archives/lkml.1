Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZGFUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZGFUNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZGFUNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:13:08 -0400
Received: from www.tglx.de ([62.245.132.106]:45997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZGFUNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:13:07 -0400
Date: Mon, 6 Jul 2009 22:12:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ftrace: add tracepoint for hrtimer
In-Reply-To: <4A51C6AE.5020204@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0907062209190.19480@localhost.localdomain>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6AE.5020204@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Xiao Guangrong wrote:
> +TRACE_EVENT(hrtimer_expire,
> +
> +	TP_PROTO(struct hrtimer *timer, s64 now),
> +
> +	TP_ARGS(timer, now),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)

  Again, function is not necessary here.

> +		__field( s64,		now		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->timer		= timer;
> +		__entry->function	= timer->function;
> +		__entry->now		= now;
> +	),
> +
> +	TP_printk("timer=%p func=%pf now=%llu", __entry->timer, __entry->function,
> +		 (unsigned long long)__entry->now)
> +);
> +
> +TRACE_EVENT(hrtimer_cancel,
> +
> +	TP_PROTO(struct hrtimer *timer),
> +	TP_ARGS(timer),
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)

  Ditto.

> +static inline void debug_and_trace_hrtimer_expire(struct hrtimer *timer,
> +                                                  s64 now)

  Technically not necessary.

>  
> +			debug_and_trace_hrtimer_expire(timer, basenow.tv64);
>  			__run_hrtimer(timer);

  Here I'd like to see a callback_done entry as well, so we can check
  for long lasting callbacks.

>  		}
>  		spin_unlock(&cpu_base->lock);
> @@ -1436,6 +1463,7 @@ void hrtimer_run_queues(void)
>  					hrtimer_get_expires_tv64(timer))
>  				break;
>  
> +			debug_and_trace_hrtimer_expire(timer, base->softirq_time.tv64);
>  			__run_hrtimer(timer);

  Ditto.

Thanks,

	tglx
