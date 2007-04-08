Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXDHSUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXDHSUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXDHSUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:20:54 -0400
Received: from mail.screens.ru ([213.234.233.54]:50825 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXDHSUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:20:53 -0400
Date: Sun, 8 Apr 2007 22:20:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] worker_thread: fix racy try_to_freeze() usage
Message-ID: <20070408182047.GA317@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

worker_thread() can miss freeze_process()->signal_wake_up() if it happens
between try_to_freeze() and prepare_to_wait(). We should check freezing()
before entering schedule().

This race was introduced by me in

	[PATCH 1/1] workqueue: don't migrate pending works from the dead CPU

Looks like mm/vmscan.c:kswapd() has the same race.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5-mm4/kernel/workqueue.c~wq_freeze	2007-04-07 20:11:14.000000000 +0400
+++ 2.6.21-rc5-mm4/kernel/workqueue.c	2007-04-08 21:37:43.000000000 +0400
@@ -307,14 +307,14 @@ static int worker_thread(void *__cwq)
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
 	for (;;) {
-		if (cwq->wq->freezeable)
-			try_to_freeze();
-
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!cwq->should_stop && list_empty(&cwq->worklist))
+		if (!freezing(current) && !cwq->should_stop
+		    && list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
+		try_to_freeze();
+
 		if (cwq_should_stop(cwq))
 			break;
 

