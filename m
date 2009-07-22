Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZGVPgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZGVPgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZGVPgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:36:44 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:46605 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbZGVPgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:36:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAEAPHMZkpMQWU3/2dsb2JhbACBUdIHhA4F
Date: Wed, 22 Jul 2009 11:36:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Anton Blanchard <anton@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] ftrace: add tracepoint for hrtimer
Message-ID: <20090722153636.GC30892@Krystal>
References: <4A604E46.5050903@cn.fujitsu.com> <4A605009.8060806@cn.fujitsu.com> <1247827801.15751.4.camel@twins> <4A641BFC.2050508@cn.fujitsu.com> <1248091771.15751.8578.camel@twins> <4A66DDB6.4000700@cn.fujitsu.com> <1248257598.27058.1227.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1248257598.27058.1227.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:31:05 up 144 days, 11:57,  3 users,  load average: 0.34, 0.36,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2009-07-22 at 17:36 +0800, Xiao Guangrong wrote:
> > 
> > Peter Zijlstra wrote:
> > 
> > > Ah, but you don't get those anyway, I'd argue the whole expire thing is
> > > broken. The only expiry you get is the hardware interrupt firing.
> > > Anything after that is a free-for-all.
> > > 
> > > Look at that loop in hrtimer_interrupt(), with your tracepoint, they'd
> > > all expire at the same time, regardless of how long previous callback's
> > > took to complete.
> > > 
> > > Also, the whole loop can be re-tried, updating 'now' expiring a whole
> > > new set of timers without expiry event.
> > > 
> > 
> > Yes, the expire time that got by _expire() is incorrect and thanks for
> > your point out.
> > 
> > > The best you can get is a tracepoint when the hrtimer interrupt happens,
> > > and the IRQ tracepoint already give you that.
> > > 
> > 
> > I'm trying to fix it address your comment, but meet some problems,
> > the time of ftrace output can't solve everything, because:
> > 
> > 1: the time unit of ftrace output is microsecond, but hrtimer's unit
> >    is nanosecond, it's not exact for us
> > 
> > 2: the time of ftrace ouput is the time after system boot, but we need
> >    xtime and wall_to_monotonic to calculate latency of hrtimer,
> >    for example:
> >    insmod-3821  [001]  3192.239335: hrtimer_start: timer=d08a1480  expires=1245162841000000000 ns
> >    <idle>-0     [001]  3201.506127: hrtimer_expire: timer=d08a1480
> >    
> >   we expect the timer expire at 1245162841000000000 ns, this is base on
> >   xtime, but we don't know the interval running that we are expect hrtimer
> >   to run if we don't know the xtime at hrtimer_start or hrtimer_expire.
> > 
> > But it's hard for hrtime's TRACE_EVENT to get xtime and wall_to_monotonic
> > since it's a fast patch, if we have to do this, the code maybe like below:
> > 
> > TRACE_EVENT(hrtimer_expire,
> > 
> > 	......
> > 
> > 	TP_STRUCT__entry(
> > 		__field( void *,	timer	)
> > 		__field( s64,		now	)
> > 		__field( s64, 		offset	)
> > 	),
> > 
> > 	TP_fast_assign(
> > 		__entry->timer	= timer;
> > 		__entry->now	= ktime_get().tv64;
> > 		__entry->wtom 	= timespec_to_ktime(wall_to_monotonic).tv64;
> > 	),
> > 
> > 	TP_printk("timer=%p now=%llu ns wtom=%llu", __entry->timer,
> > 		 (unsigned long long)__entry->now, (unsigned long long)__entry->wtom)
> > );
> > 
> > We need cooperate with trace_hrtimer_init() to get hrtimer's clockid.
> > 
> > That make trace_hrtimer_expire() slow.
> > 
> > Though the original patch get expire time not exactly, but It harm system's 
> > performance very little.
> 
> OK, so what you want to measure is the time of the actual callback
> happening (hrtimer_entry) vs that where you would have expected it to
> happen (hrtimer_start + delay), right?
> 
> So what's wrong with printing the expected expiration time in the
> hrtimer_start tracepoint in the cheap clock units?

This is also my thinking: why are __entry->now and __entry->wtom needed
at all? Ftrace should be providing an accurate clock source for the
event already.

If we _really_ need to match the trace clock with the system
gettimeofday value (or monotonic time), then we can instrument the timer
tick update routine. e.g., from LTTng (not yet ported to TRACE_EVENT):

kernel/timer.c:

void do_timer(unsigned long ticks)
{
        jiffies_64 += ticks;
        update_times(ticks);
        trace_timer_update_time(&xtime, &wall_to_monotonic);
}

ltt/probes/kernel-trace.c:

void probe_timer_update_time(struct timespec *_xtime,
                struct timespec *_wall_to_monotonic)
{
        trace_mark_tp(kernel, timer_update_time, timer_update_time,
                probe_timer_update_time,
                "jiffies #8u%llu xtime_sec %ld xtime_nsec %ld "
                "walltomonotonic_sec %ld walltomonotonic_nsec %ld",
                (unsigned long long)jiffies_64, _xtime->tv_sec, _xtime->tv_nsec,
                _wall_to_monotonic->tv_sec, _wall_to_monotonic->tv_nsec);
}

Mathieu

> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
