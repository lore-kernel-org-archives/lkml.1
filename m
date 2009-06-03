Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbZFCQkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbZFCQkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbZFCQkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:40:20 -0400
Received: from www.tglx.de ([62.245.132.106]:58523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbZFCQkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:40:18 -0400
Date: Wed, 3 Jun 2009 18:39:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/3] ftrace: add tracepoint for timer
In-Reply-To: <4A25E575.5000601@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0906031756590.3419@localhost.localdomain>
References: <4A167615.7050208@cn.fujitsu.com> <alpine.LFD.2.00.0905262334030.1762@localhost.localdomain> <4A1CED66.7030805@cn.fujitsu.com> <alpine.LFD.2.00.0905271202260.3397@localhost.localdomain> <4A1F41C5.7000803@cn.fujitsu.com>
 <alpine.LFD.2.00.0905290935030.3397@localhost.localdomain> <4A25E575.5000601@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Xiao Guangrong wrote:
> Thomas Gleixner wrote:
> > On Fri, 29 May 2009, Zhaolei wrote:
> >> But, for trace_timer_start() in __mod_timer(), we need to put it after
> >> timer->* changed.
> > 
> > Why ?
> > 
> >>> +	TP_fast_assign(
> >>> +		__entry->timer		= timer;
> >>> +		__entry->function	= timer->function;
> >>> +		__entry->expires	= timer->expires;
> >>> +		__entry->cpu		= cpu;
> > 
> > Again, neither timer nor function nor expires will change when the
> > timer is added, right ?
> > 
> > The only unknown at this point is cpu. See below.
> > 
> >> Nevertheless, it don't means we need separate trace_timer_start() and
> >> debug_timer_activate(), because we can put move debug_timer_activate() below,
> >> as:
> >> -	debug_timer_activate(timer);
> >> 	...
> >>  	timer->expires = expires;
> >>  	internal_add_timer(base, timer);
> >> +	debug_timer_activate(timer);
> > 
> > No, you can not call it with the base->lock held.
> > 
> >> +	trace_timer_start(timer, smp_processor_id());
> > 
> > Also using smp_processor_id() here is wrong. We do not necessarily add
> > the timer to the current CPUs timer wheel. See the code which selects
> > the timer base. So this information is rather useless, because the
> > tracer knows anyway  on which CPU we are running.
> > 
> > Unfortunately we do not have an easy way to figure out to which CPU
> > the base belongs (except if it's the base of the current CPU). There
> > is not much we can do about that. But OTOH, this is not a problem
> > because we see when the timer expires on which CPU it was enqueued. So
> > scrapping the cpu entry in the trace completely is not a big loss.
> > 
> > The same applies to hrtimers as well.
> > 
> 
> Hi tglx:
> 
> I also have different view here.  :-) 
>
> As you say, "We do not necessarily add the timer to the current CPUs timer
> wheel", but the timer is added to current CPU in __mod_timer(), selects the
> timer base as below code:
> 	new_base = __get_cpu_var(tvec_bases);
> In this case, we can use smp_processor_id() to get the CPU which timer is
> added.

No, this is _wrong_. You need to look at the full source. I added some
extra comments

	new_base = __get_cpu_var(tvec_bases);

	if (base != new_base) {

+ 	   	 /* current timer base is on a different CPU */

		/*
		 * We are trying to schedule the timer on the local CPU.
		 * However we can't change timer's base while it is running,
		 * otherwise del_timer_sync() can't detect that the timer's
		 * handler yet has not finished. This also guarantees that
		 * the timer is serialized wrt itself.
		 */
		if (likely(base->running_timer != timer)) {
			/* See the comment in lock_timer_base() */
			timer_set_base(timer, NULL);
			spin_unlock(&base->lock);
			base = new_base;
			spin_lock(&base->lock);
			timer_set_base(timer, base);
-		}
+		} else
+		  /*
+		   * we know that that
+		   * the callback is running on a different CPU and we need
+		   * to keep base unchanged, so smp_processor_id() is
+		   * telling you the wrong information.
+		   */
+	}

> We can not add the timer to the current CPUs by using add_timer_on(), selects

  We can add the timer to the current CPU by using add_timer_on() as well.

> the timer base in this function as below code:
> 	struct tvec_base *base = per_cpu(tvec_bases, cpu);
> In this case, We can know the timer is added to 'cpu'.
>
> So, I add trace_timer_start() in __mod_timer() and add_timer_on()in my patch.

  Still in the __mod_timer() case the tracing info can be wrong and
  tracing wrong information is worse than tracing no information.

  Your patch could result in a trace which confuses the hell out of
  people looking at it:

  ....... 0..... activate_timer on cpu 0
  
  some time later

  ....... 2..... expire timer on cpu 2

  And the guy who needs to analyse that trace would rip his hairs out
  to find out how the timer moved from cpu 0 to cpu 2
 
> In hrtimer, all timer is added to the current CPU which can be getted by using
> smp_processor_id() in probe function, so it not has 'cpu' argument in my patch.

  Wrong again. Read the code in switch_hrtimer_base(). It does the
  same thing as the timer base selection logic in __mod_timer()
 
> In addition, we do better not put trace_timer_start() and debug_timer_activate
> in one function, have two reasons:
> 1: for trace_timer_start()'s logic, the timer start event is completed in 
>    internal_add_timer(), in other words: the timer is not start before
>    internal_add_timer().

 Oh well. So where is the difference of tracing it before or after the
 list add happened ? That's complete irrelevant.
 
> 2: as Zhaolei says in the last mail, the timer's data may changed after
>    debug_timer_activate().

 Really ? What is going to change ? Nothing in the normal case, in the
 case the timer is active then it is removed first. Also it depends on
 how you do this:

void debug_and_trace_timer_activate(....)
{
	debug_timer_activate(...);
	trace_timer_activate(...);
}

in the timer code:

-      debug_timer_activate(...);
+      debug_and_trace_timer_activate(...);

So this does not change the order of functions at all, but it avoids
sprinkling the real code with tons of extra crap.

Thanks,

	tglx
