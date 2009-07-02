Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZGBPjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZGBPjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZGBPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:38:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46664 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbZGBPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:38:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v9 3/5] KVM: Fix races in irqfd using new eventfd_kref_get
	interface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Thu, 02 Jul 2009 11:38:11 -0400
Message-ID: <20090702153811.20186.994.stgit@dev.haskins.net>
In-Reply-To: <20090702153454.20186.99191.stgit@dev.haskins.net>
References: <20090702153454.20186.99191.stgit@dev.haskins.net>
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

This patch utilizes a new eventfd interface to rectify the problem.  It
also carefully coordinates the shutdown path using a deferred work-item
so that we may support a full mutual-disassociate protocol between KVM and
eventfd.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_host.h |    5 +
 virt/kvm/eventfd.c       |  158 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 136 insertions(+), 27 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9634f31..8e04a34 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -146,7 +146,10 @@ struct kvm {
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
index 9656027..9da9286 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -36,16 +36,21 @@
  * Credit goes to Avi Kivity for the original idea.
  * --------------------------------------------------------------------
  */
+
 struct _irqfd {
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
@@ -58,30 +63,89 @@ irqfd_inject(struct work_struct *work)
 	mutex_unlock(&kvm->irq_lock);
 }
 
+/*
+ * Race-free decouple logic (ordering is critical)
+ */
+static void
+irqfd_shutdown(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
+
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
+
+
+/* assumes kvm->irqfds.lock is held */
+static bool
+irqfd_is_active(struct _irqfd *irqfd)
+{
+	return list_empty(&irqfd->list) ? false : true;
+}
+
+/*
+ * Mark the irqfd as inactive and schedule it for removal
+ *
+ * assumes kvm->irqfds.lock is held
+ */
+static void
+irqfd_deactivate(struct _irqfd *irqfd)
+{
+	BUG_ON(!irqfd_is_active(irqfd));
+
+	list_del_init(&irqfd->list);
+
+	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
+}
+
+/*
+ * Called with wqh->lock held and interrupts disabled
+ */
 static int
 irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
 	unsigned long flags = (unsigned long)key;
 
-	/*
-	 * Assume we will be called with interrupts disabled
-	 */
 	if (flags & POLLIN)
-		/*
-		 * Defer the IRQ injection until later since we need to
-		 * acquire the kvm->lock to do so.
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
-		 * for now, just remove ourselves from the list and let
-		 * the rest dangle.  We will fix this up later once
-		 * the races in eventfd are fixed
+		 * We must check if someone deactivated the irqfd before
+		 * we could acquire the irqfds.lock since the item is
+		 * deactivated from the KVM side before it is unhooked from
+		 * the wait-queue.  If it is already deactivated, we can
+		 * simply return knowing the other side will cleanup for us.
+		 * We cannot race against the irqfd going away since the
+		 * other side is required to acquire wqh->lock, which we hold
 		 */
-		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
-		irqfd->wqh = NULL;
+		if (irqfd_is_active(irqfd))
+			irqfd_deactivate(irqfd);
+
+		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
 	}
 
 	return 0;
@@ -102,6 +166,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
+	struct eventfd_ctx *eventfd = NULL;
 	int ret;
 	unsigned int events;
 
@@ -113,6 +178,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
+	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
 	file = eventfd_fget(fd);
 	if (IS_ERR(file)) {
@@ -120,6 +186,14 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 		goto fail;
 	}
 
+	eventfd = eventfd_ctx_fileget(file);
+	if (IS_ERR(eventfd)) {
+		ret = PTR_ERR(eventfd);
+		goto fail;
+	}
+
+	irqfd->eventfd = eventfd;
+
 	/*
 	 * Install our own custom wake-up handling so we are notified via
 	 * a callback whenever someone signals the underlying eventfd
@@ -129,12 +203,13 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 
 	events = file->f_op->poll(file, &irqfd->pt);
 
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
@@ -148,6 +223,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	return 0;
 
 fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+
 	if (file && !IS_ERR(file))
 		fput(file);
 
@@ -158,24 +236,52 @@ fail:
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
 
-	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
-		if (irqfd->wqh)
-			remove_wait_queue(irqfd->wqh, &irqfd->wait);
+	spin_lock_irq(&kvm->irqfds.lock);
 
-		flush_work(&irqfd->inject);
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)
+		irqfd_deactivate(irqfd);
 
-		mutex_lock(&kvm->lock);
-		list_del(&irqfd->list);
-		mutex_unlock(&kvm->lock);
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed
+	 * since we do not take a kvm* reference.
+	 */
+	flush_workqueue(irqfd_cleanup_wq);
 
-		kfree(irqfd);
-	}
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

