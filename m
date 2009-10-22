Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZJVOkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZJVOkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbZJVOky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:40:54 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:58821 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbZJVOkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kvTteHAI/wrN/WKJRqENQO0v0NlPXzbGk1PJguHEk4w/WT7KyquhusyGSPG3vNyh1E
         UwIKqpoYk16S+OLgndKf/KLa4lwnqcH+MnLmjdifo5ydW28X7WapLiezcuvFlTE40mux
         9Xev11YOgeTIgLwYZ8YK42REVUpByqid8g+Bk=
MIME-Version: 1.0
In-Reply-To: <e932a33e0910220738v3c612d68ve902a770ab0928f4@mail.gmail.com>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
	 <e932a33e0910220738v3c612d68ve902a770ab0928f4@mail.gmail.com>
Date: Thu, 22 Oct 2009 20:10:56 +0530
Message-ID: <e932a33e0910220740l25ae2980x94a7e47636e1b5bc@mail.gmail.com>
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex, Deadline 
	Based Interrupt Handlers
From: Soumya K S <ssks.mt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the patch inline,,
Thanks,
Soumya

diff -Naur linux-2.6.32-rc3/arch/arm/include/asm/signal.h
linux-2.6.32-rc3-drtl/arch/arm/include/asm/signal.h
--- linux-2.6.32-rc3/arch/arm/include/asm/signal.h      2009-10-05
05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/arch/arm/include/asm/signal.h 2009-10-20
10:40:16.000000000 +0530
@@ -70,6 +70,7 @@
 #define SIGRTMIN       32
 #define SIGRTMAX       _NSIG

+#define SIGMISSDEAD    SIGRTMIN + 4
 #define SIGSWI         32

 /*
diff -Naur linux-2.6.32-rc3/include/linux/interrupt.h
linux-2.6.32-rc3-drtl/include/linux/interrupt.h
--- linux-2.6.32-rc3/include/linux/interrupt.h  2009-10-05
05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/include/linux/interrupt.h     2009-10-20
11:55:45.000000000 +0530
@@ -107,6 +107,12 @@
 };

 extern irqreturn_t no_action(int cpl, void *dev_id);
+#ifdef CONFIG_SCHED_EDF
+extern int __must_check
+request_irq_edf(unsigned int irq, irq_handler_t handler,irq_handler_t
thread_fn, unsigned long flags,
+               const char *name, void *dev, struct timespec *ts);
+#endif
+

 #ifdef CONFIG_GENERIC_HARDIRQS
 extern int __must_check
diff -Naur linux-2.6.32-rc3/include/linux/irq.h
linux-2.6.32-rc3-drtl/include/linux/irq.h
--- linux-2.6.32-rc3/include/linux/irq.h        2009-10-05
05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/include/linux/irq.h   2009-10-20
11:51:27.000000000 +0530
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/wait.h>
+#include <linux/ktime.h>

 #include <asm/irq.h>
 #include <asm/ptrace.h>
@@ -206,6 +207,8 @@
       struct proc_dir_entry   *dir;
 #endif
       const char              *name;
+       ktime_t                 deadline;
+       unsigned                edf_flag;
 } ____cacheline_internodealigned_in_smp;

 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
diff -Naur linux-2.6.32-rc3/include/linux/plist.h
linux-2.6.32-rc3-drtl/include/linux/plist.h
--- linux-2.6.32-rc3/include/linux/plist.h      2009-10-05
05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/include/linux/plist.h 2009-10-20
11:00:31.000000000 +0530
@@ -87,6 +87,8 @@

 struct plist_node {
       int                     prio;
+       long long int           deadline;
+       int                     policy;
       struct plist_head       plist;
 };

@@ -142,9 +144,11 @@
 * @node:      &struct plist_node pointer
 * @prio:      initial node priority
 */
-static inline void plist_node_init(struct plist_node *node, int prio)
+static inline void plist_node_init(struct plist_node *node, int prio,
long long int deadline, int policy)
 {
       node->prio = prio;
+       node->deadline = deadline;
+       node->policy = policy;
       plist_head_init(&node->plist, NULL);
 }

diff -Naur linux-2.6.32-rc3/include/linux/sched.h
linux-2.6.32-rc3-drtl/include/linux/sched.h
--- linux-2.6.32-rc3/include/linux/sched.h      2009-10-05
05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/include/linux/sched.h 2009-10-20
11:03:51.000000000 +0530
@@ -36,6 +36,7 @@
 #define SCHED_FIFO             1
 #define SCHED_RR               2
 #define SCHED_BATCH            3
+#define SCHED_EDF              123
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE             5
 /* Can be ORed in to make sure the process is reverted back to
SCHED_NORMAL on fork */
@@ -43,9 +44,6 @@

 #ifdef __KERNEL__

-struct sched_param {
-       int sched_priority;
-};

 #include <asm/param.h> /* for HZ */

@@ -102,6 +100,11 @@
 struct bts_context;
 struct perf_event_context;

+struct sched_param {
+       int sched_priority;
+       struct timespec deadline;
+};
+
 /*
 * List of flags we want to share for kernel threads,
 * if only because they are not used by them anyway.
@@ -195,6 +198,7 @@
 #define TASK_DEAD              64
 #define TASK_WAKEKILL          128
 #define TASK_WAKING            256
+#define EXIT_MISS_DEADLINE     512

 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE          (TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
@@ -1201,6 +1205,9 @@
       int nr_cpus_allowed;

       struct sched_rt_entity *back;
+#ifdef CONFIG_SCHED_EDF
+       struct rb_node edf_node;
+#endif
 #ifdef CONFIG_RT_GROUP_SCHED
       struct sched_rt_entity  *parent;
       /* rq on which this entity is (to be) queued: */
@@ -1232,6 +1239,11 @@
       const struct sched_class *sched_class;
       struct sched_entity se;
       struct sched_rt_entity rt;
+#ifdef CONFIG_SCHED_EDF
+       ktime_t edf_deadline;
+       ktime_t rt_deadline;
+       struct timespec orig_deadline;
+#endif

 #ifdef CONFIG_PREEMPT_NOTIFIERS
       /* list of struct preempt_notifier: */
@@ -1733,6 +1745,7 @@
 #define PF_EXITING     0x00000004      /* getting shut down */
 #define PF_EXITPIDONE  0x00000008      /* pi exit done on shut down */
 #define PF_VCPU                0x00000010      /* I'm a virtual CPU */
+#define        PF_HARDIRQ      0x00000020      /* hardirq context */
 #define PF_FORKNOEXEC  0x00000040      /* forked but didn't exec */
 #define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV   0x00000100      /* used super-user privileges */
@@ -1932,7 +1945,7 @@

 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
-extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern void rt_mutex_setprio(struct task_struct *p, int prio, ktime_t
*deadline);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 #else
 static inline int rt_mutex_getprio(struct task_struct *p)
diff -Naur linux-2.6.32-rc3/init/Kconfig linux-2.6.32-rc3-drtl/init/Kconfig
--- linux-2.6.32-rc3/init/Kconfig       2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/init/Kconfig  2009-10-20 10:40:16.000000000 +0530
@@ -425,6 +425,12 @@
 #
 config HAVE_UNSTABLE_SCHED_CLOCK
       bool
+
+config SCHED_EDF
+       bool "EDF Scheduler Support"
+       default n
+       depends on !GROUP_SCHED
+       depends on !SMP

 config GROUP_SCHED
       bool "Group CPU scheduler"
diff -Naur linux-2.6.32-rc3/init/main.c linux-2.6.32-rc3-drtl/init/main.c
--- linux-2.6.32-rc3/init/main.c        2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/init/main.c   2009-10-20 10:40:16.000000000 +0530
@@ -101,6 +101,10 @@
 enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);

+#ifdef CONFIG_SCHED_EDF
+void kthread_deadmiss(void);
+#endif
+
 /*
 * Boot command-line arguments
 */
@@ -428,6 +432,9 @@
       numa_default_policy();
       pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
       kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+#ifdef CONFIG_SCHED_EDF
+       kernel_thread(kthread_deadmiss, NULL, CLONE_FS | CLONE_FILES);
+#endif
       unlock_kernel();

       /*
diff -Naur linux-2.6.32-rc3/kernel/futex.c linux-2.6.32-rc3-drtl/kernel/futex.c
--- linux-2.6.32-rc3/kernel/futex.c     2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/futex.c        2009-10-20
11:12:18.000000000 +0530
@@ -1384,7 +1384,7 @@
        */
       prio = min(current->normal_prio, MAX_RT_PRIO);

-       plist_node_init(&q->list, prio);
+       plist_node_init(&q->list, prio, 0, 0);
 #ifdef CONFIG_DEBUG_PI_LIST
       q->list.plist.lock = &hb->lock;
 #endif
diff -Naur linux-2.6.32-rc3/kernel/irq/manage.c
linux-2.6.32-rc3-drtl/kernel/irq/manage.c
--- linux-2.6.32-rc3/kernel/irq/manage.c        2009-10-05
05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/irq/manage.c   2009-10-20
10:41:06.000000000 +0530
@@ -536,7 +536,16 @@
       struct irq_desc *desc = irq_to_desc(action->irq);
       int wake, oneshot = desc->status & IRQ_ONESHOT;

-       sched_setscheduler(current, SCHED_FIFO, &param);
+       current->flags |= PF_HARDIRQ;
+       if (desc->edf_flag)
+       {
+               param.deadline.tv_sec = desc->deadline.tv.sec;
+               param.deadline.tv_nsec = desc->deadline.tv.nsec;
+               sched_setscheduler(current, SCHED_EDF, &param);
+       }
+       else
+               sched_setscheduler(current, SCHED_FIFO, &param);
+
       current->irqaction = action;

       while (!irq_wait_for_interrupt(action)) {
@@ -1088,3 +1097,18 @@
       return retval;
 }
 EXPORT_SYMBOL(request_threaded_irq);
+
+#ifdef CONFIG_SCHED_EDF
+int request_irq_edf (unsigned int irq, irq_handler_t handler,
irq_handler_t thread_fn,
+                       unsigned long irqflags, const char *devname, void
*dev_id, struct timespec *deadline)
+{
+        struct irq_desc *desc;
+        desc = irq_to_desc(irq);
+        desc->deadline.tv.sec = deadline->tv_sec;
+        desc->deadline.tv.nsec = deadline->tv_nsec;
+        desc->edf_flag = 1;
+        return request_threaded_irq (irq, handler,thread_fn,
irqflags, devname, dev_id);
+}
+EXPORT_SYMBOL(request_irq_edf);
+#endif
+
diff -Naur linux-2.6.32-rc3/kernel/kthread.c
linux-2.6.32-rc3-drtl/kernel/kthread.c
--- linux-2.6.32-rc3/kernel/kthread.c   2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/kthread.c      2009-10-20
11:54:12.000000000 +0530
@@ -33,6 +33,14 @@
       struct list_head list;
 };

+#ifdef CONFIG_SCHED_EDF
+struct kthread_deadmiss_info {
+       struct completion deadmiss;
+       struct task_struct *k;
+} kthread_dead_info;
+EXPORT_SYMBOL (kthread_dead_info);
+#endif
+
 struct kthread {
       int should_stop;
       struct completion exited;
@@ -247,3 +255,30 @@

       return 0;
 }
+
+#ifdef CONFIG_SCHED_EDF
+void dead_miss_default (void)
+{
+       struct task_struct *tsk = current;
+       set_task_comm(current, "Deadmiss Default");
+       /* Try to stop the runaway thread */
+       kthread_stop (kthread_dead_info.k);
+}
+
+void kthread_deadmiss (void)
+{
+       struct task_struct *tsk = current;
+
+        set_task_comm(tsk, "Deadmiss Thread");
+        ignore_signals(tsk);
+        current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
+
+        while (1)
+        {
+                init_completion(&kthread_dead_info.deadmiss);
+                wait_for_completion (&kthread_dead_info.deadmiss);
+               kthread_run(dead_miss_default,NULL,"Deadmiss Default");
+
+        }
+}
+#endif
diff -Naur linux-2.6.32-rc3/kernel/rtmutex.c
linux-2.6.32-rc3-drtl/kernel/rtmutex.c
--- linux-2.6.32-rc3/kernel/rtmutex.c   2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/rtmutex.c      2009-10-20
11:13:24.000000000 +0530
@@ -112,6 +112,19 @@
                  task->normal_prio);
 }

+#ifdef CONFIG_SCHED_EDF
+ktime_t rt_mutex_getdeadline(struct task_struct *task)
+{
+
+        if (likely(!task_has_pi_waiters(task))) {
+                return task->rt_deadline;
+        }
+        if (ktime_sub((ktime_t)task_top_pi_waiter(task)->pi_list_entry.deadline,task->rt_deadline).tv64
< 0 )
+                return
(ktime_t)task_top_pi_waiter(task)->pi_list_entry.deadline;
+        else return task->rt_deadline;
+}
+#endif
+
 /*
 * Adjust the priority of a task, after its pi_waiters got modified.
 *
@@ -122,7 +135,20 @@
       int prio = rt_mutex_getprio(task);

       if (task->prio != prio)
-               rt_mutex_setprio(task, prio);
+               rt_mutex_setprio(task, prio, NULL);
+
+#ifdef CONFIG_SCHED_EDF
+       else {
+                if ((task_top_pi_waiter(task)->pi_list_entry.policy
== SCHED_EDF && task->policy == SCHED_EDF)
+                       || (!task_has_pi_waiters(task)) &&
task->policy == SCHED_EDF) {
+                        ktime_t deadline = rt_mutex_getdeadline(task);
+                        if (!ktime_equal (deadline, task->edf_deadline))
+                                rt_mutex_setprio(task,prio,&deadline);
+                        return;
+                }
+        }
+#endif
+
 }

 /*
@@ -424,8 +450,14 @@
       __rt_mutex_adjust_prio(task);
       waiter->task = task;
       waiter->lock = lock;
-       plist_node_init(&waiter->list_entry, task->prio);
-       plist_node_init(&waiter->pi_list_entry, task->prio);
+#ifdef CONFIG_SCHED_EDF
+       plist_node_init(&waiter->list_entry,
current->prio,current->edf_deadline.tv64,current->policy);
+        plist_node_init(&waiter->pi_list_entry,
current->prio,current->edf_deadline.tv64,current->policy);
+#else
+       plist_node_init(&waiter->list_entry, task->prio, 0,0);
+       plist_node_init(&waiter->pi_list_entry, task->prio,0,0);
+#endif
+

       /* Get the top priority waiter on the lock */
       if (rt_mutex_has_waiters(lock))
diff -Naur linux-2.6.32-rc3/kernel/sched.c linux-2.6.32-rc3-drtl/kernel/sched.c
--- linux-2.6.32-rc3/kernel/sched.c     2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/sched.c        2009-10-20
11:10:33.000000000 +0530
@@ -121,7 +121,7 @@

 static inline int rt_policy(int policy)
 {
-       if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
+       if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR || policy ==
SCHED_EDF))
               return 1;
       return 0;
 }
@@ -451,6 +451,9 @@
 struct rt_rq {
       struct rt_prio_array active;
       unsigned long rt_nr_running;
+#ifdef CONFIG_SCHED_EDF
+       unsigned long edf_running;
+#endif
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
       struct {
               int curr; /* highest queued rt task prio */
@@ -479,6 +482,11 @@
       struct task_group *tg;
       struct sched_rt_entity *rt_se;
 #endif
+#ifdef CONFIG_SCHED_EDF
+       struct rb_root          edf_root;
+       struct sched_rt_entity  *edf_next;
+
+#endif
 };

 #ifdef CONFIG_SMP
@@ -1816,6 +1824,9 @@
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
+#ifdef CONFIG_SCHED_EDF
+#include "sched_edf.c"
+#endif
 #include "sched_rt.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
@@ -2560,8 +2571,12 @@
       /* Want to start with kernel preemption disabled. */
       task_thread_info(p)->preempt_count = 1;
 #endif
-       plist_node_init(&p->pushable_tasks, MAX_PRIO);

+#ifdef CONFIG_SCHED_EDF
+       plist_node_init(&p->pushable_tasks, MAX_PRIO, p->edf_deadline.tv64,
p->policy);
+#else
+       plist_node_init(&p->pushable_tasks, MAX_PRIO, 0, 0);
+#endif
       put_cpu();
 }

@@ -5942,7 +5957,7 @@
 *
 * Used by the rt_mutex code to implement priority inheritance logic.
 */
-void rt_mutex_setprio(struct task_struct *p, int prio)
+void rt_mutex_setprio(struct task_struct *p, int prio, ktime_t *deadline)
 {
       unsigned long flags;
       int oldprio, on_rq, running;
@@ -5966,7 +5981,13 @@
               p->sched_class = &rt_sched_class;
       else
               p->sched_class = &fair_sched_class;
-
+
+#ifdef CONFIG_SCHED_EDF
+       if (p->policy == SCHED_EDF && deadline != NULL)
+       {
+               p->edf_deadline = *deadline;
+       }
+#endif
       p->prio = prio;

       if (running)
@@ -6150,6 +6171,7 @@
               break;
       case SCHED_FIFO:
       case SCHED_RR:
+       case SCHED_EDF:
               p->sched_class = &rt_sched_class;
               break;
       }
@@ -6197,7 +6219,7 @@
               reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
               policy &= ~SCHED_RESET_ON_FORK;

-               if (policy != SCHED_FIFO && policy != SCHED_RR &&
+               if (policy != SCHED_FIFO && policy != SCHED_RR &&
policy != SCHED_EDF &&
                               policy != SCHED_NORMAL && policy !=
SCHED_BATCH &&
                               policy != SCHED_IDLE)
                       return -EINVAL;
@@ -6344,7 +6366,7 @@
 {
       return __sched_setscheduler(p, policy, param, false);
 }
-
+EXPORT_SYMBOL(sched_setscheduler_nocheck);
 static int
 do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 {
@@ -6361,7 +6383,17 @@
       retval = -ESRCH;
       p = find_process_by_pid(pid);
       if (p != NULL)
+       {
+#ifdef CONFIG_SCHED_EDF
+               if (policy == SCHED_EDF)
+               {
+                       p->edf_deadline =
ktime_add(ktime_get(),timespec_to_ktime
(lparam.deadline));
+                       p->orig_deadline = lparam.deadline;
+                       p->rt_deadline = p->edf_deadline;
+               }
+#endif
               retval = sched_setscheduler(p, policy, &lparam);
+       }
       rcu_read_unlock();

       return retval;
@@ -6767,6 +6799,7 @@
       switch (policy) {
       case SCHED_FIFO:
       case SCHED_RR:
+       case SCHED_EDF:
               ret = MAX_USER_RT_PRIO-1;
               break;
       case SCHED_NORMAL:
@@ -6792,6 +6825,7 @@
       switch (policy) {
       case SCHED_FIFO:
       case SCHED_RR:
+       case SCHED_EDF:
               ret = 1;
               break;
       case SCHED_NORMAL:
@@ -9226,7 +9260,11 @@
 {
       struct rt_prio_array *array;
       int i;
-
+#ifdef CONFIG_SCHED_EDF
+       rt_rq->edf_root.rb_node = NULL;
+       rt_rq->edf_running = 0;
+       rt_rq->edf_next = NULL;
+#endif
       array = &rt_rq->active;
       for (i = 0; i < MAX_RT_PRIO; i++) {
               INIT_LIST_HEAD(array->queue + i);
diff -Naur linux-2.6.32-rc3/kernel/sched_edf.c
linux-2.6.32-rc3-drtl/kernel/sched_edf.c
--- linux-2.6.32-rc3/kernel/sched_edf.c 1970-01-01 05:30:00.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/sched_edf.c    2009-10-20
11:25:24.000000000 +0530
@@ -0,0 +1,116 @@
+#define check_bit(node1, node2) ((node1->rb_parent_color ^
node2->rb_parent_color)&2)
+static inline void inc_rt_tasks(struct sched_rt_entity *rt_se, struct
rt_rq *rt_rq);
+static inline void dec_rt_tasks(struct sched_rt_entity *rt_se, struct
rt_rq *rt_rq);
+static int has_equal = 0;
+static struct sched_rt_entity *leftmost = NULL;
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se);
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se);
+static inline ktime_t edf_se_deadline (struct sched_rt_entity *rt_se)
+{
+       return (rt_task_of(rt_se))->edf_deadline;
+}
+void enqueue_task_edf(struct rq *rq, struct task_struct *p)
+{
+
+       struct rt_rq *rt_rq = &rq->rt;
+       struct rb_node **link = &rt_rq->edf_root.rb_node, *parent=NULL;
+       struct sched_rt_entity *entry;
+       int leftmost_flag= 1, equal = 0;
+       s64 diff;
+       u8 last_bit = 0;
+       /*
+       * Find the right place in the rbtree:
+        */
+       has_equal = 0;
+       if (p->flags & PF_HARDIRQ)
+               p->edf_deadline = ktime_add(ktime_get(),timespec_to_ktime
(p->orig_deadline));
+        while (*link) {
+                parent = *link;
+                entry = rb_entry(parent, struct sched_rt_entity, edf_node);
+                /*
+                 * We dont care about collisions. Nodes with
+                 * the same key stay together.
+                 */
+
+               diff = ktime_sub(p->edf_deadline,edf_se_deadline(entry)).tv64;
+               if (diff < 0) {
+                        link = &parent->rb_left;
+                } else if (diff == 0) {
+                        link = &parent->rb_left;
+                       last_bit = (parent->rb_parent_color & 0x02);
+                       equal = 1;
+               }
+               else {
+                        link = &parent->rb_right;
+                       leftmost_flag = 0;
+                }
+        }
+       rb_link_node (&p->rt.edf_node,parent,link);
+       rb_insert_color(&p->rt.edf_node,&rt_rq->edf_root);
+       if (!equal)
+               last_bit = (parent==NULL)?0x2:~(parent->rb_parent_color & 0x02);
+       p->rt.edf_node.rb_parent_color |= (last_bit & 0x02);
+       if (leftmost_flag)
+       {
+               leftmost = rt_rq->edf_next = &p->rt;
+               if (equal) {
+                       has_equal = 1;
+               }
+       }
+       (rt_rq_of_se(&p->rt))->edf_running++;
+       inc_rt_tasks(&p->rt,rt_rq_of_se(&p->rt));
+}
+
+void dequeue_task_edf(struct rq *rq, struct task_struct *p)
+{
+       struct rb_node *next_node;
+       struct rb_node *prev_node;
+       struct rb_node *assign_node;
+       if (rq->rt.edf_running > 2)
+       {
+               next_node = rb_next(&leftmost->edf_node);
+               if (&p->rt.edf_node == next_node)
+                       next_node = rb_next(next_node);
+               else if (&p->rt == leftmost)
+               {
+                       leftmost = rb_entry (next_node, struct
sched_rt_entity, edf_node);
+                       next_node = rb_next(&leftmost->edf_node);
+               }
+               if (&p->rt == rq->rt.edf_next)
+               {
+                       rq->rt.edf_next =
rb_entry(rb_next(&(rq->rt.edf_next->edf_node)),
struct sched_rt_entity, edf_node);
+                       if (has_equal && (rq->rt.edf_next == NULL ||
check_bit((&(p->rt.edf_node)),(&(rq->rt.edf_next->edf_node)))))
+                               rq->rt.edf_next = leftmost;
+               }
+               has_equal = !check_bit((&leftmost->edf_node), next_node);
+       }
+       else
+       {
+
+               next_node = rb_next (&p->rt.edf_node);
+               prev_node = rb_prev (&p->rt.edf_node);
+               assign_node = (next_node == NULL) ? prev_node : next_node;
+               if (assign_node != NULL)
+                       leftmost = rq->rt.edf_next =
rb_entry(assign_node, struct
sched_rt_entity, edf_node);
+               else
+                       leftmost = rq->rt.edf_next = NULL;
+               has_equal = 0;
+       }
+       (rt_rq_of_se(&p->rt))->edf_running--;
+       dec_rt_tasks(&p->rt, rt_rq_of_se(&p->rt));
+       rb_erase(&p->rt.edf_node, &rq->rt.edf_root);
+}
+
+struct sched_rt_entity *pick_next_task_edf(struct rq *rq)
+{
+       struct sched_rt_entity *retval;
+       struct rb_node *next_node;
+       retval = rq->rt.edf_next;
+       if (has_equal)
+       {
+               next_node = rb_next(&retval->edf_node);
+               rq->rt.edf_next = (next_node == NULL ||
check_bit((&rq->rt.edf_next->edf_node), next_node)) ? leftmost :
+                       rb_entry(next_node, struct sched_rt_entity, edf_node);
+       }
+       return retval;
+}
diff -Naur linux-2.6.32-rc3/kernel/sched_rt.c
linux-2.6.32-rc3-drtl/kernel/sched_rt.c
--- linux-2.6.32-rc3/kernel/sched_rt.c  2009-10-05 05:42:30.000000000 +0530
+++ linux-2.6.32-rc3-drtl/kernel/sched_rt.c     2009-10-20
10:40:16.000000000 +0530
@@ -3,6 +3,14 @@
 * policies)
 */

+#ifdef CONFIG_SCHED_EDF
+struct kthread_deadmiss_info {
+       struct completion deadmiss;
+       struct task_struct *k;
+};
+extern struct kthread_deadmiss_info kthread_dead_info;
+#endif
+
 #ifdef CONFIG_RT_GROUP_SCHED

 #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
@@ -607,6 +615,7 @@
       if (unlikely((s64)delta_exec < 0))
               delta_exec = 0;

+
       schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));

       curr->se.sum_exec_runtime += delta_exec;
@@ -614,7 +623,6 @@

       curr->se.exec_start = rq->clock;
       cpuacct_charge(curr, delta_exec);
-
       sched_rt_avg_update(rq, delta_exec);

       if (!rt_bandwidth_enabled())
@@ -885,6 +893,11 @@
       if (wakeup)
               rt_se->timeout = 0;

+#ifdef CONFIG_SCHED_EDF
+       if (p->policy == SCHED_EDF)
+               enqueue_task_edf(rq,p);
+       else
+#endif
       enqueue_rt_entity(rt_se);

       if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
@@ -896,7 +909,12 @@
       struct sched_rt_entity *rt_se = &p->rt;

       update_curr_rt(rq);
-       dequeue_rt_entity(rt_se);
+#ifdef CONFIG_SCHED_EDF
+       if (p->policy == SCHED_EDF)
+               dequeue_task_edf(rq,p);
+       else
+#endif
+               dequeue_rt_entity(rt_se);

       dequeue_pushable_task(rq, p);
 }
@@ -924,6 +942,11 @@
       struct sched_rt_entity *rt_se = &p->rt;
       struct rt_rq *rt_rq;

+#ifndef CONFIG_SCHED_EDF
+       if (p->policy == SCHED_EDF)
+               return;
+#endif
+
       for_each_sched_rt_entity(rt_se) {
               rt_rq = rt_rq_of_se(rt_se);
               requeue_rt_entity(rt_rq, rt_se, head);
@@ -1036,10 +1059,22 @@
       int idx;

       idx = sched_find_first_bit(array->bitmap);
+#ifdef CONFIG_SCHED_EDF
+       BUG_ON(!rt_rq->edf_next && idx >= MAX_RT_PRIO);
+#else
       BUG_ON(idx >= MAX_RT_PRIO);
+#endif

-       queue = array->queue + idx;
-       next = list_entry(queue->next, struct sched_rt_entity, run_list);
+#ifdef CONFIG_SCHED_EDF
+       if (!rt_rq->edf_next || rt_se_prio(rt_rq->edf_next) > idx) {
+#endif
+               queue = array->queue + idx;
+               next = list_entry(queue->next, struct sched_rt_entity,
run_list);
+
+#ifdef CONFIG_SCHED_EDF
+       }
+       else next = pick_next_task_edf(rq);
+#endif

       return next;
 }
@@ -1089,11 +1124,30 @@
       return p;
 }

+
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
       update_curr_rt(rq);
       p->se.exec_start = 0;
-
+#ifdef CONFIG_SCHED_EDF
+       /* Deadline miss handler for run away tasks */
+       if (p->policy == SCHED_EDF && !p->flags&PF_HARDIRQ)  {
+            if (ktime_sub(p->edf_deadline,ktime_get()).tv64 <= 0) {
+               if (p->flags&PF_KTHREAD) {
+                       dequeue_task_edf (rq,p);
+                       kthread_dead_info.k = p;
+                       complete (&kthread_dead_info.deadmiss);
+                       set_task_state(p, TASK_INTERRUPTIBLE);
+               }
+               else {
+                       sigaddset(&p->pending.signal,SIGMISSDEAD);
+                       set_tsk_thread_flag(p, TIF_SIGPENDING);
+                       p->exit_code = EXIT_MISS_DEADLINE;
+               }
+           }
+       }
+#endif
+
       /*
        * The previous task needs to be made eligible for pushing
        * if it is still active






On Wed, Oct 21, 2009 at 9:08 PM, Soumya K S <ssks.mt@gmail.com> wrote:
> Hello All,
>
> We would like to present a patch on Deployment specific Real-Time
> Linux, topic discussed in LinuxCon 2009
> <http://events.linuxfoundation.org/lc09d17>
>
> The developed framework allows user to specify the real-time
> strategies for a specific real-time scenario. User specifies
> configurations like scheduling policy, Deadline-miss Fault-tolerance
> limit, interrupt priorities, etc. Real-time applications use onetime
> gateway to notify kernel that they require real-time response. All
> applications use existing POSIX APIs. DRTL scheduler is time-aware and
> uses EDF as the scheduling policy.
>
> The patch consists of Time aware scheduler having SCHED_EDF as the
> scheduling policy, Deadline based scheduling for Interrupt handlers,
> Deadline Inheritance support for RT-Mutexes.
>
> The patch is for the kernel version 2.6.32-rc3. It has been tested on
> OMAP3530, ATMEL AT91SAM9261 and X86 platforms.
>
> We look forward for support and feedback about
> DRTL <http://docs.google.com/fileview?id=0BzLQtQ1qAO7uYjYyN2QwNGUtYWE2YS00MDc1LWExYWUtZTliNjNjNmZiZTZj&hl=en>
> and the patch for its feasibility, scalability and performance.
>
> Many Thanks,
> Soumya KS
> Shubhro Sinha
>
