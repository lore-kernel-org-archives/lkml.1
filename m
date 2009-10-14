Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbZJNCuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbZJNCuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbZJNCuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:50:25 -0400
Received: from [71.74.56.123] ([71.74.56.123]:61115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754482AbZJNCuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:50:24 -0400
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
In-Reply-To: <4AD531E5.6070103@cn.fujitsu.com>
References: <20091009224954.GA26516@linux.vnet.ibm.com>
	 <4AD42FF5.2080109@cn.fujitsu.com>
	 <20091013170022.GA6782@linux.vnet.ibm.com> <4AD51D3E.60103@cn.fujitsu.com>
	 <20091014010956.GG6782@linux.vnet.ibm.com>
	 <4AD531E5.6070103@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 22:49:46 -0400
Message-Id: <1255488586.7113.3094.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 10:05 +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:

> You haven't explain the tick_nohz_stop_sched_tick() in *irq_exit()*.
> (tick_nohz_stop_sched_tick() calls rcu_enter_nohz())
> 
> void irq_exit(void)
> {
> 	....
> 	rcu_irq_exit(); /* This is OK, the opposite is in irq_enter() */
> 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
> 		tick_nohz_stop_sched_tick(0); /* where is the opposite ??? */
> 	....
> }
> 
> This means if the interrupt -is- returning to dyntick-idle mode,
> rcu_enter_nohz() is called again.
> 
> Take this flow as example:
> 
> cpu_idle():
> while(1) {
> 
>   tick_nohz_stop_sched_tick()
>      rcu_enter_nohz()                 *****
> ------->interrupt happen
>         irq_enter()
>         irq_exit()
>            tick_nohz_stop_sched_tick()
>               rcu_enter_nohz()       *****
> <-------interrupt returns
>   tick_nohz_restart_sched_tick()
>      rcu_exit_nohz()                  *****
> 
> } /* while(1) */
> 
> 
> You can see that rcu_enter_nohz() is called twice and
> rcu_exit_nohz() is only called once in this flow.
> 
> It's because tick_nohz_stop_sched_tick()/tick_nohz_restart_sched_tick()
> are not called in pairs, so rcu_enter_nohz() and rcu_exit_nohz()
> are not called in pairs either.


But isn't the tick_nohz_stop_sched_tick have several exits?

void tick_nohz_stop_sched_tick(int inidle)
{
[..]

	if (!inidle && !ts->inidle)
		goto end;

	ts->inidle = 1;

[..]

		if (!ts->tick_stopped) {
[..]
			ts->tick_stopped = 1;
			ts->idle_jiffies = last_jiffies;
			rcu_enter_nohz();
		}
[..]


So I'm not sure calling tick_nohz_stop_sched_tick twice equals calling
rcu_enter_nohz twice.

-- Steve

> > 
> > So I do believe that rcu_enter_nohz() and rcu_exit_nohz() are in fact
> > invoked in pairs.  One strange thing about this is that the idle loop
> > first invokes rcu_enter_nohz(), then invokes rcu_exit_nohz(), while
> > an interrupt handler first invokes rcu_irq_enter() and then invokes
> > rcu_irq_exit().  So the idle loop enters dyntick-idle mode and then
> > leaves it, while an interrupt handler might leave dyntick-idle mode and
> > then re-enter it.
> > 
> > Or am I still missing something here?
> > 
> > 							Thanx, Paul
> > 
> > 
> 

