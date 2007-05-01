Return-Path: <linux-kernel-owner+w=401wt.eu-S1946158AbXEAALP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946158AbXEAALP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946190AbXEAAKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:10:45 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3245 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946189AbXEAAKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:10:37 -0400
Date: Tue, 1 May 2007 02:10:34 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] rename thread_info to stack
Message-ID: <Pine.LNX.4.64.0705010210010.1479@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This finally renames the thread_info field in task structure to stack,
so that the assumptions about this field are gone and archs have more
freedom about placing the thread_info structure.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/h8300/kernel/asm-offsets.c   |    2 +-
 arch/ia64/kernel/mca.c            |    2 +-
 arch/mips/kernel/asm-offsets.c    |    2 +-
 arch/parisc/kernel/asm-offsets.c  |    2 +-
 arch/powerpc/kernel/asm-offsets.c |    2 +-
 arch/ppc/kernel/asm-offsets.c     |    2 +-
 arch/s390/kernel/asm-offsets.c    |    2 +-
 arch/sparc/kernel/asm-offsets.c   |    2 +-
 arch/v850/kernel/asm-offsets.c    |    2 +-
 arch/xtensa/kernel/asm-offsets.c  |    2 +-
 include/asm-m68k/thread_info.h    |    6 +++---
 include/linux/init_task.h         |    2 +-
 include/linux/sched.h             |    8 ++++----
 kernel/fork.c                     |    4 ++--
 14 files changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/ia64/kernel/mca.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/mca.c
+++ linux-2.6/arch/ia64/kernel/mca.c
@@ -1690,7 +1690,7 @@ format_mca_init_stack(void *mca_data, un
 	ti->preempt_count = 1;
 	ti->task = p;
 	ti->cpu = cpu;
-	p->thread_info = ti;
+	p->stack = ti;
 	p->state = TASK_UNINTERRUPTIBLE;
 	cpu_set(cpu, p->cpus_allowed);
 	INIT_LIST_HEAD(&p->tasks);
Index: linux-2.6/include/asm-m68k/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-m68k/thread_info.h
+++ linux-2.6/include/asm-m68k/thread_info.h
@@ -37,17 +37,17 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 #define task_thread_info(tsk)	(&(tsk)->thread.info)
-#define task_stack_page(tsk)	((void *)(tsk)->thread_info)
+#define task_stack_page(tsk)	((tsk)->stack)
 #define current_thread_info()	task_thread_info(current)
 
 #define __HAVE_THREAD_FUNCTIONS
 
 #define setup_thread_stack(p, org) ({			\
-	*(struct task_struct **)(p)->thread_info = (p);	\
+	*(struct task_struct **)(p)->stack = (p);	\
 	task_thread_info(p)->task = (p);		\
 })
 
-#define end_of_stack(p) ((unsigned long *)(p)->thread_info + 1)
+#define end_of_stack(p) ((unsigned long *)(p)->stack + 1)
 
 /* entry.S relies on these definitions!
  * bits 0-7 are tested at every exception exit
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -95,7 +95,7 @@ extern struct group_info init_groups;
 #define INIT_TASK(tsk)	\
 {									\
 	.state		= 0,						\
-	.thread_info	= &init_thread_info,				\
+	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= 0,						\
 	.lock_depth	= -1,						\
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -799,7 +799,7 @@ struct prio_array;
 
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
-	struct thread_info *thread_info;
+	void *stack;
 	atomic_t usage;
 	unsigned long flags;	/* per process flags, defined below */
 	unsigned long ptrace;
@@ -1494,8 +1494,8 @@ static inline void unlock_task_sighand(s
 
 #ifndef __HAVE_THREAD_FUNCTIONS
 
-#define task_thread_info(task) (task)->thread_info
-#define task_stack_page(task) ((void*)((task)->thread_info))
+#define task_thread_info(task)	((struct thread_info *)(task)->stack)
+#define task_stack_page(task)	((task)->stack)
 
 static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org)
 {
@@ -1505,7 +1505,7 @@ static inline void setup_thread_stack(st
 
 static inline unsigned long *end_of_stack(struct task_struct *p)
 {
-	return (unsigned long *)(p->thread_info + 1);
+	return (unsigned long *)(task_thread_info(p) + 1);
 }
 
 #endif
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -106,7 +106,7 @@ static struct kmem_cache *mm_cachep;
 
 void free_task(struct task_struct *tsk)
 {
-	free_thread_info(tsk->thread_info);
+	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	free_task_struct(tsk);
 }
@@ -176,7 +176,7 @@ static struct task_struct *dup_task_stru
 	}
 
 	*tsk = *orig;
-	tsk->thread_info = ti;
+	tsk->stack = ti;
 	setup_thread_stack(tsk, orig);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
Index: linux-2.6/arch/h8300/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/asm-offsets.c
+++ linux-2.6/arch/h8300/kernel/asm-offsets.c
@@ -30,7 +30,7 @@ int main(void)
 	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
 	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
 
Index: linux-2.6/arch/mips/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/asm-offsets.c
+++ linux-2.6/arch/mips/kernel/asm-offsets.c
@@ -82,7 +82,7 @@ void output_task_defines(void)
 {
 	text("/* MIPS task_struct offsets. */");
 	offset("#define TASK_STATE         ", struct task_struct, state);
-	offset("#define TASK_THREAD_INFO   ", struct task_struct, thread_info);
+	offset("#define TASK_THREAD_INFO   ", struct task_struct, stack);
 	offset("#define TASK_FLAGS         ", struct task_struct, flags);
 	offset("#define TASK_MM            ", struct task_struct, mm);
 	offset("#define TASK_PID           ", struct task_struct, pid);
Index: linux-2.6/arch/parisc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/asm-offsets.c
+++ linux-2.6/arch/parisc/kernel/asm-offsets.c
@@ -54,7 +54,7 @@
 
 int main(void)
 {
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
 	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
 	DEFINE(TASK_SIGPENDING, offsetof(struct task_struct, pending));
Index: linux-2.6/arch/powerpc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/asm-offsets.c
+++ linux-2.6/arch/powerpc/kernel/asm-offsets.c
@@ -58,7 +58,7 @@ int main(void)
 #ifdef CONFIG_PPC64
 	DEFINE(AUDITCONTEXT, offsetof(struct task_struct, audit_context));
 #else
-	DEFINE(THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(PTRACE, offsetof(struct task_struct, ptrace));
 #endif /* CONFIG_PPC64 */
 
Index: linux-2.6/arch/ppc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/ppc/kernel/asm-offsets.c
+++ linux-2.6/arch/ppc/kernel/asm-offsets.c
@@ -35,7 +35,7 @@ int
 main(void)
 {
 	DEFINE(THREAD, offsetof(struct task_struct, thread));
-	DEFINE(THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(MM, offsetof(struct task_struct, mm));
 	DEFINE(PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(KSP, offsetof(struct thread_struct, ksp));
Index: linux-2.6/arch/s390/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/asm-offsets.c
+++ linux-2.6/arch/s390/kernel/asm-offsets.c
@@ -15,7 +15,7 @@
 
 int main(void)
 {
-	DEFINE(__THREAD_info, offsetof(struct task_struct, thread_info),);
+	DEFINE(__THREAD_info, offsetof(struct task_struct, stack),);
 	DEFINE(__THREAD_ksp, offsetof(struct task_struct, thread.ksp),);
 	DEFINE(__THREAD_per, offsetof(struct task_struct, thread.per_info),);
 	DEFINE(__THREAD_mm_segment,
Index: linux-2.6/arch/sparc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/asm-offsets.c
+++ linux-2.6/arch/sparc/kernel/asm-offsets.c
@@ -28,7 +28,7 @@ int foo(void)
 	DEFINE(AOFF_task_gid, offsetof(struct task_struct, gid));
 	DEFINE(AOFF_task_euid, offsetof(struct task_struct, euid));
 	DEFINE(AOFF_task_egid, offsetof(struct task_struct, egid));
-	/* DEFINE(THREAD_INFO, offsetof(struct task_struct, thread_info)); */
+	/* DEFINE(THREAD_INFO, offsetof(struct task_struct, stack)); */
 	DEFINE(ASIZ_task_uid,	sizeof(current->uid));
 	DEFINE(ASIZ_task_gid,	sizeof(current->gid));
 	DEFINE(ASIZ_task_euid,	sizeof(current->euid));
Index: linux-2.6/arch/v850/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/v850/kernel/asm-offsets.c
+++ linux-2.6/arch/v850/kernel/asm-offsets.c
@@ -29,7 +29,7 @@ int main (void)
 	DEFINE (TASK_PTRACE, offsetof (struct task_struct, ptrace));
 	DEFINE (TASK_BLOCKED, offsetof (struct task_struct, blocked));
 	DEFINE (TASK_THREAD, offsetof (struct task_struct, thread));
-	DEFINE (TASK_THREAD_INFO, offsetof (struct task_struct, thread_info));
+	DEFINE (TASK_THREAD_INFO, offsetof (struct task_struct, stack));
 	DEFINE (TASK_MM, offsetof (struct task_struct, mm));
 	DEFINE (TASK_ACTIVE_MM, offsetof (struct task_struct, active_mm));
 	DEFINE (TASK_PID, offsetof (struct task_struct, pid));
Index: linux-2.6/arch/xtensa/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/asm-offsets.c
+++ linux-2.6/arch/xtensa/kernel/asm-offsets.c
@@ -70,7 +70,7 @@ int main(void)
 	DEFINE(TASK_ACTIVE_MM, offsetof (struct task_struct, active_mm));
 	DEFINE(TASK_PID, offsetof (struct task_struct, pid));
 	DEFINE(TASK_THREAD, offsetof (struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof (struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof (struct task_struct, stack));
 	DEFINE(TASK_STRUCT_SIZE, sizeof (struct task_struct));
 	BLANK();
 
