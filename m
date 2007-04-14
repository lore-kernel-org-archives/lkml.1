Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbXDNDPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbXDNDPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 23:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbXDNDPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 23:15:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42135 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbXDNDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 23:15:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       <linux-arch@vger.kernel.org>
Subject: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
References: <20070413130236.GA173@tv-sign.ru>
Date: Fri, 13 Apr 2007 21:13:13 -0600
In-Reply-To: <20070413130236.GA173@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 13 Apr 2007 17:02:36 +0400")
Message-ID: <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch reworks kthread_stop so it is more flexible and it causes
the target kthread to abort interruptible sleeps.  Allowing a larger
class of kernel threads to use to the kthread API.

The changes start by defining TIF_KTHREAD_STOP on all architectures.
TIF_KTHREAD_STOP is a per process flag that I can set from another
process to indicate that a kernel thread should stop.

wake_up_process in kthread_stop has been replaced by signal_wake_up
ensuring that the kernel thread if sleeping is woken up in a timely
manner and with TIF_SIGNAL_PENDING set, which causes us to break out
of interruptible sleeps.

recalc_signal_pending was modified to keep TIF_SIGNAL_PENDING set for
as long as TIF_KTHREAD_STOP is set.

Arbitrary paths to do_exit are now allowed.  I have placed a
completion on the thread stack and pointed vfork_done at it, when the
mm_release is called from do_exit the completion will be called.
Since the completion is stored on the stack it is important that
kthread() now calls do_exit ensuring the stack frame that holds the
completion is never released, and so that our exit_code is certain to
make it unchanged all the way to do_exit.

To allow kthread_stop to read the process exit code when exit_mm wakes
it up  I have moved the setting of exit_code to the beginning of
do_exit. 

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/asm-alpha/thread_info.h     |    1 +
 include/asm-arm/thread_info.h       |    1 +
 include/asm-arm26/thread_info.h     |    1 +
 include/asm-avr32/thread_info.h     |    1 +
 include/asm-cris/thread_info.h      |    1 +
 include/asm-frv/thread_info.h       |    1 +
 include/asm-h8300/thread_info.h     |    1 +
 include/asm-i386/thread_info.h      |    1 +
 include/asm-ia64/thread_info.h      |    1 +
 include/asm-m32r/thread_info.h      |    1 +
 include/asm-m68k/thread_info.h      |    1 +
 include/asm-m68knommu/thread_info.h |    1 +
 include/asm-mips/thread_info.h      |    1 +
 include/asm-parisc/thread_info.h    |    1 +
 include/asm-powerpc/thread_info.h   |    1 +
 include/asm-s390/thread_info.h      |    1 +
 include/asm-sh/thread_info.h        |    1 +
 include/asm-sh64/thread_info.h      |    1 +
 include/asm-sparc/thread_info.h     |    1 +
 include/asm-sparc64/thread_info.h   |    1 +
 include/asm-um/thread_info.h        |    1 +
 include/asm-v850/thread_info.h      |    1 +
 include/asm-x86_64/thread_info.h    |    1 +
 include/asm-xtensa/thread_info.h    |    1 +
 include/linux/kthread.h             |   20 ++++++++-
 kernel/exit.c                       |    2 +-
 kernel/kthread.c                    |   81 ++++++++++++-----------------------
 kernel/signal.c                     |    3 +-
 28 files changed, 72 insertions(+), 58 deletions(-)

diff --git a/include/asm-alpha/thread_info.h b/include/asm-alpha/thread_info.h
index 69ffd93..31c41e0 100644
--- a/include/asm-alpha/thread_info.h
+++ b/include/asm-alpha/thread_info.h
@@ -76,6 +76,7 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TIF_UAC_NOFIX		7
 #define TIF_UAC_SIGBUS		8
 #define TIF_MEMDIE		9
+#define TIF_KTHREAD_STOP	10
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/asm-arm/thread_info.h b/include/asm-arm/thread_info.h
index 5014794..e6db6f1 100644
--- a/include/asm-arm/thread_info.h
+++ b/include/asm-arm/thread_info.h
@@ -148,6 +148,7 @@ extern void iwmmxt_task_switch(struct thread_info *);
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/include/asm-arm26/thread_info.h b/include/asm-arm26/thread_info.h
index 9b367eb..614cc8c 100644
--- a/include/asm-arm26/thread_info.h
+++ b/include/asm-arm26/thread_info.h
@@ -123,6 +123,7 @@ extern void free_thread_info(struct thread_info *);
 #define TIF_USED_FPU		16
 #define TIF_POLLING_NRFLAG	17
 #define TIF_MEMDIE		18
+#define TIF_KTHREAD_STOP	19
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/include/asm-avr32/thread_info.h b/include/asm-avr32/thread_info.h
index d1f5b35..2f295de 100644
--- a/include/asm-avr32/thread_info.h
+++ b/include/asm-avr32/thread_info.h
@@ -83,6 +83,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SINGLE_STEP		6	/* single step after next break */
 #define TIF_MEMDIE		7
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal */
+#define TIF_KTHREAD_STOP	9
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
diff --git a/include/asm-cris/thread_info.h b/include/asm-cris/thread_info.h
index 7ad853c..5076b97 100644
--- a/include/asm-cris/thread_info.h
+++ b/include/asm-cris/thread_info.h
@@ -84,6 +84,7 @@ struct thread_info {
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
+#define TIF_KTHREAD_STOP	18
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/asm-frv/thread_info.h b/include/asm-frv/thread_info.h
index d881f51..3bb68c0 100644
--- a/include/asm-frv/thread_info.h
+++ b/include/asm-frv/thread_info.h
@@ -117,6 +117,7 @@ register struct thread_info *__current_thread_info asm("gr15");
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
+#define TIF_KTHREAD_STOP	19
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
diff --git a/include/asm-h8300/thread_info.h b/include/asm-h8300/thread_info.h
index 45f09dc..fda90d3 100644
--- a/include/asm-h8300/thread_info.h
+++ b/include/asm-h8300/thread_info.h
@@ -92,6 +92,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_KTHREAD_STOP	6
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/include/asm-i386/thread_info.h b/include/asm-i386/thread_info.h
index 4b187bb..b823054 100644
--- a/include/asm-i386/thread_info.h
+++ b/include/asm-i386/thread_info.h
@@ -135,6 +135,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/asm-ia64/thread_info.h b/include/asm-ia64/thread_info.h
index 9169859..2a5391b 100644
--- a/include/asm-ia64/thread_info.h
+++ b/include/asm-ia64/thread_info.h
@@ -90,6 +90,7 @@ struct thread_info {
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
 #define TIF_FREEZE		20	/* is freezing for suspend */
+#define TIF_KTHREAD_STOP	21
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
diff --git a/include/asm-m32r/thread_info.h b/include/asm-m32r/thread_info.h
index 22aff32..6f06f93 100644
--- a/include/asm-m32r/thread_info.h
+++ b/include/asm-m32r/thread_info.h
@@ -154,6 +154,7 @@ static inline unsigned int get_thread_fault_code(void)
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 					/* 31..28 fault code */
 #define TIF_MEMDIE		17
+#define TIF_KTHREAD_STOP	18
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/asm-m68k/thread_info.h b/include/asm-m68k/thread_info.h
index c4d622a..3c9d2f2 100644
--- a/include/asm-m68k/thread_info.h
+++ b/include/asm-m68k/thread_info.h
@@ -58,5 +58,6 @@ struct thread_info {
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16
+#define TIF_KTHREAD_STOP	17
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
diff --git a/include/asm-m68knommu/thread_info.h b/include/asm-m68knommu/thread_info.h
index b8f009e..95f44c6 100644
--- a/include/asm-m68knommu/thread_info.h
+++ b/include/asm-m68knommu/thread_info.h
@@ -89,6 +89,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_KTHREAD_STOP	6
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/include/asm-mips/thread_info.h b/include/asm-mips/thread_info.h
index 6cf05f4..9c425bf 100644
--- a/include/asm-mips/thread_info.h
+++ b/include/asm-mips/thread_info.h
@@ -120,6 +120,7 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
 #define TIF_ALLOW_FP_IN_KERNEL	20
+#define TIF_KTHREAD_STOP	21
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/include/asm-parisc/thread_info.h b/include/asm-parisc/thread_info.h
index 949314c..44706a5 100644
--- a/include/asm-parisc/thread_info.h
+++ b/include/asm-parisc/thread_info.h
@@ -63,6 +63,7 @@ struct thread_info {
 #define TIF_32BIT               5       /* 32 bit binary */
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore saved signal mask */
+#define TIF_KTHREAD_STOP	8
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
diff --git a/include/asm-powerpc/thread_info.h b/include/asm-powerpc/thread_info.h
index 3f32ca8..6e20084 100644
--- a/include/asm-powerpc/thread_info.h
+++ b/include/asm-powerpc/thread_info.h
@@ -123,6 +123,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOERROR		14	/* Force successful syscall return */
 #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		16	/* Freezing for suspend */
+#define TIF_KTHREAD_STOP	17
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/include/asm-s390/thread_info.h b/include/asm-s390/thread_info.h
index 0a51891..f345e1f 100644
--- a/include/asm-s390/thread_info.h
+++ b/include/asm-s390/thread_info.h
@@ -101,6 +101,7 @@ static inline struct thread_info *current_thread_info(void)
 					   TIF_NEED_RESCHED */
 #define TIF_31BIT		18	/* 32bit process */ 
 #define TIF_MEMDIE		19
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
diff --git a/include/asm-sh/thread_info.h b/include/asm-sh/thread_info.h
index 31d55e3..8fb5d52 100644
--- a/include/asm-sh/thread_info.h
+++ b/include/asm-sh/thread_info.h
@@ -116,6 +116,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/asm-sh64/thread_info.h b/include/asm-sh64/thread_info.h
index 1f825cb..cd7f7c8 100644
--- a/include/asm-sh64/thread_info.h
+++ b/include/asm-sh64/thread_info.h
@@ -78,6 +78,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_MEMDIE		4
+#define TIF_KTHREAD_STOP	5
 
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-sparc/thread_info.h b/include/asm-sparc/thread_info.h
index 91b9f58..594bce5 100644
--- a/include/asm-sparc/thread_info.h
+++ b/include/asm-sparc/thread_info.h
@@ -137,6 +137,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, struct thread_info *)
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
 					 * TIF_NEED_RESCHED */
 #define TIF_MEMDIE		10
+#define TIF_KTHREAD_STOP	11
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/include/asm-sparc64/thread_info.h b/include/asm-sparc64/thread_info.h
index 2ebf7f2..3a5178d 100644
--- a/include/asm-sparc64/thread_info.h
+++ b/include/asm-sparc64/thread_info.h
@@ -236,6 +236,7 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define TIF_ABI_PENDING		12
 #define TIF_MEMDIE		13
 #define TIF_POLLING_NRFLAG	14
+#define TIF_KTHREAD_STOP	15
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
diff --git a/include/asm-um/thread_info.h b/include/asm-um/thread_info.h
index 261e2f4..f10a6ca 100644
--- a/include/asm-um/thread_info.h
+++ b/include/asm-um/thread_info.h
@@ -69,6 +69,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_KTHREAD_STOP	8
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/include/asm-v850/thread_info.h b/include/asm-v850/thread_info.h
index 82b8f28..98d5922 100644
--- a/include/asm-v850/thread_info.h
+++ b/include/asm-v850/thread_info.h
@@ -83,6 +83,7 @@ struct thread_info {
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_KTHREAD_STOP	6
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/include/asm-x86_64/thread_info.h b/include/asm-x86_64/thread_info.h
index 74a6c74..9ad6545 100644
--- a/include/asm-x86_64/thread_info.h
+++ b/include/asm-x86_64/thread_info.h
@@ -123,6 +123,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_KTHREAD_STOP	24
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/asm-xtensa/thread_info.h b/include/asm-xtensa/thread_info.h
index 5ae34ab..facf5cd 100644
--- a/include/asm-xtensa/thread_info.h
+++ b/include/asm-xtensa/thread_info.h
@@ -117,6 +117,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_IRET		5	/* return with iret */
 #define TIF_MEMDIE		6
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_KTHREAD_STOP	17
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 00dd957..a8ea31d 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -10,7 +10,7 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 
 /**
  * kthread_run - create and wake a thread.
- * @threadfn: the function to run until signal_pending(current).
+ * @threadfn: the function to run until kthread_should_stop().
  * @data: data ptr for @threadfn.
  * @namefmt: printf-style name for the thread.
  *
@@ -28,7 +28,23 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
-int kthread_should_stop(void);
+
+static inline int __kthread_should_stop(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
+}
+
+/**
+ * kthread_should_stop - should this kthread return now?
+ *
+ * When someone calls kthread_stop() on your kthread, it will be woken
+ * and this will return true.  You should then return, and your return
+ * value will be passed through to kthread_stop().
+ */
+static inline int kthread_should_stop(void)
+{
+	return __kthread_should_stop(current);
+}
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/exit.c b/kernel/exit.c
index 8024e79..3dad696 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -891,6 +891,7 @@ fastcall NORET_TYPE void do_exit(long code)
 	}
 
 	tsk->flags |= PF_EXITING;
+	tsk->exit_code = code;
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
@@ -937,7 +938,6 @@ fastcall NORET_TYPE void do_exit(long code)
 	if (tsk->binfmt)
 		module_put(tsk->binfmt->module);
 
-	tsk->exit_code = code;
 	proc_exit_connector(tsk);
 	exit_task_namespaces(tsk);
 	exit_notify(tsk);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index df8a8e8..06c7e51 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -33,38 +33,18 @@ struct kthread_create_info
 	struct list_head list;
 };
 
-struct kthread_stop_info
-{
-	struct task_struct *k;
-	int err;
-	struct completion done;
-};
-
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
-
-/**
- * kthread_should_stop - should this kthread return now?
- *
- * When someone calls kthread_stop() on your kthread, it will be woken
- * and this will return true.  You should then return, and your return
- * value will be passed through to kthread_stop().
- */
-int kthread_should_stop(void)
-{
-	return (kthread_stop_info.k == current);
-}
-EXPORT_SYMBOL(kthread_should_stop);
-
 static int kthread(void *_create)
 {
 	struct kthread_create_info *create = _create;
+	struct completion done;
 	int (*threadfn)(void *data);
 	void *data;
 	int ret = -EINTR;
 
+	/* Setup a completion on this thread's stack */
+	init_completion(&done);
+	current->vfork_done = &done;
+
 	/* Copy data: it's on kthread's stack */
 	threadfn = create->threadfn;
 	data = create->data;
@@ -77,12 +57,7 @@ static int kthread(void *_create)
 	if (!kthread_should_stop())
 		ret = threadfn(data);
 
-	/* It might have exited on its own, w/o kthread_stop.  Check. */
-	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
-	}
-	return 0;
+	do_exit(ret);
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -104,7 +79,7 @@ static void create_kthread(struct kthread_create_info *create)
 
 /**
  * kthread_create - create a kthread.
- * @threadfn: the function to run until signal_pending(current).
+ * @threadfn: the function to run until kthread_should_stop().
  * @data: data ptr for @threadfn.
  * @namefmt: printf-style name for the thread.
  *
@@ -174,38 +149,36 @@ EXPORT_SYMBOL(kthread_bind);
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
- * Sets kthread_should_stop() for @k to return true, wakes it, and
- * waits for it to exit.  Your threadfn() must not call do_exit()
- * itself if you use this function!  This can also be called after
- * kthread_create() instead of calling wake_up_process(): the thread
- * will exit without calling threadfn().
+ * Sets TIF_KTHREAD_STOP for @k, wakes it and waits for it to exit.
+ *
+ * kthread_stop should be called exactly once on @k.
+ *
+ * This can also be called after kthread_create() instead of calling
+ * wake_up_process(): the thread  will exit without calling threadfn().
+ *
+ * If your threadfn may terminate before you call kthread_stop
+ * you should call get_task_struct on @k so it is valid when you call
+ * kthread_stop.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
  * was never called.
  */
-int kthread_stop(struct task_struct *k)
+int kthread_stop(struct task_struct *tsk)
 {
 	int ret;
 
-	mutex_lock(&kthread_stop_lock);
-
-	/* It could exit after stop_info.k set, but before wake_up_process. */
-	get_task_struct(k);
+	/* Ensure the task struct persists until I read the exit code. */
+	get_task_struct(tsk);
 
-	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
-	smp_wmb();
+	set_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
+	spin_lock_irq(&tsk->sighand->siglock);
+	signal_wake_up(tsk, 1);
+	spin_unlock_irq(&tsk->sighand->siglock);
 
-	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
-	wake_up_process(k);
-	put_task_struct(k);
+	wait_for_completion(tsk->vfork_done);
+	ret = tsk->exit_code;
 
-	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
+	put_task_struct(tsk);
 
 	return ret;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 2d437f6..fca2a45 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -26,6 +26,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/kthread.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -218,7 +219,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 fastcall void recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
-	    (freezing(t)) ||
+	    (freezing(t)) || __kthread_should_stop(t) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked))
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
-- 
1.5.0.g53756

