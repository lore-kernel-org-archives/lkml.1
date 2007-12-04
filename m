Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbXLDQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbXLDQSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbXLDQSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:18:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43601 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbXLDQSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:18:42 -0500
Date: Tue, 4 Dec 2007 17:18:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: [git pull] scheduler fixes
Message-ID: <20071204161827.GA491@elte.hu>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <20071204120715.4ea204a8@mandriva.com.br> <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org> <20071204160005.GA29783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204160005.GA29783@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> The problem is on SMP: if sched_rr_get_interval() gets a task from an 
> otherwise idle runqueue, then rq->load.weight is 0. Normally 
> sched_slice() is only used on a busy runqueue. So the correct fixup 
> site is not in sched_slice() but in sys_sched_rr_get_interval() - i'm 
> working on the right fix, i hope to be able to send a pull request in 
> a few minutes.

the problem is on UP too - if there are no SCHED_OTHER tasks. I've 
tested the fix and it solves the problem for various combinations of 
crash.c. I've updated sched.git, please pull it from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

It has another commit besides this fix. Thanks,

	Ingo

------------------>

Ingo Molnar (2):
      sched: fix crash in sys_sched_rr_get_interval()
      sched: default to more agressive yield for SCHED_BATCH tasks

 sched.c      |   14 +++++++++-----
 sched_fair.c |    7 ++++---
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 59ff6b1..b062856 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4850,17 +4850,21 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 	if (retval)
 		goto out_unlock;
 
-	if (p->policy == SCHED_FIFO)
-		time_slice = 0;
-	else if (p->policy == SCHED_RR)
+	/*
+	 * Time slice is 0 for SCHED_FIFO tasks and for SCHED_OTHER
+	 * tasks that are on an otherwise idle runqueue:
+	 */
+	time_slice = 0;
+	if (p->policy == SCHED_RR) {
 		time_slice = DEF_TIMESLICE;
-	else {
+	} else {
 		struct sched_entity *se = &p->se;
 		unsigned long flags;
 		struct rq *rq;
 
 		rq = task_rq_lock(p, &flags);
-		time_slice = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
+		if (rq->cfs.load.weight)
+			time_slice = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
 		task_rq_unlock(rq, &flags);
 	}
 	read_unlock(&tasklist_lock);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37bb265..c33f0ce 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -799,8 +799,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
  */
 static void yield_task_fair(struct rq *rq)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(rq->curr);
-	struct sched_entity *rightmost, *se = &rq->curr->se;
+	struct task_struct *curr = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	struct sched_entity *rightmost, *se = &curr->se;
 
 	/*
 	 * Are we the only task in the tree?
@@ -808,7 +809,7 @@ static void yield_task_fair(struct rq *rq)
 	if (unlikely(cfs_rq->nr_running == 1))
 		return;
 
-	if (likely(!sysctl_sched_compat_yield)) {
+	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
 		__update_rq_clock(rq);
 		/*
 		 * Update run-time statistics of the 'current'.
