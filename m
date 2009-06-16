Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbZFPCaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbZFPCaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbZFPCaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:30:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36889 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFPCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:30:00 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
	interface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mst@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Date: Mon, 15 Jun 2009 22:29:56 -0400
Message-ID: <20090616022956.23890.63776.stgit@dev.haskins.net>
In-Reply-To: <20090616022041.23890.90120.stgit@dev.haskins.net>
References: <20090616022041.23890.90120.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqfd and its underlying implementation, eventfd, currently utilize
the embedded wait-queue in eventfd for signal notification.  The nice thing
about this design decision is that it re-uses the existing
eventfd/wait-queue code and it generally works well....with several
limitations.

One of the limitations is that notification callbacks are always called
inside a spin_lock_irqsave critical section.  Another limitation is
that it is very difficult to build a system that can recieve release
notification without being racy.

Therefore, we introduce a new registration interface that is SRCU based
instead of wait-queue based, and implement the internal wait-queue
infrastructure in terms of this new interface.  We then convert irqfd
to use this new interface instead of the existing wait-queue code.

The end result is that we now have the opportunity to run the interrupt
injection code serially to the callback (when the signal is raised from
process-context, at least) instead of always deferring the injection to a
work-queue.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c            |  115 +++++++++++++++++++++++++++++++++++++++++++----
 include/linux/eventfd.h |   30 ++++++++++++
 virt/kvm/eventfd.c      |  114 +++++++++++++++++++++--------------------------
 3 files changed, 188 insertions(+), 71 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 72f5f8d..505d5de 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -30,8 +30,47 @@ struct eventfd_ctx {
 	 */
 	__u64 count;
 	unsigned int flags;
+	struct srcu_struct srcu;
+	struct list_head nh;
+	struct eventfd_notifier notifier;
 };
 
+static void _eventfd_wqh_notify(struct eventfd_notifier *en)
+{
+	struct eventfd_ctx *ctx = container_of(en,
+					       struct eventfd_ctx,
+					       notifier);
+
+	if (waitqueue_active(&ctx->wqh))
+		wake_up_poll(&ctx->wqh, POLLIN);
+}
+
+static void _eventfd_notify(struct eventfd_ctx *ctx)
+{
+	struct eventfd_notifier *en;
+	int idx;
+
+	idx = srcu_read_lock(&ctx->srcu);
+
+	/*
+	 * The goal here is to allow the notification to be preemptible
+	 * as often as possible.  We cannot achieve this with the basic
+	 * wqh mechanism because it requires the wqh->lock.  Therefore
+	 * we have an internal srcu list mechanism of which the wqh is
+	 * a client.
+	 *
+	 * Not all paths will invoke this function in process context.
+	 * Callers should check for suitable state before assuming they
+	 * can sleep (such as with preemptible()).  Paul McKenney assures
+	 * me that srcu_read_lock is compatible with in-atomic, as long as
+	 * the code within the critical section is also compatible.
+	 */
+	list_for_each_entry_rcu(en, &ctx->nh, list)
+		en->ops->signal(en);
+
+	srcu_read_unlock(&ctx->srcu, idx);
+}
+
 /*
  * Adds "n" to the eventfd counter "count". Returns "n" in case of
  * success, or a value lower then "n" in case of coutner overflow.
@@ -51,10 +90,10 @@ int eventfd_signal(struct file *file, int n)
 	if (ULLONG_MAX - ctx->count < n)
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
-	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked_poll(&ctx->wqh, POLLIN);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
+	_eventfd_notify(ctx);
+
 	return n;
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
@@ -62,13 +101,21 @@ EXPORT_SYMBOL_GPL(eventfd_signal);
 static int eventfd_release(struct inode *inode, struct file *file)
 {
 	struct eventfd_ctx *ctx = file->private_data;
+	struct eventfd_notifier *en, *tmp;
 
 	/*
 	 * No need to hold the lock here, since we are on the file cleanup
-	 * path and the ones still attached to the wait queue will be
-	 * serialized by wake_up_locked_poll().
+	 * path
 	 */
-	wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	list_for_each_entry_safe(en, tmp, &ctx->nh, list) {
+		list_del(&en->list);
+		if (en->ops->release)
+			en->ops->release(en);
+	}
+
+	synchronize_srcu(&ctx->srcu);
+	cleanup_srcu_struct(&ctx->srcu);
+
 	kfree(ctx);
 	return 0;
 }
@@ -176,13 +223,13 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (likely(res > 0)) {
+	if (likely(res > 0))
 		ctx->count += ucnt;
-		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked_poll(&ctx->wqh, POLLIN);
-	}
 	spin_unlock_irq(&ctx->wqh.lock);
 
+	if (likely(res > 0))
+		_eventfd_notify(ctx);
+
 	return res;
 }
 
@@ -209,6 +256,50 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+static int _eventfd_notifier_register(struct eventfd_ctx *ctx,
+				      struct eventfd_notifier *en)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	list_add_tail_rcu(&en->list, &ctx->nh);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+
+	return 0;
+}
+
+int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+
+	return _eventfd_notifier_register(ctx, en);
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_register);
+
+int eventfd_notifier_unregister(struct file *file, struct eventfd_notifier *en)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	list_del_rcu(&en->list);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	synchronize_srcu(&ctx->srcu);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_unregister);
+
+static const struct eventfd_notifier_ops eventfd_wqh_ops = {
+	.signal = _eventfd_wqh_notify,
+};
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -229,6 +320,12 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 	ctx->count = count;
 	ctx->flags = flags;
 
+	init_srcu_struct(&ctx->srcu);
+	INIT_LIST_HEAD(&ctx->nh);
+
+	eventfd_notifier_init(&ctx->notifier, &eventfd_wqh_ops);
+	_eventfd_notifier_register(ctx, &ctx->notifier);
+
 	/*
 	 * When we call this, the initialization must be complete, since
 	 * anon_inode_getfd() will install the fd.
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index f45a8ae..0218cf6 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,6 +8,28 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+#include <linux/list.h>
+
+struct eventfd_notifier;
+
+struct eventfd_notifier_ops {
+	void (*signal)(struct eventfd_notifier *en);
+	void (*release)(struct eventfd_notifier *en);
+};
+
+struct eventfd_notifier {
+	struct list_head                   list;
+	const struct eventfd_notifier_ops *ops;
+};
+
+static inline void eventfd_notifier_init(struct eventfd_notifier *en,
+					 const struct eventfd_notifier_ops *ops)
+{
+	memset(en, 0, sizeof(*en));
+	INIT_LIST_HEAD(&en->list);
+	en->ops = ops;
+}
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -29,12 +51,20 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en);
+int eventfd_notifier_unregister(struct file *file, struct eventfd_notifier *en);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+static inline int eventfd_notifier_register(struct file *file,
+					    struct eventfd_notifier *en)
+{ return -ENOENT; }
+static inline int eventfd_notifier_unregister(struct file *file,
+					      struct eventfd_notifier *en)
+{ return -ENOENT; }
 
 #endif /* CONFIG_EVENTFD */
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2c8028c..efc3d77 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -43,33 +43,11 @@ struct _irqfd {
 	struct kvm               *kvm;
 	int                       gsi;
 	struct list_head          list;
-	poll_table                pt;
-	wait_queue_head_t        *wqh;
-	wait_queue_t              wait;
 	struct work_struct        inject;
+	struct eventfd_notifier   notifier;
 };
 
 static void
-irqfd_inject(struct work_struct *work)
-{
-	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
-	struct kvm *kvm;
-	int idx;
-
-	idx = srcu_read_lock(&irqfd->srcu);
-
-	kvm = rcu_dereference(irqfd->kvm);
-	if (kvm) {
-		mutex_lock(&kvm->irq_lock);
-		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
-		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
-		mutex_unlock(&kvm->irq_lock);
-	}
-
-	srcu_read_unlock(&irqfd->srcu, idx);
-}
-
-static void
 irqfd_disconnect(struct _irqfd *irqfd)
 {
 	struct kvm *kvm;
@@ -97,47 +75,67 @@ irqfd_disconnect(struct _irqfd *irqfd)
 	kvm_put_kvm(kvm);
 }
 
-static int
-irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
+static void
+_irqfd_inject(struct _irqfd *irqfd)
 {
-	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
-	unsigned long flags = (unsigned long)key;
-
-	if (flags & POLLIN)
-		/*
-		 * The POLLIN wake_up is called with interrupts disabled.
-		 * Therefore we need to defer the IRQ injection until later
-		 * since we need to acquire the kvm->lock to do so.
-		 */
-		schedule_work(&irqfd->inject);
+	struct kvm *kvm;
+	int idx;
 
-	if (flags & POLLHUP) {
-		/*
-		 * The POLLHUP is called unlocked, so it theoretically should
-		 * be safe to remove ourselves from the wqh using the locked
-		 * variant of remove_wait_queue()
-		 */
-		remove_wait_queue(irqfd->wqh, &irqfd->wait);
-		flush_work(&irqfd->inject);
-		irqfd_disconnect(irqfd);
+	idx = srcu_read_lock(&irqfd->srcu);
 
-		cleanup_srcu_struct(&irqfd->srcu);
-		kfree(irqfd);
+	kvm = rcu_dereference(irqfd->kvm);
+	if (kvm) {
+		mutex_lock(&kvm->irq_lock);
+		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
+		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+		mutex_unlock(&kvm->irq_lock);
 	}
 
-	return 0;
+	srcu_read_unlock(&irqfd->srcu, idx);
+}
+
+static void
+irqfd_inject(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+
+	_irqfd_inject(irqfd);
+}
+
+static void
+irqfd_eventfd_signal(struct eventfd_notifier *notifier)
+{
+	struct _irqfd *irqfd = container_of(notifier, struct _irqfd, notifier);
+
+	/*
+	 * Our signal may or may not be called from atomic context.  We can
+	 * detect if this can safely sleep by checking preemptible() on
+	 * CONFIG_PREEMPT kernels.  CONFIG_PREEMPT=n, or in_atomic() will fail
+	 * this check and therefore defer the injection via a work-queue
+	 */
+	if (preemptible())
+		_irqfd_inject(irqfd);
+	else
+		schedule_work(&irqfd->inject);
 }
 
 static void
-irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
-			poll_table *pt)
+irqfd_eventfd_release(struct eventfd_notifier *notifier)
 {
-	struct _irqfd *irqfd = container_of(pt, struct _irqfd, pt);
+	struct _irqfd *irqfd = container_of(notifier, struct _irqfd, notifier);
 
-	irqfd->wqh = wqh;
-	add_wait_queue(wqh, &irqfd->wait);
+	flush_work(&irqfd->inject);
+	irqfd_disconnect(irqfd);
+
+	cleanup_srcu_struct(&irqfd->srcu);
+	kfree(irqfd);
 }
 
+static const struct eventfd_notifier_ops irqfd_notifier_ops = {
+	.signal  = irqfd_eventfd_signal,
+	.release = irqfd_eventfd_release,
+};
+
 int
 kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
@@ -165,14 +163,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 		goto fail;
 	}
 
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
+	eventfd_notifier_init(&irqfd->notifier, &irqfd_notifier_ops);
 
-	ret = file->f_op->poll(file, &irqfd->pt);
+	ret = eventfd_notifier_register(file, &irqfd->notifier);
 	if (ret < 0)
 		goto fail;
 
@@ -191,9 +184,6 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	return 0;
 
 fail:
-	if (irqfd->wqh)
-		remove_wait_queue(irqfd->wqh, &irqfd->wait);
-
 	if (file && !IS_ERR(file))
 		fput(file);
 

