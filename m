Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbYEBIev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbYEBIev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYEBIen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:34:43 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3258 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756221AbYEBIel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:34:41 -0400
Subject: Re: Horrendous Audio Stutter - current git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>
In-Reply-To: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 10:34:38 +0200
Message-Id: <1209717278.13978.136.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 20:14 -0400, Parag Warudkar wrote:
> Hi Ingo, Peter
> 
> Under kernel compilation load (make -j8) audio is very much unusable
> on current linux-2.6.git - The stutter is so bad I can hardly tell
> what song I am listening to :)
> Even with make -j4 it still skips but not that badly.
> 
> I am running Ubuntu Hardy (Pulseaudio) on a quad core machine and
> switching back to Ubuntu shipped kernel (2.6.24-16) resolves the issue
> totally.
> 
> ..config below.  Revert of e22ecef1d2658ba54ed7d3fdb5d60829fb434c23
> fixed similar issue.

So you're saying reverting e22ecef1 fixes the issue? - as have others.

The initial rationale for the change was: vruntime and walltime are
related by a factor of rq->weight, hence compensate for that.

However that in itself has a flaw, we're comparing vruntime to process
runtime time, _NOT_ walltime. And vruntime and process runtime do not
have that factor so the compensation is unneeded.

However that still leaves me puzzled on why it would cause such bad
regression. The current code reads like:

/*
 * delta *= w / rw
 */
static inline unsigned long
calc_delta_weight(unsigned long delta, struct sched_entity *se);


/* sleeps upto a single latency don't count. */
if (sched_feat(NEW_FAIR_SLEEPERS)) {
        if (sched_feat(NORMALIZED_SLEEPER))
                vruntime -= calc_delta_weight(sysctl_sched_latency, se);
        else
                vruntime -= sysctl_sched_latency;
}

So what we do is _shrink_ the bonus the busier we get (the more tasks we
get, the higher the total runqueue weight (rw) hence delta will get
smaller)

The thing is, I once asked Frans to test !NEW_FAIR_SLEEPERS and he
reported that that also solves the problem. So no bonus is good, and a
fixed bonus is good, but a variable bonus that is between these two
values is not.


Parag, would you also test with !NEW_FAIR_SLEEPERS to see if that solves
your problem?

The easiest way to disable it is (assumes you have debugfs mounted
at /debug):

 # echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features

You can also disable NORMALIZED_SLEEPER that way (of course you would
first have to enable NEW_FAIR_SLEEPERS again):

 # echo NO_NORMALIZED_SLEEPER > /debug/sched_features

You can get a current status of all the flags using:

 # cat /debug/sched_features


So by default we have both enabled; could you report if either

NO_NEW_FAIR_SLEEPERS

NEW_FAIR_SLEEPERS + NO_NORMALIZED_SLEEPERS

works for you?

Also, could you apply this patch, and report the bonus_max value for
your music player under all three scenarios?

I use amarok and use the following line, something similar should also
work for PA.

# grep bonus_max `grep -l amarokapp /proc/*/task/*/sched`

All of the above assumes you have:

CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_DEBUG_FS=y


---
Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -977,6 +977,7 @@ struct sched_entity {
 	u64			block_max;
 	u64			exec_max;
 	u64			slice_max;
+	u64			bonus_max;
 
 	u64			nr_migrations;
 	u64			nr_migrations_cold;
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -2587,6 +2587,7 @@ static void __sched_fork(struct task_str
 	p->se.block_max			= 0;
 	p->se.exec_max			= 0;
 	p->se.slice_max			= 0;
+	p->se.bonus_max			= 0;
 	p->se.wait_max			= 0;
 #endif
 
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -325,6 +325,7 @@ void proc_sched_show_task(struct task_st
 	PN(se.block_max);
 	PN(se.exec_max);
 	PN(se.slice_max);
+	PN(se.bonus_max);
 	PN(se.wait_max);
 	PN(se.wait_sum);
 	P(se.wait_count);
@@ -402,6 +403,7 @@ void proc_sched_set_task(struct task_str
 	p->se.block_max				= 0;
 	p->se.exec_max				= 0;
 	p->se.slice_max				= 0;
+	p->se.bonus_max				= 0;
 	p->se.nr_migrations			= 0;
 	p->se.nr_migrations_cold		= 0;
 	p->se.nr_failed_migrations_affine	= 0;
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -662,9 +662,12 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
-			if (sched_feat(NORMALIZED_SLEEPER))
-				vruntime -= calc_delta_weight(sysctl_sched_latency, se);
-			else
+			if (sched_feat(NORMALIZED_SLEEPER)) {
+				unsigned long bonus;
+				bonus = calc_delta_weight(sysctl_sched_latency, se);
+				schedstat_set(se->bonus_max, max_t(u64, se->bonus_max, bonus));
+				vruntime -= bonus;
+			} else
 				vruntime -= sysctl_sched_latency;
 		}
 


