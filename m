Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbYKGQaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbYKGQaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYKGQ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:29:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54112 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYKGQ36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:29:58 -0500
Date: Fri, 7 Nov 2008 17:29:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: [git pull] scheduler fixes
Message-ID: <20081107162942.GA3747@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched: fine-tune SD_SIBLING_INIT

Li Zefan (2):
      sched: fix a bug in sched domain degenerate
      sched: fix memory leak in a failure path

Mike Galbraith (1):
      sched: fine-tune SD_MC_INIT


 include/linux/topology.h |    4 ++--
 kernel/sched.c           |    7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 34a7ee0..117f1b7 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
-				| SD_WAKE_IDLE		\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_CPUPOWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
@@ -120,10 +120,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\
diff --git a/kernel/sched.c b/kernel/sched.c
index 82cc839..57c933f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6877,15 +6877,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct sched_domain *tmp;
 
 	/* Remove the sched domains which do not contribute to scheduling. */
-	for (tmp = sd; tmp; tmp = tmp->parent) {
+	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
 		if (!parent)
 			break;
+
 		if (sd_parent_degenerate(tmp, parent)) {
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
-		}
+		} else
+			tmp = tmp->parent;
 	}
 
 	if (sd && sd_degenerate(sd)) {
@@ -7674,6 +7676,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 error:
 	free_sched_groups(cpu_map, tmpmask);
 	SCHED_CPUMASK_FREE((void *)allmasks);
+	kfree(rd);
 	return -ENOMEM;
 #endif
 }
