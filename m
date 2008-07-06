Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYGFQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYGFQZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYGFQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:25:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:32953 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbYGFQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:25:05 -0400
Date: Sun, 6 Jul 2008 20:28:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Johannes Berg <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] workqueues: lockdep annotations for flush_work()
Message-ID: <20080706162800.GA6443@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockdep annotations to flush_work() and update the comment.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/workqueue.c~FW_LOCKDEP	2008-06-29 19:36:27.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-07-06 20:15:16.000000000 +0400
@@ -403,6 +403,8 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  * flush_work - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
+ * Returns false if @work has already terminated.
+ *
  * It is expected that, prior to calling flush_work(), the caller has
  * arranged for the work to not be requeued, otherwise it doesn't make
  * sense to use this function.
@@ -418,6 +420,9 @@ int flush_work(struct work_struct *work)
 	if (!cwq)
 		return 0;
 
+	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&work->entry)) {

