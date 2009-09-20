Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZITSHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZITSHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZITSHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:07:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:50122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbZITSHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:07:18 -0400
Date: Sun, 20 Sep 2009 18:06:52 GMT
From: tip-bot for Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200909191855.n8JItiko022148@imap1.linux-foundation.org>
References: <200909191855.n8JItiko022148@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix raciness in runqueue_is_locked()
Message-ID: <tip-89f19f04dc72363d912fd007a399cb10310eff6e@git.kernel.org>
Git-Commit-ID: 89f19f04dc72363d912fd007a399cb10310eff6e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:06:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89f19f04dc72363d912fd007a399cb10310eff6e
Gitweb:     http://git.kernel.org/tip/89f19f04dc72363d912fd007a399cb10310eff6e
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Sat, 19 Sep 2009 11:55:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:00:32 +0200

sched: Fix raciness in runqueue_is_locked()

runqueue_is_locked() is unavoidably racy due to a poor interface design.
It does

	cpu = get_cpu()
	ret = some_perpcu_thing(cpu);
	put_cpu(cpu);
	return ret;

Its return value is unreliable.

Fix.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <200909191855.n8JItiko022148@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |   10 ++--------
 kernel/trace/trace.c  |    8 +++++++-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8af3d24..cc37a3f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -257,7 +257,7 @@ extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
-extern int runqueue_is_locked(void);
+extern int runqueue_is_locked(int cpu);
 extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
diff --git a/kernel/sched.c b/kernel/sched.c
index faf4d46..575fb01 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -681,15 +681,9 @@ inline void update_rq_clock(struct rq *rq)
  * This interface allows printk to be called with the runqueue lock
  * held and know whether or not it is OK to wake up the klogd.
  */
-int runqueue_is_locked(void)
+int runqueue_is_locked(int cpu)
 {
-	int cpu = get_cpu();
-	struct rq *rq = cpu_rq(cpu);
-	int ret;
-
-	ret = spin_is_locked(&rq->lock);
-	put_cpu();
-	return ret;
+	return spin_is_locked(&cpu_rq(cpu)->lock);
 }
 
 /*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fd52a19..420232a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -275,12 +275,18 @@ static DEFINE_SPINLOCK(tracing_start_lock);
  */
 void trace_wake_up(void)
 {
+	int cpu;
+
+	if (trace_flags & TRACE_ITER_BLOCK)
+		return;
 	/*
 	 * The runqueue_is_locked() can fail, but this is the best we
 	 * have for now:
 	 */
-	if (!(trace_flags & TRACE_ITER_BLOCK) && !runqueue_is_locked())
+	cpu = get_cpu();
+	if (!runqueue_is_locked(cpu))
 		wake_up(&trace_wait);
+	put_cpu();
 }
 
 static int __init set_buf_size(char *str)
