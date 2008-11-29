Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYK2TyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYK2TyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYK2Txn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:53:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYK2Txm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:53:42 -0500
Date: Sat, 29 Nov 2008 20:53:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081129195329.GA27563@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      sched, cpusets: fix warning in kernel/cpuset.c
      sched: prevent divide by zero error in cpu_avg_load_per_task, update

Steven Rostedt (1):
      sched: prevent divide by zero error in cpu_avg_load_per_task


 kernel/cpuset.c |    2 +-
 kernel/sched.c  |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index da7ff61..96c0ba1 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -585,7 +585,7 @@ static int generate_sched_domains(cpumask_t **domains,
 	int i, j, k;		/* indices for partition finding loops */
 	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
-	int ndoms;		/* number of sched domains in result */
+	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
 	doms = NULL;
diff --git a/kernel/sched.c b/kernel/sched.c
index 9b1e793..b7480fb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1453,9 +1453,10 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
-	if (rq->nr_running)
-		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+	if (nr_running)
+		rq->avg_load_per_task = rq->load.weight / nr_running;
 	else
 		rq->avg_load_per_task = 0;
 
