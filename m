Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbZFVQGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbZFVQGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757000AbZFVQGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:06:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41204 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbZFVQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:05:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 1/3] kvm: prepare irqfd for having interrupts disabled
	during eventfd->release
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org, mingo@elte.hu,
       rusty@rustcorp.com.au
Date: Mon, 22 Jun 2009 12:05:46 -0400
Message-ID: <20090622160546.22967.12334.stgit@dev.haskins.net>
In-Reply-To: <20090622155504.22967.50532.stgit@dev.haskins.net>
References: <20090622155504.22967.50532.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to plug some race conditions on eventfd shutdown.  In order to
do this, we need to change the context in which the release notification
is delivered so that the wqh lock is now held.  However, there is currently
code in the release callback that assumes it can sleep.

We have a slight chicken and egg problem where we cant fix the race
without adding the lock, and we can't add the lock without breaking
the sleepy code.  Normally we could deal with this by making both
changes in an atomic changeset.  However, we want to keep the eventfd
and kvm specific changes isolated to ease the reviewer burden on upstream
eventfd (at the specific request of upstream).  Therefore, we have this
intermediate patch.

This intermediate patch allows the release() method to work in an atomic
context, at the expense of correctness w.r.t. memory-leaks.  Today we have
a race condition.  With this patch applied we leak.  Both issues will be
resolved later in the series.  It is the author's opinion that a leak is
better for bisectability than the hang would be should we leave the sleepy
code in place after the locking changeover.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 virt/kvm/eventfd.c |   89 ++++++++++++++++------------------------------------
 1 files changed, 27 insertions(+), 62 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a9e7de7..9656027 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,7 +28,6 @@
 #include <linux/file.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
-#include <linux/srcu.h>
 
 /*
  * --------------------------------------------------------------------
@@ -38,8 +37,6 @@
  * --------------------------------------------------------------------
  */
 struct _irqfd {
-	struct mutex              lock;
-	struct srcu_struct        srcu;
 	struct kvm               *kvm;
 	int                       gsi;
 	struct list_head          list;
@@ -53,48 +50,12 @@ static void
 irqfd_inject(struct work_struct *work)
 {
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
-	struct kvm *kvm;
-	int idx;
+	struct kvm *kvm = irqfd->kvm;
 
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
-irqfd_disconnect(struct _irqfd *irqfd)
-{
-	struct kvm *kvm;
-
-	mutex_lock(&irqfd->lock);
-
-	kvm = rcu_dereference(irqfd->kvm);
-	rcu_assign_pointer(irqfd->kvm, NULL);
-
-	mutex_unlock(&irqfd->lock);
-
-	if (!kvm)
-		return;
-
-	mutex_lock(&kvm->lock);
-	list_del(&irqfd->list);
-	mutex_unlock(&kvm->lock);
-
-	/*
-	 * It is important to not drop the kvm reference until the next grace
-	 * period because there might be lockless references in flight up
-	 * until then
-	 */
-	synchronize_srcu(&irqfd->srcu);
-	kvm_put_kvm(kvm);
+	mutex_lock(&kvm->irq_lock);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+	mutex_unlock(&kvm->irq_lock);
 }
 
 static int
@@ -103,26 +64,24 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
 	unsigned long flags = (unsigned long)key;
 
+	/*
+	 * Assume we will be called with interrupts disabled
+	 */
 	if (flags & POLLIN)
 		/*
-		 * The POLLIN wake_up is called with interrupts disabled.
-		 * Therefore we need to defer the IRQ injection until later
-		 * since we need to acquire the kvm->lock to do so.
+		 * Defer the IRQ injection until later since we need to
+		 * acquire the kvm->lock to do so.
 		 */
 		schedule_work(&irqfd->inject);
 
 	if (flags & POLLHUP) {
 		/*
-		 * The POLLHUP is called unlocked, so it theoretically should
-		 * be safe to remove ourselves from the wqh using the locked
-		 * variant of remove_wait_queue()
+		 * for now, just remove ourselves from the list and let
+		 * the rest dangle.  We will fix this up later once
+		 * the races in eventfd are fixed
 		 */
-		remove_wait_queue(irqfd->wqh, &irqfd->wait);
-		flush_work(&irqfd->inject);
-		irqfd_disconnect(irqfd);
-
-		cleanup_srcu_struct(&irqfd->srcu);
-		kfree(irqfd);
+		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
+		irqfd->wqh = NULL;
 	}
 
 	return 0;
@@ -150,8 +109,6 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	if (!irqfd)
 		return -ENOMEM;
 
-	mutex_init(&irqfd->lock);
-	init_srcu_struct(&irqfd->srcu);
 	irqfd->kvm = kvm;
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
@@ -172,8 +129,6 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 
 	events = file->f_op->poll(file, &irqfd->pt);
 
-	kvm_get_kvm(kvm);
-
 	mutex_lock(&kvm->lock);
 	list_add_tail(&irqfd->list, &kvm->irqfds);
 	mutex_unlock(&kvm->lock);
@@ -211,6 +166,16 @@ kvm_irqfd_release(struct kvm *kvm)
 {
 	struct _irqfd *irqfd, *tmp;
 
-	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
-		irqfd_disconnect(irqfd);
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
+		if (irqfd->wqh)
+			remove_wait_queue(irqfd->wqh, &irqfd->wait);
+
+		flush_work(&irqfd->inject);
+
+		mutex_lock(&kvm->lock);
+		list_del(&irqfd->list);
+		mutex_unlock(&kvm->lock);
+
+		kfree(irqfd);
+	}
 }

