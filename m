Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZFTVYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZFTVYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 17:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZFTVXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 17:23:53 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39298 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbZFTVXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:23:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 20 Jun 2009 14:17:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3C44DA.7000503@novell.com>
Message-ID: <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009, Gregory Haskins wrote:

> > In the POLLIN event, you schedule_work(&irqfd->inject) and there are no 
> > races there AFAICS (you basically do not care of anything eventfd memory 
> > related at all).
> > For POLLHUP, you do:
> >
> > 	spin_lock(irqfd->slock);
> > 	if (irqfd->wqh)
> > 		schedule_work(&irqfd->inject);
> > 	irqfd->wqh = NULL;
> > 	spin_unlock(irqfd->slock);
> >
> > In your work function you notice the POLLHUP condition and take proper 
> > action (dunno what it is in your case).
> > In your kvm_irqfd_release() function:
> >
> > 	spin_lock(irqfd->slock);
> > 	if (irqfd->wqh)
> > 		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> > 	irqfd->wqh = NULL;
> > 	spin_unlock(irqfd->slock);
> >
> > Any races in there?
> >   
> 
> Yes, for one you have an ABBA deadlock on the irqfd->slock and wqh->lock
> (recall wqh has to be locked to fix that other race I mentioned).

Yep, true. How about we go in little steps?
How about the one below?
When you register your poll callback, you get a reference with 
eventfd_refget().
At that point we have no more worries about the eventfd memory (namely 
"wqh") going away.
Symmetrically, you use eventfd_refput() once you done with it.
So we basically de-couple the internal VFS refcount, from the eventfd 
context memory refcount.
Where are the non-solveable races on the IRQfd side, of an approach like 
this one?



> Yes, understood.  What I was trying to gently say is that the one-liner
> proposal alone is still broken afaict.  However, if there is another
> solution that works that you like better than 133-liner I posted, I am
> more than willing to help analyze it.  In the end, I only care that this
> is fixed.

Is it so?
What I noticed here, is that you went from "Detailed Mode" (in the emails 
where you were pushing the new bits), to "Hint Mode" (as below) when it 
was time to see if there were simpler solutions to the problem.

> (As a hint, I think I fixed 4-5 races with these patches, so there are a
> few others still lurking as well)

Not knowing the details of IRQfd, hinting only is not going to help 
anything in this case.



- Davide



---
 fs/eventfd.c            |   37 ++++++++++++++++++++++++++++++++++++-
 include/linux/eventfd.h |    6 ++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-06-20 13:08:22.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-06-20 14:00:23.000000000 -0700
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
 
@@ -201,6 +213,28 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+int eventfd_refget(struct file *file)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+	kref_get(&ctx->kref);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_refget);
+
+int eventfd_refput(struct file *file)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+	kref_put(&ctx->kref, eventfd_free);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_refput);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -217,6 +251,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	if (!ctx)
 		return -ENOMEM;
 
+	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-06-20 13:08:22.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-06-20 13:59:09.000000000 -0700
@@ -29,12 +29,18 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+int eventfd_refget(struct file *file);
+int eventfd_refput(struct file *file);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+static inline int eventfd_refget(struct file *file)
+{ return -ENOSYS; }
+static inline int eventfd_refput(struct file *file)
+{ return -ENOSYS; }
 
 #endif /* CONFIG_EVENTFD */
 
