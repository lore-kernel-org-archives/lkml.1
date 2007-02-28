Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXB1VEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXB1VEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXB1VEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:04:50 -0500
Received: from mail.screens.ru ([213.234.233.54]:44553 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXB1VEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:04:49 -0500
Date: Thu, 1 Mar 2007 00:04:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] worker_thread: don't play with signals
Message-ID: <20070228210438.GA818@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

worker_thread() doesn't need to "Block and flush all signals", this was already
done by its caller, kthread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~signals	2007-02-20 02:21:11.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-28 23:58:11.000000000 +0300
@@ -290,18 +290,11 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 	struct k_sigaction sa;
-	sigset_t blocked;
 
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
-
-	/* Block and flush all signals */
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
-
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
 	 * Set MPOL_DEFAULT to insure node local allocations.

