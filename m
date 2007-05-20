Return-Path: <linux-kernel-owner+w=401wt.eu-S1764695AbXETAH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764695AbXETAH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXETAHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:07:18 -0400
Received: from haxent.com ([65.99.219.155]:4276 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbXETAHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:07:17 -0400
Message-ID: <464F912F.3040205@haxent.com.br>
Date: Sat, 19 May 2007 21:07:11 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] signalfd: retrieve multiple signals with one read() call
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Gathering signals in bulk enables server applications to drain a signal
queue (almost full of realtime signals) more efficiently by reducing the
syscall and file look-up overhead.

Very similar to the sigtimedwait4() call described by Niels Provos,
Chuck Lever, and Stephen Tweedie in a paper entitled "Analyzing the
Overload Behavior of a Simple Web Server". The paper lists more details
and advantages.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 7cfeab4..f6303c5 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -11,6 +11,8 @@
  *      Now using anonymous inode source.
  *      Thanks to Oleg Nesterov for useful code review and suggestions.
  *      More comments and suggestions from Arnd Bergmann.
+ * Sat May 19, 2007: Davi E. M. Arnaut <davi@haxent.com.br>
+ *      Retrieve multiple signals with one read() call
  */
 
 #include <linux/file.h>
@@ -206,6 +208,64 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 	return err ? -EFAULT: sizeof(*uinfo);
 }
 
+static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
+				int nonblock)
+{
+	int locked;
+	ssize_t ret;
+	struct signalfd_lockctx lk;
+	DECLARE_WAITQUEUE(wait, current);
+
+	locked = signalfd_lock(ctx, &lk);
+	if (!locked)
+		return 0;
+
+	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+	switch (ret) {
+	case 0:
+		if (!nonblock)
+			break;
+		ret = -EAGAIN;
+	default:
+		signalfd_unlock(&lk);
+		return ret;
+	}
+
+	add_wait_queue(&ctx->wqh, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+		if (ret != 0)
+			break;
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+		signalfd_unlock(&lk);
+		schedule();
+		locked = signalfd_lock(ctx, &lk);
+		if (unlikely(!locked)) {
+			/*
+			 * Let the caller read zero byte, ala socket
+			 * recv() when the peer disconnect. This test
+			 * must be done before doing a dequeue_signal(),
+			 * because if the sighand has been orphaned,
+			 * the dequeue_signal() call is going to crash.
+			 */
+			 ret = 0;
+			 break;
+		}
+	}
+
+	remove_wait_queue(&ctx->wqh, &wait);
+	__set_current_state(TASK_RUNNING);
+
+	if (likely(locked))
+		signalfd_unlock(&lk);
+
+	return ret;
+}
+
 /*
  * Returns either the size of a "struct signalfd_siginfo", or zero if the
  * sighand we are attached to, has been orphaned. The "count" parameter
@@ -215,55 +275,30 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 			     loff_t *ppos)
 {
 	struct signalfd_ctx *ctx = file->private_data;
-	ssize_t res = 0;
-	int locked, signo;
+	struct signalfd_siginfo __user *siginfo;
+	int nonblock = file->f_flags & O_NONBLOCK;
+	ssize_t ret, total = 0;
 	siginfo_t info;
-	struct signalfd_lockctx lk;
-	DECLARE_WAITQUEUE(wait, current);
 
-	if (count < sizeof(struct signalfd_siginfo))
+	count /= sizeof(struct signalfd_siginfo);
+	if (!count)
 		return -EINVAL;
-	locked = signalfd_lock(ctx, &lk);
-	if (!locked)
-		return 0;
-	res = -EAGAIN;
-	signo = dequeue_signal(lk.tsk, &ctx->sigmask, &info);
-	if (signo == 0 && !(file->f_flags & O_NONBLOCK)) {
-		add_wait_queue(&ctx->wqh, &wait);
-		for (;;) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			signo = dequeue_signal(lk.tsk, &ctx->sigmask, &info);
-			if (signo != 0)
-				break;
-			if (signal_pending(current)) {
-				res = -ERESTARTSYS;
-				break;
-			}
-			signalfd_unlock(&lk);
-			schedule();
-			locked = signalfd_lock(ctx, &lk);
-			if (unlikely(!locked)) {
-				/*
-				 * Let the caller read zero byte, ala socket
-				 * recv() when the peer disconnect. This test
-				 * must be done before doing a dequeue_signal(),
-				 * because if the sighand has been orphaned,
-				 * the dequeue_signal() call is going to crash.
-				 */
-				res = 0;
-				break;
-			}
-		}
-		remove_wait_queue(&ctx->wqh, &wait);
-		__set_current_state(TASK_RUNNING);
-	}
-	if (likely(locked))
-		signalfd_unlock(&lk);
-	if (likely(signo))
-		res = signalfd_copyinfo((struct signalfd_siginfo __user *) buf,
-					&info);
 
-	return res;
+	siginfo = (struct signalfd_siginfo __user *) buf;
+
+	do {
+		ret = signalfd_dequeue(ctx, &info, nonblock);
+		if (unlikely(ret <= 0))
+			break;
+		ret = signalfd_copyinfo(siginfo, &info);
+		if (ret < 0)
+			break;
+		siginfo++;
+		total += ret;
+		nonblock = 1;
+	} while (--count);
+
+	return total ? total : ret;
 }
 
 static const struct file_operations signalfd_fops = {
