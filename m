Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbZJIOYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbZJIOYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbZJIOYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:24:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:42828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335AbZJIOYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:24:21 -0400
Date: Fri, 9 Oct 2009 14:23:20 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1255070103.7639.30.camel@marge.simson.net>
References: <1255070103.7639.30.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Update the clock of runqueue select_task_rq() selected
Message-ID: <tip-f5dc37530ba8a35aae0f7f4f13781d1904f71e94@git.kernel.org>
Git-Commit-ID: f5dc37530ba8a35aae0f7f4f13781d1904f71e94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Oct 2009 14:23:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5dc37530ba8a35aae0f7f4f13781d1904f71e94
Gitweb:     http://git.kernel.org/tip/f5dc37530ba8a35aae0f7f4f13781d1904f71e94
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 9 Oct 2009 08:35:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Oct 2009 15:58:11 +0200

sched: Update the clock of runqueue select_task_rq() selected

In try_to_wake_up(), we update the runqueue clock, but
select_task_rq() may select a different runqueue than the one we
updated, leaving the new runqueue's clock stale for a bit.

This patch cures occasional huge latencies reported by latencytop
when coming out of idle on a mostly idle NO_HZ box.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1255070103.7639.30.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 76c0e96..e3f8f4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2311,7 +2311,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq, *orig_rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2319,7 +2319,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
+	rq = orig_rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
@@ -2350,6 +2350,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 		set_task_cpu(p, cpu);
 
 	rq = task_rq_lock(p, &flags);
+
+	if (rq != orig_rq)
+		update_rq_clock(rq);
+
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
