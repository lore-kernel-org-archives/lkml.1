Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZFUQ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZFUQ5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 12:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZFUQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 12:57:37 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49610 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZFUQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:57:36 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 21 Jun 2009 09:51:24 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3D895C.7020605@novell.com>
Message-ID: <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Sat, 20 Jun 2009, Davide Libenzi wrote:
> >
> >   
> >> On Sat, 20 Jun 2009, Davide Libenzi wrote:
> >>
> >>     
> >>> How about the one below?
> >>>       
> >> Maybe with an interface that can be undone w/out a file* :)
> >>     
> >
> > This is another alternative, based on a low-carb diet of your notifier 
> > patch.
> >   
> Ah, I should always check if I have more mail before responding to a now
> stale patch ;)

Here. I changed the eventfd_pollcb_register() prototype to return the full 
registeration time event mask, instead of the POLLIN explicit check.
Let's give this one some more thought before I push it to Andrew.



- Davide


---
 fs/eventfd.c            |   94 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/eventfd.h |   24 ++++++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-06-20 16:25:45.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-06-21 09:36:46.000000000 -0700
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
@@ -59,9 +61,30 @@ int eventfd_signal(struct file *file, in
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
 
@@ -185,6 +208,14 @@ static const struct file_operations even
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
@@ -217,6 +248,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
@@ -237,3 +269,63 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
 	return sys_eventfd2(count, 0);
 }
 
+static void eventfd_pollcb_ptqueue(struct file *file, wait_queue_head_t *wqh,
+				   poll_table *pt)
+{
+	struct eventfd_pollcb *ecb;
+
+	ecb = container_of(pt, struct eventfd_pollcb, pt);
+
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
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-20 16:25:45.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-06-21 09:37:12.000000000 -0700
@@ -8,6 +8,20 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/file.h>
+#include <linux/list.h>
+#include <linux/kref.h>
+
+struct eventfd_ctx;
+
+struct eventfd_pollcb {
+	poll_table pt;
+	struct eventfd_ctx *ctx;
+	wait_queue_t wait;
+};
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -29,12 +43,22 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+int eventfd_pollcb_register(struct file *file, struct eventfd_pollcb *ecb,
+			    wait_queue_func_t cbf, unsigned int *events);
+void eventfd_pollcb_unregister(struct eventfd_pollcb *ecb);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+static inline int eventfd_pollcb_register(struct file *file,
+					  struct eventfd_pollcb *ecb,
+					  wait_queue_func_t cbf,
+					  unsigned int *events)
+{ return -ENOSYS; }
+static inline void eventfd_pollcb_unregister(struct eventfd_pollcb *ecb)
+{ }
 
 #endif /* CONFIG_EVENTFD */
 
