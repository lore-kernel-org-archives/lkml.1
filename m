Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYG0Mjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYG0Mjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 08:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYG0Mjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 08:39:33 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39812 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYG0Mjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 08:39:32 -0400
Date: Sun, 27 Jul 2008 16:42:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: roland@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] kthread_bind: use wait_task_inactive(TASK_UNINTERRUPTIBLE)
Message-ID: <20080727124259.GC178@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that wait_task_inactive(task, state) checks task->state == state,
we can simplify the code and make this debugging check more robust.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- LINUS/kernel/kthread.c~	2008-07-27 16:19:27.000000000 +0400
+++ LINUS/kernel/kthread.c	2008-07-27 16:22:17.000000000 +0400
@@ -171,12 +171,11 @@ EXPORT_SYMBOL(kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	if (k->state != TASK_UNINTERRUPTIBLE) {
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(k, TASK_UNINTERRUPTIBLE)) {
 		WARN_ON(1);
 		return;
 	}
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
 	k->rt.nr_cpus_allowed = 1;

