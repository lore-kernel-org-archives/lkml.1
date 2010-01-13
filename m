Return-Path: <linux-kernel-owner+w=401wt.eu-S932200Ab0AMRek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0AMRek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932177Ab0AMRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:34:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46411 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0AMReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:34:37 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 13 Jan 2010 09:34:36 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [patch] eventfd - allow atomic read and waitqueue remove
Message-ID: <alpine.DEB.2.00.1001130927590.2775@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM needs a wait to atomically remove themselves from the eventfd ->poll() 
wait queue head, in order to handle correctly their IRQfd deassign 
operation.
This patch introduces such API, plus a way to read an eventfd from its 
context.
Andrew, they prefer to have this go through Avi's KVM tree, in order to 
keep dependencies localized. So you just ignore this.
Avi, this fixes a few checkpatch warnings, so you should get this instead 
of the one posted previously.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventfd.c            |   89 +++++++++++++++++++++++++++++++++++++++---------
 include/linux/eventfd.h |   16 ++++++++
 2 files changed, 90 insertions(+), 15 deletions(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2010-01-10 11:04:44.000000000 -0800
+++ linux-2.6.mod/fs/eventfd.c	2010-01-13 09:23:56.000000000 -0800
@@ -135,26 +135,71 @@ static unsigned int eventfd_poll(struct 
 	return events;
 }
 
-static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
-			    loff_t *ppos)
+static void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
+{
+	*cnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
+	ctx->count -= *cnt;
+}
+
+/**
+ * eventfd_ctx_remove_wait_queue - Read the current counter and removes wait queue.
+ * @ctx: [in] Pointer to eventfd context.
+ * @wait: [in] Wait queue to be removed.
+ * @cnt: [out] Pointer to the 64bit conter value.
+ *
+ * Returns zero if successful, or the following error codes:
+ *
+ * -EAGAIN      : The operation would have blocked.
+ *
+ * This is used to atomically remove a wait queue entry from the eventfd wait
+ * queue head, and read/reset the counter value.
+ */
+int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
+				  __u64 *cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	eventfd_ctx_do_read(ctx, cnt);
+	__remove_wait_queue(&ctx->wqh, wait);
+	if (*cnt != 0 && waitqueue_active(&ctx->wqh))
+		wake_up_locked_poll(&ctx->wqh, POLLOUT);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+
+	return *cnt != 0 ? 0 : -EAGAIN;
+}
+EXPORT_SYMBOL_GPL(eventfd_ctx_remove_wait_queue);
+
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
+ *
+ * If @no_wait is zero, the function might sleep until the eventfd internal
+ * counter becomes greater than zero.
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
@@ -168,18 +213,32 @@ static ssize_t eventfd_read(struct file 
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (likely(res > 0)) {
-		ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
-		ctx->count -= ucnt;
+	if (likely(res == 0)) {
+		eventfd_ctx_do_read(ctx, cnt);
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
+	res = eventfd_ctx_read(ctx, file->f_flags & O_NONBLOCK, &cnt);
+	if (res < 0)
+		return res;
+
+	return put_user(cnt, (__u64 __user *) buf) ? -EFAULT : sizeof(cnt);
+}
 
 static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
 			     loff_t *ppos)
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2010-01-10 11:04:44.000000000 -0800
+++ linux-2.6.mod/include/linux/eventfd.h	2010-01-13 09:20:54.000000000 -0800
@@ -10,6 +10,7 @@
 
 #include <linux/fcntl.h>
 #include <linux/file.h>
+#include <linux/wait.h>
 
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
@@ -34,6 +35,9 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 int eventfd_signal(struct eventfd_ctx *ctx, int n);
+ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
+int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
+				  __u64 *cnt);
 
 #else /* CONFIG_EVENTFD */
 
@@ -61,6 +65,18 @@ static inline void eventfd_ctx_put(struc
 
 }
 
+static inline ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait,
+				       __u64 *cnt)
+{
+	return -ENOSYS;
+}
+
+static inline int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx,
+						wait_queue_t *wait, __u64 *cnt)
+{
+	return -ENOSYS;
+}
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */
