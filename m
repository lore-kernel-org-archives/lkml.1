Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYGATqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYGATqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYGATqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:46:21 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:49477 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYGATqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:46:19 -0400
Date: Tue, 1 Jul 2008 12:46:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       laijs@cn.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080701194613.GC7488@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com> <20080627145845.GA9229@linux.vnet.ibm.com> <20080701053900.GB8205@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701053900.GB8205@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 11:09:00AM +0530, Gautham R Shenoy wrote:
> On Fri, Jun 27, 2008 at 07:58:45AM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 27, 2008 at 11:19:59AM +0530, Dhaval Giani wrote:
> > > On Fri, Jun 27, 2008 at 10:48:55AM +0530, Dipankar Sarma wrote:
> > > > On Fri, Jun 27, 2008 at 10:17:38AM +0530, Gautham R Shenoy wrote:
> > > > > IMHO the warning is a spurious one.
> > > > > Here's the timeline.
> > > > > CPU_A						 CPU_B
> > > > > --------------------------------------------------------------
> > > > > cpu_down():					.
> > > > > .					   	.
> > > > > .						.
> > > > > stop_machine(): /* disables preemption,		.
> > > > > 		 * and irqs */			.
> > > > > .						.
> > > > > .						.
> > > > > take_cpu_down();				.
> > > > > .						.
> > > > > .						.
> > > > > .						.
> > > > > cpu_disable(); /*this removes cpu 		.
> > > > > 		*from cpu_online_map 		.
> > > > > 		*/				.
> > > > > .						.
> > > > > .						.
> > > > > restart_machine(); /* enables irqs */		.
> > > > > ------WINDOW DURING WHICH rcp->cpumask is stale ---------------
> > > > > .						call_rcu();
> > > > > .						/* disables irqs here */
> > > > > .						.force_quiescent_state();
> > > > > .CPU_DEAD:					.for_each_cpu(rcp->cpumask)
> > > > > .						.   smp_send_reschedule();
> > > > > .						.
> > > > > .						.   WARN_ON() for offlined CPU!
> > > > > .
> > > > 
> > > > Exactly. The call_rcu()s are coming from a different subsystem
> > > > and can happen anytime during the CPU hotplug path. So, RCU subsystem
> > > > doesn't have anything to do to keep rcu->cpumask consistent.
> > > > It is *safe* even if we miss poking a cpu or two while
> > > > forcing quiescent state in all CPUs. The worst that can happen
> > > > is a delay in grace period. No correctness problem here.
> > > > 
> > > 
> > > One question. What is preventing a CPU from clearing its mask after we
> > > have checked whether it is online but before we have called into
> > > smp_send_reschedule?
> > 
> > This is my concern as well.  Gautham, at which point in the above
> > timeline is the offlining CPU marked DYING?  Before stop_machine(), right?
> 
> No :) The offlining CPU is marked DYING after stop_machine(), inside
> take_cpu_down() which is the work we want to execute after stopping the
> machine.
> 
> it's like
> _cpu_down()
> |
> |-> stop_machine_run();
> |   |
> |   |-> stop_machine(); /* All CPUs irqs disabled. */
> |   |
> |   |-> take_cpu_down() --> sets state to CPU_DYING. disables irqs on
> |   |				offlined cpu
> |   |
> |   |-> restart_machine(); /* All CPUs irqs reenabled */
> |
> |-> send_CPU_DEAD_notification.
> 
> The very fact that a thread is running with irqs disabled means that
> stop_machine_run() thread cannot start executing the work it has been
> assinged to execute. Because for Machine to be stopped, stop_machine()
> needs to create n-1 high priority threads on n-1 online cpus, which will
> disable interrupts and preemption, and stop the machine. Then it will
> run the task assigned to it on the ith cpu, which in this case is the
> cpu to be offlined.
> 
> So, it's the design of stop_machine() that's preventing someone
> from updating the cpu_online_map while
> force_quiescent_state() is performing the
> cpu_is_online() check. Becase we always call force_quiescent_state()
> with irqs disabled :)

Got it, so the patch looks good.

							Thanx, Paul

> > If so, can't we just disable irqs, check for DYING or DEAD, and invoke
> > smp_send_reschedule() only if not DYING or DEAD?
> 
> 
> 
> > 
> > 							Thanx, Paul
> 
> -- 
> Thanks and Regards
> gautham
