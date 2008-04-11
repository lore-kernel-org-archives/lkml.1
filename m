Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbYDKVAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbYDKVAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760396AbYDKVAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:00:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45821 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760248AbYDKVAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:00:40 -0400
Date: Fri, 11 Apr 2008 15:00:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Replace completions with semaphores
Message-ID: <20080411210022.GJ11962@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A long long time ago when dinosaurs roamed the earth and tech
company stock valuations were high (2001), the primitive
of the completion was introduced to save us from a problem
with semaphores.  Those interested in the details can examine
http://www.ussg.iu.edu/hypermail/linux/kernel/0107.3/0674.html and
related messages, but everyone else can take my word for it that, with
the generic semaphores I hope will be merged in 2.6.26, semaphores no
longer have the problem that caused us to switch to completions.

So does it make sense to retain the completion as a primitive
in Linux?  On the one hand, it clearly denotes how one uses it --
that it's initially 'locked' and becomes 'unlocked' later.  On the
other hand, it is Yet Another Thing to be maintained; I had to
add wait_for_completion_killable(), probably there needs to be a
wait_for_completion_killable_timeout() too.

I have a cheesy hack to remove them without causing too much disturbance.
Obviously, I would never suggest this for inclusion -- #define completion
semaphore should be enough to raise anyone's eyebrows -- but it's a
starting point to decide whether or not to get rid of completions or
retain them in some way while basing their implementation on semaphores,
or leave them the hell alone.

I'm a little puzzled at the numbers I get for replacing completions with
semaphores.  The individual files change very little in size:

   text    data     bss     dec     hex filename
   1280       0       0    1280     500 kernel/semaphore-before.o
   1656       0       0    1656     678 kernel/semaphore.o
  36816    8270     376   45462    b196 kernel/sched-before.o
  35938    8270     392   44600    ae38 kernel/sched.o
 369958  678538 4287224 5335720  516aa8 kernel/built-in-before.o
 371154  678538 4287288 5336980  516f94 kernel/built-in.o
7388295 1401040 4712200 13501535         ce045f vmlinux-before
7380903 1401040 4712000 13493943         cde6b7 vmlinux

So despite a net gain of 500 bytes when comparing semaphore.o and sched.o,
kernel/built-in.o actually increases in size and vmlinux is even bigger.
The only thing I can think of is that this is a lockdep thing.

Anyway, here's the cheesy patch, just for entertainment value.  I think
the discussion needs to be more around semantics and maintainability
than code size or just how silly this patch is.

diff --git a/include/linux/completion.h b/include/linux/completion.h
index d2961b6..9e7e718 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -1,58 +1,30 @@
 #ifndef __LINUX_COMPLETION_H
 #define __LINUX_COMPLETION_H
 
-/*
- * (C) Copyright 2001 Linus Torvalds
- *
- * Atomic wait-for-completion handler data structures.
- * See kernel/sched.c for details.
- */
-
-#include <linux/wait.h>
-
-struct completion {
-	unsigned int done;
-	wait_queue_head_t wait;
-};
-
-#define COMPLETION_INITIALIZER(work) \
-	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
-
-#define COMPLETION_INITIALIZER_ONSTACK(work) \
-	({ init_completion(&work); work; })
-
-#define DECLARE_COMPLETION(work) \
-	struct completion work = COMPLETION_INITIALIZER(work)
-
-/*
- * Lockdep needs to run a non-constant initializer for on-stack
- * completions - so we use the _ONSTACK() variant for those that
- * are on the kernel stack:
- */
-#ifdef CONFIG_LOCKDEP
-# define DECLARE_COMPLETION_ONSTACK(work) \
-	struct completion work = COMPLETION_INITIALIZER_ONSTACK(work)
-#else
-# define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
-#endif
-
-static inline void init_completion(struct completion *x)
+#include <linux/semaphore.h>
+
+#define completion semaphore
+#define COMPLETION_INITIALIZER(work)		__SEMAPHORE_INITIALIZER(work, 0)
+#define COMPLETION_INITIALIZER_ONSTACK(work)	__SEMAPHORE_INITIALIZER(work, 0)
+#define DECLARE_COMPLETION(work)	__DECLARE_SEMAPHORE_GENERIC(work, 0) 
+#define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
+#define init_completion(work)	init_MUTEX_LOCKED(work)
+
+#define wait_for_completion(work)		down(work)
+#define wait_for_completion_interruptible(work)	down_interruptible(work)
+#define wait_for_completion_killable(work)	down_killable(work)
+#define wait_for_completion_timeout(work, timeout) \
+			down_timeout(work, timeout)
+#define wait_for_completion_interruptible_timeout(work, timeout) \
+			down_interruptible_timeout(work, timeout)
+
+static inline void complete(struct semaphore *work)
 {
-	x->done = 0;
-	init_waitqueue_head(&x->wait);
+	up(work);
 }
 
-extern void wait_for_completion(struct completion *);
-extern int wait_for_completion_interruptible(struct completion *x);
-extern int wait_for_completion_killable(struct completion *x);
-extern unsigned long wait_for_completion_timeout(struct completion *x,
-						   unsigned long timeout);
-extern unsigned long wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout);
-
-extern void complete(struct completion *);
-extern void complete_all(struct completion *);
+#define complete_all(work)			up_all(work)
 
-#define INIT_COMPLETION(x)	((x).done = 0)
+#define INIT_COMPLETION(x)			init_MUTEX_LOCKED(x)
 
 #endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..e8634e5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -90,7 +90,7 @@ extern int console_printk[];
 #define minimum_console_loglevel (console_printk[2])
 #define default_console_loglevel (console_printk[3])
 
-struct completion;
+struct semaphore;
 struct pt_regs;
 struct user;
 
@@ -135,7 +135,7 @@ extern void oops_exit(void);
 extern int oops_may_print(void);
 NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
+NORET_TYPE void complete_and_exit(struct semaphore *, long)
 	ATTRIB_NORET;
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 9b6c935..111c540 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -8,7 +8,7 @@
 #include <asm/atomic.h>
 
 struct net;
-struct completion;
+struct semaphore;
 
 /*
  * The proc filesystem constants/structures
@@ -79,7 +79,7 @@ struct proc_dir_entry {
 	atomic_t count;		/* use count */
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
-	struct completion *pde_unload_completion;
+	struct semaphore *pde_unload_completion;
 };
 
 struct kcore_list {
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 9cae64b..470a4bc 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -46,6 +46,9 @@ extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
 extern int __must_check down_trylock(struct semaphore *sem);
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
+extern int __must_check down_interruptible_timeout(struct semaphore *sem,
+						   long jiffies);
 extern void up(struct semaphore *sem);
+extern void up_all(struct semaphore *sem);
 
 #endif /* __LINUX_SEMAPHORE_H */
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 571f01d..15d0ace 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -30,7 +30,7 @@
 #include <linux/compiler.h>
 
 struct file;
-struct completion;
+struct semaphore;
 
 #define CTL_MAXNAME 10		/* how many path components do we allow in a
 				   call to sysctl?   In other words, what is
@@ -1063,7 +1063,7 @@ struct ctl_table_header
 	struct ctl_table *ctl_table;
 	struct list_head ctl_entry;
 	int used;
-	struct completion *unregistering;
+	struct semaphore *unregistering;
 	struct ctl_table *ctl_table_arg;
 	struct ctl_table_root *root;
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index 8dcdec6..08752d4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4142,109 +4142,6 @@ __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
-void complete(struct completion *x)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	x->done++;
-	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-}
-EXPORT_SYMBOL(complete);
-
-void complete_all(struct completion *x)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-}
-EXPORT_SYMBOL(complete_all);
-
-static inline long __sched
-do_wait_for_common(struct completion *x, long timeout, int state)
-{
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
-		do {
-			if ((state == TASK_INTERRUPTIBLE &&
-			     signal_pending(current)) ||
-			    (state == TASK_KILLABLE &&
-			     fatal_signal_pending(current))) {
-				__remove_wait_queue(&x->wait, &wait);
-				return -ERESTARTSYS;
-			}
-			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
-			timeout = schedule_timeout(timeout);
-			spin_lock_irq(&x->wait.lock);
-			if (!timeout) {
-				__remove_wait_queue(&x->wait, &wait);
-				return timeout;
-			}
-		} while (!x->done);
-		__remove_wait_queue(&x->wait, &wait);
-	}
-	x->done--;
-	return timeout;
-}
-
-static long __sched
-wait_for_common(struct completion *x, long timeout, int state)
-{
-	might_sleep();
-
-	spin_lock_irq(&x->wait.lock);
-	timeout = do_wait_for_common(x, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
-	return timeout;
-}
-
-void __sched wait_for_completion(struct completion *x)
-{
-	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion);
-
-unsigned long __sched
-wait_for_completion_timeout(struct completion *x, unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_timeout);
-
-int __sched wait_for_completion_interruptible(struct completion *x)
-{
-	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
-	if (t == -ERESTARTSYS)
-		return t;
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_completion_interruptible);
-
-unsigned long __sched
-wait_for_completion_interruptible_timeout(struct completion *x,
-					  unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
-
-int __sched wait_for_completion_killable(struct completion *x)
-{
-	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
-	if (t == -ERESTARTSYS)
-		return t;
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_completion_killable);
-
 static long __sched
 sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 5c2942e..4e536c5 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -36,6 +36,8 @@ static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
 static noinline int __down_killable(struct semaphore *sem);
 static noinline int __down_timeout(struct semaphore *sem, long jiffies);
+static noinline int __down_interruptible_timeout(struct semaphore *sem,
+							long jiffies);
 static noinline void __up(struct semaphore *sem);
 
 /**
@@ -167,6 +169,22 @@ int down_timeout(struct semaphore *sem, long jiffies)
 }
 EXPORT_SYMBOL(down_timeout);
 
+int down_interruptible_timeout(struct semaphore *sem, long jiffies)
+{
+	unsigned long flags;
+	int result = 0;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	if (likely(sem->count > 0))
+		sem->count--;
+	else
+		result = __down_interruptible_timeout(sem, jiffies);
+	spin_unlock_irqrestore(&sem->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(down_interruptible_timeout);
+
 /**
  * up - release the semaphore
  * @sem: the semaphore to release
@@ -187,6 +205,18 @@ void up(struct semaphore *sem)
 }
 EXPORT_SYMBOL(up);
 
+void up_all(struct semaphore *sem)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	while (!list_empty(&sem->wait_list))
+		__up(sem);
+	sem->count = 1 << 30;
+	spin_unlock_irqrestore(&sem->lock, flags);
+}
+EXPORT_SYMBOL(up_all);
+
 /* Functions for the contended case */
 
 struct semaphore_waiter {
@@ -254,6 +284,12 @@ static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
 	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
 }
 
+static noinline int __sched __down_interruptible_timeout(struct semaphore *sem,
+								long jiffies)
+{
+	return __down_common(sem, TASK_INTERRUPTIBLE, jiffies);
+}
+
 static noinline void __sched __up(struct semaphore *sem)
 {
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
