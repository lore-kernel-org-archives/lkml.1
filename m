Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXHBR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXHBR3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXHBR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:29:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41772 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXHBR3d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:29:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping (updated)
Date: Thu, 2 Aug 2007 19:38:36 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708012328.23939.rjw@sisk.pl> <20070801164831.ed40546d.akpm@linux-foundation.org> <200708021315.18851.rjw@sisk.pl>
In-Reply-To: <200708021315.18851.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708021938.37547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 2 August 2007 13:15, Rafael J. Wysocki wrote:
> On Thursday, 2 August 2007 01:48, Andrew Morton wrote:
> > On Wed, 1 Aug 2007 23:32:48 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > +/*
> > > + * Used to notify try_to_freeze_tasks() that the refrigerator has been entered
> > > + * by a task.
> > > + */
> > > +static int refrigerator_called;
> > 
> > this is rather icky.
> 
> Well, the alternative would be to open code something like wait_event_timeout.

Still, having considered this for a while, I think it may be a good idea to
actually try this.

<modifies the patch, tests>

OK, here it goes (I hope I didn't messed up anything).  Please replace the
previous version with this patch if you prefer it. :-)

Greetings,
Rafael


---
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
---
 kernel/power/process.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc1-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.23-rc1-mm2.orig/kernel/power/process.c
+++ linux-2.6.23-rc1-mm2/kernel/power/process.c
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
 
@@ -43,6 +49,12 @@ static inline void frozen_process(void)
 	clear_freeze_flag(current);
 }
 
+/*
+ * Wait queue head used by try_to_freeze_tasks() to wait for tasks to enter the
+ * refrigerator.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(refrigerator_waitq);
+
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -58,6 +70,9 @@ void refrigerator(void)
 		task_unlock(current);
 		return;
 	}
+
+	wake_up(&refrigerator_waitq);
+
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
@@ -171,6 +186,10 @@ static int try_to_freeze_tasks(int freez
 
 	end_time = jiffies + TIMEOUT;
 	do {
+		DEFINE_WAIT(wait);
+
+		add_wait_queue(&refrigerator_waitq, &wait);
+
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
@@ -189,7 +208,12 @@ static int try_to_freeze_tasks(int freez
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-		yield();			/* Yield is okay here */
+
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (todo && !list_empty_careful(&wait.task_list))
+			schedule_timeout(WAIT_TIME);
+		finish_wait(&refrigerator_waitq, &wait);
+
 		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);
