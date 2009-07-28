Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZG1Rzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZG1Rzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZG1Rzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:55:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZG1Rzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:55:47 -0400
Date: Tue, 28 Jul 2009 20:54:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: davidel@xmailserver.org, avi@redhat.com, gleb@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH-RFC 1/2] eventfd: reorganize the code to simplify new flags
Message-ID: <20090728175446.GB21549@redhat.com>
References: <cover.1248803500.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1248803500.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This slightly reorganizes the code in eventfd, encapsulating counter
math in inline functions, so that it will be easier to add a new flag.
No functional changes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 fs/eventfd.c |   56 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 31d12de..347a0e0 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -34,6 +34,37 @@ struct eventfd_ctx {
 	unsigned int flags;
 };
 
+
+static inline int eventfd_readable(struct eventfd_ctx *ctx)
+{
+	return ctx->count > 0;
+}
+
+static inline int eventfd_writeable(struct eventfd_ctx *ctx, u64 n)
+{
+	return ULLONG_MAX - n > ctx->count;
+}
+
+static inline int eventfd_overflow(struct eventfd_ctx *ctx, u64 cnt)
+{
+	return cnt == ULLONG_MAX;
+}
+
+static inline void eventfd_dowrite(struct eventfd_ctx *ctx, u64 ucnt)
+{
+	if (eventfd_writeable(ctx, ucnt))
+		ucnt = ULLONG_MAX - ctx->count;
+
+	ctx->count += ucnt;
+}
+
+static inline u64 eventfd_doread(struct eventfd_ctx *ctx)
+{
+	u64 ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
+	ctx->count -= ucnt;
+	return ucnt;
+}
+
 /**
  * eventfd_signal - Adds @n to the eventfd counter.
  * @ctx: [in] Pointer to the eventfd context.
@@ -57,9 +88,7 @@ int eventfd_signal(struct eventfd_ctx *ctx, int n)
 	if (n < 0)
 		return -EINVAL;
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	if (ULLONG_MAX - ctx->count < n)
-		n = (int) (ULLONG_MAX - ctx->count);
-	ctx->count += n;
+	eventfd_dowrite(ctx, n);
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, POLLIN);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
@@ -119,11 +148,11 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &ctx->wqh, wait);
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	if (ctx->count > 0)
+	if (eventfd_readable(ctx))
 		events |= POLLIN;
-	if (ctx->count == ULLONG_MAX)
+	if (eventfd_overflow(ctx, ctx->count))
 		events |= POLLERR;
-	if (ULLONG_MAX - 1 > ctx->count)
+	if (eventfd_writeable(ctx, 1))
 		events |= POLLOUT;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
@@ -142,13 +171,13 @@ static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
-	if (ctx->count > 0)
+	if (eventfd_readable(ctx))
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (ctx->count > 0) {
+			if (eventfd_readable(ctx)) {
 				res = sizeof(ucnt);
 				break;
 			}
@@ -164,8 +193,7 @@ static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
 		__set_current_state(TASK_RUNNING);
 	}
 	if (likely(res > 0)) {
-		ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
-		ctx->count -= ucnt;
+		ucnt = eventfd_doread(ctx);
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLOUT);
 	}
@@ -188,17 +216,17 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		return -EINVAL;
 	if (copy_from_user(&ucnt, buf, sizeof(ucnt)))
 		return -EFAULT;
-	if (ucnt == ULLONG_MAX)
+	if (eventfd_overflow(ctx, ucnt))
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
-	if (ULLONG_MAX - ctx->count > ucnt)
+	if (eventfd_writeable(ctx, ucnt))
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (ULLONG_MAX - ctx->count > ucnt) {
+			if (eventfd_writeable(ctx, ucnt)) {
 				res = sizeof(ucnt);
 				break;
 			}
@@ -214,7 +242,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		__set_current_state(TASK_RUNNING);
 	}
 	if (likely(res > 0)) {
-		ctx->count += ucnt;
+		eventfd_dowrite(ctx, ucnt);
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLIN);
 	}
-- 
1.6.2.5

