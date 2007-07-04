Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXGDVed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXGDVed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbXGDVe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:34:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:22313 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbXGDVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=M5X5ZxugjhTbby1J8hDVsxKLNuEyRn4vvHJS77iBo2M6m5LhYTcoiVrY64EjO1hFF5RBKEgB6gyvRS+veZ0UQyG7CWuv1NSTCXWT0tBx+UCXAwZ0+VF9SS0JA9ZzWjKbQ7Mygkh2mt9bUY5dkQ5oN91rHqvUIKZkjWXSPAuCx88=
Date: Thu, 5 Jul 2007 01:34:20 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Some love to default profiler
Message-ID: <20070704213420.GA5864@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Drop __KERNEL__ out of profile.h. It contains only internal kernel stuff and
   not in exported headers list
2) Put profile.c under CONFIG_PROFILING. You enabled profiling in config, you
   will get it. Removes conditional branch from schedule(). Code savings on my
   usual config:

	   text	   data	    bss	    dec	    hex	filename
	2921871	 179895	 180224	3281990	 321446	vmlinux		before
	2920141	 179847	 180224	3280212	 320d54	vmlinux		after
	--------------------------------------------------------------
	  -1730     -48           -1778

3) Make timer_hook static (hi, Adrian!)
4) Convert do {} while (0) into static inline functions
5) minor misc stuff

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/profile.h |   78 +++++++++++++++++++++++++-----------------------
 kernel/Makefile         |    3 +
 kernel/profile.c        |    2 -
 3 files changed, 44 insertions(+), 39 deletions(-)

--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_PROFILE_H
 #define _LINUX_PROFILE_H
 
-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/cpumask.h>
@@ -10,16 +8,22 @@
 
 #include <asm/errno.h>
 
-extern int prof_on __read_mostly;
+struct proc_dir_entry;
+struct pt_regs;
+struct notifier_block;
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
 #define SLEEP_PROFILING	3
 #define KVM_PROFILING	4
 
-struct proc_dir_entry;
-struct pt_regs;
-struct notifier_block;
+enum profile_type {
+	PROFILE_TASK_EXIT,
+	PROFILE_MUNMAP
+};
+
+#ifdef CONFIG_PROFILING
+extern int prof_on __read_mostly;
 
 /* init basic kernel profiler */
 void __init profile_init(void);
@@ -42,22 +46,6 @@ static inline void profile_hit(int type, void *ip)
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
-struct task_struct;
-struct mm_struct;
-
 /* task is in do_exit() */
 void profile_task_exit(struct task_struct * task);
 
@@ -77,14 +65,30 @@ int profile_event_unregister(enum profile_type, struct notifier_block * n);
 
 int register_timer_hook(int (*hook)(struct pt_regs *));
 void unregister_timer_hook(int (*hook)(struct pt_regs *));
-
-/* Timer based profiling hook */
-extern int (*timer_hook)(struct pt_regs *);
-
-struct pt_regs;
-
 #else
-
+#define prof_on 0
+static inline void profile_init(void)
+{
+}
+static inline void profile_tick(int type)
+{
+}
+static inline void profile_hits(int type, void *ip, unsigned int nr_hits)
+{
+}
+static inline void profile_hit(int type, void *ip)
+{
+}
+static inline void profile_munmap(unsigned long addr)
+{
+}
+static inline void profile_task_exit(struct task_struct *tsk)
+{
+}
+static inline int profile_handoff_task(struct task_struct *tsk)
+{
+	return 0;
+}
 static inline int task_handoff_register(struct notifier_block * n)
 {
 	return -ENOSYS;
@@ -105,10 +109,6 @@ static inline int profile_event_unregister(enum profile_type t, struct notifier_
 	return -ENOSYS;
 }
 
-#define profile_task_exit(a) do { } while (0)
-#define profile_handoff_task(a) (0)
-#define profile_munmap(a) do { } while (0)
-
 static inline int register_timer_hook(int (*hook)(struct pt_regs *))
 {
 	return -ENOSYS;
@@ -116,11 +116,15 @@ static inline int register_timer_hook(int (*hook)(struct pt_regs *))
 
 static inline void unregister_timer_hook(int (*hook)(struct pt_regs *))
 {
-	return;
 }
+#endif
 
-#endif /* CONFIG_PROFILING */
-
-#endif /* __KERNEL__ */
+#ifdef CONFIG_PROC_FS
+void create_prof_cpu_mask(struct proc_dir_entry *);
+#else
+static inline void create_prof_cpu_mask(struct proc_dir_entry *pde)
+{
+}
+#endif
 
 #endif /* _LINUX_PROFILE_H */
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
@@ -10,6 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o
 
+obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -37,7 +37,7 @@ struct profile_hit {
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
 /* Oprofile timer tick hook */
-int (*timer_hook)(struct pt_regs *) __read_mostly;
+static int (*timer_hook)(struct pt_regs *) __read_mostly;
 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;

