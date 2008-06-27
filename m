Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYF0O66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYF0O66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYF0O6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:58:50 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:44212 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYF0O6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:58:49 -0400
Date: Fri, 27 Jun 2008 07:58:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080627145845.GA9229@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627054959.GB3309@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 11:19:59AM +0530, Dhaval Giani wrote:
> On Fri, Jun 27, 2008 at 10:48:55AM +0530, Dipankar Sarma wrote:
> > On Fri, Jun 27, 2008 at 10:17:38AM +0530, Gautham R Shenoy wrote:
> > > IMHO the warning is a spurious one.
> > > Here's the timeline.
> > > CPU_A						 CPU_B
> > > --------------------------------------------------------------
> > > cpu_down():					.
> > > .					   	.
> > > .						.
> > > stop_machine(): /* disables preemption,		.
> > > 		 * and irqs */			.
> > > .						.
> > > .						.
> > > take_cpu_down();				.
> > > .						.
> > > .						.
> > > .						.
> > > cpu_disable(); /*this removes cpu 		.
> > > 		*from cpu_online_map 		.
> > > 		*/				.
> > > .						.
> > > .						.
> > > restart_machine(); /* enables irqs */		.
> > > ------WINDOW DURING WHICH rcp->cpumask is stale ---------------
> > > .						call_rcu();
> > > .						/* disables irqs here */
> > > .						.force_quiescent_state();
> > > .CPU_DEAD:					.for_each_cpu(rcp->cpumask)
> > > .						.   smp_send_reschedule();
> > > .						.
> > > .						.   WARN_ON() for offlined CPU!
> > > .
> > 
> > Exactly. The call_rcu()s are coming from a different subsystem
> > and can happen anytime during the CPU hotplug path. So, RCU subsystem
> > doesn't have anything to do to keep rcu->cpumask consistent.
> > It is *safe* even if we miss poking a cpu or two while
> > forcing quiescent state in all CPUs. The worst that can happen
> > is a delay in grace period. No correctness problem here.
> > 
> 
> One question. What is preventing a CPU from clearing its mask after we
> have checked whether it is online but before we have called into
> smp_send_reschedule?

This is my concern as well.  Gautham, at which point in the above
timeline is the offlining CPU marked DYING?  Before stop_machine(), right?

If so, can't we just disable irqs, check for DYING or DEAD, and invoke
smp_send_reschedule() only if not DYING or DEAD?

							Thanx, Paul
