Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZJ0UTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZJ0UTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbZJ0UTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:19:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbZJ0UT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:19:29 -0400
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       avi@redhat.com, mtosatti@redhat.com, torvalds@linux-foundation.org
In-Reply-To: <4AE6A0BD.1080102@cn.fujitsu.com>
References: <20091009224954.GA26516@linux.vnet.ibm.com>
	 <4AD42FF5.2080109@cn.fujitsu.com>
	 <20091013170022.GA6782@linux.vnet.ibm.com> <4AD51D3E.60103@cn.fujitsu.com>
	 <20091014010956.GG6782@linux.vnet.ibm.com>
	 <4AD531E5.6070103@cn.fujitsu.com>
	 <1255488586.7113.3094.camel@gandalf.stny.rr.com>
	 <4AE6A0BD.1080102@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 15:56:16 -0400
Message-Id: <1256673376.26028.422.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 15:26 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:

> I found something weird about NO_HZ, maybe I misunderstood the codes.
> 
> see this flow:
> 
> cpu idle
>   enter nohz
>   cpu halt
> ---->interrupt happens
>      irq_enter()
>         we don't reprogram the clock device                         #1
>      irq_exit()
>        tick_nohz_stop_sched_tick(inidle = 0)
>          something disallow this cpu reenter nohz                   #2
>          we don't reprogram the clock device                        #3
> <----interrupt return
>    cpu halt again and wait interrupt for a long time than expected  #4
>    exit nohz
> 
> 
> #1 tick_nohz_kick_tick() is disabled in the current mainline kernel,
>    so we don't calls tick_nohz_restart(ts, now) when irq_enter()
> 
> static void tick_nohz_kick_tick(int cpu)
> {
> #if 0                                            <------------- here
> 	/* Switch back to 2.6.27 behaviour */
> 
> 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> 	ktime_t delta, now;
> 
> 	if (!ts->tick_stopped)
> 		return;
> 
> 	/*
> 	 * Do not touch the tick device, when the next expiry is either
> 	 * already reached or less/equal than the tick period.
> 	 */
> 	now = ktime_get();
> 	delta =	ktime_sub(hrtimer_get_expires(&ts->sched_timer), now);
> 	if (delta.tv64 <= tick_period.tv64)
> 		return;
> 
> 	tick_nohz_restart(ts, now);               <----------- here
> #endif
> }
> 
> 
> #2 When rcu_needs_cpu() or  printk_needs_cpu()
>    returns true then tick_nohz_stop_sched_tick() will just return.
> 
> #3 And we don't reprogram the clock device when #2 happens
> 
> #4 So we may be in nohz for a long time than expected, but actually
>     we have some work to do. (rcu, printk... etc)
> 
> So I think, we need to reprogram the clock device and restart the tick
> when #2 happens, or there is something that I have misunderstood.


This looks like a different question than you asked before. And
something I don't know the answer to ;-)

-- Steve


