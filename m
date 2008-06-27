Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYF0FWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYF0FWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYF0FV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:21:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50436 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYF0FV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:21:56 -0400
Date: Fri, 27 Jun 2008 10:48:55 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       laijs@cn.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080627051855.GD26167@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627044738.GC3419@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 10:17:38AM +0530, Gautham R Shenoy wrote:
> IMHO the warning is a spurious one.
> Here's the timeline.
> CPU_A						 CPU_B
> --------------------------------------------------------------
> cpu_down():					.
> .					   	.
> .						.
> stop_machine(): /* disables preemption,		.
> 		 * and irqs */			.
> .						.
> .						.
> take_cpu_down();				.
> .						.
> .						.
> .						.
> cpu_disable(); /*this removes cpu 		.
> 		*from cpu_online_map 		.
> 		*/				.
> .						.
> .						.
> restart_machine(); /* enables irqs */		.
> ------WINDOW DURING WHICH rcp->cpumask is stale ---------------
> .						call_rcu();
> .						/* disables irqs here */
> .						.force_quiescent_state();
> .CPU_DEAD:					.for_each_cpu(rcp->cpumask)
> .						.   smp_send_reschedule();
> .						.
> .						.   WARN_ON() for offlined CPU!
> .

Exactly. The call_rcu()s are coming from a different subsystem
and can happen anytime during the CPU hotplug path. So, RCU subsystem
doesn't have anything to do to keep rcu->cpumask consistent.
It is *safe* even if we miss poking a cpu or two while
forcing quiescent state in all CPUs. The worst that can happen
is a delay in grace period. No correctness problem here.

Thanks
Dipankar
