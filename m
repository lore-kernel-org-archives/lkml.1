Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbXDBFiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbXDBFiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXDBFiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:38:11 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:33437 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbXDBFiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:38:09 -0400
Date: Mon, 2 Apr 2007 11:07:41 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 2/8] Make process freezer reentrant
Message-ID: <20070402053741.GB12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds provision to make the process freezer reentrant 
for different kinds of freeze events.

Credit to Rafael Wysocki for the system_freeze_event_mask idea.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>

--
 kernel/power/process.c |   57 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

Index: linux-2.6.21-rc3/kernel/power/process.c
===================================================================
--- linux-2.6.21-rc3.orig/kernel/power/process.c
+++ linux-2.6.21-rc3/kernel/power/process.c
@@ -23,6 +23,13 @@
 
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
+/*
+ * Global mask of the events (think suspend, cpu-hotplug, etc) for
+ * which the services of the processes freezer have been
+ * currently employed.
+ */
+static unsigned long system_freeze_event_mask;
+static DEFINE_MUTEX(freezer_mutex);
 
 static inline int freezeable(struct task_struct * p, unsigned long freeze_event)
 {
@@ -33,6 +40,25 @@ static inline int freezeable(struct task
 	return 1;
 }
 
+/* Returns the mask of the events for which p is currently frozen */
+static inline int process_frozen_event_mask(struct task_struct *p)
+{
+	return freezeable_event_mask(p) & system_freeze_event_mask;
+}
+
+static inline int thawable(struct task_struct *p, unsigned long freeze_event)
+{
+	if (!freezeable(p, freeze_event))
+		return 0;
+
+	/* p can be thawed iff the process p has been
+	 * frozen for freeze_event alone.
+	 */
+	if (process_frozen_event_mask(p) & ~freeze_event)
+		return 0;
+
+	return 1;
+}
 /* Refrigerator is place where frozen processes are stored :-). */
 void refrigerator(void)
 {
@@ -183,20 +209,30 @@ static unsigned int try_to_freeze_tasks(
 int freeze_processes(unsigned long freeze_event)
 {
 	unsigned int nr_unfrozen;
-
+	int ret = 0;
+	mutex_lock(&freezer_mutex);
+	if (system_freeze_event_mask & freeze_event)
+		goto done;
+	system_freeze_event_mask |= freeze_event;
 	printk("Stopping tasks ... ");
 	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE, freeze_event);
-	if (nr_unfrozen)
-		return nr_unfrozen;
+	if (nr_unfrozen) {
+		ret = nr_unfrozen;
+		goto done;
+	}
 
 	sys_sync();
 	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS, freeze_event);
-	if (nr_unfrozen)
-		return nr_unfrozen;
+	if (nr_unfrozen){
+		ret = nr_unfrozen;
+		goto done;
+	}
 
 	printk("done.\n");
+done:
+	mutex_unlock(&freezer_mutex);
 	BUG_ON(in_atomic());
-	return 0;
+	return ret;
 }
 
 static void thaw_tasks(int thaw_user_space, unsigned long freeze_event)
@@ -205,7 +241,7 @@ static void thaw_tasks(int thaw_user_spa
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		if (!freezeable(p, freeze_event))
+		if (!thawable(p, freeze_event))
 			continue;
 
 		if (is_user_space(p) == !thaw_user_space)
@@ -218,11 +254,18 @@ static void thaw_tasks(int thaw_user_spa
 
 void thaw_processes(unsigned long freeze_event)
 {
+	mutex_lock(&freezer_mutex);
+	/* Thaw for freeze_event, only if we've frozen for freeze_event */
+	if (!(system_freeze_event_mask & freeze_event))
+		goto done;
 	printk("Restarting tasks ... ");
 	thaw_tasks(FREEZER_KERNEL_THREADS, freeze_event);
 	thaw_tasks(FREEZER_USER_SPACE, freeze_event);
 	schedule();
 	printk("done.\n");
+	system_freeze_event_mask &= ~freeze_event;
+done:
+	mutex_unlock(&freezer_mutex);
 }
 
 EXPORT_SYMBOL(refrigerator);
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
