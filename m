Return-Path: <linux-kernel-owner+w=401wt.eu-S1763936AbYESVzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763936AbYESVzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762925AbYESVzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:55:21 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44616 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297AbYESVzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:55:11 -0400
Date: Tue, 20 May 2008 00:53:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC: 2.6 patch] build kernel/profile.o only when requested
Message-ID: <20080519215306.GD17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build kernel/profile.o only if CONFIG_PROFILING is enabled.

This makes CONFIG_PROFILING=n kernels smaller.

As a bonus, some profile_tick() calls and one branch from schedule() are 
now eliminated with CONFIG_PROFILING=n (but I doubt these are
measurable effects).

This patch changes the effects of CONFIG_PROFILING=n, but I don't think 
having more than two choices would be the better choice.

This patch also adds the name of the first parameter to the prototypes 
of profile_{hits,tick}() since I anyway had to add them for the dummy 
functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/profile.h |   56 +++++++++++++++++++++++++++-------------
 kernel/Makefile         |    3 +-
 kernel/profile.c        |    4 --
 3 files changed, 41 insertions(+), 22 deletions(-)

182e01e59fe8cb1a93e1fb2589007ab938312626 diff --git a/include/linux/profile.h b/include/linux/profile.h
index 05c1cc7..4081fa3 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -8,8 +8,6 @@
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
-
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
 #define SLEEP_PROFILING	3
@@ -19,14 +17,29 @@ struct proc_dir_entry;
 struct pt_regs;
 struct notifier_block;
 
+#if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
+void create_prof_cpu_mask(struct proc_dir_entry *);
+#else
+#define create_prof_cpu_mask(x)			do { (void)(x); } while (0)
+#endif
+
+enum profile_type {
+	PROFILE_TASK_EXIT,
+	PROFILE_MUNMAP
+};
+
+#ifdef CONFIG_PROFILING
+
+extern int prof_on __read_mostly;
+
 /* init basic kernel profiler */
 void __init profile_init(void);
-void profile_tick(int);
+void profile_tick(int type);
 
 /*
  * Add multiple profiler hits to a given address:
  */
-void profile_hits(int, void *ip, unsigned int nr_hits);
+void profile_hits(int type, void *ip, unsigned int nr_hits);
 
 /*
  * Single profiler hit:
@@ -40,19 +53,6 @@ static inline void profile_hit(int type, void *ip)
 		profile_hits(type, ip, 1);
 }
 
-#ifdef CONFIG_PROC_FS
-void create_prof_cpu_mask(struct proc_dir_entry *);
-#else
-#define create_prof_cpu_mask(x)			do { (void)(x); } while (0)
-#endif
-
-enum profile_type {
-	PROFILE_TASK_EXIT,
-	PROFILE_MUNMAP
-};
-
-#ifdef CONFIG_PROFILING
-
 struct task_struct;
 struct mm_struct;
 
@@ -80,6 +80,28 @@ struct pt_regs;
 
 #else
 
+#define prof_on 0
+
+static inline void profile_init(void)
+{
+	return;
+}
+
+static inline void profile_tick(int type)
+{
+	return;
+}
+
+static inline void profile_hits(int type, void *ip, unsigned int nr_hits)
+{
+	return;
+}
+
+static inline void profile_hit(int type, void *ip)
+{
+	return;
+}
+
 static inline int task_handoff_register(struct notifier_block * n)
 {
 	return -ENOSYS;
diff --git a/kernel/Makefile b/kernel/Makefile
index 1c9938a..05ea52b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
+obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
@@ -11,6 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
+obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/profile.c b/kernel/profile.c
index ae7ead8..4f53f09 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -112,8 +112,6 @@ void __init profile_init(void)
 
 /* Profile event notifications */
 
-#ifdef CONFIG_PROFILING
-
 static BLOCKING_NOTIFIER_HEAD(task_exit_notifier);
 static ATOMIC_NOTIFIER_HEAD(task_free_notifier);
 static BLOCKING_NOTIFIER_HEAD(munmap_notifier);
@@ -203,8 +201,6 @@ void unregister_timer_hook(int (*hook)(struct pt_regs *))
 }
 EXPORT_SYMBOL_GPL(unregister_timer_hook);
 
-#endif /* CONFIG_PROFILING */
-
 
 #ifdef CONFIG_SMP
 /*

