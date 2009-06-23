Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbZFWQxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbZFWQxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZFWQxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:53:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38392 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbZFWQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:53:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 09:47:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
       kvm@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: [patch] eventfd - revised interface and cleanups
Message-ID: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch changes the eventfd interface to de-couple the eventfd 
memory context, from the file pointer instance.
Without such change, there is no clean way to racely free handle the 
POLLHUP event sent when the last instance of the file* goes away.
Also, now the internal eventfd APIs are using the eventfd context instead 
of the file*.
Another cleanup this patch does, is making AIO select EVENTFD, instead of 
adding a bunch of empty function stubs inside eventfd.h.

Andrew, this better go via Avi and the KVM tree, since they have patches 
that will be based on the new interface.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 drivers/lguest/lg.h          |    2 
 drivers/lguest/lguest_user.c |    4 -
 fs/aio.c                     |   24 ++--------
 fs/eventfd.c                 |  101 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/aio.h          |    4 -
 include/linux/eventfd.h      |   17 ++-----
 init/Kconfig                 |    1 
 7 files changed, 108 insertions(+), 45 deletions(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-06-23 09:34:42.000000000 -0700
@@ -17,32 +17,38 @@
 #include <linux/eventfd.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
+#include <linux/kref.h>
 
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
+ * eventfd_signal - Adds @n to the eventfd counter. This function is
+ *                  supposed to be called by the kernel in paths that do not
+ *                  allow sleeping. In this function we allow the counter
+ *                  to reach the ULLONG_MAX value, and we signal this as
+ *                  overflow condition by returining a POLLERR to poll(2).
+ *
+ * @ctx: [in] Pointer to the eventfd context.
+ * @n: [in] Value of the counter to be added to the eventfd internal counter.
+ *
+ * Returns: In case of success, it returns @n, otherwise (in case of overflow
+ *          of the eventfd 64bit internal counter) a value lower than @n.
  */
-int eventfd_signal(struct file *file, int n)
+int eventfd_signal(struct eventfd_ctx *ctx, int n)
 {
-	struct eventfd_ctx *ctx = file->private_data;
 	unsigned long flags;
 
 	if (n < 0)
@@ -59,9 +65,49 @@ int eventfd_signal(struct file *file, in
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
+ *
+ * @ctx: [in] Pointer to the eventfd context.
+ *
+ * Returns: In case of success, returns a pointer to the eventfd context,
+ *          otherwise a proper error code.
+ */
+struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
+{
+	kref_get(&ctx->kref);
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_get);
+
+/**
+ * eventfd_ctx_put - Releases a reference to the internal eventfd context
+ *                   (previously acquired either with eventfd_ctx_get() or
+ *                   eventfd_ctx_fdget()).
+ *
+ * @ctx: [in] Pointer to eventfd context.
+ *
+ * Returns: Nothing.
+ */
+void eventfd_ctx_put(struct eventfd_ctx *ctx)
+{
+	kref_put(&ctx->kref, eventfd_free);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_put);
+
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	wake_up_poll(&ctx->wqh, POLLHUP);
+	eventfd_ctx_put(ctx);
 	return 0;
 }
 
@@ -185,6 +231,14 @@ static const struct file_operations even
 	.write		= eventfd_write,
 };
 
+/**
+ * eventfd_fget - Acquire a reference of an eventfd file descriptor.
+ *
+ * @fd: [in] Eventfd file descriptor.
+ *
+ * Returns: A pointer to the eventfd file structure in case of success, or a
+ *          proper error pointer in case of failure.
+ */
 struct file *eventfd_fget(int fd)
 {
 	struct file *file;
@@ -201,6 +255,30 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+/**
+ * eventfd_ctx_fdget - Acquires a reference to the internal eventfd context
+ *                     given an eventfd file descriptor.
+ *
+ * @fd: [in] Eventfd file descriptor.
+ *
+ * Returns: In case of success, it returns a pointer to the internal eventfd
+ *          context, otherwise a proper error code.
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
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -217,6 +295,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-06-23 08:54:43.000000000 -0700
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
@@ -28,15 +26,10 @@
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
 struct file *eventfd_fget(int fd);
-int eventfd_signal(struct file *file, int n);
-
-#else /* CONFIG_EVENTFD */
-
-#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
-static inline int eventfd_signal(struct file *file, int n)
-{ return 0; }
-
-#endif /* CONFIG_EVENTFD */
+struct eventfd_ctx *eventfd_ctx_fdget(int fd);
+struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx);
+void eventfd_ctx_put(struct eventfd_ctx *ctx);
+int eventfd_signal(struct eventfd_ctx *ctx, int n);
 
 #endif /* _LINUX_EVENTFD_H */
 
Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/fs/aio.c	2009-06-22 10:54:13.000000000 -0700
@@ -485,6 +485,8 @@ static inline void really_put_req(struct
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (req->ki_eventfd != NULL)
+		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -509,8 +511,6 @@ static void aio_fput_routine(struct work
 		/* Complete the fput(s) */
 		if (req->ki_filp != NULL)
 			__fput(req->ki_filp);
-		if (req->ki_eventfd != NULL)
-			__fput(req->ki_eventfd);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
@@ -528,8 +528,6 @@ static void aio_fput_routine(struct work
  */
 static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	int schedule_putreq = 0;
-
 	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
 		req, atomic_long_read(&req->ki_filp->f_count));
 
@@ -549,24 +547,16 @@ static int __aio_put_req(struct kioctx *
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
 
@@ -1622,7 +1612,7 @@ static int io_submit_one(struct kioctx *
 		 * an eventfd() fd, and will be signaled for each completed
 		 * event using the eventfd_signal() function.
 		 */
-		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
+		req->ki_eventfd = eventfd_ctx_fdget((int) iocb->aio_resfd);
 		if (IS_ERR(req->ki_eventfd)) {
 			ret = PTR_ERR(req->ki_eventfd);
 			req->ki_eventfd = NULL;
Index: linux-2.6.mod/include/linux/aio.h
===================================================================
--- linux-2.6.mod.orig/include/linux/aio.h	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/include/linux/aio.h	2009-06-23 09:19:11.000000000 -0700
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
Index: linux-2.6.mod/init/Kconfig
===================================================================
--- linux-2.6.mod.orig/init/Kconfig	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/init/Kconfig	2009-06-22 10:54:13.000000000 -0700
@@ -925,6 +925,7 @@ config SHMEM
 
 config AIO
 	bool "Enable AIO support" if EMBEDDED
+	select EVENTFD
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
Index: linux-2.6.mod/drivers/lguest/lg.h
===================================================================
--- linux-2.6.mod.orig/drivers/lguest/lg.h	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/drivers/lguest/lg.h	2009-06-23 08:55:34.000000000 -0700
@@ -82,7 +82,7 @@ struct lg_cpu {
 
 struct lg_eventfd {
 	unsigned long addr;
-	struct file *event;
+	struct eventfd_ctx *event;
 };
 
 struct lg_eventfd_map {
Index: linux-2.6.mod/drivers/lguest/lguest_user.c
===================================================================
--- linux-2.6.mod.orig/drivers/lguest/lguest_user.c	2009-06-21 16:54:15.000000000 -0700
+++ linux-2.6.mod/drivers/lguest/lguest_user.c	2009-06-22 10:54:13.000000000 -0700
@@ -50,7 +50,7 @@ static int add_eventfd(struct lguest *lg
 
 	/* Now append new entry. */
 	new->map[new->num].addr = addr;
-	new->map[new->num].event = eventfd_fget(fd);
+	new->map[new->num].event = eventfd_ctx_fdget(fd);
 	if (IS_ERR(new->map[new->num].event)) {
 		kfree(new);
 		return PTR_ERR(new->map[new->num].event);
@@ -357,7 +357,7 @@ static int close(struct inode *inode, st
 
 	/* Release any eventfds they registered. */
 	for (i = 0; i < lg->eventfds->num; i++)
-		fput(lg->eventfds->map[i].event);
+		eventfd_ctx_put(lg->eventfds->map[i].event);
 	kfree(lg->eventfds);
 
 	/* If lg->dead doesn't contain an error code it will be NULL or a
