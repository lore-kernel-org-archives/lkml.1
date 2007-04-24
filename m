Return-Path: <linux-kernel-owner+w=401wt.eu-S1423144AbXDXVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423144AbXDXVul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423147AbXDXVul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:50:41 -0400
Received: from mail.screens.ru ([213.234.233.54]:38163 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423144AbXDXVuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:50:40 -0400
Date: Wed, 25 Apr 2007 01:50:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070424215034.GA5985@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

del_timer_sync() buys nothing for cancel_delayed_work(), but it is less
efficient since it locks the timer unconditionally, and may wait for the
completion of the delayed_work_timer_fn().

cancel_delayed_work() == 0 means:

	before this patch:
		work->func may still be running or queued

	after this patch:
		work->func may still be running or queued, or
		delayed_work_timer_fn->__queue_work() in progress.

		The latter doesn't differ from the caller's POV,
		delayed_work_timer_fn() is called with _PENDING
		bit set.

cancel_delayed_work() == 1 with this patch adds a new possibility:

	delayed_work->work was cancelled, but delayed_work_timer_fn
	is still running (this is only possible for the re-arming
	works on single-threaded workqueue).

	In this case the timer was re-started by work->func(), nobody
	else can do this. This in turn means that delayed_work_timer_fn
	has already passed __queue_work() (and wont't touch delayed_work)
	because nobody else can queue delayed_work->work.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/include/linux/workqueue.h~2_CDW	2007-04-05 12:20:35.000000000 +0400
+++ OLD/include/linux/workqueue.h	2007-04-25 01:48:24.000000000 +0400
@@ -152,14 +152,15 @@ extern void cancel_work_sync(struct work
 
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
- * function may still be running on return from cancel_delayed_work().  Run
- * flush_workqueue() or cancel_work_sync() to wait on it.
+ * function may still be running on return from cancel_delayed_work(), unless
+ * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
+ * cancel_work_sync() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
 	int ret;
 
-	ret = del_timer_sync(&work->timer);
+	ret = del_timer(&work->timer);
 	if (ret)
 		work_clear_pending(&work->work);
 	return ret;

