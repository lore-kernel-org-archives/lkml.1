Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZFYN3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZFYN3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZFYN2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:28:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49715 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZFYN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:28:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v5 2/4] eventfd - revised interface and cleanups (4th rev)
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Date: Thu, 25 Jun 2009 09:28:21 -0400
Message-ID: <20090625132821.26748.24298.stgit@dev.haskins.net>
In-Reply-To: <20090625132441.26748.641.stgit@dev.haskins.net>
References: <20090625132441.26748.641.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>

The following patch changes the eventfd interface to de-couple the eventfd
memory context, from the file pointer instance.
Without such change, there is no clean way to racely free handle the
POLLHUP event sent when the last instance of the file* goes away.
Also, now the internal eventfd APIs are using the eventfd context instead
of the file*.

Gregory, none of the APIs changed, so your patches do not need to be
rebased over this one. The last three revisions just updated comments.

Andrew, I'm not posting the "AIO select EVENTFD" patch at this time. Will
eventually try another push in your skull once I come back from vacation ;)

[gmh: resolved merge conflict against prior POLLHUP patch ]

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/lguest/lg.h          |    2 -
 drivers/lguest/lguest_user.c |    4 +
 fs/aio.c                     |   24 ++------
 fs/eventfd.c                 |  126 ++++++++++++++++++++++++++++++++++++------
 include/linux/aio.h          |    4 +
 include/linux/eventfd.h      |   35 +++++++++---
 6 files changed, 147 insertions(+), 48 deletions(-)

diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index d4e8979..9c31382 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -82,7 +82,7 @@ struct lg_cpu {
 
 struct lg_eventfd {
 	unsigned long addr;
-	struct file *event;
+	struct eventfd_ctx *event;
 };
 
 struct lg_eventfd_map {
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 32e2971..9f9a295 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -50,7 +50,7 @@ static int add_eventfd(struct lguest *lg, unsigned long addr, int fd)
 
 	/* Now append new entry. */
 	new->map[new->num].addr = addr;
-	new->map[new->num].event = eventfd_fget(fd);
+	new->map[new->num].event = eventfd_ctx_fdget(fd);
 	if (IS_ERR(new->map[new->num].event)) {
 		kfree(new);
 		return PTR_ERR(new->map[new->num].event);
@@ -357,7 +357,7 @@ static int close(struct inode *inode, struct file *file)
 
 	/* Release any eventfds they registered. */
 	for (i = 0; i < lg->eventfds->num; i++)
-		fput(lg->eventfds->map[i].event);
+		eventfd_ctx_put(lg->eventfds->map[i].event);
 	kfree(lg->eventfds);
 
 	/* If lg->dead doesn't contain an error code it will be NULL or a
diff --git a/fs/aio.c b/fs/aio.c
index 76da125..d065b2c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -485,6 +485,8 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (req->ki_eventfd != NULL)
+		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -509,8 +511,6 @@ static void aio_fput_routine(struct work_struct *data)
 		/* Complete the fput(s) */
 		if (req->ki_filp != NULL)
 			__fput(req->ki_filp);
-		if (req->ki_eventfd != NULL)
-			__fput(req->ki_eventfd);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
@@ -528,8 +528,6 @@ static void aio_fput_routine(struct work_struct *data)
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	int schedule_putreq = 0;
-
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
@@ -549,24 +547,16 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 	 * we would not be holding the last reference to the file*, so
 	 * this function will be executed w/out any aio kthread wakeup.
 	 */
-	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count)))
-		schedule_putreq++;
-	else
-		req->ki_filp = NULL;
-	if (req->ki_eventfd != NULL) {
-		if (unlikely(atomic_long_dec_and_test(&req->ki_eventfd->f_count)))
-			schedule_putreq++;
-		else
-			req->ki_eventfd = NULL;
-	}
-	if (unlikely(schedule_putreq)) {
+	if (unlikely(atomic_long_dec_and_test(&req->ki_filp->f_count))) {
 		get_ioctx(ctx);
 		spin_lock(&fput_lock);
 		list_add(&req->ki_list, &fput_head);
 		spin_unlock(&fput_lock);
 		queue_work(aio_wq, &fput_work);
-	} else
+	} else {
+		req->ki_filp = NULL;
 		really_put_req(ctx, req);
+	}
 	return 1;
 }
 
@@ -1622,7 +1612,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		 * an eventfd() fd, and will be signaled for each completed
 		 * event using the eventfd_signal() function.
 		 */
-		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
+		req->ki_eventfd = eventfd_ctx_fdget((int) iocb->aio_resfd);
 		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
 			req->ki_eventfd = NULL;
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 72f5f8d..31d12de 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -14,35 +14,44 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/anon_inodes.h>
-#include <linux/eventfd.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
+#include <linux/kref.h>
+#include <linux/eventfd.h>
 
 struct eventfd_ctx {
+	struct kref kref;
 	wait_queue_head_t wqh;
 	/*
 	 * Every time that a write(2) is performed on an eventfd, the
 	 * value of the __u64 being written is added to "count" and a
 	 * wakeup is performed on "wqh". A read(2) will return the "count"
 	 * value to userspace, and will reset "count" to zero. The kernel
-	 * size eventfd_signal() also, adds to the "count" counter and
+	 * side eventfd_signal() also, adds to the "count" counter and
 	 * issue a wakeup.
 	 */
 	__u64 count;
 	unsigned int flags;
 };
 
-/*
- * Adds "n" to the eventfd counter "count". Returns "n" in case of
- * success, or a value lower then "n" in case of coutner overflow.
- * This function is supposed to be called by the kernel in paths
- * that do not allow sleeping. In this function we allow the counter
- * to reach the ULLONG_MAX value, and we signal this as overflow
- * condition by returining a POLLERR to poll(2).
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *          The value cannot be negative.
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returining a POLLERR
+ * to poll(2).
+ *
+ * Returns @n in case of success, a non-negative number lower than @n in case
+ * of overflow, or the following error codes:
+ *
+ * -EINVAL    : The value of @n is negative.
  */
-int eventfd_signal(struct file *file, int n)
+int eventfd_signal(struct eventfd_ctx *ctx, int n)
 {
-	struct eventfd_ctx *ctx = file->private_data;
 	unsigned long flags;
 
 	if (n < 0)
@@ -59,17 +68,45 @@ int eventfd_signal(struct file *file, int n)
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+static void eventfd_free(struct kref *kref)
+{
+	struct eventfd_ctx *ctx = container_of(kref, struct eventfd_ctx, kref);
+
+	kfree(ctx);
+}
+
+/**
+ * eventfd_ctx_get - Acquires a reference to the internal eventfd context.
+ * @ctx: [in] Pointer to the eventfd context.
+ *
+ * Returns: In case of success, returns a pointer to the eventfd context.
+ */
+struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
+{
+	kref_get(&ctx->kref);
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_get);
+
+/**
+ * eventfd_ctx_put - Releases a reference to the internal eventfd context.
+ * @ctx: [in] Pointer to eventfd context.
+ *
+ * The eventfd context reference must have been previously acquired either
+ * with eventfd_ctx_get() or eventfd_ctx_fdget()).
+ */
+void eventfd_ctx_put(struct eventfd_ctx *ctx)
+{
+	kref_put(&ctx->kref, eventfd_free);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_put);
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
+	eventfd_ctx_put(ctx);
 	return 0;
 }
 
@@ -193,6 +230,16 @@ static const struct file_operations eventfd_fops = {
 	.write		= eventfd_write,
 };
 
+/**
+ * eventfd_fget - Acquire a reference of an eventfd file descriptor.
+ * @fd: [in] Eventfd file descriptor.
+ *
+ * Returns a pointer to the eventfd file structure in case of success, or the
+ * following error pointer:
+ *
+ * -EBADF    : Invalid @fd file descriptor.
+ * -EINVAL   : The @fd file descriptor is not an eventfd file.
+ */
 struct file *eventfd_fget(int fd)
 {
 	struct file *file;
@@ -209,6 +256,48 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+/**
+ * eventfd_ctx_fdget - Acquires a reference to the internal eventfd context.
+ * @fd: [in] Eventfd file descriptor.
+ *
+ * Returns a pointer to the internal eventfd context, otherwise the error
+ * pointers returned by the following functions:
+ *
+ * eventfd_fget
+ */
+struct eventfd_ctx *eventfd_ctx_fdget(int fd)
+{
+	struct file *file;
+	struct eventfd_ctx *ctx;
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(file))
+		return (struct eventfd_ctx *) file;
+	ctx = eventfd_ctx_get(file->private_data);
+	fput(file);
+
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_fdget);
+
+/**
+ * eventfd_ctx_fileget - Acquires a reference to the internal eventfd context.
+ * @file: [in] Eventfd file pointer.
+ *
+ * Returns a pointer to the internal eventfd context, otherwise the error
+ * pointer:
+ *
+ * -EINVAL   : The @fd file descriptor is not an eventfd file.
+ */
+struct eventfd_ctx *eventfd_ctx_fileget(struct file *file)
+{
+	if (file->f_op != &eventfd_fops)
+		return ERR_PTR(-EINVAL);
+
+	return eventfd_ctx_get(file->private_data);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_fileget);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -225,6 +314,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b16a957..47f7d93 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -121,9 +121,9 @@ struct kiocb {
 
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
-	 * this is the underlying file* to deliver event to.
+	 * this is the underlying eventfd context to deliver events to.
 	 */
-	struct file		*ki_eventfd;
+	struct eventfd_ctx	*ki_eventfd;
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index f45a8ae..3b85ba6 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,10 +8,8 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
-#ifdef CONFIG_EVENTFD
-
-/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
+#include <linux/file.h>
 
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
@@ -27,16 +25,37 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
+#ifdef CONFIG_EVENTFD
+
+struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx);
+void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
-int eventfd_signal(struct file *file, int n);
+struct eventfd_ctx *eventfd_ctx_fdget(int fd);
+struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
+int eventfd_signal(struct eventfd_ctx *ctx, int n);
 
 #else /* CONFIG_EVENTFD */
 
-#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
-static inline int eventfd_signal(struct file *file, int n)
-{ return 0; }
+/*
+ * Ugly ugly ugly error layer to support modules that uses eventfd but
+ * pretend to work in !CONFIG_EVENTFD configurations. Namely, AIO.
+ */
+static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
+{
+	return -ENOSYS;
+}
+
+static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
+{
+
+}
 
-#endif /* CONFIG_EVENTFD */
+#endif
 
 #endif /* _LINUX_EVENTFD_H */
 

