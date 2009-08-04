Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbZHDFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbZHDFrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 01:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbZHDFrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 01:47:17 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:43516 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbZHDFrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 01:47:16 -0400
Date: Tue, 4 Aug 2009 11:17:04 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090804054704.GA2706@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802221324.GP6854@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 03:13:25PM -0700, Paul E. McKenney wrote:
> > FYI, the new warning triggered in -tip testing:
> 
> Yow!!!  I never was able to get this to trigger...  Of course, I never
> was able to reproduce the original problem, either.
> 
> Just so you know, one of the reasons it took me so long to come up with
> the fix is that this just isn't supposed to happen.  Where I grew up, CPUs
> were supposed to come online -before- starting to handle softirqs.  ;-)
> 
> Here is my reasoning:
> 
> o	rcu_init(), which is invoked before a second CPU can possibly
> 	come online, calls hotplug_notifier(), which causes
> 	rcu_barrier_cpu_hotplug() to be invoked in response to any
> 	CPU-hotplug event.
> 
> o	We know rcu_init() really was called, because otherwise
> 	open_softirq(RCU_SOFTIRQ) never gets called, so the softirq would
> 	never have happened.  In addition, there should be a "Hierarchical
> 	RCU implementation" message in your bootlog.  (Is there?)
> 
> o	rcu_barrier_cpu_hotplug() unconditionally invokes
> 	rcu_cpu_notify() on every CPU-hotplug event.
> 
> o	rcu_cpu_notify() invokes rcu_online_cpu() in response to
> 	any CPU_UP_PREPARE or CPU_UP_PREPARE_FROZEN CPU-hotplug
> 	event.
> 
> o	The CPU_UP_PREPARE and CPU_UP_PREPARE_FROZEN CPU-hotplug events
> 	happen before the CPU in question is capable of running any code.
> 
> o	This looks to be the first onlining of this CPU during boot
> 	(right?).  So we cannot possibly have some strange situation
> 	where the end of the prior CPU-offline event overlaps with
> 	the current CPU-online event.  (Yes, this isn't supposed to
> 	happen courtesy of CPU-hotplug locking, but impossibility
> 	is clearly no reason to dismiss possible scenarios for -this-
> 	particular bug.)
> 
> o	Therefore the WARN_ON_ONCE() cannot possibly trigger.
> 
> This would be a convincing argument, aside from the fact that you
> really did make it trigger.  So first, anything I am missing in
> the above?  If not, could you please help me with the following,
> at least if the answers are readily available?
> 
> o	Is rcu_init()'s "Hierarchical RCU implementation" log message
> 	in your bootlog?
> 
> o	Is _cpu_up() really being called, and, if so, is it really
> 	invoking __raw_notifier_call_chain() with CPU_UP_PREPARE?
> 
> o	Is this really during initial boot, or am I misreading your
> 	bootlog?  (The other reason I believe that this happened on
> 	the first CPU-online for this CPU is that ->beenonline, once
> 	set, is never cleared.)
> 
> Gautham, any thoughts on what might be happening here?

Beats me. You're reasoning seems quite iron-clad, there's nothing that's
obviously missing at least from the CPU-Hotplug point of view.

I am trying to reproduce this on 2.6.31-rc5 tip-master + your patch with
an added printk.
Let me see if I can catch it.


-->
rcu: Check if the cpu has been initialized before handling callbacks

From: Gautham R Shenoy <ego@in.ibm.com>

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Paul E.Mckenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0e40e61..1809cc8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1137,6 +1137,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(rdp->beenonline == 0);
+
 	/*
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
@@ -1351,6 +1353,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	printk(KERN_INFO "Initializing RCU for cpu %d\n", cpu);
+
 	/* Set up local state, ensuring consistent view of global state. */
 	spin_lock_irqsave(&rnp->lock, flags);
 	lastcomp = rsp->completed;



-- 
Thanks and Regards
gautham
