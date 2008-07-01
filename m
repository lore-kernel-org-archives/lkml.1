Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYGAHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYGAHxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYGAHxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:53:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYGAHxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:53:03 -0400
Date: Tue, 1 Jul 2008 09:48:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080701074824.GA19400@elte.hu>
References: <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com> <20080627145845.GA9229@linux.vnet.ibm.com> <20080701053900.GB8205@in.ibm.com> <20080701061600.GF14658@elte.hu> <20080701062854.GD6131@linux.vnet.ibm.com> <20080701063531.GD16642@elte.hu> <20080701065226.GA24639@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701065226.GA24639@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Ingo,
> > > 
> > > I believe Gautham's fix at http://lkml.org/lkml/2008/6/27/9 is 
> > > better and also explains it better.
> > 
> > ah, indeed - picked that one up instead.
> 
> this is the patch i picked up:

for some reason my mail to lkml was cut in half - here it is again:

* Ingo Molnar <mingo@elte.hu> wrote:

> > Ingo,
> > 
> > I believe Gautham's fix at http://lkml.org/lkml/2008/6/27/9 is 
> > better and also explains it better.
> 
> ah, indeed - picked that one up instead.

this is the patch i picked up:

-------------------------->
Subject: rcu: fix hotplug vs rcu race
From: Gautham R Shenoy <ego@in.ibm.com>
Date: Fri, 27 Jun 2008 10:17:38 +0530

Dhaval Giani reported this warning during cpu hotplug stress-tests:

| On running kernel compiles in parallel with cpu hotplug:
|
| WARNING: at arch/x86/kernel/smp.c:118
| native_smp_send_reschedule+0x21/0x36()
| Modules linked in:
| Pid: 27483, comm: cc1 Not tainted 2.6.26-rc7 #1
| [...]
|  [<c0110355>] native_smp_send_reschedule+0x21/0x36
|  [<c014fe8f>] force_quiescent_state+0x47/0x57
|  [<c014fef0>] call_rcu+0x51/0x6d
|  [<c01713b3>] __fput+0x130/0x158
|  [<c0171231>] fput+0x17/0x19
|  [<c016fd99>] filp_close+0x4d/0x57
|  [<c016fdff>] sys_close+0x5c/0x97

IMHO the warning is a spurious one.

cpu_online_map is updated by the _cpu_down() using stop_machine_run().
Since force_quiescent_state is invoked from irqs disabled section,
stop_machine_run() won't be executing while a cpu is executing
force_quiescent_state(). Hence the cpu_online_map is stable while we're
in the irq disabled section.

However, a cpu might have been offlined _just_ before we disabled irqs
while entering force_quiescent_state(). And rcu subsystem might not yet
have handled the CPU_DEAD notification, leading to the offlined cpu's
bit being set in the rcp->cpumask.

Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent sending
smp_reschedule() to an offlined CPU.

Here's the timeline:

CPU_A						 CPU_B
--------------------------------------------------------------
cpu_down():					.
.					   	.
.						.
stop_machine(): /* disables preemption,		.
		 * and irqs */			.
.						.
.						.
take_cpu_down();				.
.						.
.						.
.						.
cpu_disable(); /*this removes cpu 		.
		*from cpu_online_map 		.
		*/				.
.						.
.						.
restart_machine(); /* enables irqs */		.
------WINDOW DURING WHICH rcp->cpumask is stale ---------------
.						call_rcu();
.						/* disables irqs here */
.						.force_quiescent_state();
.CPU_DEAD:					.for_each_cpu(rcp->cpumask)
.						.   smp_send_reschedule();
.						.
.						.   WARN_ON() for offlined CPU!
