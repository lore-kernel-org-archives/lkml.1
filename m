Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZEDRfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZEDRfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbZEDRec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:34:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758530AbZEDRe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:34:29 -0400
Date: Mon, 4 May 2009 17:33:55 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: initialize the per-cpu context earlier
Message-ID: <tip-0d905bca23aca5c86a10ee101bcd3b1abbd40b25@git.kernel.org>
Git-Commit-ID: 0d905bca23aca5c86a10ee101bcd3b1abbd40b25
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 17:33:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d905bca23aca5c86a10ee101bcd3b1abbd40b25
Gitweb:     http://git.kernel.org/tip/0d905bca23aca5c86a10ee101bcd3b1abbd40b25
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 4 May 2009 19:13:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 19:30:32 +0200

perf_counter: initialize the per-cpu context earlier

percpu scheduling for perfcounters wants to take the context lock,
but that lock first needs to be initialized. Currently it is an
early_initcall() - but that is too late, the task tick runs much
sooner than that.

Call it explicitly from the scheduler init sequence instead.

[ Impact: fix access-before-init crash ]

LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    5 ++++-
 kernel/perf_counter.c        |    5 +----
 kernel/sched.c               |    5 ++++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index f776851..a356fa6 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -573,6 +573,8 @@ extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_priv;
 
+extern void perf_counter_init(void);
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -600,9 +602,10 @@ perf_counter_mmap(unsigned long addr, unsigned long len,
 
 static inline void
 perf_counter_munmap(unsigned long addr, unsigned long len,
-		    unsigned long pgoff, struct file *file) 		{ }
+		    unsigned long pgoff, struct file *file)		{ }
 
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
+static inline void perf_counter_init(void)				{ }
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b9679c3..fcdafa2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3265,15 +3265,12 @@ static struct notifier_block __cpuinitdata perf_cpu_nb = {
 	.notifier_call		= perf_cpu_notify,
 };
 
-static int __init perf_counter_init(void)
+void __init perf_counter_init(void)
 {
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
 	register_cpu_notifier(&perf_cpu_nb);
-
-	return 0;
 }
-early_initcall(perf_counter_init);
 
 static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 2f600e3..a728976 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -39,6 +39,7 @@
 #include <linux/completion.h>
 #include <linux/kernel_stat.h>
 #include <linux/debug_locks.h>
+#include <linux/perf_counter.h>
 #include <linux/security.h>
 #include <linux/notifier.h>
 #include <linux/profile.h>
@@ -8996,7 +8997,7 @@ void __init sched_init(void)
 		 * 1024) and two child groups A0 and A1 (of weight 1024 each),
 		 * then A0's share of the cpu resource is:
 		 *
-		 * 	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
+		 *	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
 		 *
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
@@ -9097,6 +9098,8 @@ void __init sched_init(void)
 	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 #endif /* SMP */
 
+	perf_counter_init();
+
 	scheduler_running = 1;
 }
 
