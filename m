Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZHZXac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZHZXac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 19:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZHZXab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 19:30:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:55011 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZHZXa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 19:30:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Aug 2009 16:30:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Avi Kivity <avi@redhat.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <alpine.DEB.2.00.0908261242530.7780@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.2.00.0908261626410.7780@makko.or.mcafeemobile.com>
References: <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
 <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com>
 <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com> <4A9585EC.2030505@redhat.com> <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <4A95900D.9090201@redhat.com> <alpine.DEB.2.00.0908261242530.7780@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Davide Libenzi wrote:

> > I see no kernel equivalent to read(), but that's easily done.
> 
> Adding an in-kernel read based on "ctx", that is no problem at all.

Something like the untested below.
I had thought you said the eventfd readers where in userspace, but I might 
have misunderstood you.



- Davide



---
 fs/eventfd.c            |   51 +++++++++++++++++++++++++++++++++---------------
 include/linux/eventfd.h |    7 ++++++
 2 files changed, 43 insertions(+), 15 deletions(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-08-26 15:58:03.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-08-26 16:20:03.000000000 -0700
@@ -130,26 +130,33 @@ static unsigned int eventfd_poll(struct 
 	return events;
 }
 
-static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
-			    loff_t *ppos)
+/**
+ * eventfd_ctx_read - Reads the eventfd counter or wait if it is zero.
+ * @ctx: [in] Pointer to eventfd context.
+ * @no_wait: [in] Different from zero if the operation should not block.
+ * @cnt: [out] Pointer to the 64bit conter value.
+ *
+ * Returns zero if successful, or the following error codes:
+ *
+ * -EAGAIN      : The operation would have blocked but @no_wait was nonzero.
+ * -ERESTARTSYS : A signal interrupted the wait operation.
+ */
+ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt)
 {
-	struct eventfd_ctx *ctx = file->private_data;
 	ssize_t res;
-	__u64 ucnt = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	if (count < sizeof(ucnt))
-		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
+	*cnt = 0;
 	res = -EAGAIN;
 	if (ctx->count > 0)
-		res = sizeof(ucnt);
-	else if (!(file->f_flags & O_NONBLOCK)) {
+		res = 0;
+	else if (!no_wait) {
 		__add_wait_queue(&ctx->wqh, &wait);
-		for (res = 0;;) {
+		for (;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ctx->count > 0) {
-				res = sizeof(ucnt);
+				res = 0;
 				break;
 			}
 			if (signal_pending(current)) {
@@ -163,18 +170,32 @@ static ssize_t eventfd_read(struct file 
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (likely(res > 0)) {
-		ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
-		ctx->count -= ucnt;
+	if (likely(res == 0)) {
+		*cnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
+		ctx->count -= *cnt;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLOUT);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
-	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
-		return -EFAULT;
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(eventfd_ctx_read);
+
+static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	__u64 cnt;
+
+	if (count < sizeof(cnt))
+		return -EINVAL;
+	if ((res = eventfd_ctx_read(ctx, file->f_flags & O_NONBLOCK, &cnt)) < 0)
+		return res;
+
+	return put_user(cnt, (__u64 __user *) buf) ? -EFAULT: sizeof(cnt);
+}
 
 static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
 			     loff_t *ppos)
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-08-26 15:58:03.000000000 -0700
+++ linux-2.6.mod/include/linux/eventfd.h	2009-08-26 16:17:01.000000000 -0700
@@ -33,6 +33,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 int eventfd_signal(struct eventfd_ctx *ctx, int n);
+ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 
 #else /* CONFIG_EVENTFD */
 
@@ -55,6 +56,12 @@ static inline void eventfd_ctx_put(struc
 
 }
 
+static inline ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait,
+				       __u64 *cnt)
+{
+	return -ENOSYS;
+}
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */
