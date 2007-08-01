Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXHAVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXHAVcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXHAVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:31:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXHAVbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:31:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/3] Freezer: Measure freezing time
Date: Wed, 1 Aug 2007 23:36:39 +0200
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
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012336.40388.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Measure the time of the freezing of tasks, even if it doesn't fail.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6.23-rc1/kernel/power/process.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/process.c	2007-07-31 23:00:43.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/process.c	2007-07-31 23:00:52.000000000 +0200
@@ -190,6 +190,11 @@ static int try_to_freeze_tasks(int freez
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
+	struct timeval start, end;
+	s64 elapsed_csecs64;
+	unsigned int elapsed_csecs;
+
+	do_gettimeofday(&start);
 
 	end_time = jiffies + TIMEOUT;
 	refrigerator_called = 0;
@@ -226,6 +231,11 @@ static int try_to_freeze_tasks(int freez
 			break;
 	} while (todo);
 
+	do_gettimeofday(&end);
+	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
+	do_div(elapsed_csecs64, NSEC_PER_SEC / 100);
+	elapsed_csecs = elapsed_csecs64;
+
 	if (todo) {
 		/* This does not unfreeze processes that are already frozen
 		 * (we have slightly ugly calling convention in that respect,
@@ -233,10 +243,9 @@ static int try_to_freeze_tasks(int freez
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
 		printk("\n");
-		printk(KERN_ERR "Freezing of %s timed out after %d seconds "
+		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
 				"(%d tasks refusing to freeze):\n",
-				freeze_user_space ? "user space " : "tasks ",
-				TIMEOUT / HZ, todo);
+				elapsed_csecs / 100, elapsed_csecs % 100, todo);
 		show_state();
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
@@ -247,6 +256,9 @@ static int try_to_freeze_tasks(int freez
 			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
+	} else {
+		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
+			elapsed_csecs % 100);
 	}
 
 	return todo ? -EBUSY : 0;
