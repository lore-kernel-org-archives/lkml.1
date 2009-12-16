Return-Path: <linux-kernel-owner+w=401wt.eu-S935132AbZLPSiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132AbZLPSiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762815AbZLPSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:37:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:53433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZLPSh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:37:56 -0500
Date: Wed, 16 Dec 2009 18:37:06 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.577998058@chello.nl>
References: <20091216170517.577998058@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix task_hot() test order
Message-ID: <tip-e6c8fba7771563b2f3dfb96a78f36ec17e15bdf0@git.kernel.org>
Git-Commit-ID: e6c8fba7771563b2f3dfb96a78f36ec17e15bdf0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6c8fba7771563b2f3dfb96a78f36ec17e15bdf0
Gitweb:     http://git.kernel.org/tip/e6c8fba7771563b2f3dfb96a78f36ec17e15bdf0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:54 +0100

sched: Fix task_hot() test order

Make sure not to access sched_fair fields before verifying it is
indeed a sched_fair task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
CC: stable@kernel.org
LKML-Reference: <20091216170517.577998058@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9c30858..1d8ca25 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2046,6 +2046,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 {
 	s64 delta;
 
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
@@ -2054,9 +2057,6 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
 
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
 	if (sysctl_sched_migration_cost == -1)
 		return 1;
 	if (sysctl_sched_migration_cost == 0)
