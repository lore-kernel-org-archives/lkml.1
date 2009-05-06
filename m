Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZEFWvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZEFWvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZEFWuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:50:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60864 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZEFWuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:50:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 1/5] PM/Freezer: Disable OOM killer when tasks are frozen
Date: Thu, 7 May 2009 00:41:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>
References: <200905070040.08561.rjw@sisk.pl>
In-Reply-To: <200905070040.08561.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905070041.04787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The OOM killer is not really going to work while tasks are frozen, so
we can just give up calling it in that case.

This will allow us to safely use memory allocations for decreasing
the number of saveable pages in the hibernation core code instead of
using any artificial memory shriking mechanisms for this purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |    2 ++
 kernel/power/process.c  |   12 ++++++++++++
 mm/page_alloc.c         |    5 +++++
 3 files changed, 19 insertions(+)

Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -19,6 +19,8 @@
  */
 #define TIMEOUT	(20 * HZ)
 
+static bool tasks_frozen;
+
 static inline int freezeable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -120,6 +122,10 @@ int freeze_processes(void)
  Exit:
 	BUG_ON(in_atomic());
 	printk("\n");
+
+	if (!error)
+		tasks_frozen = true;
+
 	return error;
 }
 
@@ -145,6 +151,8 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
+	tasks_frozen = false;
+
 	printk("Restarting tasks ... ");
 	thaw_tasks(true);
 	thaw_tasks(false);
@@ -152,3 +160,7 @@ void thaw_processes(void)
 	printk("done.\n");
 }
 
+bool processes_are_frozen(void)
+{
+	return tasks_frozen;
+}
Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h
+++ linux-2.6/include/linux/freezer.h
@@ -50,6 +50,7 @@ extern int thaw_process(struct task_stru
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
+extern bool processes_are_frozen(void);
 
 static inline int try_to_freeze(void)
 {
@@ -170,6 +171,7 @@ static inline int thaw_process(struct ta
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
 static inline void thaw_processes(void) {}
+static inline bool processes_are_frozen(void) { return false; }
 
 static inline int try_to_freeze(void) { return 0; }
 
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/freezer.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1600,6 +1601,10 @@ nofail_alloc:
 		if (page)
 			goto got_pg;
 	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+		/* The OOM killer won't work if processes are frozen. */
+		if (processes_are_frozen())
+			goto nopage;
+
 		if (!try_set_zone_oom(zonelist, gfp_mask)) {
 			schedule_timeout_uninterruptible(1);
 			goto restart;
