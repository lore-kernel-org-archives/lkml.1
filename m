Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXFNRWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXFNRWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXFNRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:22:26 -0400
Received: from mail.screens.ru ([213.234.233.54]:55333 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbXFNRWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:22:25 -0400
Date: Thu, 14 Jun 2007 21:22:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Clements <Paul.Clements@steeleye.com>, Pavel Machek <pavel@ucw.cz>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] nbd.c:sock_xmit: cleanup signal related code
Message-ID: <20070614172243.GA2446@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sock_xmit() re-implements sigprocmask() and dequeue_signal_lock().

Note: I can't understand this dequeue_signal(), it can dequeue SIGKILL
for the user-space task doing nbd_ioctl() ?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- sig/drivers/block/nbd.c~1_nbd	2007-05-21 13:57:50.000000000 +0400
+++ sig/drivers/block/nbd.c	2007-06-14 19:39:55.000000000 +0400
@@ -122,17 +122,12 @@ static int sock_xmit(struct socket *sock
 	int result;
 	struct msghdr msg;
 	struct kvec iov;
-	unsigned long flags;
-	sigset_t oldset;
+	sigset_t blocked, oldset;
 
 	/* Allow interception of SIGKILL only
 	 * Don't allow other signals to interrupt the transmission */
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	oldset = current->blocked;
-	sigfillset(&current->blocked);
-	sigdelsetmask(&current->blocked, sigmask(SIGKILL));
-	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	siginitsetinv(&blocked, sigmask(SIGKILL));
+	sigprocmask(SIG_SETMASK, &blocked, &oldset);
 
 	do {
 		sock->sk->sk_allocation = GFP_NOIO;
@@ -151,11 +146,9 @@ static int sock_xmit(struct socket *sock
 
 		if (signal_pending(current)) {
 			siginfo_t info;
-			spin_lock_irqsave(&current->sighand->siglock, flags);
 			printk(KERN_WARNING "nbd (pid %d: %s) got signal %d\n",
-				current->pid, current->comm, 
-				dequeue_signal(current, &current->blocked, &info));
-			spin_unlock_irqrestore(&current->sighand->siglock, flags);
+				current->pid, current->comm,
+				dequeue_signal_lock(current, &current->blocked, &info));
 			result = -EINTR;
 			break;
 		}
@@ -169,10 +162,7 @@ static int sock_xmit(struct socket *sock
 		buf += result;
 	} while (size > 0);
 
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	current->blocked = oldset;
-	recalc_sigpending();
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	sigprocmask(SIG_SETMASK, &oldset, NULL);
 
 	return result;
 }

