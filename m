Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXEKJIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXEKJIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbXEKJG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:06:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbXEKJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:06:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/7] Freezer: Fix kthread_create vs freezer theoretical race
Date: Fri, 11 May 2007 00:41:16 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl>
In-Reply-To: <200705110035.32229.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110041.17783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@tv-sign.ru>

kthread() sleeps in TASK_INTERRUPTIBLE state waiting for the first wakeup.  In
theory, this wakeup may come from freeze_process()->signal_wake_up(), so the
task can disappear even before kthread_create() sets its ->comm.

Change kthread() to use TASK_UNINTERRUPTIBLE.

[akpm@linux-foundation.org: s/BUG_ON/WARN_ON+recover]

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kthread.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/kthread.c
===================================================================
--- linux-2.6.orig/kernel/kthread.c	2007-05-10 21:44:23.000000000 +0200
+++ linux-2.6/kernel/kthread.c	2007-05-10 21:44:43.000000000 +0200
@@ -70,7 +70,7 @@ static int kthread(void *_create)
 	data = create->data;
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
-	__set_current_state(TASK_INTERRUPTIBLE);
+	__set_current_state(TASK_UNINTERRUPTIBLE);
 	complete(&create->started);
 	schedule();
 
@@ -162,7 +162,10 @@ EXPORT_SYMBOL(kthread_create);
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
-	BUG_ON(k->state != TASK_INTERRUPTIBLE);
+	if (k->state != TASK_UNINTERRUPTIBLE) {
+		WARN_ON(1);
+		return;
+	}
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	wait_task_inactive(k);
 	set_task_cpu(k, cpu);

