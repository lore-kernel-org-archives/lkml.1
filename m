Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbZFQKdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbZFQKdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759625AbZFQKc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:32:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:38177 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763296AbZFQKc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:32:57 -0400
Date: Wed, 17 Jun 2009 10:32:17 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, efault@gmx.de, lennart@poettering.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, peterz@infradead.org, lennart@poettering.net,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245143108.6038.10.camel@marge.simson.net>
References: <1245143108.6038.10.camel@marge.simson.net>
Subject: [tip:sched/core] sched: Introduce SCHED_RESET_ON_FORK scheduling policy flag, fix
Message-ID: <tip-e53438963eacc5624b61293f64e9f93c71f71198@git.kernel.org>
Git-Commit-ID: e53438963eacc5624b61293f64e9f93c71f71198
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 10:32:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e53438963eacc5624b61293f64e9f93c71f71198
Gitweb:     http://git.kernel.org/tip/e53438963eacc5624b61293f64e9f93c71f71198
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 16 Jun 2009 11:05:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 09:01:51 +0200

sched: Introduce SCHED_RESET_ON_FORK scheduling policy flag, fix

Make SCHED_RESET_ON_FORK to DTRT for reniced tasks, and make the
sched_fork() SCHED_RESET_ON_FORK bits a self-contained unlikely
code block.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Lennart Poettering <lennart@poettering.net>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245143108.6038.10.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
 kernel/sched.c |   41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)


---
 kernel/sched.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 32e6ede..34f9424 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2613,28 +2613,35 @@ void sched_fork(struct task_struct *p, int clone_flags)
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
+		if (PRIO_TO_NICE(p->static_prio) < 0) {
+			p->static_prio = NICE_TO_PRIO(0);
+			set_load_weight(p);
+		}
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
