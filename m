Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZALNEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZALNEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZALND7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:03:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:51765 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752771AbZALND6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:03:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/0FH5bFov08KGGt/lgBMjJu2STwbfqlflBC78r3x
	R50V5+poJJDPR6
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1231736941.6003.7.camel@marge.simson.net>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:03:53 +0100
Message-Id: <1231765433.5789.35.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 06:09 +0100, Mike Galbraith wrote:
> On Sun, 2009-01-11 at 02:58 -0800, Brian Rogers wrote:
> > The attached program gives itself idle priority, then forks off two 
> > child processes that execute a busy loop. The result is that sometimes 
> > all other processes stop and the whole system freezes until this program 
> > exits. An affected system will respond to pings, but X freezes, the 
> > cursor won't move, SSH sessions won't respond or echo characters back, 
> > and not even a text console will budge. Hitting Alt-SysRq-N twice can 
> > sometimes unfreeze the system, or you can just wait for the program to exit.
> > 
> > This bug is in 2.6.29-rc1. I have also observed this bug in 2.6.28 on 
> > two dual-core systems, an Athlon X2 desktop and a Core 2 Duo laptop. 
> > Both are running a 64-bit system. Using i386 and amd64 Ubuntu Jaunty 
> > daily builds with a 2.6.28 kernel, I found I could reproduce the problem 
> > with the 64-bit kernel, but not the 32-bit kernel. Since that might just 
> > be due to a difference in the kernel configurations, I'm attaching the 
> > kernel configuration on which I know this problem can be triggered.
> > 
> > It may take a couple-dozen runs of this program for the freeze to occur. 
> > Just hit control-C and re-run the program until it happens. When it does 
> > freeze, the effect is immediate, so there's no chance you'll interrupt 
> > the program too soon.
> 
> Hi,
> 
> I haven't been able to reproduce complete hangs, but with your proggy
> adapted to my quad, _and_ the addition of a SCHED_NORMAL hog, I can
> reproduce some very bad interactivity, including massive character
> repeats while attempting to type, and general "lurchiness" (_bad_ wakeup
> latency).  I'll poke it with a sharp stick or two.

Would you mind trying the below?

Impact: fix latency issues when SCHED_IDLE tasks are queued.

Exclude SCHED_IDLE tasks from wakeup preemption, ensure that same will
always be wakeup preempted, and exclude them from being buddies so they
will only be selected via their vruntime.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched.c b/kernel/sched.c
index deb5ac8..5582065 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1888,8 +1888,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			schedstat_inc(p, se.nr_forced2_migrations);
 	}
 #endif
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+	p->se.vruntime = new_cfsrq->min_vruntime;
 
 	__set_task_cpu(p, new_cpu);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e1352c..500ed14 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1340,14 +1340,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->last = se;
+	for_each_sched_entity(se) {
+		if (likely(task_of(se)->policy != SCHED_IDLE))
+			cfs_rq_of(se)->last = se;
+	}
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->next = se;
+	for_each_sched_entity(se) {
+		if (likely(task_of(se)->policy != SCHED_IDLE))
+			cfs_rq_of(se)->next = se;
+	}
 }
 
 /*
@@ -1393,12 +1397,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 		return;
 
 	/*
-	 * Batch tasks do not preempt (their preemption is driven by
+	 * Batch and idle tasks do not preempt (their preemption is driven by
 	 * the tick):
 	 */
-	if (unlikely(p->policy == SCHED_BATCH))
+	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
+	/* Idle tasks are by definition preempted by everybody. */
+	if (unlikely(curr->policy == SCHED_IDLE)) {
+		resched_task(curr);
+		return;
+	}
+
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 


