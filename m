Return-Path: <linux-kernel-owner+w=401wt.eu-S1750895AbXB0Vtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbXB0Vtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXB0Vtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:49:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbXB0Vti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:49:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Problem with freezable workqueues
Date: Tue, 27 Feb 2007 22:51:27 +0100
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702272251.28844.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a problem with freezable workqueues in 2.6.21-rc1 and in -mm
(there are only two of them, in XFS, but still).  Namely, their worker threads
deadlock with workqueue_cpu_callback() that gets called during the CPU hotplug,
becuase workqueue_cpu_callback() tries to stop these threads while they are
frozen (disable_nonboot_cpus() happens after we've frozen tasks).

For 2.6.21-rc1 I've invented the appended workaround (works for me, waiting for
Johannes to confirm it works for him too), but I think we need something better
for -mm and future kernels.

Greetings,
Rafael


 kernel/workqueue.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc1/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc1.orig/kernel/workqueue.c	2007-02-24 10:17:57.000000000 +0100
+++ linux-2.6.21-rc1/kernel/workqueue.c	2007-02-24 20:00:22.000000000 +0100
@@ -376,8 +376,19 @@ static int worker_thread(void *__cwq)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		if (cwq->freezeable)
-			try_to_freeze();
+		if (try_to_freeze()) {
+			/* We've just left the refrigerator.  If our CPU is
+			 * a nonboot one, we might have been replaced.
+			 * The lock is taken to prevent the race with
+			 * cleanup_workqueue_thread() from happening
+			 */
+			spin_lock_irq(&cwq->lock);
+			if (cwq->thread != current) {
+				spin_unlock_irq(&cwq->lock);
+				break;
+			}
+			spin_unlock_irq(&cwq->lock);
+		}
 
 		add_wait_queue(&cwq->more_work, &wait);
 		if (list_empty(&cwq->worklist))
@@ -539,6 +550,9 @@ static void cleanup_workqueue_thread(str
 	cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 	spin_lock_irqsave(&cwq->lock, flags);
 	p = cwq->thread;
+	if (p && frozen(p))
+		p = NULL;
+
 	cwq->thread = NULL;
 	spin_unlock_irqrestore(&cwq->lock, flags);
 	if (p)
