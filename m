Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZJWOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZJWOq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZJWOqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:46:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZJWOqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:46:54 -0400
Date: Fri, 23 Oct 2009 16:46:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] scheduler fixes
Message-ID: <20091023144648.GA11665@elte.hu>
References: <20091023144328.GA10521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023144328.GA10521@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest sched-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Sorry - the tail commit was bad and i forgot to exclude it. Updated pull 
request (with different URI):

Please pull the latest sched-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus-2

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      sched: Disable SD_PREFER_LOCAL for MC/CPU domains
      sched: Do less agressive buddy clearing


 arch/x86/include/asm/topology.h |    1 +
 include/linux/topology.h        |    4 ++--
 kernel/sched_fair.c             |   27 +++++++++++++--------------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 25a9284..d823c24 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,6 +143,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fc0bf3e..57e6357 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -162,7 +162,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..c32c3e6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -861,12 +861,21 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *buddy;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1)
-		return cfs_rq->next;
+	if (cfs_rq->next) {
+		buddy = cfs_rq->next;
+		cfs_rq->next = NULL;
+		if (wakeup_preempt_entity(buddy, se) < 1)
+			return buddy;
+	}
 
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1)
-		return cfs_rq->last;
+	if (cfs_rq->last) {
+		buddy = cfs_rq->last;
+		cfs_rq->last = NULL;
+		if (wakeup_preempt_entity(buddy, se) < 1)
+			return buddy;
+	}
 
 	return se;
 }
@@ -1654,16 +1663,6 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
-		/*
-		 * If se was a buddy, clear it so that it will have to earn
-		 * the favour again.
-		 *
-		 * If se was not a buddy, clear the buddies because neither
-		 * was elegible to run, let them earn it again.
-		 *
-		 * IOW. unconditionally clear buddies.
-		 */
-		__clear_buddies(cfs_rq, NULL);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
