Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbZIQHzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbZIQHzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIQHzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:55:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:53797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZIQHzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:55:05 -0400
Date: Thu, 17 Sep 2009 07:54:35 GMT
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
Message-ID: <tip-eb24073bc1fe3e569a855cf38d529fb650c35524@git.kernel.org>
Git-Commit-ID: eb24073bc1fe3e569a855cf38d529fb650c35524
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:54:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb24073bc1fe3e569a855cf38d529fb650c35524
Gitweb:     http://git.kernel.org/tip/eb24073bc1fe3e569a855cf38d529fb650c35524
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 21:09:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 09:51:20 +0200

sched: Fix TASK_WAKING & loadaverage breakage

Fix this:

top - 21:54:00 up  2:59,  1 user,  load average: 432512.33, 426421.74, 417432.74

Which happens because we now set TASK_WAKING before activate_task().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5049d95..969dfae 100644
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
 
