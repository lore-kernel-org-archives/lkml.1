Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbXDMNBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbXDMNBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXDMNBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:01:49 -0400
Received: from mail.screens.ru ([213.234.233.54]:33960 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbXDMNBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:01:48 -0400
Date: Fri, 13 Apr 2007 17:01:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fix kthread_create() vs freezer theoretical race
Message-ID: <20070413130119.GA164@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kthread() sleeps in TASK_INTERRUPTIBLE state waiting for the first wakeup.
In theory, this wakeup may come from freeze_process()->signal_wake_up(),
so the task can disappear even before kthread_create() sets its ->comm.

Change kthread() to use TASK_UNINTERRUPTIBLE.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/kernel/kthread.c~0_FREEZER	2007-04-13 14:52:44.000000000 +0400
+++ 2.6.21-rc5/kernel/kthread.c	2007-04-13 15:36:43.000000000 +0400
@@ -70,7 +70,7 @@ static int kthread(void *_create)
 	data = create->data;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
-	__set_current_state(TASK_INTERRUPTIBLE);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
 	complete(&create->started);
 	schedule();
 
@@ -174,7 +174,7 @@ EXPORT_SYMBOL(kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	BUG_ON(k->state != TASK_INTERRUPTIBLE);
+	BUG_ON(k->state != TASK_UNINTERRUPTIBLE);
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	wait_task_inactive(k);
 	set_task_cpu(k, cpu);

