Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZJ0H1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZJ0H1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZJ0H1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:27:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59272 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZJ0H1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:27:14 -0400
Message-ID: <4AE6A0BD.1080102@cn.fujitsu.com>
Date: Tue, 27 Oct 2009 15:26:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org, tglx@linutronix.de
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, avi@redhat.com, mtosatti@redhat.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
References: <20091009224954.GA26516@linux.vnet.ibm.com>	 <4AD42FF5.2080109@cn.fujitsu.com>	 <20091013170022.GA6782@linux.vnet.ibm.com> <4AD51D3E.60103@cn.fujitsu.com>	 <20091014010956.GG6782@linux.vnet.ibm.com>	 <4AD531E5.6070103@cn.fujitsu.com> <1255488586.7113.3094.camel@gandalf.stny.rr.com>
In-Reply-To: <1255488586.7113.3094.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> But isn't the tick_nohz_stop_sched_tick have several exits?
> 
> void tick_nohz_stop_sched_tick(int inidle)
> {
> [..]
> 
> 	if (!inidle && !ts->inidle)
> 		goto end;
> 
> 	ts->inidle = 1;
> 
> [..]
> 
> 		if (!ts->tick_stopped) {
> [..]
> 			ts->tick_stopped = 1;
> 			ts->idle_jiffies = last_jiffies;
> 			rcu_enter_nohz();
> 		}
> [..]
> 
> 
> So I'm not sure calling tick_nohz_stop_sched_tick twice equals calling
> rcu_enter_nohz twice.
> 

Hi, tglx, steven,

(Thank to tglx for helping me at the Japan Linux Symposium)

I found something weird about NO_HZ, maybe I misunderstood the codes.

see this flow:

cpu idle
  enter nohz
  cpu halt
---->interrupt happens
     irq_enter()
        we don't reprogram the clock device                         #1
     irq_exit()
       tick_nohz_stop_sched_tick(inidle = 0)
         something disallow this cpu reenter nohz                   #2
         we don't reprogram the clock device                        #3
<----interrupt return
   cpu halt again and wait interrupt for a long time than expected  #4
   exit nohz


#1 tick_nohz_kick_tick() is disabled in the current mainline kernel,
   so we don't calls tick_nohz_restart(ts, now) when irq_enter()

static void tick_nohz_kick_tick(int cpu)
{
#if 0                                            <------------- here
	/* Switch back to 2.6.27 behaviour */

	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
	ktime_t delta, now;

	if (!ts->tick_stopped)
		return;

	/*
	 * Do not touch the tick device, when the next expiry is either
	 * already reached or less/equal than the tick period.
	 */
	now = ktime_get();
	delta =	ktime_sub(hrtimer_get_expires(&ts->sched_timer), now);
	if (delta.tv64 <= tick_period.tv64)
		return;

	tick_nohz_restart(ts, now);               <----------- here
#endif
}


#2 When rcu_needs_cpu() or  printk_needs_cpu()
   returns true then tick_nohz_stop_sched_tick() will just return.

#3 And we don't reprogram the clock device when #2 happens

#4 So we may be in nohz for a long time than expected, but actually
    we have some work to do. (rcu, printk... etc)

So I think, we need to reprogram the clock device and restart the tick
when #2 happens, or there is something that I have misunderstood.

Thanks, Lai



> -- Steve
> 
>>> So I do believe that rcu_enter_nohz() and rcu_exit_nohz() are in fact
>>> invoked in pairs.  One strange thing about this is that the idle loop
>>> first invokes rcu_enter_nohz(), then invokes rcu_exit_nohz(), while
>>> an interrupt handler first invokes rcu_irq_enter() and then invokes
>>> rcu_irq_exit().  So the idle loop enters dyntick-idle mode and then
>>> leaves it, while an interrupt handler might leave dyntick-idle mode and
>>> then re-enter it.
>>>
>>> Or am I still missing something here?
>>>
>>> 							Thanx, Paul
>>>
>>>
> 
> 
> 


