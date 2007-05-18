Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbXERTCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbXERTCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbXERTCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:02:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4272 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbXERTCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:02:35 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davi Arnaut <davi@haxent.com.br>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 18 May 2007 12:02:33 -0700
Subject: [patch 2/2] timerfd use waitqueue lock ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.6638.1179514954.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The timerfd was using the unlocked waitqueue operations, but it was
using a different lock, so poll_wait() would race with it. This patch
makes timerfd directly use the waitqueue lock.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2007-05-18 11:11:09.000000000 -0700
+++ linux-2.6.mod/fs/timerfd.c	2007-05-18 11:11:16.000000000 -0700
@@ -24,7 +24,6 @@
 struct timerfd_ctx {
 	struct hrtimer tmr;
 	ktime_t tintv;
-	spinlock_t lock;
 	wait_queue_head_t wqh;
 	int expired;
 };
@@ -39,10 +38,10 @@
 	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	ctx->expired = 1;
 	wake_up_locked(&ctx->wqh);
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return HRTIMER_NORESTART;
 }
@@ -83,10 +82,10 @@
 
 	poll_wait(file, &ctx->wqh, wait);
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ctx->expired)
 		events |= POLLIN;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
 }
@@ -101,7 +100,7 @@
 
 	if (count < sizeof(ticks))
 		return -EINVAL;
-	spin_lock_irq(&ctx->lock);
+	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
 	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
@@ -115,9 +114,9 @@
 				res = -ERESTARTSYS;
 				break;
 			}
-			spin_unlock_irq(&ctx->lock);
+			spin_unlock_irq(&ctx->wqh.lock);
 			schedule();
-			spin_lock_irq(&ctx->lock);
+			spin_lock_irq(&ctx->wqh.lock);
 		}
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
@@ -139,7 +138,7 @@
 		} else
 			ticks = 1;
 	}
-	spin_unlock_irq(&ctx->lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
 		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
 	return res;
@@ -176,7 +175,6 @@
 			return -ENOMEM;
 
 		init_waitqueue_head(&ctx->wqh);
-		spin_lock_init(&ctx->lock);
 
 		timerfd_setup(ctx, clockid, flags, &ktmr);
 
@@ -202,10 +200,10 @@
 		 * it to the new values.
 		 */
 		for (;;) {
-			spin_lock_irq(&ctx->lock);
+			spin_lock_irq(&ctx->wqh.lock);
 			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
 				break;
-			spin_unlock_irq(&ctx->lock);
+			spin_unlock_irq(&ctx->wqh.lock);
 			cpu_relax();
 		}
 		/*
@@ -213,7 +211,7 @@
 		 */
 		timerfd_setup(ctx, clockid, flags, &ktmr);
 
-		spin_unlock_irq(&ctx->lock);
+		spin_unlock_irq(&ctx->wqh.lock);
 		fput(file);
 	}
 

