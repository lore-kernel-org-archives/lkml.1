Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbXE0LAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbXE0LAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXE0LAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:00:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXE0LAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:00:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/3] Freezer: Return int from freeze_processes
Date: Sun, 27 May 2007 13:03:23 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200705271300.18443.rjw@sisk.pl>
In-Reply-To: <200705271300.18443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271303.24640.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make try_to_freeze_tasks() and freeze_processes() return -EBUSY on failure
instead of the number of unfrozen tasks (none of the callers actually uses this
number).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

Index: linux-2.6.22-rc2/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/process.c
+++ linux-2.6.22-rc2/kernel/power/process.c
@@ -105,7 +105,7 @@ static void cancel_freezing(struct task_
 	}
 }
 
-static unsigned int try_to_freeze_tasks(int freeze_user_space)
+static int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
 	unsigned long end_time;
@@ -175,28 +175,25 @@ static unsigned int try_to_freeze_tasks(
 		read_unlock(&tasklist_lock);
 	}
 
-	return todo;
+	return todo ? -EBUSY : 0;
 }
 
 /**
  *	freeze_processes - tell processes to enter the refrigerator
- *
- *	Returns 0 on success, or the number of processes that didn't freeze,
- *	although they were told to.
  */
 int freeze_processes(void)
 {
-	unsigned int nr_unfrozen;
+	int error;
 
 	printk("Stopping tasks ... ");
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
-	if (nr_unfrozen)
-		return nr_unfrozen;
+	error = try_to_freeze_tasks(FREEZER_USER_SPACE);
+	if (error)
+		return error;
 
 	sys_sync();
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
-	if (nr_unfrozen)
-		return nr_unfrozen;
+	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
+	if (error)
+		return error;
 
 	printk("done.\n");
 	BUG_ON(in_atomic());

