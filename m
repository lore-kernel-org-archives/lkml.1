Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZFQQhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZFQQhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZFQQhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:37:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:51970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbZFQQh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:37:29 -0400
Date: Wed, 17 Jun 2009 16:36:32 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, efault@gmx.de, mzxreary@0pointer.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, peterz@infradead.org, mzxreary@0pointer.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245228361.18329.6.camel@marge.simson.net>
References: <1245228361.18329.6.camel@marge.simson.net>
Subject: [tip:sched/core] sched: Clean up SCHED_RESET_ON_FORK
Message-ID: <tip-b9dc29e72fd3dc2a739ce8eafd958220d0745734@git.kernel.org>
Git-Commit-ID: b9dc29e72fd3dc2a739ce8eafd958220d0745734
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 16:36:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9dc29e72fd3dc2a739ce8eafd958220d0745734
Gitweb:     http://git.kernel.org/tip/b9dc29e72fd3dc2a739ce8eafd958220d0745734
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 17 Jun 2009 10:46:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 18:34:17 +0200

sched: Clean up SCHED_RESET_ON_FORK

Make SCHED_RESET_ON_FORK sched_fork() bits a self-contained unlikely code path.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245228361.18329.6.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 32e6ede..50e4e3d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2613,28 +2613,30 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	set_task_cpu(p, cpu);
 
 	/*
-	 * Revert to default priority/policy on fork if requested. Make sure we
-	 * do not leak PI boosting priority to the child.
+	 * Make sure we do not leak PI boosting priority to the child.
 	 */
-	if (current->sched_reset_on_fork &&
-			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
-		p->policy = SCHED_NORMAL;
+	p->prio = current->normal_prio;
 
-	if (current->sched_reset_on_fork &&
-			(current->normal_prio < DEFAULT_PRIO))
-		p->prio = DEFAULT_PRIO;
-	else
-		p->prio = current->normal_prio;
+	/*
+	 * Revert to default priority/policy on fork if requested.
+	 */
+	if (unlikely(p->sched_reset_on_fork)) {
+		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR)
+			p->policy = SCHED_NORMAL;
+
+		if (p->normal_prio < DEFAULT_PRIO)
+			p->prio = DEFAULT_PRIO;
+
+		/*
+		 * We don't need the reset flag anymore after the fork. It has
+		 * fulfilled its duty:
+		 */
+		p->sched_reset_on_fork = 0;
+	}
 
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
-	/*
-	 * We don't need the reset flag anymore after the fork. It has
-	 * fulfilled its duty:
-	 */
-	p->sched_reset_on_fork = 0;
-
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
