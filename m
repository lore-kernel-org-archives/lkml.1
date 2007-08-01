Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXHAVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXHAVbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXHAVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:31:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXHAVbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:31:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping
Date: Wed, 1 Aug 2007 23:32:48 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708012328.23939.rjw@sisk.pl>
In-Reply-To: <200708012328.23939.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708012332.48798.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the observation that try_to_freeze_tasks() need not loop while waiting for
the freezing tasks to enter the refrigerator and make it use a wait queue.

The idea is that after sending freeze requests to the tasks regarded as
freezable try_to_freeze_tasks() can go to sleep and wait until at least one task
enters the refrigerator.  The first task that does it wakes up
try_to_freeze_tasks() and the procedure is repeated.  If the refrigerator is not
entered by any tasks before TIMEOUT expires, the freezing of tasks fails.

This way, try_to_freeze_tasks() doesn't occupy the CPU unnecessarily when some
freezing tasks are waiting for I/O to complete.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc1/kernel/power/process.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/process.c	2007-07-31 21:58:32.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/process.c	2007-07-31 23:00:43.000000000 +0200
@@ -19,6 +19,12 @@
  */
 #define TIMEOUT	(20 * HZ)
 
+/*
+ * Time to wait until one or more tasks enter the refrigerator after sending
+ * freeze requests to them.
+ */
+#define WAIT_TIME (HZ / 5)
+
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
 
@@ -43,6 +49,18 @@ static inline void frozen_process(void)
 	clear_freeze_flag(current);
 }
 
+/*
+ * Wait queue head used by try_to_freeze_tasks() to wait for tasks to enter the
+ * refrigerator.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(refrigerator_waitq);
+
+/*
+ * Used to notify try_to_freeze_tasks() that the refrigerator has been entered
+ * by a task.
+ */
+static int refrigerator_called;
+
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -58,6 +76,10 @@ void refrigerator(void)
 		task_unlock(current);
 		return;
 	}
+
+	refrigerator_called = 1;
+	wake_up(&refrigerator_waitq);
+
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
@@ -170,6 +192,7 @@ static int try_to_freeze_tasks(int freez
 	unsigned int todo;
 
 	end_time = jiffies + TIMEOUT;
+	refrigerator_called = 0;
 	do {
 		todo = 0;
 		read_lock(&tasklist_lock);
@@ -189,7 +212,16 @@ static int try_to_freeze_tasks(int freez
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-		yield();			/* Yield is okay here */
+
+		if (todo) {
+			unsigned long ret;
+
+			ret = wait_event_timeout(refrigerator_waitq,
+					refrigerator_called, WAIT_TIME);
+			if (ret)
+				refrigerator_called = 0;
+		}
+
 		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);

