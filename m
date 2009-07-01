Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZGAQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZGAQJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZGAQJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:09:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48937 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZGAQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:09:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v8 1/3] KVM: Fix races in irqfd using new eventfd_kref_get
	interface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Wed, 01 Jul 2009 12:09:02 -0400
Message-ID: <20090701160902.3615.39426.stgit@dev.haskins.net>
In-Reply-To: <20090701160208.3615.99153.stgit@dev.haskins.net>
References: <20090701160208.3615.99153.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventfd currently emits a POLLHUP wakeup on f_ops->release() to generate a
"release" callback.  This lets eventfd clients know if the eventfd is about
to go away and is very useful particularly for in-kernel clients.  However,
until recently it is not possible to use this feature of eventfd in a
race-free way.

This patch utilizes a new eventfd interface to rectify the problem.  It also
converts the eventfd POLLHUP generation code to use the locked variant
of wakeup.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c             |    7 --
 include/linux/kvm_host.h |    5 +
 virt/kvm/eventfd.c       |  187 ++++++++++++++++++++++++++++++++--------------
 3 files changed, 134 insertions(+), 65 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index d9849a1..31d12de 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -105,12 +105,7 @@ static int eventfd_release(struct inode *inode, struct file *file)
 {
 	struct eventfd_ctx *ctx = file->private_data;
 
-	/*
-	 * No need to hold the lock here, since we are on the file cleanup
-	 * path and the ones still attached to the wait queue will be
-	 * serialized by wake_up_locked_poll().
-	 */
-	wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	wake_up_poll(&ctx->wqh, POLLHUP);
 	eventfd_ctx_put(ctx);
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a8952f..7605bc4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -141,7 +141,10 @@ struct kvm {
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 #ifdef CONFIG_HAVE_KVM_EVENTFD
-	struct list_head irqfds;
+	struct {
+		spinlock_t        lock;
+		struct list_head  items;
+	} irqfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a9e7de7..05ce447 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,7 +28,6 @@
 #include <linux/file.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
-#include <linux/srcu.h>
 
 /*
  * --------------------------------------------------------------------
@@ -37,66 +36,86 @@
  * Credit goes to Avi Kivity for the original idea.
  * --------------------------------------------------------------------
  */
+
 struct _irqfd {
-	struct mutex              lock;
-	struct srcu_struct        srcu;
 	struct kvm               *kvm;
+	struct eventfd_ctx       *eventfd;
 	int                       gsi;
 	struct list_head          list;
 	poll_table                pt;
 	wait_queue_head_t        *wqh;
 	wait_queue_t              wait;
 	struct work_struct        inject;
+	struct work_struct        shutdown;
 };
 
+static struct workqueue_struct *irqfd_cleanup_wq;
+
 static void
 irqfd_inject(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
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
+	struct kvm *kvm = irqfd->kvm;
 
-	srcu_read_unlock(&irqfd->srcu, idx);
+	mutex_lock(&kvm->irq_lock);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+	mutex_unlock(&kvm->irq_lock);
 }
 
+/*
+ * Race-free decouple logic (ordering is critical)
+ */
 static void
-irqfd_disconnect(struct _irqfd *irqfd)
+irqfd_shutdown(struct work_struct *work)
 {
-	struct kvm *kvm;
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
 
-	mutex_lock(&irqfd->lock);
+	/*
+	 * Synchronize with the wait-queue and unhook ourselves to prevent
+	 * further events.
+	 */
+	remove_wait_queue(irqfd->wqh, &irqfd->wait);
+
+	/*
+	 * We know no new events will be scheduled at this point, so block
+	 * until all previously outstanding events have completed
+	 */
+	flush_work(&irqfd->inject);
+
+	/*
+	 * It is now safe to release the object's resources
+	 */
+	eventfd_ctx_put(irqfd->eventfd);
+	kfree(irqfd);
+}
 
-	kvm = rcu_dereference(irqfd->kvm);
-	rcu_assign_pointer(irqfd->kvm, NULL);
 
-	mutex_unlock(&irqfd->lock);
+/* assumes kvm->irqfds.lock is held */
+static bool
+irqfd_is_active(struct _irqfd *irqfd)
+{
+	return list_empty(&irqfd->list) ? false : true;
+}
 
-	if (!kvm)
-		return;
+/*
+ * Mark the irqfd as inactive and schedule it for removal
+ *
+ * assumes kvm->irqfds.lock is held
+ */
+static void
+irqfd_deactivate(struct _irqfd *irqfd)
+{
+	BUG_ON(!irqfd_is_active(irqfd));
 
-	mutex_lock(&kvm->lock);
-	list_del(&irqfd->list);
-	mutex_unlock(&kvm->lock);
+	list_del_init(&irqfd->list);
 
-	/*
-	 * It is important to not drop the kvm reference until the next grace
-	 * period because there might be lockless references in flight up
-	 * until then
-	 */
-	synchronize_srcu(&irqfd->srcu);
-	kvm_put_kvm(kvm);
+	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
 }
 
+/*
+ * Called with wqh->lock held and interrupts disabled
+ */
 static int
 irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
@@ -104,25 +123,29 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLIN)
-		/*
-		 * The POLLIN wake_up is called with interrupts disabled.
-		 * Therefore we need to defer the IRQ injection until later
-		 * since we need to acquire the kvm->lock to do so.
-		 */
+		/* An event has been signaled, inject an interrupt */
 		schedule_work(&irqfd->inject);
 
 	if (flags & POLLHUP) {
+		/* The eventfd is closing, detach from KVM */
+		struct kvm *kvm = irqfd->kvm;
+		unsigned long flags;
+
+		spin_lock_irqsave(&kvm->irqfds.lock, flags);
+
 		/*
-		 * The POLLHUP is called unlocked, so it theoretically should
-		 * be safe to remove ourselves from the wqh using the locked
-		 * variant of remove_wait_queue()
+		 * We must check if someone deactivated the irqfd before
+		 * we could acquire the irqfds.lock since the item is
+		 * deactivated from the KVM side before it is unhooked from
+		 * the wait-queue.  If it is already deactivated, we can
+		 * simply return knowing the other side will cleanup for us.
+		 * We cannot race against the irqfd going away since the
+		 * other side is required to acquire wqh->lock, which we hold
 		 */
-		remove_wait_queue(irqfd->wqh, &irqfd->wait);
-		flush_work(&irqfd->inject);
-		irqfd_disconnect(irqfd);
+		if (irqfd_is_active(irqfd))
+			irqfd_deactivate(irqfd);
 
-		cleanup_srcu_struct(&irqfd->srcu);
-		kfree(irqfd);
+		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
 	}
 
 	return 0;
@@ -143,6 +166,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
+	struct eventfd_ctx *eventfd = NULL;
 	int ret;
 	unsigned int events;
 
@@ -150,12 +174,11 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	if (!irqfd)
 		return -ENOMEM;
 
-	mutex_init(&irqfd->lock);
-	init_srcu_struct(&irqfd->srcu);
 	irqfd->kvm = kvm;
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
+	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(fd);
 	if (IS_ERR(file)) {
@@ -163,6 +186,14 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 		goto fail;
 	}
 
+	eventfd = eventfd_ctx_fileget(file);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto fail;
+	}
+
+	irqfd->eventfd = eventfd;
+
 	/*
 	 * Install our own custom wake-up handling so we are notified via
 	 * a callback whenever someone signals the underlying eventfd
@@ -172,14 +203,13 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 
 	events = file->f_op->poll(file, &irqfd->pt);
 
-	kvm_get_kvm(kvm);
-
-	mutex_lock(&kvm->lock);
-	list_add_tail(&irqfd->list, &kvm->irqfds);
-	mutex_unlock(&kvm->lock);
+	spin_lock_irq(&kvm->irqfds.lock);
+	list_add_tail(&irqfd->list, &kvm->irqfds.items);
+	spin_unlock_irq(&kvm->irqfds.lock);
 
 	/*
-	 * Check if there was an event already queued
+	 * Check if there was an event already pending on the eventfd
+	 * before we registered, and trigger it as if we didn't miss it.
 	 */
 	if (events & POLLIN)
 		schedule_work(&irqfd->inject);
@@ -193,6 +223,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	return 0;
 
 fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+
 	if (file && !IS_ERR(file))
 		fput(file);
 
@@ -203,14 +236,52 @@ fail:
 void
 kvm_irqfd_init(struct kvm *kvm)
 {
-	INIT_LIST_HEAD(&kvm->irqfds);
+	spin_lock_init(&kvm->irqfds.lock);
+	INIT_LIST_HEAD(&kvm->irqfds.items);
 }
 
+/*
+ * This function is called as the kvm VM fd is being released. Shutdown all
+ * irqfds that still remain open
+ */
 void
 kvm_irqfd_release(struct kvm *kvm)
 {
 	struct _irqfd *irqfd, *tmp;
 
-	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
-		irqfd_disconnect(irqfd);
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)
+		irqfd_deactivate(irqfd);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed
+	 * since we do not take a kvm* reference.
+	 */
+	flush_workqueue(irqfd_cleanup_wq);
+
 }
+
+/*
+ * create a host-wide workqueue for issuing deferred shutdown requests
+ * aggregated from all vm* instances. We need our own isolated single-thread
+ * queue to prevent deadlock against flushing the normal work-queue.
+ */
+static int __init irqfd_module_init(void)
+{
+	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
+	if (!irqfd_cleanup_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit irqfd_module_exit(void)
+{
+	destroy_workqueue(irqfd_cleanup_wq);
+}
+
+module_init(irqfd_module_init);
+module_exit(irqfd_module_exit);

