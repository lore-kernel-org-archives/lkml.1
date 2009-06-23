Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbZFXUEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbZFXUEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761991AbZFXUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:03:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55307 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZFXUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:03:06 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 4/4] KVM: Fix races in irqfd using new eventfd_kref_get
	interface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org, dhowells@redhat.com
Date: Tue, 23 Jun 2009 18:40:53 -0400
Message-ID: <20090623224053.5254.29597.stgit@dev.haskins.net>
In-Reply-To: <20090623223717.5254.22497.stgit@dev.haskins.net>
References: <20090623223717.5254.22497.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all known races in irqfd, and paves the way to restore
DEASSIGN support.  For details of the eventfd races, please see the header
for patch 2/4, or the thread on which it was based on:

http://www.mail-archive.com/kvm@vger.kernel.org/msg17767.html

In a nutshell, we use eventfd_ctx_get/put() to properly manage the
lifetime of the underlying eventfd.  We also use careful coordination
with our workqueue to ensure that all irqfd objects have terminated
before we allow kvm to shutdown.  The logic used for shutdown walks
all open irqfds and releases them.  This logic can be generalized in
the future to allow a subset of irqfds to be released, thus allowing
DEASSIGN support.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_host.h |    7 +-
 virt/kvm/Kconfig         |    1 
 virt/kvm/eventfd.c       |  199 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 183 insertions(+), 24 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2451f48..d94ee72 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -141,7 +141,12 @@ struct kvm {
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 #ifdef CONFIG_HAVE_KVM_EVENTFD
-	struct list_head irqfds;
+	struct {
+		spinlock_t        lock;
+		struct list_head  items;
+		atomic_t          outstanding;
+		wait_queue_head_t wqh;
+	} irqfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index daece36..ab7848a 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -9,6 +9,7 @@ config HAVE_KVM_IRQCHIP
 config HAVE_KVM_EVENTFD
        bool
        select EVENTFD
+       select SLOW_WORK
 
 config KVM_APIC_ARCHITECTURE
        bool
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 9656027..e9e74f4 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
+#include <linux/slow-work.h>
 
 /*
  * --------------------------------------------------------------------
@@ -36,17 +37,27 @@
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
+	struct slow_work          shutdown;
 };
 
 static void
+irqfd_release(struct _irqfd *irqfd)
+{
+	eventfd_ctx_put(irqfd->eventfd);
+	kfree(irqfd);
+}
+
+static void
 irqfd_inject(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
@@ -58,6 +69,55 @@ irqfd_inject(struct work_struct *work)
 	mutex_unlock(&kvm->irq_lock);
 }
 
+static struct _irqfd *
+work_to_irqfd(struct slow_work *work)
+{
+	return container_of(work, struct _irqfd, shutdown);
+}
+
+static int
+irqfd_shutdown_get_ref(struct slow_work *work)
+{
+	struct _irqfd *irqfd = work_to_irqfd(work);
+	struct kvm *kvm = irqfd->kvm;
+
+	atomic_inc(&kvm->irqfds.outstanding);
+
+	return 0;
+}
+
+static void
+irqfd_shutdown_put_ref(struct slow_work *work)
+{
+	struct _irqfd *irqfd = work_to_irqfd(work);
+	struct kvm *kvm = irqfd->kvm;
+
+	irqfd_release(irqfd);
+
+	if (atomic_dec_and_test(&kvm->irqfds.outstanding))
+		wake_up(&kvm->irqfds.wqh);
+}
+
+static void
+irqfd_shutdown_execute(struct slow_work *work)
+{
+	struct _irqfd *irqfd = work_to_irqfd(work);
+
+	/*
+	 * Ensure there are no outstanding "inject" work-items before we blow
+	 * away our state.  Once this job completes, the slow_work
+	 * infrastructure will drop the irqfd object completely via put_ref
+	 */
+	flush_work(&irqfd->inject);
+}
+
+const static struct slow_work_ops irqfd_shutdown_work_ops = {
+	.get_ref = irqfd_shutdown_get_ref,
+	.put_ref = irqfd_shutdown_put_ref,
+	.execute = irqfd_shutdown_execute,
+};
+
+
 static int
 irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
@@ -65,25 +125,47 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	unsigned long flags = (unsigned long)key;
 
 	/*
-	 * Assume we will be called with interrupts disabled
+	 * Called with interrupts disabled
 	 */
 	if (flags & POLLIN)
-		/*
-		 * Defer the IRQ injection until later since we need to
-		 * acquire the kvm->lock to do so.
-		 */
+		/* An event has been signaled, inject an interrupt */
 		schedule_work(&irqfd->inject);
 
 	if (flags & POLLHUP) {
-		/*
-		 * for now, just remove ourselves from the list and let
-		 * the rest dangle.  We will fix this up later once
-		 * the races in eventfd are fixed
-		 */
+		/* The eventfd is closing, detach from KVM */
+		struct kvm *kvm = irqfd->kvm;
+		unsigned long flags;
+
 		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
-		irqfd->wqh = NULL;
+
+		spin_lock_irqsave(&kvm->irqfds.lock, flags);
+
+		if (!list_empty(&irqfd->list)) {
+			/*
+			 * If the item is still on the list when we check
+			 * we can be sure that no-one else is trying to
+			 * shutdown this object at the same time.  It is
+			 * therefore our responsibility to unhook the item
+			 * and to schedule its removal from the system.  We
+			 * can't free the object directly here because we need
+			 * to sync with things like outstanding "inject" tasks.
+			 *
+			 * To make matters more complicated, we cannot use
+			 * a work-queue for shutdown because work-queues cannot
+			 * block on one another without risking a deadlock.
+			 * So instead we queue the shutdown job on the
+			 * slow_work infrastructure, which is well suited to
+			 * blocking anyway and probably a better fit.
+			 */
+
+			list_del_init(&irqfd->list);
+			slow_work_enqueue(&irqfd->shutdown);
+		}
+
+		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
 	}
 
+
 	return 0;
 }
 
@@ -102,6 +184,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
+	struct eventfd_ctx *eventfd = NULL;
 	int ret;
 	unsigned int events;
 
@@ -113,6 +196,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
+	slow_work_init(&irqfd->shutdown, &irqfd_shutdown_work_ops);
 
 	file = eventfd_fget(fd);
 	if (IS_ERR(file)) {
@@ -130,11 +214,20 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	events = file->f_op->poll(file, &irqfd->pt);
 
 	mutex_lock(&kvm->lock);
-	list_add_tail(&irqfd->list, &kvm->irqfds);
+	list_add_tail(&irqfd->list, &kvm->irqfds.items);
 	mutex_unlock(&kvm->lock);
 
+	eventfd = eventfd_ctx_fileget(file);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto fail;
+	}
+
+	irqfd->eventfd = eventfd;
+
 	/*
-	 * Check if there was an event already queued
+	 * Check if there was an event already pending on the eventfd
+	 * before we registered, and trigger it as if we didn't miss it.
 	 */
 	if (events & POLLIN)
 		schedule_work(&irqfd->inject);
@@ -148,6 +241,9 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	return 0;
 
 fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+
 	if (file && !IS_ERR(file))
 		fput(file);
 
@@ -158,24 +254,81 @@ fail:
 void
 kvm_irqfd_init(struct kvm *kvm)
 {
-	INIT_LIST_HEAD(&kvm->irqfds);
+	slow_work_register_user();
+
+	spin_lock_init(&kvm->irqfds.lock);
+	INIT_LIST_HEAD(&kvm->irqfds.items);
+	atomic_set(&kvm->irqfds.outstanding, 0);
+	init_waitqueue_head(&kvm->irqfds.wqh);
+}
+
+static struct _irqfd *
+irqfd_pop(struct kvm *kvm)
+{
+	struct _irqfd *irqfd = NULL;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	if (!list_empty(&kvm->irqfds.items)) {
+		irqfd = list_first_entry(&kvm->irqfds.items,
+					 struct _irqfd, list);
+
+		/*
+		 * Removing this item from the list is also a state-flag
+		 * to indicate that shutdown processing is occuring.  So
+		 * be sure to use the "init" variant so that list_empty()
+		 * works as expected
+		 */
+		list_del_init(&irqfd->list);
+	}
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	return irqfd;
 }
 
 void
 kvm_irqfd_release(struct kvm *kvm)
 {
-	struct _irqfd *irqfd, *tmp;
+	struct _irqfd *irqfd;
 
-	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
-		if (irqfd->wqh)
-			remove_wait_queue(irqfd->wqh, &irqfd->wait);
+	while ((irqfd = irqfd_pop(kvm))) {
 
-		flush_work(&irqfd->inject);
+		/*
+		 * If we get here, it means KVM won the race with eventfd
+		 * to have the honors of freeing this irqfd.  However, we
+		 * still need to dance carefully.  First we will remove
+		 * ourselves from the wait-queue, which will act to sync
+		 * us with eventfd.  Thankfully this is a no-op if it was
+		 * already performed by a concurrent eventfd thread.
+		 *
+		 * Note that we are now guaranteed that we will never
+		 * schedule a shutdown task against this object since we
+		 * effecively marked the state by removing it from the list.
+		 */
+		remove_wait_queue(irqfd->wqh, &irqfd->wait);
 
-		mutex_lock(&kvm->lock);
-		list_del(&irqfd->list);
-		mutex_unlock(&kvm->lock);
+		/*
+		 * Now that we are off the wait-queue, we can guarantee
+		 * that no more inject jobs will be scheduled, so go ahead
+		 * and sync to any potential outstanding jobs that were
+		 * already in flight.
+		 */
+		flush_work(&irqfd->inject);
 
-		kfree(irqfd);
+		/*
+		 * Now it is safe to really release it
+		 */
+		irqfd_release(irqfd);
 	}
+
+	/*
+	 * irqfds.outstanding tracks the number of outstanding "shutdown"
+	 * jobs pending at any given time.  Once we get here, we know that
+	 * no more jobs will get scheduled, so go ahead and block until all
+	 * of them complete
+	 */
+	wait_event(kvm->irqfds.wqh, (!atomic_read(&kvm->irqfds.outstanding)));
+
+	slow_work_unregister_user();
 }

