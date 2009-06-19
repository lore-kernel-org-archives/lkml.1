Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZFSSwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZFSSwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZFSSvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:51:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35049 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZFSSvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:51:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
	race conditions
To: davidel@xmailserver.org
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Date: Fri, 19 Jun 2009 14:51:38 -0400
Message-ID: <20090619185138.31118.14916.stgit@dev.haskins.net>
In-Reply-To: <20090619183534.31118.30934.stgit@dev.haskins.net>
References: <20090619183534.31118.30934.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventfd currently emits a POLLHUP wakeup on f_ops->release() to generate a
notifier->release() callback.  This lets notification clients know if
the eventfd is about to go away and is very useful particularly for
in-kernel clients.  However, as it stands today it is not possible to
use the notification API in a race-free way.  This patch adds some
additional logic to the notification subsystem to rectify this problem.

Background:
-----------------------
Eventfd currently only has one reference count mechanism: fget/fput.  This
in of itself is normally fine.  However, if a client expects to be
notified if the eventfd is closed, it cannot hold a fget() reference
itself or the underlying f_ops->release() callback will never be invoked
by VFS.  Therefore we have this somewhat unusual situation where we may
hold a pointer to an eventfd object (by virtue of having a waiter registered
in its wait-queue), but no reference.  This makes it nearly impossible to
design a mutual decoupling algorithm: you cannot unhook one side from the
other (or vice versa) without racing.

The first problem was dealt with by essentially "donating" a surrogate
object to eventfd.  In other words, when a client attached to eventfd
and then later detached, it would decouple internally in a race free way
and then leave part of the object still attached to the eventfd.  This
decoupled object would correctly detect the end-of-life of the eventfd
object at some point in the future and be deallocated: However, we cannot
guarantee that this operation would not race with a potential rmmod of the
client, and is therefore broken.

Solution Details:
-----------------------

1) We add a private kref to the internal eventfd_ctx object.  This
   reference can be (transparently) held by notification clients without
   affecting the ability for VFS to indicate ->release() notification.

2) We convert the current lockless POLLHUP to a more traditional locked
   variant (*) so that we can ensure a race free mutual-decouple
   algorithm without requiring an surrogate object.

3) We guard the decouple algorithm with an atomic bit-clear to ensure
   mutual exclusion of the decoupling and reference-drop.

4) We hold a reference to the underlying eventfd_ctx until all paths
   have satisfactorily completed to ensure we do not race with eventfd
   going away.

Between these points, we believe we now have a race-free release
mechanism.

[*] Clients that previously assumed the ->release() could sleep will
need to be refactored.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
CC: Michael S. Tsirkin <mst@redhat.com>
---

 fs/eventfd.c            |   62 +++++++++++++++++++++++++++++++++--------------
 include/linux/eventfd.h |    3 ++
 2 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 3d7fb16..934efee 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -16,8 +16,10 @@
 #include <linux/anon_inodes.h>
 #include <linux/eventfd.h>
 #include <linux/syscalls.h>
+#include <linux/kref.h>
 
 struct eventfd_ctx {
+	struct kref kref;
 	wait_queue_head_t wqh;
 	/*
 	 * Every time that a write(2) is performed on an eventfd, the
@@ -57,17 +59,24 @@ int eventfd_signal(struct file *file, int n)
 	return n;
 }
 
+static void _eventfd_release(struct kref *kref)
+{
+	struct eventfd_ctx *ctx = container_of(kref, struct eventfd_ctx, kref);
+
+	kfree(ctx);
+}
+
+static void _eventfd_put(struct kref *kref)
+{
+	kref_put(kref, &_eventfd_release);
+}
+
 static int eventfd_release(struct inode *inode, struct file *file)
 {
 	struct eventfd_ctx *ctx = file->private_data;
 
-	/*
-	 * No need to hold the lock here, since we are on the file cleanup
-	 * path and the ones still attached to the wait queue will be
-	 * serialized by wake_up_locked_poll().
-	 */
-	wake_up_locked_poll(&ctx->wqh, POLLHUP);
-	kfree(ctx);
+	wake_up_poll(&ctx->wqh, POLLHUP);
+	_eventfd_put(&ctx->kref);
 	return 0;
 }
 
@@ -222,6 +231,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
@@ -242,6 +252,15 @@ SYSCALL_DEFINE1(eventfd, unsigned int, count)
 	return sys_eventfd2(count, 0);
 }
 
+enum {
+	eventfd_notifier_flag_active,
+};
+
+static int test_and_clear_active(struct eventfd_notifier *en)
+{
+	return test_and_clear_bit(eventfd_notifier_flag_active, &en->flags);
+}
+
 static int eventfd_notifier_wakeup(wait_queue_t *wait, unsigned mode,
 				   int sync, void *key)
 {
@@ -251,19 +270,15 @@ static int eventfd_notifier_wakeup(wait_queue_t *wait, unsigned mode,
 	en = container_of(wait, struct eventfd_notifier, wait);
 
 	if (flags & POLLIN)
-		/*
-		 * The POLLIN wake_up is called with interrupts disabled.
-		 */
 		en->ops->signal(en);
 
 	if (flags & POLLHUP) {
-		/*
-		 * The POLLHUP is called unlocked, so it theoretically should
-		 * be safe to remove ourselves from the wqh using the locked
-		 * variant of remove_wait_queue()
-		 */
-		remove_wait_queue(en->wqh, &en->wait);
-		en->ops->release(en);
+
+		if (test_and_clear_active(en)) {
+			__remove_wait_queue(en->wqh, &en->wait);
+			_eventfd_put(en->eventfd);
+			en->ops->release(en);
+		}
 	}
 
 	return 0;
@@ -283,11 +298,14 @@ static void eventfd_notifier_ptable_enqueue(struct file *file,
 
 int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en)
 {
+	struct eventfd_ctx *ctx;
 	unsigned int events;
 
 	if (file->f_op != &eventfd_fops)
 		return -EINVAL;
 
+	ctx = file->private_data;
+
 	/*
 	 * Install our own custom wake-up handling so we are notified via
 	 * a callback whenever someone signals the underlying eventfd
@@ -297,12 +315,20 @@ int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en)
 
 	events = file->f_op->poll(file, &en->pt);
 
+	kref_get(&ctx->kref);
+	en->eventfd = &ctx->kref;
+
+	set_bit(eventfd_notifier_flag_active, &en->flags);
+
 	return (events & POLLIN) ? 1 : 0;
 }
 EXPORT_SYMBOL_GPL(eventfd_notifier_register);
 
 void eventfd_notifier_unregister(struct eventfd_notifier *en)
 {
-	remove_wait_queue(en->wqh, &en->wait);
+	if (test_and_clear_active(en)) {
+		remove_wait_queue(en->wqh, &en->wait);
+		_eventfd_put(en->eventfd);
+	}
 }
 EXPORT_SYMBOL_GPL(eventfd_notifier_unregister);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index cb23969..2b6e239 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -12,6 +12,7 @@
 #include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/list.h>
+#include <linux/kref.h>
 
 struct eventfd_notifier;
 
@@ -24,6 +25,8 @@ struct eventfd_notifier {
 	poll_table                         pt;
 	wait_queue_head_t                 *wqh;
 	wait_queue_t                       wait;
+	struct kref                       *eventfd;
+	unsigned long                      flags;
 	const struct eventfd_notifier_ops *ops;
 };
 

