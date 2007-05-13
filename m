Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXEMT1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXEMT1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXEMT1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:27:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbXEMT1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:27:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.22-rc1: Broken suspend on SMP with tifm
Date: Sun, 13 May 2007 21:32:07 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Alex Dubov <oakad@yahoo.com>,
       Pierre Ossman <drzeus@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705132132.08546.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The suspend/hibernation is broken on SMP due to:

commit 3540af8ffddcdbc7573451ac0b5cd57a2eaf8af5
tifm: replace per-adapter kthread with freezeable workqueue

Well, it looks like freezable worqueues still deadlock with CPU hotplug
when worker threads are frozen.

The appended patch fixes the issue, but I think we could even avoid the
killing of frozen worker threads.

Greetings,
Rafael


---
Prevent freezable worqueues from deadlocking with CPU hotplug during a
suspend/hibernation by thawing their worker threads before they get stopped.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/workqueue.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc1/kernel/workqueue.c
===================================================================
--- linux-2.6.22-rc1.orig/kernel/workqueue.c
+++ linux-2.6.22-rc1/kernel/workqueue.c
@@ -799,9 +799,7 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
-	action &= ~CPU_TASKS_FROZEN;
-
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
 		return NOTIFY_OK;
@@ -819,20 +817,29 @@ static int __devinit workqueue_cpu_callb
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+		case CPU_UP_PREPARE_FROZEN:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue for %i failed\n", cpu);
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			start_workqueue_thread(cwq, cpu);
 			break;
 
 		case CPU_UP_CANCELED:
+		case CPU_UP_CANCELED_FROZEN:
 			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
+
+		case CPU_DEAD_FROZEN:
+			if (wq->freezeable)
+				thaw_process(cwq->thread);
+			cleanup_workqueue_thread(cwq, cpu);
+			break;
 		}
 	}
 
