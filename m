Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073Ab0AUNwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0AUNwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894Ab0AUNwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:52:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:46231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0AUNwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:52:31 -0500
Date: Thu, 21 Jan 2010 13:51:53 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yong.zhang0@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, yong.zhang0@gmail.com,
       mingo@elte.hu
In-Reply-To: <2674af741001102238w7b0ddcadref00d345e2181d11@mail.gmail.com>
References: <2674af741001102238w7b0ddcadref00d345e2181d11@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Reassign prev and switch_count when reacquire_kernel_lock() fail
Message-ID: <tip-6d558c3ac9b6508d26fd5cadccce51fc9d726b1c@git.kernel.org>
Git-Commit-ID: 6d558c3ac9b6508d26fd5cadccce51fc9d726b1c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:51:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d558c3ac9b6508d26fd5cadccce51fc9d726b1c
Gitweb:     http://git.kernel.org/tip/6d558c3ac9b6508d26fd5cadccce51fc9d726b1c
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Mon, 11 Jan 2010 14:21:25 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:39:04 +0100

sched: Reassign prev and switch_count when reacquire_kernel_lock() fail

Assume A->B schedule is processing, if B have acquired BKL before and it
need reschedule this time. Then on B's context, it will go to
need_resched_nonpreemptible for reschedule. But at this time, prev and
switch_count are related to A. It's wrong and will lead to incorrect
scheduler statistics.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <2674af741001102238w7b0ddcadref00d345e2181d11@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

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
