Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936015Ab0COJMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935985Ab0COJM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:29 -0400
Date: Mon, 15 Mar 2010 10:10:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] sched_exec: remove select_fallback_rq() logic
Message-ID: <20100315091019.GA9141@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_exec()->select_task_rq() reads/updates ->cpus_allowed lockless.
This can race with other CPUs updating our ->cpus_allowed, and this
looks meaningless to me.

The task is current and running, it must have online cpus in ->cpus_allowed,
the fallback mode is bogus. And, if ->sched_class returns the "wrong" cpu,
this likely means we raced with set_cpus_allowed() which was called
for reason, why should sched_exec() retry and call ->select_task_rq()
again?

Change the code to call sched_class->select_task_rq() directly and do
nothing if the returned cpu is wrong after re-checking under rq->lock.

>From now task_struct->cpus_allowed is always stable under TASK_WAKING,
select_fallback_rq() is always called under rq-lock or the caller or
the caller owns TASK_WAKING (select_task_rq).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- 34-rc1/kernel/sched.c~3_SCHED_EXEC_DONT_FALLBACK	2010-03-15 09:40:44.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-15 09:41:28.000000000 +0100
@@ -2272,6 +2272,9 @@ void task_oncpu_function_call(struct tas
 }
 
 #ifdef CONFIG_SMP
+/*
+ * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
 	int dest_cpu;
@@ -2308,12 +2311,7 @@ static int select_fallback_rq(int cpu, s
 }
 
 /*
- * Gets called from 3 sites (exec, fork, wakeup), since it is called without
- * holding rq->lock we need to ensure ->cpus_allowed is stable, this is done
- * by:
- *
- *  exec:           is unstable, retry loop
- *  fork & wake-up: serialize ->cpus_allowed against TASK_WAKING
+ * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
  */
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
@@ -3123,9 +3121,8 @@ void sched_exec(void)
 	unsigned long flags;
 	struct rq *rq;
 
-again:
 	this_cpu = get_cpu();
-	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == this_cpu) {
 		put_cpu();
 		return;
@@ -3133,18 +3130,12 @@ again:
 
 	rq = task_rq_lock(p, &flags);
 	put_cpu();
-
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu))) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
-
-	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
+	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
+	    likely(cpu_active(dest_cpu)) &&
+	    migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
 		struct task_struct *mt = rq->migration_thread;
 

