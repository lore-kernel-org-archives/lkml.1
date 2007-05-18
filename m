Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXERTCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXERTCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbXERTCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:02:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4269 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbXERTCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:02:34 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davi Arnaut <davi@haxent.com.br>
Date: Fri, 18 May 2007 12:02:33 -0700
Subject: [patch 1/2] eventfd use waitqueue lock ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.6638.1179514953.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The eventfd was using the unlocked waitqueue operations, but it was
using a different lock, so poll_wait() would race with it. This patch
makes eventfd directly use the waitqueue lock.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2007-05-18 10:33:39.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2007-05-18 11:05:01.000000000 -0700
@@ -17,7 +17,6 @@
 #include <linux/eventfd.h>
 
 struct eventfd_ctx {
-	spinlock_t lock;
 	wait_queue_head_t wqh;
 	/*
 	 * Every time that a write(2) is performed on an eventfd, the
@@ -45,13 +44,13 @@
 
 	if (n < 0)
 		return -EINVAL;
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ULLONG_MAX - ctx->count < n)
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked(&ctx->wqh);
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
 }
@@ -70,14 +69,14 @@
 
 	poll_wait(file, &ctx->wqh, wait);
 
-	spin_lock_irqsave(&ctx->lock, flags);
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ctx->count > 0)
 		events |= POLLIN;
 	if (ctx->count == ULLONG_MAX)
 		events |= POLLERR;
 	if (ULLONG_MAX - 1 > ctx->count)
 		events |= POLLOUT;
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
 }
@@ -92,7 +91,7 @@
 
 	if (count < sizeof(ucnt))
 		return -EINVAL;
-	spin_lock_irq(&ctx->lock);
+	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
 	ucnt = ctx->count;
 	if (ucnt > 0)
@@ -110,9 +109,9 @@
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
@@ -122,7 +121,7 @@
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked(&ctx->wqh);
 	}
-	spin_unlock_irq(&ctx->lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
 		return -EFAULT;
 
@@ -143,7 +142,7 @@
 		return -EFAULT;
 	if (ucnt == ULLONG_MAX)
 		return -EINVAL;
-	spin_lock_irq(&ctx->lock);
+	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
 	if (ULLONG_MAX - ctx->count > ucnt)
 		res = sizeof(ucnt);
@@ -159,9 +158,9 @@
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
@@ -171,7 +170,7 @@
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked(&ctx->wqh);
 	}
-	spin_unlock_irq(&ctx->lock);
+	spin_unlock_irq(&ctx->wqh.lock);
 
 	return res;
 }
@@ -210,7 +209,6 @@
 		return -ENOMEM;
 
 	init_waitqueue_head(&ctx->wqh);
-	spin_lock_init(&ctx->lock);
 	ctx->count = count;
 
 	/*

