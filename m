Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXDMH3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXDMH3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXDMH3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:29:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:55699 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXDMH3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:29:13 -0400
Date: Fri, 13 Apr 2007 11:29:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] worker_thread: don't play with SIGCHLD
Message-ID: <20070413072910.GA1522@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

depends on Eric's

	kthread-dont-depend-on-work-queues-take-2.patch

worker_thread() inherits ignored SIGCHLD from its parent, kthreadd.
We can remove unneeded do_sigaction().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/kernel/workqueue.c~wt	2007-04-05 12:20:35.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-04-13 11:21:43.000000000 +0400
@@ -289,7 +289,6 @@ static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
-	struct k_sigaction sa;
 
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
@@ -300,12 +299,6 @@ static int worker_thread(void *__cwq)
 	 */
 	numa_default_policy();
 
-	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
-
 	for (;;) {
 		if (cwq->wq->freezeable)
 			try_to_freeze();

