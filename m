Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0BORgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:36:49 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47746 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab0BORgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:36:48 -0500
Date: Mon, 15 Feb 2010 09:36:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rcu_dereference() without protection in select_task_rq_fair()
Message-ID: <20100215173645.GA6750@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100211165246.GA8329@linux.vnet.ibm.com> <1266142358.5273.420.camel@laptop> <20100214170409.GK7084@linux.vnet.ibm.com> <1266225126.5273.720.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266225126.5273.720.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 10:12:06AM +0100, Peter Zijlstra wrote:
> On Sun, 2010-02-14 at 09:04 -0800, Paul E. McKenney wrote:
> 
> > OK, but doesn't the "preempt_count() != 0" that is in the current version
> > of rcu_read_lock_sched_held() already cover this check?
> 
> Hmm, yes it should.
> 
> > In other words, I believe that I have located a usage of for_each_domain()
> > that violates the rule that it may only be called within preempt-disabled
> > sections.
> 
> >From the trace:
> 
> >  [<ffffffff81033ec4>] select_task_rq_fair+0xc1/0x686
> >  [<ffffffff810353f4>] wake_up_new_task+0x1e/0x13e
> 
> Which reads like:
> 
> void wake_up_new_task(...)
> {
> 	...
> 
>         int cpu __maybe_unused = get_cpu();
> 
> #ifdef CONFIG_SMP
>         /*
>          * Fork balancing, do it here and not earlier because:
>          *  - cpus_allowed can change in the fork path
>          *  - any previously selected cpu might disappear through hotplug
>          *
>          * We still have TASK_WAKING but PF_STARTING is gone now, meaning
>          * ->cpus_allowed is stable, we have preemption disabled, meaning
>          * cpu_online_mask is stable.
>          */
>         cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
>         set_task_cpu(p, cpu);
> #endif
> 
> 	...
> 
> 	put_cpu()
> }
> 
> I cannot see how we can get there without preemption disabled.

Interesting point.  I have seen this but once.  If it reproduces, I will
instrument the code path and see if I can track it down.

							Thanx, Paul
