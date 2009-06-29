Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZF2SaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZF2SaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZF2S3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:29:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:32919 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbZF2S3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:29:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v7 5/5] KVM: Make irqfd use slow-work for shutdown
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 29 Jun 2009 14:29:25 -0400
Message-ID: <20090629182925.1886.48022.stgit@dev.haskins.net>
In-Reply-To: <20090629181954.1886.20225.stgit@dev.haskins.net>
References: <20090629181954.1886.20225.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates the mostly idle, dedicated work-queue in favor of
utilizing the slow-work thread pool.  The downside to this approach is
that we add ~30 lines of complexity to irqfd to get rid of the thread,
but this may be a worthwhile tradeoff.

Note that a race is known to exist: the slow-work thread may race with
module removal.  We are currently working with slow-work upstream to fix
this issue as well.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_host.h |    2 +
 virt/kvm/Kconfig         |    1 
 virt/kvm/eventfd.c       |  100 +++++++++++++++++++++++++++++-----------------
 3 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5a90c6a..d94ee72 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -144,6 +144,8 @@ struct kvm {
 	struct {
 		spinlock_t        lock;
 		struct list_head  items;
+		atomic_t          outstanding;
+		wait_queue_head_t wqh;
 	} irqfds;
 #endif
 	struct kvm_vm_stat stat;
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
index c1ade4f..5fbd97b 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
+#include <linux/slow-work.h>
 
 /*
  * --------------------------------------------------------------------
@@ -46,12 +47,10 @@ struct _irqfd {
 	wait_queue_head_t        *wqh;
 	wait_queue_t              wait;
 	struct work_struct        inject;
-	struct work_struct        shutdown;
+	struct slow_work          shutdown;
 	int                       active:1; /* guarded by kvm->irqfds.lock */
 };
 
-static struct workqueue_struct *irqfd_cleanup_wq;
-
 static void
 irqfd_inject(struct work_struct *work)
 {
@@ -64,13 +63,53 @@ irqfd_inject(struct work_struct *work)
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
+	/*
+	 * It is now safe to release the object's resources
+	 */
+	eventfd_ctx_put(irqfd->eventfd);
+	kfree(irqfd);
+
+	if (atomic_dec_and_test(&kvm->irqfds.outstanding))
+		wake_up(&kvm->irqfds.wqh);
+}
+
+
+static void
+irqfd_shutdown_flush(struct kvm *kvm)
+{
+	wait_event(kvm->irqfds.wqh, (!atomic_read(&kvm->irqfds.outstanding)));
+}
+
 /*
  * Race-free decouple logic (ordering is critical)
  */
 static void
-irqfd_shutdown(struct work_struct *work)
+irqfd_shutdown_execute(struct slow_work *work)
 {
-	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
+	struct _irqfd *irqfd = work_to_irqfd(work);
 
 	/*
 	 * Synchronize with the wait-queue and unhook ourselves to prevent
@@ -80,17 +119,19 @@ irqfd_shutdown(struct work_struct *work)
 
 	/*
 	 * We know no new events will be scheduled at this point, so block
-	 * until all previously outstanding events have completed
+	 * until all previously outstanding events have completed.  Once this
+	 * job completes, the slow_work infrastructure will drop the irqfd
+	 * object completely via put_ref
 	 */
 	flush_work(&irqfd->inject);
-
-	/*
-	 * It is now safe to release the object's resources
-	 */
-	eventfd_ctx_put(irqfd->eventfd);
-	kfree(irqfd);
 }
 
+const static struct slow_work_ops irqfd_shutdown_work_ops = {
+	.get_ref = irqfd_shutdown_get_ref,
+	.put_ref = irqfd_shutdown_put_ref,
+	.execute = irqfd_shutdown_execute,
+};
+
 /*
  * Mark the irqfd as inactive and schedule it for removal
  *
@@ -104,7 +145,7 @@ irqfd_deactivate(struct _irqfd *irqfd)
 	irqfd->active = false;
 	list_del(&irqfd->list);
 
-	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
+	slow_work_enqueue(&irqfd->shutdown);
 }
 
 /*
@@ -168,7 +209,7 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
-	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
+	slow_work_init(&irqfd->shutdown, &irqfd_shutdown_work_ops);
 	irqfd->active = true;
 
 	file = eventfd_fget(fd);
@@ -227,8 +268,12 @@ fail:
 void
 kvm_irqfd_init(struct kvm *kvm)
 {
+	slow_work_register_user();
+
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
+	atomic_set(&kvm->irqfds.outstanding, 0);
+	init_waitqueue_head(&kvm->irqfds.wqh);
 }
 
 /*
@@ -259,7 +304,7 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
 	 * so that we guarantee there will not be any more interrupts on this
 	 * gsi once this deassign function returns.
 	 */
-	flush_workqueue(irqfd_cleanup_wq);
+	irqfd_shutdown_flush(kvm);
 
 	return 0;
 }
@@ -293,28 +338,7 @@ kvm_irqfd_release(struct kvm *kvm)
 	 * Block until we know all outstanding shutdown jobs have completed
 	 * since we do not take a kvm* reference.
 	 */
-	flush_workqueue(irqfd_cleanup_wq);
+	irqfd_shutdown_flush(kvm);
 
+	slow_work_unregister_user();
 }
-
-/*
- * create a host-wide workqueue for issuing deferred shutdown requests
- * aggregated from all vm* instances. We need our own isolated single-thread
- * queue to prevent deadlock against flushing the normal work-queue.
- */
-static int __init irqfd_module_init(void)
-{
-	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
-	if (!irqfd_cleanup_wq)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void __exit irqfd_module_exit(void)
-{
-	destroy_workqueue(irqfd_cleanup_wq);
-}
-
-module_init(irqfd_module_init);
-module_exit(irqfd_module_exit);

