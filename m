Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbXDMNyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbXDMNyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbXDMNyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:54:38 -0400
Received: from mail.screens.ru ([213.234.233.54]:36891 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbXDMNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:54:35 -0400
Date: Fri, 13 Apr 2007 17:54:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] worker_thread: don't play with SIGCHLD and numa policy
Message-ID: <20070413135437.GA547@tv-sign.ru>
References: <20070413072910.GA1522@tv-sign.ru> <m1irc0pfyq.fsf@ebiederm.dsl.xmission.com> <20070413134046.GA180@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413134046.GA180@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

depends on Eric's

	kthread-dont-depend-on-work-queues-take-2.patch

worker_thread() inherits ignored SIGCHLD and numa_default_policy() from its
parent, kthreadd. No need to setup this again.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

--- OLD/kernel/workqueue.c~wt	2007-04-05 12:20:35.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-04-13 17:43:23.000000000 +0400
@@ -289,23 +289,10 @@ static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
-	struct k_sigaction sa;
 
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	/*
-	 * We inherited MPOL_INTERLEAVE from the booting kernel.
-	 * Set MPOL_DEFAULT to insure node local allocations.
-	 */
-	numa_default_policy();
-
-	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
-
 	for (;;) {
 		if (cwq->wq->freezeable)
 			try_to_freeze();

