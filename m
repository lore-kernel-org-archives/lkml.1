Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZFVAAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZFVAAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZFVAAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:00:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:32869 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbZFVAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:00:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 21 Jun 2009 16:54:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3E7E63.1070407@novell.com>
Message-ID: <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Gregory Haskins wrote:

> This looks great, Davide.  I am fairly certain I can now solve the races
> and even implement Michael's DEASSIGN feature with this patch in place. 
> I will actually fire it up tomorrow when I am back in the office and
> give it a spin, but I do not spy any more races via visual inspection.
> 
> Kind Regards,
> -Greg
> 
> PS: I was wrong with my previous statement about requiring an embeddable
> object (eventfd_notifier for me, eventfd_pollcb for you).  I think you
> can technically solve this issue minimally by merely locking the POLLHUP
> and exposing the kref.  However, I think that leads to an more awkward
> interface (e.g. we already have eventfd_fget() plus we add a new one
> like eventfd_refget(), which might confuse users), so I prefer what you
> did here.  Just thought I would throw that out there in case you would
> prefer to change even fewer lines.

I actually ended up exposing the eventfd context anyway, since IMO is a 
better option instead of holding references to the eventfd file (that 
makes VFS people uneasy).
So eventfd_signal() now accepts the eventfd context instead of the file 
pointer.
Inside KAIO we had it holding a reference to the underlying file*, same 
thing LGUEST (Rusty Cc-ed), that has been changed to fit the new API.
And since eventfd_ctx_put() doesn't sleep, KAIO code got simpler a little.
The other change have been to make KAIO select EVENTFD, instead of making 
the ugly empty stubs inside eventfd.h to accomodate (KAIO && !EVENTFD).
The eventfd_pollcb_register() remained to be accepting a file*, first 
because it needs it ;) , second because it can unracely detect POLLHUP due 
to the caller holding a reference to the file*.




- Davide


---
 drivers/lguest/lg.h          |    4 -
 drivers/lguest/lguest_user.c |    4 -
 fs/aio.c                     |   24 +-----
 fs/eventfd.c                 |  170 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/aio.h          |    5 -
 include/linux/eventfd.h      |   28 ++++---
 init/Kconfig                 |    1 
 7 files changed, 192 insertions(+), 44 deletions(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-06-21 09:52:10.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-06-21 16:51:27.000000000 -0700
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
@@ -59,9 +65,30 @@ int eventfd_signal(struct file *file, in
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+static void eventfd_free(struct kref *kref)
+{
+	struct eventfd_ctx *ctx = container_of(kref, struct eventfd_ctx, kref);
+
+	kfree(ctx);
+}
+
+static struct eventfd_ctx *eventfd_get(struct eventfd_ctx *ctx)
+{
+	kref_get(&ctx->kref);
+	return ctx;
+}
+
+static void eventfd_put(struct eventfd_ctx *ctx)
+{
+	kref_put(&ctx->kref, eventfd_free);
+}
+
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	wake_up_poll(&ctx->wqh, POLLHUP);
+	eventfd_put(ctx);
 	return 0;
 }
 
@@ -185,6 +212,14 @@ static const struct file_operations even
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
@@ -201,6 +236,59 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+/**
+ * eventfd_ctx_get - Acquires a reference to the internal eventfd context.
+ *
+ * @file: [in] Pointer to the eventfd file.
+ *
+ * Returns: In case of success, returns a pointer to the eventfd context,
+ *          otherwise a proper error code.
+ */
+struct eventfd_ctx *eventfd_ctx_get(struct file *file)
+{
+	return file->f_op == &eventfd_fops ? eventfd_get(file->private_data) :
+		ERR_PTR(-EINVAL);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_get);
+
+/**
+ * eventfd_ctx_put - Releases a reference to the internal eventfd context
+ *                   (previously acquired with eventfd_ctx_get()).
+ *
+ * @ctx: [in] Pointer to eventfd context.
+ *
+ * Returns: Nothing.
+ */
+void eventfd_ctx_put(struct eventfd_ctx *ctx)
+{
+	eventfd_put(ctx);
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_put);
+
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
+	ctx = eventfd_ctx_get(file);
+	fput(file);
+
+	return ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_fdget);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -217,6 +305,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
@@ -237,3 +326,62 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
 	return sys_eventfd2(count, 0);
 }
 
+static void eventfd_pollcb_ptqueue(struct file *file, wait_queue_head_t *wqh,
+				   poll_table *pt)
+{
+	struct eventfd_pollcb *ecb;
+
+	ecb = container_of(pt, struct eventfd_pollcb, pt);
+	add_wait_queue(wqh, &ecb->wait);
+}
+
+/**
+ * eventfd_pollcb_register - Registers a wakeup callback with the eventfd
+ *                           file. The wakeup callback will be called from
+ *                           atomic context, and should handle the POLLHUP
+ *                           event accordingly in order to notice the last
+ *                           instance of the eventfd descriptor going away.
+ *
+ * @file: [in] Pointer to the eventfd file.
+ * @ecb: [out] Pointer to the eventfd callback structure.
+ * @cbf: [in] Pointer to the wakeup callback function.
+ * @events: [out] Pointer to the events that were ready at the time of the
+ *                callback registration.
+ *
+ * Returns: Zero in case of success, or a proper error code.
+ */
+int eventfd_pollcb_register(struct file *file, struct eventfd_pollcb *ecb,
+			    wait_queue_func_t cbf, unsigned int *events)
+{
+	struct eventfd_ctx *ctx;
+
+	ctx = file->private_data;
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+
+	init_waitqueue_func_entry(&ecb->wait, cbf);
+	init_poll_funcptr(&ecb->pt, eventfd_pollcb_ptqueue);
+	ecb->ctx = eventfd_get(ctx);
+
+	*events = file->f_op->poll(file, &ecb->pt);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_pollcb_register);
+
+/**
+ * eventfd_pollcb_unregister - Unregisters a wakeup callback previously registered
+ *                             with eventfd_pollcb_register().
+ *
+ * @ecb: [in] Pointer to the eventfd callback structure previously registered with
+ *            eventfd_pollcb_register().
+ *
+ * Returns: Nothing.
+ */
+void eventfd_pollcb_unregister(struct eventfd_pollcb *ecb)
+{
+	remove_wait_queue(&ecb->ctx->wqh, &ecb->wait);
+	eventfd_put(ecb->ctx);
+}
+EXPORT_SYMBOL_GPL(eventfd_pollcb_unregister);
+
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-21 09:52:10.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-06-21 16:49:19.000000000 -0700
@@ -8,10 +8,10 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
-#ifdef CONFIG_EVENTFD
-
-/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/file.h>
 
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
@@ -27,16 +27,22 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
-struct file *eventfd_fget(int fd);
-int eventfd_signal(struct file *file, int n);
-
-#else /* CONFIG_EVENTFD */
+struct eventfd_ctx;
 
-#define eventfd_fget(fd) ERR_PTR(-ENOSYS)
-static inline int eventfd_signal(struct file *file, int n)
-{ return 0; }
+struct eventfd_pollcb {
+	poll_table pt;
+	struct eventfd_ctx *ctx;
+	wait_queue_t wait;
+};
 
-#endif /* CONFIG_EVENTFD */
+struct file *eventfd_fget(int fd);
+struct eventfd_ctx *eventfd_ctx_fdget(int fd);
+struct eventfd_ctx *eventfd_ctx_get(struct file *file);
+void eventfd_ctx_put(struct eventfd_ctx *ctx);
+int eventfd_signal(struct eventfd_ctx *ctx, int n);
+int eventfd_pollcb_register(struct file *file, struct eventfd_pollcb *ecb,
+			    wait_queue_func_t cbf, unsigned int *events);
+void eventfd_pollcb_unregister(struct eventfd_pollcb *ecb);
 
 #endif /* _LINUX_EVENTFD_H */
 
Index: linux-2.6.mod/fs/aio.c
===================================================================
--- linux-2.6.mod.orig/fs/aio.c	2009-06-21 14:36:52.000000000 -0700
+++ linux-2.6.mod/fs/aio.c	2009-06-21 15:25:44.000000000 -0700
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
--- linux-2.6.mod.orig/include/linux/aio.h	2009-06-21 14:36:52.000000000 -0700
+++ linux-2.6.mod/include/linux/aio.h	2009-06-21 15:32:42.000000000 -0700
@@ -12,6 +12,7 @@
 #define AIO_MAXSEGS		4
 #define AIO_KIOGRP_NR_ATOMIC	8
 
+struct eventfd_ctx;
 struct kioctx;
 
 /* Notes on cancelling a kiocb:
@@ -121,9 +122,9 @@ struct kiocb {
 
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
--- linux-2.6.mod.orig/init/Kconfig	2009-06-21 15:42:52.000000000 -0700
+++ linux-2.6.mod/init/Kconfig	2009-06-21 15:43:25.000000000 -0700
@@ -925,6 +925,7 @@ config SHMEM
 
 config AIO
 	bool "Enable AIO support" if EMBEDDED
+	select EVENTFD
 	default y
 	help
 	  This option enables POSIX asynchronous I/O which may by used
Index: linux-2.6.mod/drivers/lguest/lg.h
===================================================================
--- linux-2.6.mod.orig/drivers/lguest/lg.h	2009-06-21 15:55:17.000000000 -0700
+++ linux-2.6.mod/drivers/lguest/lg.h	2009-06-21 15:56:00.000000000 -0700
@@ -80,9 +80,11 @@ struct lg_cpu {
 	struct lg_cpu_arch arch;
 };
 
+struct eventfd_ctx;
+
 struct lg_eventfd {
 	unsigned long addr;
-	struct file *event;
+	struct eventfd_ctx *event;
 };
 
 struct lg_eventfd_map {
Index: linux-2.6.mod/drivers/lguest/lguest_user.c
===================================================================
--- linux-2.6.mod.orig/drivers/lguest/lguest_user.c	2009-06-21 15:55:17.000000000 -0700
+++ linux-2.6.mod/drivers/lguest/lguest_user.c	2009-06-21 15:57:11.000000000 -0700
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
