Return-Path: <linux-kernel-owner+w=401wt.eu-S1761196AbXERDpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbXERDpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbXERDpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:45:13 -0400
Received: from haxent.com ([65.99.219.155]:2115 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbXERDpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:45:12 -0400
Message-ID: <464D2142.3070705@haxent.com.br>
Date: Fri, 18 May 2007 00:45:06 -0300
From: Davi Arnaut <davi@haxent.com.br>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] timerfd/eventfd context lock doesn't protect against poll_wait
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

poll_wait() callback may modify the waitqueue without holding the
context private lock.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 480e2b3..9c672be 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -50,7 +50,7 @@ int eventfd_signal(struct file *file, int n)
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
-		wake_up_locked(&ctx->wqh);
+		wake_up(&ctx->wqh);
 	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	return n;
@@ -98,7 +98,7 @@ static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
 	if (ucnt > 0)
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
-		__add_wait_queue(&ctx->wqh, &wait);
+		add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ctx->count > 0) {
@@ -114,13 +114,13 @@ static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
 			schedule();
 			spin_lock_irq(&ctx->lock);
 		}
-		__remove_wait_queue(&ctx->wqh, &wait);
+		remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
 	if (res > 0) {
 		ctx->count = 0;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			wake_up(&ctx->wqh);
 	}
 	spin_unlock_irq(&ctx->lock);
 	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
@@ -148,7 +148,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 	if (ULLONG_MAX - ctx->count > ucnt)
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
-		__add_wait_queue(&ctx->wqh, &wait);
+		add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ULLONG_MAX - ctx->count > ucnt) {
@@ -163,13 +163,13 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 			schedule();
 			spin_lock_irq(&ctx->lock);
 		}
-		__remove_wait_queue(&ctx->wqh, &wait);
+		remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
 	if (res > 0) {
 		ctx->count += ucnt;
 		if (waitqueue_active(&ctx->wqh))
-			wake_up_locked(&ctx->wqh);
+			wake_up(&ctx->wqh);
 	}
 	spin_unlock_irq(&ctx->lock);
 
diff --git a/fs/timerfd.c b/fs/timerfd.c
index e329e37..e48eae7 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -41,8 +41,8 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 
 	spin_lock_irqsave(&ctx->lock, flags);
 	ctx->expired = 1;
-	wake_up_locked(&ctx->wqh);
 	spin_unlock_irqrestore(&ctx->lock, flags);
+	wake_up(&ctx->wqh);
 
 	return HRTIMER_NORESTART;
 }
@@ -104,7 +104,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	spin_lock_irq(&ctx->lock);
 	res = -EAGAIN;
 	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
-		__add_wait_queue(&ctx->wqh, &wait);
+		add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ctx->expired) {
@@ -119,7 +119,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 			schedule();
 			spin_lock_irq(&ctx->lock);
 		}
-		__remove_wait_queue(&ctx->wqh, &wait);
+		remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
 	if (ctx->expired) {
