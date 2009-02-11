Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZBKNZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZBKNZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZBKNZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:25:28 -0500
Received: from viefep12-int.chello.at ([62.179.121.32]:40072 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZBKNZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:25:27 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <20090211131156.GN16535@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang>
	 <20090206151832.GL18368@elte.hu>
	 <1234161961.5991.41.camel@minggr.sh.intel.com>
	 <20090209214723.GA2664@elte.hu> <1234270044.23438.7.camel@twins>
	 <20090211131156.GN16535@elte.hu>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 14:27:17 +0100
Message-Id: <1234358837.23438.161.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 14:11 +0100, Ingo Molnar wrote:

> Could you please send a changelogged minimal reverter patch with Reported-by
> and Bisected-by tags in place, etc? It does not have to be a full revert,
> if you think we can do with less that's fine too.

I don't think its worth playing games with at this point, lets just do a
full revert.

---
Subject: sched: revert recent sync wakeup changes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Feb 11 14:22:24 CET 2009

Intel reported a hefty 10% regression on a 16-way machine with these patches:

  1596e29: sched: symmetric sync vs avg_overlap
  d942fb6: sched: fix sync wakeups

Revert them.

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Bisected-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   10 ----------
 kernel/sched_fair.c |   11 +++++++++--
 2 files changed, 9 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2362,16 +2362,6 @@ static int try_to_wake_up(struct task_st
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
-	if (!sync) {
-		if (current->se.avg_overlap < sysctl_sched_migration_cost &&
-			  p->se.avg_overlap < sysctl_sched_migration_cost)
-			sync = 1;
-	} else {
-		if (current->se.avg_overlap >= sysctl_sched_migration_cost ||
-			  p->se.avg_overlap >= sysctl_sched_migration_cost)
-			sync = 0;
-	}
-
 #ifdef CONFIG_SMP
 	if (sched_feat(LB_WAKEUP_UPDATE)) {
 		struct sched_domain *sd;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1191,15 +1191,20 @@ wake_affine(struct sched_domain *this_sd
 	    int idx, unsigned long load, unsigned long this_load,
 	    unsigned int imbalance)
 {
+	struct task_struct *curr = this_rq->curr;
+	struct task_group *tg;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
-	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
 
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
+	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
+			p->se.avg_overlap > sysctl_sched_migration_cost))
+		sync = 0;
+
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1473,7 +1478,9 @@ static void check_preempt_wakeup(struct 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (sched_feat(WAKEUP_OVERLAP) && sync) {
+	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
+			(se->avg_overlap < sysctl_sched_migration_cost &&
+			 pse->avg_overlap < sysctl_sched_migration_cost))) {
 		resched_task(curr);
 		return;
 	}


