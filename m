Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbXKZXTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbXKZXTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXKZXSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:18:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40850 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbXKZXSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:18:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/6] Suspend: Use common prefix in messages
Date: Tue, 27 Nov 2007 00:30:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711270025.08128.rjw@sisk.pl>
In-Reply-To: <200711270025.08128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270030.10561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make suspend messages start with one common prefix "PM: ".

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c  |   19 ++++++++++---------
 kernel/power/power.h |    2 ++
 2 files changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -183,11 +183,11 @@ static int suspend_prepare(void)
 
 	free_pages = global_page_state(NR_FREE_PAGES);
 	if (free_pages < FREE_PAGE_NUMBER) {
-		pr_debug("PM: free some memory\n");
+		pr_debug(PREFIX "Free some memory\n");
 		shrink_all_memory(FREE_PAGE_NUMBER - free_pages);
 		if (nr_free_pages() < FREE_PAGE_NUMBER) {
 			error = -ENOMEM;
-			printk(KERN_ERR "PM: No enough memory\n");
+			printk(KERN_ERR PREFIX "No enough memory\n");
 		}
 	}
 	if (!error)
@@ -227,7 +227,7 @@ static int suspend_enter(suspend_state_t
 	BUG_ON(!irqs_disabled());
 
 	if ((error = device_power_down(PMSG_SUSPEND))) {
-		printk(KERN_ERR "Some devices failed to power down\n");
+		printk(KERN_ERR PREFIX "Some devices failed to power down\n");
 		goto Done;
 	}
 
@@ -261,7 +261,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error) {
-		printk(KERN_ERR "Some devices failed to suspend\n");
+		printk(KERN_ERR PREFIX "Some devices failed to suspend\n");
 		goto Resume_console;
 	}
 
@@ -344,11 +344,12 @@ static int enter_state(suspend_state_t s
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
-	printk("Syncing filesystems ... ");
+	printk(KERN_INFO PREFIX "Syncing filesystems ... ");
 	sys_sync();
-	printk("done.\n");
+	printk(KERN_INFO "done.\n");
 
-	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
+	pr_debug(PREFIX "Preparing system to enter %s sleep state\n",
+			pm_states[state]);
 	error = suspend_prepare();
 	if (error)
 		goto Unlock;
@@ -356,11 +357,11 @@ static int enter_state(suspend_state_t s
 	if (suspend_test(TEST_FREEZER))
 		goto Finish;
 
-	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pr_debug(PREFIX "Entering %s sleep state\n", pm_states[state]);
 	error = suspend_devices_and_enter(state);
 
  Finish:
-	pr_debug("PM: Finishing wakeup.\n");
+	pr_debug(PREFIX "Finishing wakeup.\n");
 	suspend_finish();
  Unlock:
 	mutex_unlock(&pm_mutex);
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -2,6 +2,8 @@
 #include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
 
+#define PREFIX	"PM: "
+
 struct swsusp_info {
 	struct new_utsname	uts;
 	u32			version_code;

