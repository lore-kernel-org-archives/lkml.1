Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZFDMsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZFDMsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbZFDMsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:48:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41844 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbZFDMsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:48:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead of an
	explicit ioctl
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davdel@xmailserver.org,
       mst@redhat.com, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Date: Thu, 04 Jun 2009 08:48:12 -0400
Message-ID: <20090604124812.10544.5811.stgit@dev.haskins.net>
In-Reply-To: <20090604124047.10544.38861.stgit@dev.haskins.net>
References: <20090604124047.10544.38861.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning an irqfd object to a kvm object creates a relationship that we
currently manage by having the kvm oject acquire/hold a file* reference to
the underlying eventfd.  The lifetime of these objects is properly maintained
by decoupling the two objects whenever the irqfd is closed or kvm is closed,
whichever comes first.

However, the irqfd "close" method is less than ideal since it requires two
system calls to complete (one for ioctl(kvmfd, IRQFD_DEASSIGN), the other for
close(eventfd)).  This dual-call approach was utilized because there was no
notification mechanism on the eventfd side at the time irqfd was implemented.

Recently, Davide proposed a patch to send a POLLHUP wakeup whenever an
eventfd is about to close.  So we eliminate the IRQFD_DEASSIGN ioctl (*)
vector in favor of sensing the desassign automatically when the fd is closed.
The resulting code is slightly more complex as a result since we need to
allow either side to sever the relationship independently.  We utilize SRCU
to guarantee stable concurrent access to the KVM pointer without adding
additional atomic operations in the fast path.

At minimum, this design should be acked by both Davide and Paul (cc'd).

(*) The irqfd patch does not exist in any released tree, so the understanding
is that we can alter the irqfd specific ABI without taking the normal
precautions, such as CAP bits.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
CC: Michael S. Tsirkin <mst@redhat.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/kvm.h |    2 -
 virt/kvm/eventfd.c  |  177 +++++++++++++++++++++++----------------------------
 virt/kvm/kvm_main.c |    3 +
 3 files changed, 81 insertions(+), 101 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 632a856..29b62cc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -482,8 +482,6 @@ struct kvm_x86_mce {
 };
 #endif
 
-#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
-
 struct kvm_irqfd {
 	__u32 fd;
 	__u32 gsi;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f3f2ea1..004c660 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -37,39 +37,92 @@
  * --------------------------------------------------------------------
  */
 struct _irqfd {
+	struct mutex              lock;
+	struct srcu_struct        srcu;
 	struct kvm               *kvm;
 	int                       gsi;
-	struct file              *file;
 	struct list_head          list;
 	poll_table                pt;
 	wait_queue_head_t        *wqh;
 	wait_queue_t              wait;
-	struct work_struct        work;
+	struct work_struct        inject;
 };
 
 static void
 irqfd_inject(struct work_struct *work)
 {
-	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
-	struct kvm *kvm = irqfd->kvm;
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+	struct kvm *kvm;
+	int idx;
+
+	idx = srcu_read_lock(&irqfd->srcu);
+
+	kvm = rcu_dereference(irqfd->kvm);
+	if (kvm) {
+		mutex_lock(&kvm->lock);
+		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
+		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+		mutex_unlock(&kvm->lock);
+	}
+
+	srcu_read_unlock(&irqfd->srcu, idx);
+}
+
+static void
+irqfd_disconnect(struct _irqfd *irqfd)
+{
+	struct kvm *kvm;
+
+	mutex_lock(&irqfd->lock);
+
+	kvm = rcu_dereference(irqfd->kvm);
+	rcu_assign_pointer(irqfd->kvm, NULL);
+
+	mutex_unlock(&irqfd->lock);
+
+	if (!kvm)
+		return;
 
 	mutex_lock(&kvm->lock);
-	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
-	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+	list_del(&irqfd->list);
 	mutex_unlock(&kvm->lock);
+
+	/*
+	 * It is important to not drop the kvm reference until the next grace
+	 * period because there might be lockless references in flight up
+	 * until then
+	 */
+	synchronize_srcu(&irqfd->srcu);
+	kvm_put_kvm(kvm);
 }
 
 static int
 irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
+	unsigned long flags = (unsigned long)key;
 
-	/*
-	 * The wake_up is called with interrupts disabled.  Therefore we need
-	 * to defer the IRQ injection until later since we need to acquire the
-	 * kvm->lock to do so.
-	 */
-	schedule_work(&irqfd->work);
+	if (flags & POLLIN)
+		/*
+		 * The POLLIN wake_up is called with interrupts disabled.
+		 * Therefore we need to defer the IRQ injection until later
+		 * since we need to acquire the kvm->lock to do so.
+		 */
+		schedule_work(&irqfd->inject);
+
+	if (flags & POLLHUP) {
+		/*
+		 * The POLLHUP is called unlocked, so it theoretically should
+		 * be safe to remove ourselves from the wqh using the locked
+		 * variant of remove_wait_queue()
+		 */
+		remove_wait_queue(irqfd->wqh, &irqfd->wait);
+		flush_work(&irqfd->inject);
+		irqfd_disconnect(irqfd);
+
+		cleanup_srcu_struct(&irqfd->srcu);
+		kfree(irqfd);
+	}
 
 	return 0;
 }
@@ -84,8 +137,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 	add_wait_queue(wqh, &irqfd->wait);
 }
 
-static int
-kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
+int
+kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
@@ -95,10 +148,12 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
 	if (!irqfd)
 		return -ENOMEM;
 
+	mutex_init(&irqfd->lock);
+	init_srcu_struct(&irqfd->srcu);
 	irqfd->kvm = kvm;
 	irqfd->gsi = gsi;
 	INIT_LIST_HEAD(&irqfd->list);
-	INIT_WORK(&irqfd->work, irqfd_inject);
+	INIT_WORK(&irqfd->inject, irqfd_inject);
 
 	/*
 	 * Embed the file* lifetime in the irqfd.
@@ -120,12 +175,18 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
 	if (ret < 0)
 		goto fail;
 
-	irqfd->file = file;
+	kvm_get_kvm(kvm);
 
 	mutex_lock(&kvm->lock);
 	list_add_tail(&irqfd->list, &kvm->irqfds);
 	mutex_unlock(&kvm->lock);
 
+	/*
+	 * do not drop the file until the irqfd is fully initialized, otherwise
+	 * we might race against the POLLHUP
+	 */
+	fput(file);
+
 	return 0;
 
 fail:
@@ -139,97 +200,17 @@ fail:
 	return ret;
 }
 
-static void
-irqfd_release(struct _irqfd *irqfd)
-{
-	/*
-	 * The ordering is important.  We must remove ourselves from the wqh
-	 * first to ensure no more event callbacks are issued, and then flush
-	 * any previously scheduled work prior to freeing the memory
-	 */
-	remove_wait_queue(irqfd->wqh, &irqfd->wait);
-
-	flush_work(&irqfd->work);
-
-	fput(irqfd->file);
-	kfree(irqfd);
-}
-
-static struct _irqfd *
-irqfd_remove(struct kvm *kvm, struct file *file, int gsi)
-{
-	struct _irqfd *irqfd;
-
-	mutex_lock(&kvm->lock);
-
-	/*
-	 * linear search isn't brilliant, but this should be an infrequent
-	 * slow-path operation, and the list should not grow very large
-	 */
-	list_for_each_entry(irqfd, &kvm->irqfds, list) {
-		if (irqfd->file != file || irqfd->gsi != gsi)
-			continue;
-
-		list_del(&irqfd->list);
-		mutex_unlock(&kvm->lock);
-
-		return irqfd;
-	}
-
-	mutex_unlock(&kvm->lock);
-
-	return NULL;
-}
-
-static int
-kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
-{
-	struct _irqfd *irqfd;
-	struct file *file;
-	int count = 0;
-
-	file = fget(fd);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
-	while ((irqfd = irqfd_remove(kvm, file, gsi))) {
-		/*
-		 * We remove the item from the list under the lock, but we
-		 * free it outside the lock to avoid deadlocking with the
-		 * flush_work and the work_item taking the lock
-		 */
-		irqfd_release(irqfd);
-		count++;
-	}
-
-	fput(file);
-
-	return count ? count : -ENOENT;
-}
-
 void
 kvm_irqfd_init(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->irqfds);
 }
 
-int
-kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
-{
-	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
-		return kvm_deassign_irqfd(kvm, fd, gsi);
-
-	return kvm_assign_irqfd(kvm, fd, gsi);
-}
-
 void
 kvm_irqfd_release(struct kvm *kvm)
 {
 	struct _irqfd *irqfd, *tmp;
 
-	/* don't bother with the lock..we are shutting down */
-	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
-		list_del(&irqfd->list);
-		irqfd_release(irqfd);
-	}
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
+		irqfd_disconnect(irqfd);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 902fed9..a9f62bb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1029,7 +1029,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
-	kvm_irqfd_release(kvm);
 	kvm_free_irq_routing(kvm);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
@@ -1064,6 +1063,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
+	kvm_irqfd_release(kvm);
+
 	kvm_put_kvm(kvm);
 	return 0;
 }

