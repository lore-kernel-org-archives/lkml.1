Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYCKPs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYCKPs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbYCKPss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:48:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbYCKPss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:48:48 -0400
Date: Tue, 11 Mar 2008 16:48:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20080311154837.GA27219@elte.hu>
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


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

Thanks,

	Ingo

------------------>
Gregory Haskins (2):
      Revert "cpu hotplug: adjust root-domain->online span in response to hotplug event"
      keep rd->online and cpu_online_map in sync

 kernel/sched.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b02e4fc..1cb53fb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5813,13 +5813,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
 		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
-
-		/* Update our root-domain */
-		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_set(cpu, rq->rd->online);
-		}
-
 		task_rq_unlock(rq, &flags);
 		cpu_rq(cpu)->migration_thread = p;
 		break;
@@ -5828,6 +5821,15 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
+
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_set(cpu, rq->rd->online);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5879,7 +5881,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_unlock_irq(&rq->lock);
 		break;
 
-	case CPU_DOWN_PREPARE:
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
@@ -6103,6 +6106,8 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpu_set(rq->cpu, rd->span);
+	if (cpu_isset(rq->cpu, cpu_online_map))
+		cpu_set(rq->cpu, rd->online);
 
 	for (class = sched_class_highest; class; class = class->next) {
 		if (class->join_domain)
