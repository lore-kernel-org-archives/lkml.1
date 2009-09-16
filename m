Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZIPTNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZIPTNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZIPTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:13:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:40616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZIPTNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:13:31 -0400
Date: Wed, 16 Sep 2009 19:13:02 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix TASK_WAKING & loadaverage breakage
Message-ID: <tip-bf2add6a0aacf632a71237ac5fc818a82ea12684@git.kernel.org>
Git-Commit-ID: bf2add6a0aacf632a71237ac5fc818a82ea12684
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 19:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf2add6a0aacf632a71237ac5fc818a82ea12684
Gitweb:     http://git.kernel.org/tip/bf2add6a0aacf632a71237ac5fc818a82ea12684
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 21:09:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 21:09:13 +0200

sched: Fix TASK_WAKING & loadaverage breakage

Fix this:

top - 21:54:00 up  2:59,  1 user,  load average: 432512.33, 426421.74, 417432.74

Which happens because we now set TASK_WAKING before activate_task().

Spread out activate_task() in two parts - this is also
a micro-optimization as try_to_wake_up() is one of the
hottest path.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5049d95..e3fbd83 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2343,7 +2343,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	/*
 	 * In order to handle concurrent wakeups and release the rq->lock
 	 * we put the task in TASK_WAKING state.
+	 *
+	 * First fix up the nr_uninterruptible count:
 	 */
+	if (task_contributes_to_load(p))
+		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
 	task_rq_unlock(rq, &flags);
 
@@ -2381,7 +2385,9 @@ out_activate:
 		schedstat_inc(p, se.nr_wakeups_local);
 	else
 		schedstat_inc(p, se.nr_wakeups_remote);
-	activate_task(rq, p, 1);
+
+	enqueue_task(rq, p, wakeup);
+	inc_nr_running(rq);
 	success = 1;
 
 	/*
