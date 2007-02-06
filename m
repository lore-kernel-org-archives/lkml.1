Return-Path: <linux-kernel-owner+w=401wt.eu-S1030569AbXBFXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030569AbXBFXaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXBFXaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:30:09 -0500
Received: from mail.screens.ru ([213.234.233.54]:58426 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030569AbXBFXaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:30:06 -0500
Date: Wed, 7 Feb 2007 02:30:08 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] workqueue: don't save interrupts in run_workqueue()
Message-ID: <20070206233008.GA105@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

work->func() may sleep, it's a bug to call run_workqueue() with irqs disabled.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~2_run_irq	2007-02-06 22:54:16.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-06 23:09:34.000000000 +0300
@@ -227,13 +227,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	unsigned long flags;
-
-	/*
-	 * Keep taking off work from the queue until
-	 * done.
-	 */
-	spin_lock_irqsave(&cwq->lock, flags);
+	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
 	if (cwq->run_depth > 3) {
 		/* morton gets to eat his hat */
@@ -248,7 +242,7 @@ static void run_workqueue(struct cpu_wor
 
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
-		spin_unlock_irqrestore(&cwq->lock, flags);
+		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
 		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
@@ -266,11 +260,11 @@ static void run_workqueue(struct cpu_wor
 			dump_stack();
 		}
 
-		spin_lock_irqsave(&cwq->lock, flags);
+		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 	}
 	cwq->run_depth--;
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	spin_unlock_irq(&cwq->lock);
 }
 
 /*

