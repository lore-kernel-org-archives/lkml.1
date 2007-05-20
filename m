Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbXETDk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbXETDk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 23:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbXETDkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 23:40:18 -0400
Received: from haxent.com ([65.99.219.155]:3460 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbXETDkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 23:40:16 -0400
Message-ID: <464FC31B.9000609@haxent.com.br>
Date: Sun, 20 May 2007 00:40:11 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] shrink task_struct by 16 bytes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Shrink task_struct by replacing the notifier callback with a
notifier list. The block_all_signals() function (and the signal
notifier mechanism) has only one user at the moment, which is drm.

Pahole output for task_struct:

i386 before:

   /* size: 2640, cachelines: 42 */
   /* sum members: 2619, holes: 3, sum holes: 9 */
   /* bit holes: 2, sum bit holes: 62 bits */
   /* padding: 12 */
   /* paddings: 1, sum paddings: 8 */
   /* last cacheline: 16 bytes */

i386 after:

   /* size: 2624, cachelines: 41 */
   /* sum members: 2615, holes: 3, sum holes: 9 */
   /* bit holes: 2, sum bit holes: 62 bits */
   /* paddings: 1, sum paddings: 8 */

x86_64 before:

   /* size: 3648, cachelines: 57 */
   /* sum members: 3587, holes: 13, sum holes: 53 */
   /* bit holes: 2, sum bit holes: 62 bits */
   /* padding: 8 */

x86_64 after:

   /* size: 3632, cachelines: 57 */
   /* sum members: 3579, holes: 13, sum holes: 53 */
   /* bit holes: 2, sum bit holes: 62 bits */
   /* last cacheline: 48 bytes */

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 drivers/char/drm/drmP.h     |    4 ++--
 drivers/char/drm/drm_lock.c |   16 +++++++++-------
 include/linux/init_task.h   |    1 +
 include/linux/sched.h       |   12 +++++-------
 include/linux/signal.h      |   16 ++++++++++++++++
 kernel/fork.c               |    1 +
 kernel/signal.c             |   42 ++++++++++++++++++++----------------------
 7 files changed, 54 insertions(+), 38 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -963,10 +963,9 @@ struct task_struct {
 
 	unsigned long sas_ss_sp;
 	size_t sas_ss_size;
-	int (*notifier)(void *priv);
-	void *notifier_data;
-	sigset_t *notifier_mask;
-	
+	/* signal notifier list */
+	struct list_head notifier_list;
+
 	void *security;
 	struct audit_context *audit_context;
 	seccomp_t seccomp;
@@ -1339,9 +1338,8 @@ static inline int dequeue_signal_lock(st
 	return ret;
 }	
 
-extern void block_all_signals(int (*notifier)(void *priv), void *priv,
-			      sigset_t *mask);
-extern void unblock_all_signals(void);
+extern void block_signals(struct signal_notifier *);
+extern void unblock_signals(struct signal_notifier *);
 extern void release_task(struct task_struct * p);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int send_group_sig_info(int, struct siginfo *, struct task_struct *);
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -157,6 +157,7 @@ extern struct group_info init_groups;
 		.list = LIST_HEAD_INIT(tsk.pending.list),		\
 		.signal = {{0}}},					\
 	.blocked	= {{0}},					\
+	.notifier_list	= LIST_HEAD_INIT(tsk.notifier_list),		\
 	.alloc_lock	= __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),		\
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
Index: linux-2.6/include/linux/signal.h
===================================================================
--- linux-2.6.orig/include/linux/signal.h
+++ linux-2.6/include/linux/signal.h
@@ -27,6 +27,22 @@ struct sigpending {
 	sigset_t signal;
 };
 
+/**
+ * struct signal_notifier - the signal notifier struct
+ * @list: list head to enqueue into the process notifier list
+ * @func: notifier callback function. if the callback routine returns 0
+ * then then signal will be blocked.
+ * @data: pointer to private data that the notifier routine can use to
+ * determine if the signal should be blocked or not.
+ * @mask: mask of signals to call the callback routine upon
+ */
+struct signal_notifier {
+	struct list_head list;
+	int (*func)(void *priv);
+	void *data;
+	sigset_t mask;
+};
+
 /*
  * Define some primitives to manipulate sigset_t.
  */
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1034,6 +1034,7 @@ static struct task_struct *copy_process(
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
+	INIT_LIST_HEAD(&p->notifier_list);
 	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
Index: linux-2.6/drivers/char/drm/drm_lock.c
===================================================================
--- linux-2.6.orig/drivers/char/drm/drm_lock.c
+++ linux-2.6/drivers/char/drm/drm_lock.c
@@ -110,14 +110,16 @@ int drm_lock(struct inode *inode, struct
 	DRM_DEBUG( "%d %s\n", lock.context, ret ? "interrupted" : "has lock" );
 	if (ret) return ret;
 
-	sigemptyset(&dev->sigmask);
-	sigaddset(&dev->sigmask, SIGSTOP);
-	sigaddset(&dev->sigmask, SIGTSTP);
-	sigaddset(&dev->sigmask, SIGTTIN);
-	sigaddset(&dev->sigmask, SIGTTOU);
+	sigemptyset(&dev->notifier.mask);
+	sigaddset(&dev->notifier.mask, SIGSTOP);
+	sigaddset(&dev->notifier.mask, SIGTSTP);
+	sigaddset(&dev->notifier.mask, SIGTTIN);
+	sigaddset(&dev->notifier.mask, SIGTTOU);
 	dev->sigdata.context = lock.context;
 	dev->sigdata.lock = dev->lock.hw_lock;
-	block_all_signals(drm_notifier, &dev->sigdata, &dev->sigmask);
+	dev->notifier.data = &dev->sigdata;
+	dev->notifier.func = drm_notifier;
+	block_signals(&dev->notifier);
 
 	if (dev->driver->dma_ready && (lock.flags & _DRM_LOCK_READY))
 		dev->driver->dma_ready(dev);
@@ -189,7 +191,7 @@ int drm_unlock(struct inode *inode, stru
 		}
 	}
 
-	unblock_all_signals();
+	unblock_signals(&dev->notifier);
 	return 0;
 }
 
Index: linux-2.6/drivers/char/drm/drmP.h
===================================================================
--- linux-2.6.orig/drivers/char/drm/drmP.h
+++ linux-2.6/drivers/char/drm/drmP.h
@@ -750,8 +750,8 @@ typedef struct drm_device {
 	drm_sg_mem_t *sg;	/**< Scatter gather memory */
 	unsigned long *ctx_bitmap;	/**< context bitmap */
 	void *dev_private;		/**< device private data */
-	drm_sigdata_t sigdata;	   /**< For block_all_signals */
-	sigset_t sigmask;
+	drm_sigdata_t sigdata;	   /**< Signal notifier data */
+	struct signal_notifier notifier;	/**< For block_signals */
 
 	struct drm_driver *driver;
 	drm_local_map_t *agp_buffer_map;
Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c
+++ linux-2.6/kernel/signal.c
@@ -242,32 +242,28 @@ flush_signal_handlers(struct task_struct
  * process, and wants to be notified if any signals at all were to be
  * sent/acted upon.  If the notifier routine returns non-zero, then the
  * signal will be acted upon after all.  If the notifier routine returns 0,
- * then then signal will be blocked.  Only one block per process is
- * allowed.  priv is a pointer to private data that the notifier routine
- * can use to determine if the signal should be blocked or not.  */
+ * the signal will be blocked.
+ */
 
 void
-block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
+block_signals(struct signal_notifier *notifier)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&current->sighand->siglock, flags);
-	current->notifier_mask = mask;
-	current->notifier_data = priv;
-	current->notifier = notifier;
+	list_add_tail(&notifier->list, &current->notifier_list);
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
 /* Notify the system that blocking has ended. */
 
 void
-unblock_all_signals(void)
+unblock_signals(struct signal_notifier *notifier)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&current->sighand->siglock, flags);
-	current->notifier = NULL;
-	current->notifier_data = NULL;
+	list_del(&notifier->list);
 	recalc_sigpending();
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
@@ -318,22 +314,24 @@ static int collect_signal(int sig, struc
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
 			siginfo_t *info)
 {
+	struct signal_notifier *tmp, *notifier;
 	int sig = next_signal(pending, mask);
 
-	if (sig) {
-		if (current->notifier) {
-			if (sigismember(current->notifier_mask, sig)) {
-				if (!(current->notifier)(current->notifier_data)) {
-					clear_thread_flag(TIF_SIGPENDING);
-					return 0;
-				}
+	if (unlikely(!sig))
+		return 0;
+
+	list_for_each_entry_safe(notifier, tmp, &current->notifier_list, list) {
+		if (sigismember(&notifier->mask, sig)) {
+			if (!(notifier->func)(notifier->data)) {
+				clear_thread_flag(TIF_SIGPENDING);
+				return 0;
 			}
 		}
-
-		if (!collect_signal(sig, pending, info))
-			sig = 0;
 	}
 
+	if (!collect_signal(sig, pending, info))
+		sig = 0;
+
 	return sig;
 }
 
@@ -1860,8 +1858,8 @@ EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
 EXPORT_SYMBOL(sigprocmask);
-EXPORT_SYMBOL(block_all_signals);
-EXPORT_SYMBOL(unblock_all_signals);
+EXPORT_SYMBOL(block_signals);
+EXPORT_SYMBOL(unblock_signals);
 
 
 /*
