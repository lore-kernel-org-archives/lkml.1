Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZLWJHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZLWJHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZLWJHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:07:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:35086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZLWJHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:07:18 -0500
Date: Wed, 23 Dec 2009 09:06:36 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, eparis@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eparis@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1261492999.4937.36.camel@laptop>
References: <1261492999.4937.36.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Revert 738d2be, simplify set_task_cpu()
Message-ID: <tip-0c69774e6ce94364cfaa8bdeb18061edc414bc5a@git.kernel.org>
Git-Commit-ID: 0c69774e6ce94364cfaa8bdeb18061edc414bc5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c69774e6ce94364cfaa8bdeb18061edc414bc5a
Gitweb:     http://git.kernel.org/tip/0c69774e6ce94364cfaa8bdeb18061edc414bc5a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 22 Dec 2009 15:43:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Dec 2009 10:04:10 +0100

sched: Revert 738d2be, simplify set_task_cpu()

Effectively reverts 738d2be4301007f054541c5c4bf7fb6a361c9b3a.

As demonstrated by Eric, we really need to call __set_task_cpu()
early in the fork() path to properly initialize the various task
state -- specifically the cgroup state through set_task_rq().

[ we could probably fix this by explicitly calling
  __set_task_cpu() from   sched_fork(), but lets try that for the
  next cycle and simply revert to the old behaviour for now. ]

Reported-by: Eric Paris <eparis@redhat.com>
Tested-by: Eric Paris <eparis@redhat.com>,
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: efault@gmx.de
LKML-Reference: <1261492999.4937.36.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 87f1f47..c535cc4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2045,11 +2045,10 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	trace_sched_migrate_task(p, new_cpu);
 
-	if (task_cpu(p) == new_cpu)
-		return;
-
-	p->se.nr_migrations++;
-	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+	if (task_cpu(p) != new_cpu) {
+		p->se.nr_migrations++;
+		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+	}
 
 	__set_task_cpu(p, new_cpu);
 }
