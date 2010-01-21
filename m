Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376Ab0AUPgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0AUPgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154Ab0AUPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:36:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab0AUPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:36:01 -0500
Date: Thu, 21 Jan 2010 16:35:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100121153546.GA28147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Mike Galbraith (1):
      sched: Fix vmark regression on big machines

Yong Zhang (1):
      sched: Reassign prev and switch_count when reacquire_kernel_lock() fail


 include/linux/topology.h |    2 +-
 kernel/sched.c           |    5 ++++-
 kernel/sched_fair.c      |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 57e6357..5b81156 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..4508fe7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5530,8 +5530,11 @@ need_resched_nonpreemptible:
 
 	post_schedule(rq);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0))
+	if (unlikely(reacquire_kernel_lock(current) < 0)) {
+		prev = rq->curr;
+		switch_count = &prev->nivcsw;
 		goto need_resched_nonpreemptible;
+	}
 
 	preempt_enable_no_resched();
 	if (need_resched())
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..8fe7ee8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1508,7 +1508,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
