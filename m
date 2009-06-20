Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZFTWR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZFTWR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 18:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZFTWRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 18:17:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:52090 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZFTWRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:17:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 20 Jun 2009 15:11:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Davide Libenzi wrote:

> How about the one below?

Maybe with an interface that can be undone w/out a file* :)


- Davide


---
 fs/eventfd.c            |   34 +++++++++++++++++++++++++++++++++-
 include/linux/eventfd.h |    8 ++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-06-20 13:08:22.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-06-20 15:07:18.000000000 -0700
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
@@ -59,9 +61,19 @@ int eventfd_signal(struct file *file, in
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+static void eventfd_free(struct kref *kref)
+{
+	struct eventfd_ctx *ctx = container_of(kref, struct eventfd_ctx, kref);
+
+	kfree(ctx);
+}
+
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	wake_up_poll(&ctx->wqh, POLLHUP);
+	kref_put(&ctx->kref, eventfd_free);
 	return 0;
 }
 
@@ -201,6 +213,25 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+struct eventfd_kref *eventfd_refget(struct file *file)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+
+	if (file->f_op != &eventfd_fops)
+		return ERR_PTR(-EINVAL);
+	kref_get(&ctx->kref);
+	return (struct eventfd_kref *) ctx;
+}
+EXPORT_SYMBOL_GPL(eventfd_refget);
+
+void eventfd_refput(struct eventfd_kref *ref)
+{
+	struct eventfd_ctx *ctx = (struct eventfd_ctx *) ref;
+
+	kref_put(&ctx->kref, eventfd_free);
+}
+EXPORT_SYMBOL_GPL(eventfd_refput);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -217,6 +248,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-20 13:08:22.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-06-20 15:06:03.000000000 -0700
@@ -8,6 +8,8 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+struct eventfd_kref;
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -29,12 +31,18 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+struct eventfd_kref *eventfd_refget(struct file *file);
+void eventfd_refput(struct eventfd_kref *ref);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+static inline struct eventfd_kref *eventfd_refget(struct file *file)
+{ return ERR_PTR(-ENOSYS); }
+static inline void eventfd_refput(struct eventfd_kref *ref)
+{ }
 
 #endif /* CONFIG_EVENTFD */
 
