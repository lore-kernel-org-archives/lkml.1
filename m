Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbXFUJ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbXFUJ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbXFUJ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:27:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:44336 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbXFUJ1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:27:15 -0400
Date: Thu, 21 Jun 2007 13:27:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] exclude sync signals from signalfd sets
Message-ID: <20070621092731.GC88@tv-sign.ru>
References: <Pine.LNX.4.64.0706201209570.6029@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706201255530.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706201255530.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Linus Torvalds wrote:
> 
> 
> On Wed, 20 Jun 2007, Davide Libenzi wrote:
> > 
> > The following patch excludes synchronous signals from being dequeued
> > by a signalfd.
> 
> I really prefer the current code. Listign special cases is just ugly. Just 
> make it so that thread-local signals stay thread-local, and it's all good.

OK. How about the patch below then? I think this is what Nicholas suggested.

(Sorry for persistance! I can't explain why I think the current behaviour is
 not good. Just a personal feeling).

Oleg.

--- signalfd.c~	2007-06-21 13:00:21.000000000 +0400
+++ signalfd.c	2007-06-21 13:04:45.000000000 +0400
@@ -208,6 +208,15 @@ static int signalfd_copyinfo(struct sign
 	return err ? -EFAULT: sizeof(*uinfo);
 }
 
+static int
+__signalfd_dequeue(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+{
+	if (tsk->tgid == current->tgid)
+		tsk = current;
+
+	return dequeue_signal(tsk, mask, info);
+}
+
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 				int nonblock)
 {
@@ -218,7 +227,7 @@ static ssize_t signalfd_dequeue(struct s
 	if (!signalfd_lock(ctx, &lk))
 		return 0;
 
-	ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+	ret = __signalfd_dequeue(lk.tsk, &ctx->sigmask, info);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -232,7 +241,7 @@ static ssize_t signalfd_dequeue(struct s
 	add_wait_queue(&ctx->wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(lk.tsk, &ctx->sigmask, info);
+		ret = __signalfd_dequeue(lk.tsk, &ctx->sigmask, info);
 		signalfd_unlock(&lk);
 		if (ret != 0)
 			break;
@@ -330,7 +339,7 @@ asmlinkage long sys_signalfd(int ufd, si
 
 		init_waitqueue_head(&ctx->wqh);
 		ctx->sigmask = sigmask;
-		ctx->tsk = current;
+		ctx->tsk = current->group_leader;
 
 		sighand = current->sighand;
 		/*

