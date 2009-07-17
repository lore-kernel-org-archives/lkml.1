Return-Path: <linux-kernel-owner+w=401wt.eu-S934413AbZGQKuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413AbZGQKuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934393AbZGQKuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:50:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49387 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934392AbZGQKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:50:20 -0400
Subject: Re: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A605009.8060806@cn.fujitsu.com>
References: <4A604E46.5050903@cn.fujitsu.com>
	 <4A605009.8060806@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Jul 2009 12:50:01 +0200
Message-Id: <1247827801.15751.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 18:18 +0800, Xiao Guangrong wrote:
> Those tracepoints are wanted and useful:
> 1: We can detect a hrtimer's delay
> 2: We can monitor the lifecycle and behaviors of a hrtimer
> 
> Thus they help in analysing and debuging.
> 
> Great thanks to Thomas for giving me so many valuable advices.
> 
> Example ftrace output:
>   insmod-5280  [000] 10798.356372: hrtimer_init: timer=d0b044c0 clockid=CLOCK_REALTIME mode=HRTIMER_MODE_ABS
>   insmod-5280  [000] 10798.356385: hrtimer_start: timer=d0b044c0 func=hrtimer_fun expires=1246242896000000000 ns softexpires=1246242896000000000 ns
>   <idle>-0     [000] 10807.982987: hrtimer_expire: timer=d0b044c0 now=1246242896000906503 ns
>   <idle>-0     [000] 10807.982989: hrtimer_cancel: timer=d0b044c0
>   <idle>-0     [000] 10807.983562: hrtimer_callback_done: timer=d0b044c0
>  
> We expect the hrtimer expires at 1246242896000000000 ns, actually the
> hrtimer expires at 1246242896000906503 ns, so it is delayed by
> 1246242896000906503-1246242896000000000 = 906503 ns.
> We also realize the hrtimer's callback started at 10807.982987, and it
> finished at 10807.983562, so it's taking 10807.983562-10807.982987=0.6ms.
> 
> Changelog:
> v1->v2:
> 1: Remove ktime_to_ns() in TP_fast_assign()
> 2: Combine debugobjects and trace as Thomas's suggestion
> v2->v3:
> 1: Remove function address from hrtimer_expire and hrtimer_cancel
>    as Thomas's suggestion
> 2: Remove debug_and_trace_hrtimer_expire() as Thomas's suggestion
> 3: Rename trace_hrtimer_entry() and trace_hrtimer_exit() to match this patch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---



> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 33317e4..bd21c9b 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -442,6 +442,26 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
>  static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
>  #endif
>  
> +static inline void
> +debug_and_trace_hrtimer_init(struct hrtimer *timer, clockid_t clockid,
> +			     enum hrtimer_mode mode)
> +{
> +	debug_hrtimer_init(timer);
> +	trace_hrtimer_init(timer, clockid, mode);
> +}
> +
> +static inline void debug_and_trace_hrtimer_activate(struct hrtimer *timer)
> +{
> +	debug_hrtimer_activate(timer);
> +	trace_hrtimer_start(timer);
> +}
> +
> +static inline void debug_and_trace_hrtimer_deactivate(struct hrtimer *timer)
> +{
> +	debug_hrtimer_deactivate(timer);
> +	trace_hrtimer_cancel(timer);
> +}

I would argue that tracing is a form of debugging and you shouldn't need
to mangle these names like that, simply leave them debug_*().


> @@ -1162,9 +1182,8 @@ static void __run_hrtimer(struct hrtimer *timer)
>  	 * the timer base.
>  	 */
>  	spin_unlock(&cpu_base->lock);
> -	trace_hrtimer_entry(timer);
>  	restart = fn(timer);
> -	trace_hrtimer_exit(timer, restart);
> +	trace_hrtimer_callback_done(timer);
>  	spin_lock(&cpu_base->lock);
>  
>  	/*

Why bother introducing these tracepoints if you're going to remove them
in the same patch-set?

Also, the below:

> @@ -1275,6 +1294,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
>  				break;
>  			}
>  
> +			trace_hrtimer_expire(timer, basenow.tv64);
>  			__run_hrtimer(timer);
>  		}
>  		base++;
> @@ -1397,6 +1417,7 @@ void hrtimer_run_queues(void)
>  					hrtimer_get_expires_tv64(timer))
>  				break;
>  
> +			trace_hrtimer_expire(timer, base->softirq_time.tv64);
>  			__run_hrtimer(timer);
>  		}
>  		spin_unlock(&cpu_base->lock);

indicates you placed that tracepoint in the wrong place.

Furthermore, I don't get why you want it there and not on the old
_entry() site, because this adds all kinds of extra overhead and you
loose the exact callback timings.


