Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab0CKOmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:42:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:35527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab0CKOm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:42:28 -0500
Date: Thu, 11 Mar 2010 14:41:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, dhaval.giani@gmail.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dhaval.giani@gmail.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix pick_next_highest_task_rt() for cgroups
Message-ID: <tip-3d07467b7aa91623b31d7b5888a123a2c8c8e9cc@git.kernel.org>
Git-Commit-ID: 3d07467b7aa91623b31d7b5888a123a2c8c8e9cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:41:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d07467b7aa91623b31d7b5888a123a2c8c8e9cc
Gitweb:     http://git.kernel.org/tip/3d07467b7aa91623b31d7b5888a123a2c8c8e9cc
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Mar 2010 17:07:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 15:21:50 +0100

sched: Fix pick_next_highest_task_rt() for cgroups

Since pick_next_highest_task_rt() already iterates all the cgroups and
is really only interested in tasks, skip over the !task entries.

Reported-by: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Dhaval Giani <dhaval.giani@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bf3e38f..c4fb42a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1146,7 +1146,12 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 		if (next && next->prio < idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p = rt_task_of(rt_se);
+			struct task_struct *p;
+
+			if (!rt_entity_is_task(rt_se))
+				continue;
+
+			p = rt_task_of(rt_se);
 			if (pick_rt_task(rq, p, cpu)) {
 				next = p;
 				break;
