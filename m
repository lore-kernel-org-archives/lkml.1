Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZLIJyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZLIJyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZLIJyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:54:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:45079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbZLIJyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:54:18 -0500
Date: Wed, 9 Dec 2009 09:53:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Consolidate select_task_rq() callers
Message-ID: <tip-970b13bacba14a8cef6f642861947df1d175b0b3@git.kernel.org>
Git-Commit-ID: 970b13bacba14a8cef6f642861947df1d175b0b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  970b13bacba14a8cef6f642861947df1d175b0b3
Gitweb:     http://git.kernel.org/tip/970b13bacba14a8cef6f642861947df1d175b0b3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Nov 2009 13:31:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:02 +0100

sched: Consolidate select_task_rq() callers

Small cleanup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
[ v2: build fix ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 68db5a2..01fd131 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2323,6 +2323,14 @@ void task_oncpu_function_call(struct task_struct *p,
 	preempt_enable();
 }
 
+#ifdef CONFIG_SMP
+static inline
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+{
+	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+}
+#endif
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2376,7 +2384,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	p->state = TASK_WAKING;
 	task_rq_unlock(rq, &flags);
 
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu) {
 		local_irq_save(flags);
 		rq = cpu_rq(cpu);
@@ -2593,7 +2601,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
 		p->sched_class = &fair_sched_class;
 
 #ifdef CONFIG_SMP
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
 	local_irq_save(flags);
 	update_rq_clock(cpu_rq(cpu));
@@ -3156,7 +3164,7 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
+	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);
