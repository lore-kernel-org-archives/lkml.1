Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbZEAWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbZEAWcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764877AbZEAWbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:31:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764714AbZEAWbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:31:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] PM: Disable OOM killer during system-wide power transitions
Date: Sat, 2 May 2009 00:27:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090422131943.69288af3.akpm@linux-foundation.org> <200905020026.19027.rjw@sisk.pl>
In-Reply-To: <200905020026.19027.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905020027.31244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The OOM killer is not particularly useful during system-wide power
transitions, so do not use it if such a transition is in progress.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/suspend.h |    4 ++++
 kernel/power/disk.c     |   13 ++++++++++++-
 kernel/power/main.c     |   13 +++++++++++++
 kernel/power/power.h    |    1 +
 mm/page_alloc.c         |    8 ++++++--
 5 files changed, 36 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -282,6 +282,8 @@ extern int unregister_pm_notifier(struct
 		{ .notifier_call = fn, .priority = pri };	\
 	register_pm_notifier(&fn##_nb);			\
 }
+
+extern bool pm_transition_in_progress(void);
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
@@ -295,6 +297,8 @@ static inline int unregister_pm_notifier
 }
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
+
+static inline bool pm_transition_in_progress(void) { return false; }
 #endif /* !CONFIG_PM_SLEEP */
 
 #ifndef CONFIG_HIBERNATION
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1619,8 +1619,12 @@ nofail_alloc:
 			goto got_pg;
 		}
 
-		/* The OOM killer will not help higher order allocs so fail */
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+		/*
+		 * The OOM killer will not help higher order allocs and it is
+		 * not useful during system-wide power transitions, so fail.
+		 */
+		if (order > PAGE_ALLOC_COSTLY_ORDER
+		    || pm_transition_in_progress()) {
 			clear_zonelist_oom(zonelist, gfp_mask);
 			goto nopage;
 		}
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -299,9 +299,11 @@ int hibernation_snapshot(int platform_mo
 {
 	int error;
 
+	transition_in_progress = true;
+
 	error = platform_begin(platform_mode);
 	if (error)
-		return error;
+		goto Out;
 
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
@@ -325,6 +327,9 @@ int hibernation_snapshot(int platform_mo
 	resume_console();
  Close:
 	platform_end(platform_mode);
+
+ Out:
+	transition_in_progress = false;
 	return error;
 
  Recover_platform:
@@ -607,6 +612,7 @@ int hibernate(void)
 		pr_debug("PM: Image restored successfully.\n");
 		swsusp_free();
 	}
+
  Thaw:
 	thaw_processes();
  Finish:
@@ -724,6 +730,8 @@ static int software_resume(void)
 		goto Done;
 	}
 
+	transition_in_progress = true;
+
 	pr_debug("PM: Reading hibernation image.\n");
 
 	error = swsusp_read(&flags);
@@ -732,6 +740,9 @@ static int software_resume(void)
 
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	swsusp_free();
+
+	transition_in_progress = false;
+
 	thaw_processes();
  Done:
 	free_basic_memory_bitmaps();
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -32,6 +32,13 @@ EXPORT_SYMBOL(pm_flags);
 
 #ifdef CONFIG_PM_SLEEP
 
+bool transition_in_progress;
+
+bool pm_transition_in_progress(void)
+{
+	return transition_in_progress;
+}
+
 /* Routines for PM-transition notifications */
 
 static BLOCKING_NOTIFIER_HEAD(pm_chain_head);
@@ -246,6 +253,8 @@ static int suspend_prepare(void)
 		goto Thaw;
 	}
 
+	transition_in_progress = true;
+
 	free_pages = global_page_state(NR_FREE_PAGES);
 	if (free_pages < FREE_PAGE_NUMBER) {
 		pr_debug("PM: free some memory\n");
@@ -258,6 +267,8 @@ static int suspend_prepare(void)
 	if (!error)
 		return 0;
 
+	transition_in_progress = false;
+
  Thaw:
 	suspend_thaw_processes();
 	usermodehelper_enable();
@@ -403,6 +414,8 @@ int suspend_devices_and_enter(suspend_st
  */
 static void suspend_finish(void)
 {
+	transition_in_progress = false;
+
 	suspend_thaw_processes();
 	usermodehelper_enable();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -173,6 +173,7 @@ static inline int suspend_devices_and_en
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
+extern bool transition_in_progress;
 #endif
 
 #ifdef CONFIG_HIGHMEM
