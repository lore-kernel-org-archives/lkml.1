Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXEEVcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXEEVcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933793AbXEEVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:32:36 -0400
Received: from mail.screens.ru ([213.234.233.54]:42838 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790AbXEEVcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:32:36 -0400
Date: Sun, 6 May 2007 01:32:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] make-cancel_rearming_delayed_work-reliable-fix
Message-ID: <20070505213213.GA1013@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503181513.0b0aa4fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

on top of
	make-cancel_rearming_delayed_work-reliable-spelling.patch

Add cpu-relax() into spinloops, and a comments update.

Small note. The new implementation has another downside. Suppose that rearming
work->func() gets a preemtion after setting WORK_STRUCT_PENDING but before
add_timer/__queue_work. In that case cancel_rearming_delayed_work() will burn
CPU in a busy-wait loop. Fortunately this can happen only with CONFIG_PREEMPT
and we spin with preemption enabled.

We can avoid this,

	void cancel_rearming_delayed_work(struct delayed_work *dwork)
	{
		int retry;

		do {
			retry = !del_timer(&dwork->timer) &&
				!try_to_grab_pending(&dwork->work);
			wait_on_work(&dwork->work);
		} while (retry);

		work_clear_pending(&dwork->work);
	}

but I don't think this is worth fixing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/kernel/workqueue.c~2_RELAX	2007-05-05 23:17:48.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-05-05 23:59:59.000000000 +0400
@@ -475,13 +475,16 @@ static void wait_on_work(struct work_str
  * case it only guarantees that work->func() has completed on the last queued
  * workqueue.
  *
+ * cancel_work_sync(&delayed_work->work) should be used only if ->timer is not
+ * pending, otherwise it goes into a busy-wait loop until the timer expires.
+ *
  * The caller must ensure that workqueue_struct on which this work was last
  * queued can't be destroyed before this function returns.
  */
 void cancel_work_sync(struct work_struct *work)
 {
 	while (!try_to_grab_pending(work))
-		;
+		cpu_relax();
 	wait_on_work(work);
 	work_clear_pending(work);
 }
@@ -498,7 +501,7 @@ void cancel_rearming_delayed_work(struct
 {
 	while (!del_timer(&dwork->timer) &&
 	       !try_to_grab_pending(&dwork->work))
-		;
+		cpu_relax();
 	wait_on_work(&dwork->work);
 	work_clear_pending(&dwork->work);
 }

