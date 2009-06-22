Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZFVQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZFVQGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbZFVQF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:05:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57094 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbZFVQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:05:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 2/3] eventfd: add internal reference counting to fix
	notifier race conditions
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org, mingo@elte.hu,
       rusty@rustcorp.com.au
Date: Mon, 22 Jun 2009 12:05:51 -0400
Message-ID: <20090622160551.22967.32376.stgit@dev.haskins.net>
In-Reply-To: <20090622155504.22967.50532.stgit@dev.haskins.net>
References: <20090622155504.22967.50532.stgit@dev.haskins.net>
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
as it stands today it is not possible to use this feature of eventfd in a
race-free way.  This patch adds some additional logic to eventfd in order
to rectify this problem.

Background:
-----------------------
Eventfd currently only has one reference count mechanism: fget/fput.  This
in of itself is normally fine.  However, if a client expects to be
notified if the eventfd is closed, it cannot hold a fget() reference
itself or the underlying f_ops->release() callback will never be invoked
by VFS.  Therefore we have this somewhat unusual situation where we may
hold a pointer to an eventfd object (by virtue of having a waiter registered
in its wait-queue), but no reference.  To make matters more complicated,
the release callback is issued in an unlocked state.  This makes it nearly
impossible to design a mutual decoupling algorithm: you cannot unhook one
side from the other (or vice versa) without racing.

-----------------------

In summary, there are two fundamental problems:

1) The POLLHUP wakeup is broadcast lockless
2) There are no references to the wait-queue-head (embedded in eventfd_ctx)

We fix this by using the locked variant of wakeup for POLLHUP, and by
adding/exposing a kref to the underlying eventfd_ctx.  Clients should then
be able to govern their usage of the wait-queue as they do for any other
wait-queue in the kernel.

We propose this more raw solution rather than trying to encapsulate the
poll-callback because there are advantages to decoupling the
remove_wait_queue from the kref_put().  Namely, its nice to unhook the
wait-queue inside the wakeup, but to defer the kref_put() until we can
synchronize with the client.

Between these points, we believe we now have a race-free release
mechanism.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c            |   43 ++++++++++++++++++++++++++++++++++++-------
 include/linux/eventfd.h |    7 +++++++
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 72f5f8d..4806116 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -17,8 +17,10 @@
 #include <linux/eventfd.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
+#include <linux/kref.h>
 
 struct eventfd_ctx {
+	struct kref kref;
 	wait_queue_head_t wqh;
 	/*
 	 * Every time that a write(2) is performed on an eventfd, the
@@ -59,17 +61,24 @@ int eventfd_signal(struct file *file, int n)
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
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
 
@@ -209,6 +218,26 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+struct kref *eventfd_kref_get(struct file *file)
+{
+	struct eventfd_ctx *ctx;
+
+	if (file->f_op != &eventfd_fops)
+		return ERR_PTR(-EINVAL);
+
+	ctx = file->private_data;
+	kref_get(&ctx->kref);
+
+	return &ctx->kref;
+}
+EXPORT_SYMBOL_GPL(eventfd_kref_get);
+
+void eventfd_kref_put(struct kref *kref)
+{
+	_eventfd_put(kref);
+}
+EXPORT_SYMBOL_GPL(eventfd_kref_put);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index f45a8ae..c0396b3 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+#include <linux/kref.h>
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -28,11 +30,16 @@
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
 struct file *eventfd_fget(int fd);
+struct kref *eventfd_kref_get(struct file *file);
+void eventfd_kref_put(struct kref *kref);
 int eventfd_signal(struct file *file, int n);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
+#define eventfd_kref_get(file) ERR_PTR(-ENOSYS);
+static inline void eventfd_kref_put(struct kref *kref)
+{ }
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
 

