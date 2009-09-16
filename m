Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZIPKYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZIPKYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZIPKYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:24:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:58404 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774AbZIPKYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:24:42 -0400
Date: Wed, 16 Sep 2009 10:24:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add WF_FORK
Message-ID: <tip-a7558e01056f5191ff2ecff53b075dcb9e484188@git.kernel.org>
Git-Commit-ID: a7558e01056f5191ff2ecff53b075dcb9e484188
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:24:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7558e01056f5191ff2ecff53b075dcb9e484188
Gitweb:     http://git.kernel.org/tip/a7558e01056f5191ff2ecff53b075dcb9e484188
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 Sep 2009 20:02:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:31 +0200

sched: Add WF_FORK

Avoid the cache buddies from biasing the time distribution away
from fork()ers. Normally the next buddy will be the preferred
scheduling target, but this makes fork()s prefer to run the new
child, whereas we prefer to run the parent, since that will
generate more work.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 +-
 kernel/sched_fair.c   |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3b07168..ee1f889 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1028,6 +1028,7 @@ struct sched_domain;
  * wake flags
  */
 #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
+#define WF_FORK		0x02		/* child wakeup after fork */
 
 struct sched_class {
 	const struct sched_class *next;
diff --git a/kernel/sched.c b/kernel/sched.c
index 4da335c..0d4c4fe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2602,7 +2602,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		inc_nr_running(rq);
 	}
 	trace_sched_wakeup_new(rq, p, 1);
-	check_preempt_curr(rq, p, 0);
+	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 007958e..6766959 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1580,7 +1580,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int flags
 	 */
 	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	if (sched_feat(NEXT_BUDDY))
+	if (sched_feat(NEXT_BUDDY) && !(flags & WF_FORK))
 		set_next_buddy(pse);
 
 	/*
