Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXLGSVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXLGSVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXLGSVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:21:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbXLGSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:21:44 -0500
Date: Fri, 7 Dec 2007 19:21:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20071207182134.GB26778@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

two commits: a lockdep warning improvement and a sched_clock() fix. 
Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      lockdep: make cli/sti annotation warnings clearer
      sched: enable early use of sched_clock()

 lockdep.c |   13 +++++++++----
 sched.c   |    7 ++++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0f38962..723bd9f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2654,10 +2654,15 @@ static void check_flags(unsigned long flags)
 	if (!debug_locks)
 		return;
 
-	if (irqs_disabled_flags(flags))
-		DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled);
-	else
-		DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled);
+	if (irqs_disabled_flags(flags)) {
+		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
+			printk("possible reason: unannotated irqs-off.\n");
+		}
+	} else {
+		if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
+			printk("possible reason: unannotated irqs-on.\n");
+		}
+	}
 
 	/*
 	 * We dont accurately track softirq state in e.g.
diff --git a/kernel/sched.c b/kernel/sched.c
index 67d9d17..c6e551d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -488,7 +488,12 @@ unsigned long long cpu_clock(int cpu)
 
 	local_irq_save(flags);
 	rq = cpu_rq(cpu);
-	update_rq_clock(rq);
+	/*
+	 * Only call sched_clock() if the scheduler has already been
+	 * initialized (some code might call cpu_clock() very early):
+	 */
+	if (rq->idle)
+		update_rq_clock(rq);
 	now = rq->clock;
 	local_irq_restore(flags);
 

