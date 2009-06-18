Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZFRRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZFRRp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZFRRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:44:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60067 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbZFRRo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:44:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 3/4] eventfd: add generalized notifier interface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, mingo@elte.hu,
       mst@redhat.com, avi@redhat.com, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au
Date: Thu, 18 Jun 2009 13:44:26 -0400
Message-ID: <20090618174426.24119.69689.stgit@dev.haskins.net>
In-Reply-To: <20090618173534.24119.95115.stgit@dev.haskins.net>
References: <20090618173534.24119.95115.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently open-code notification registration via the f_ops->poll()
method of the eventfd.  Lets abstract this into a notification API
extension of eventfd, while still using the wait-queue as the underlying
mechanism.  This will allow us to manage the notification mechanism
internal to eventfd without requiring the clients to change.  This also
gives us the opportunity to implement race-free release() callbacks,
which we do later in the series.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c            |   69 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/eventfd.h |   34 +++++++++++++++++++++
 virt/kvm/eventfd.c      |   75 ++++++++++++++++++-----------------------------
 3 files changed, 132 insertions(+), 46 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 72f5f8d..f9d7e1d 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -245,3 +245,72 @@ SYSCALL_DEFINE1(eventfd, unsigned int, count)
 	return sys_eventfd2(count, 0);
 }
 
+static int eventfd_notifier_wakeup(wait_queue_t *wait, unsigned mode,
+				   int sync, void *key)
+{
+	struct eventfd_notifier *en;
+	unsigned long flags = (unsigned long)key;
+
+	en = container_of(wait, struct eventfd_notifier, wait);
+
+	if (flags & POLLIN)
+		/*
+		 * The POLLIN wake_up is called with interrupts disabled.
+		 */
+		en->ops->signal(en);
+
+	if (flags & POLLHUP) {
+		/*
+		 * The POLLHUP is called unlocked, so it theoretically should
+		 * be safe to remove ourselves from the wqh using the locked
+		 * variant of remove_wait_queue()
+		 */
+		remove_wait_queue(en->wqh, &en->wait);
+		en->ops->release(en);
+	}
+
+	return 0;
+}
+
+static void eventfd_notifier_ptable_enqueue(struct file *file,
+					    wait_queue_head_t *wqh,
+					    poll_table *pt)
+{
+	struct eventfd_notifier *en;
+
+	en = container_of(pt, struct eventfd_notifier, pt);
+
+	en->wqh = wqh;
+	add_wait_queue(wqh, &en->wait);
+}
+
+int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en)
+{
+	unsigned int events;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd
+	 */
+	init_waitqueue_func_entry(&en->wait, eventfd_notifier_wakeup);
+	init_poll_funcptr(&en->pt, eventfd_notifier_ptable_enqueue);
+
+	events = file->f_op->poll(file, &en->pt);
+
+	return (events & POLLIN) ? 1 : 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_register);
+
+int eventfd_notifier_unregister(struct file *file, struct eventfd_notifier *en)
+{
+	if (!en->wqh)
+		return -EINVAL;
+
+	remove_wait_queue(en->wqh, &en->wait);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_unregister);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index f45a8ae..802b59d 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,6 +8,32 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/file.h>
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
+	poll_table                         pt;
+	wait_queue_head_t                 *wqh;
+	wait_queue_t                       wait;
+	const struct eventfd_notifier_ops *ops;
+};
+
+static inline void eventfd_notifier_init(struct eventfd_notifier *en,
+					 const struct eventfd_notifier_ops *ops)
+{
+	memset(en, 0, sizeof(*en));
+	en->ops = ops;
+}
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -29,12 +55,20 @@
 
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
index a9e7de7..7afa483 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -43,9 +43,7 @@ struct _irqfd {
 	struct kvm               *kvm;
 	int                       gsi;
 	struct list_head          list;
-	poll_table                pt;
-	wait_queue_head_t        *wqh;
-	wait_queue_t              wait;
+	struct eventfd_notifier   notifier;
 	struct work_struct        inject;
 };
 
@@ -97,54 +95,43 @@ irqfd_disconnect(struct _irqfd *irqfd)
 	kvm_put_kvm(kvm);
 }
 
-static int
-irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
+static void
+irqfd_eventfd_signal(struct eventfd_notifier *notifier)
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
+	struct _irqfd *irqfd = container_of(notifier, struct _irqfd, notifier);
 
-	if (flags & POLLHUP) {
-		/*
-		 * The POLLHUP is called unlocked, so it theoretically should
-		 * be safe to remove ourselves from the wqh using the locked
-		 * variant of remove_wait_queue()
-		 */
-		remove_wait_queue(irqfd->wqh, &irqfd->wait);
-		flush_work(&irqfd->inject);
-		irqfd_disconnect(irqfd);
-
-		cleanup_srcu_struct(&irqfd->srcu);
-		kfree(irqfd);
-	}
-
-	return 0;
+	/*
+	 * The ->signal() is called with interrupts disabled.
+	 * Therefore we need to defer the IRQ injection until later
+	 * since we need to acquire the kvm->lock to do so.
+	 */
+	schedule_work(&irqfd->inject);
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
 
+const static struct eventfd_notifier_ops irqfd_eventfd_ops = {
+	.signal = irqfd_eventfd_signal,
+	.release = irqfd_eventfd_release,
+};
+
+
 int
 kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	struct _irqfd *irqfd;
 	struct file *file = NULL;
 	int ret;
-	unsigned int events;
 
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
 	if (!irqfd)
@@ -163,14 +150,10 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 		goto fail;
 	}
 
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
-
-	events = file->f_op->poll(file, &irqfd->pt);
+	eventfd_notifier_init(&irqfd->notifier, &irqfd_eventfd_ops);
+	ret = eventfd_notifier_register(file, &irqfd->notifier);
+	if (ret < 0)
+		goto fail;
 
 	kvm_get_kvm(kvm);
 
@@ -181,12 +164,12 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 	/*
 	 * Check if there was an event already queued
 	 */
-	if (events & POLLIN)
+	if (ret > 0)
 		schedule_work(&irqfd->inject);
 
 	/*
 	 * do not drop the file until the irqfd is fully initialized, otherwise
-	 * we might race against the POLLHUP
+	 * we might race against the notifier->release()
 	 */
 	fput(file);
 

