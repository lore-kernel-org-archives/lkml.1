Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004Ab0AUQ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0AUQ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968Ab0AUQ34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:29:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0AUQ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:29:55 -0500
Date: Thu, 21 Jan 2010 18:26:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, davidel@xmailserver.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
Message-ID: <20100121162648.GA16458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a backport of commit: 03db343a6320f780937078433fa7d8da955e6fce
modified in a way that introduces some code duplication on the one hand,
but reduces the risk of regressing existing eventfd users on the other
hand.

KVM needs a wait to atomically remove themselves from the eventfd
->poll() wait queue head, in order to handle correctly their IRQfd
deassign operation.

This patch introduces such API, plus a way to read an eventfd from its
context.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Avi, Davidel, how about only including the following part for -stable
then?  Reason is, I still would like to be able to use irqfd there, and
getting spurious interrupts 100% of times unmask is done isn't a very
good idea IMO ...


 fs/eventfd.c            |   35 +++++++++++++++++++++++++++++++++++
 include/linux/eventfd.h |    9 +++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 8b47e42..ea9c18a 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -135,6 +135,41 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
 	return events;
 }
 
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
 static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
 			    loff_t *ppos)
 {
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 94dd103..85eac48 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -10,6 +10,7 @@
 
 #include <linux/fcntl.h>
 #include <linux/file.h>
+#include <linux/wait.h>
 
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
@@ -34,6 +35,8 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 int eventfd_signal(struct eventfd_ctx *ctx, int n);
+int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
+				  __u64 *cnt);
 
 #else /* CONFIG_EVENTFD */
 
@@ -61,6 +64,12 @@ static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 
 }
 
+static inline int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx,
+						wait_queue_t *wait, __u64 *cnt)
+{
+	return -ENOSYS;
+}
+
 #endif
 
 #endif /* _LINUX_EVENTFD_H */
-- 
1.6.6.144.g5c3af
