Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZBQGrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZBQGrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 01:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZBQGq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 01:46:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:39611 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750727AbZBQGqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 01:46:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+jNzIF67mjo1DzBoigvjK1Of+3mpEpqRKeT2BZcp
	5IfdbjsnVewqL2
Subject: Re: [BUG] SCHED_IDLE makes system unresponsive
From: Mike Galbraith <efault@gmx.de>
To: John Werden <jwerden@hotpop.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090216205535.1a1eafe0@desktop.workplace>
References: <20090216205535.1a1eafe0@desktop.workplace>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 07:46:51 +0100
Message-Id: <1234853211.5507.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-02-16 at 20:55 +0100, John Werden wrote:
> I use a file indexer program named pinot and the newest versions of
> it seem to freeze my system (completely unresponsive X Server/GUI,
> frozen mouse pointer, no hdd activity). I could track the problem down
> to a single commit, which makes pinot use SCHED_IDLE instead of
> priority 15:
> 
> http://svn.berlios.de/wsvn/pinot/?op=comp&compare[]=%2F@1557&compare[]=%2F@1558
> 
> I also found out that the problem is already known on the mailing
> list, but I don't know if it was solved with the following commit in
> 2.6.28.2:
> 
> http://lkml.org/lkml/2009/1/22/416
> 
> other related threads I found:
> 
> http://lkml.org/lkml/2009/1/11/70
> http://lkml.org/lkml/2009/1/30/297
> 
> Is this correct? I use 2.6.28.5 and still encounter the problem (I
> didn't test it with earlier kernel versions). How can I work around this
> or/and make SCHED_IDLE work as intended? It looks like right now every
> running program could freeze my system which I definitely don't want.

If you need to use SCHED_IDLE in 28-stable, you'll want the below.

commit 6bc912b71b6f33b041cfde93ca3f019cbaa852bc
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jan 15 14:53:38 2009 +0100

    sched: SCHED_OTHER vs SCHED_IDLE isolation
    
    Stronger SCHED_IDLE isolation:
    
     - no SCHED_IDLE buddies
     - never let SCHED_IDLE preempt on wakeup
     - always preempt SCHED_IDLE on wakeup
     - limit SLEEPER fairness for SCHED_IDLE.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched_fair.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux-2.6.28/kernel/sched_fair.c
===================================================================
--- linux-2.6.28.orig/kernel/sched_fair.c
+++ linux-2.6.28/kernel/sched_fair.c
@@ -681,9 +681,13 @@ place_entity(struct cfs_rq *cfs_rq, stru
 			unsigned long thresh = sysctl_sched_latency;
 
 			/*
-			 * convert the sleeper threshold into virtual time
+			 * Convert the sleeper threshold into virtual time.
+			 * SCHED_IDLE is a special sub-class.  We care about
+			 * fairness only relative to other SCHED_IDLE tasks,
+			 * all of which have the same weight.
 			 */
-			if (sched_feat(NORMALIZED_SLEEPER))
+			if (sched_feat(NORMALIZED_SLEEPER) &&
+					task_of(se)->policy != SCHED_IDLE)
 				thresh = calc_delta_fair(thresh, se);
 
 			vruntime -= thresh;
@@ -1328,14 +1332,18 @@ wakeup_preempt_entity(struct sched_entit
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->last = se;
+	if (likely(task_of(se)->policy != SCHED_IDLE)) {
+		for_each_sched_entity(se)
+			cfs_rq_of(se)->last = se;
+	}
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->next = se;
+	if (likely(task_of(se)->policy != SCHED_IDLE)) {
+		for_each_sched_entity(se)
+			cfs_rq_of(se)->next = se;
+	}
 }
 
 /*
@@ -1382,11 +1390,17 @@ static void check_preempt_wakeup(struct
 		return;
 
 	/*
-	 * Batch tasks do not preempt (their preemption is driven by
+	 * Batch and idle tasks do not preempt (their preemption is driven by
 	 * the tick):
 	 */
-	if (unlikely(p->policy == SCHED_BATCH))
+	if (unlikely(p->policy != SCHED_NORMAL))
+		return;
+
+	/* Idle tasks are by definition preempted by everybody. */
+	if (unlikely(curr->policy == SCHED_IDLE)) {
+		resched_task(curr);
 		return;
+	}
 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
commit cce7ade803699463ecc62a065ca522004f7ccb3d
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jan 15 14:53:37 2009 +0100

    sched: SCHED_IDLE weight change
    
    Increase the SCHED_IDLE weight from 2 to 3, this gives much more stable
    vruntime numbers.
    
    time advanced in 100ms:
    
     weight=2
    
     64765.988352
     67012.881408
     88501.412352
    
     weight=3
    
     35496.181411
     34130.971298
     35497.411573
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.28/kernel/sched.c
===================================================================
--- linux-2.6.28.orig/kernel/sched.c
+++ linux-2.6.28/kernel/sched.c
@@ -1314,8 +1314,8 @@ static inline void update_load_sub(struc
  * slice expiry etc.
  */
 
-#define WEIGHT_IDLEPRIO		2
-#define WMULT_IDLEPRIO		(1 << 31)
+#define WEIGHT_IDLEPRIO                3
+#define WMULT_IDLEPRIO         1431655765
 
 /*
  * Nice levels are multiplicative, with a gentle 10% change for every


