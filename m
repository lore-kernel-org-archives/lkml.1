Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZL1Hya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZL1Hya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZL1Hya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:54:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZL1Hy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:54:29 -0500
Date: Mon, 28 Dec 2009 08:54:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5]: trace_event: export HZ in timer's tracepoint
 format
Message-ID: <20091228075417.GB20039@elte.hu>
References: <4B27702F.1080507@cn.fujitsu.com>
 <20091215142325.GC5833@nowhere>
 <4B30C2D1.4030006@cn.fujitsu.com>
 <4B30C3A0.909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B30C3A0.909@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Export HZ in timer's tracepoint, we can use it to get
> TIMER/ITIMER_VIRTUAL/ITIMER_PROF exact latency and it's
> suggested by Ingo
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/trace/events/timer.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> index 13ec15a..7749ae5 100644
> --- a/include/trace/events/timer.h
> +++ b/include/trace/events/timer.h
> @@ -74,14 +74,17 @@ TRACE_EVENT(timer_expire_entry,
>  	TP_STRUCT__entry(
>  		__field( void *,	timer	)
>  		__field( unsigned long,	now	)
> +		__field( int,		hz	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->timer		= timer;
>  		__entry->now		= jiffies;
> +		__entry->hz		= HZ;
>  	),
>  
> -	TP_printk("timer=%p now=%lu", __entry->timer, __entry->now)
> +	TP_printk("timer=%p now=%lu HZ=%d", __entry->timer, __entry->now,
> +		  __entry->hz)
>  );

I think we can do something slightly different and more efficient: just create 
a new timer event to report the value of HZ.

That way we dont clutter the timer_expire_entry record format with a 
repetitive HZ field. It's an extra 4 bytes overhead: that has to be written, 
passed along, copied and thrown away in 99.9999% of the cases - such overhead 
should be avoided.

If you created a special timer_params event, which would produce precisely one 
event when triggered via say a new perf ioctl. I.e. add something like this to 
perf_event.h:

  #define PERF_EVENT_IOC_INJECT       _IOW('$', 7, __u64)

and add code to kernel/perf_event.c's perf_ioctl() function that takes that 
__u64 parameter as an event ID and injects an 'artificial' event.

Such a new feature would be useful for other things as well: backtesting rare 
events, injecting other types of 'parameter/query events', etc.

There might be more details to this, but it would be a useful scheme IMO - and 
it would still integrate nicely with the whole ftrace event enumeration scheme 
so tooling support would be easier.

What do you think?

	Ingo
