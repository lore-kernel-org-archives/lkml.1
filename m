Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbXGRHdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbXGRHdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbXGRHcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:32:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbXGRHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/5] Freezer: Do not sync filesystems from freeze_processes
Date: Wed, 18 Jul 2007 09:32:09 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl>
In-Reply-To: <200707180929.31511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180932.10678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The syncing of filesystems from within the freezer is generally not needed.
Also, if there's an ext3 filesystem loopback-mounted from a FUSE one, the
syncing results in writes to it and deadlocks.  Similarly, it will deadlock if
FUSE implements sync.

Change freeze_processes() so that it doesn't execute sys_sync() and make the
suspend and hibernation code path sync filesystems independently of the freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/disk.c    |    4 ++++
 kernel/power/main.c    |    6 ++++++
 kernel/power/process.c |    1 -
 kernel/power/user.c    |    4 ++++
 4 files changed, 14 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc6-mm1/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/disk.c
+++ linux-2.6.22-rc6-mm1/kernel/power/disk.c
@@ -312,6 +312,10 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
+	printk("Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
 	error = prepare_processes();
 	if (error)
 		goto Finish;
Index: linux-2.6.22-rc6-mm1/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/main.c
+++ linux-2.6.22-rc6-mm1/kernel/power/main.c
@@ -20,6 +20,7 @@
 #include <linux/resume-trace.h>
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
+#include <linux/syscalls.h>
 
 #include "power.h"
 
@@ -228,9 +229,14 @@ static int enter_state(suspend_state_t s
 
 	if (!valid_state(state))
 		return -ENODEV;
+
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	printk("Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	if ((error = suspend_prepare()))
 		goto Unlock;
Index: linux-2.6.22-rc6-mm1/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/process.c
+++ linux-2.6.22-rc6-mm1/kernel/power/process.c
@@ -191,7 +191,6 @@ int freeze_processes(void)
 	if (error)
 		return error;
 
-	sys_sync();
 	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
 	if (error)
 		return error;
Index: linux-2.6.22-rc6-mm1/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/user.c
+++ linux-2.6.22-rc6-mm1/kernel/power/user.c
@@ -153,6 +153,10 @@ static int snapshot_ioctl(struct inode *
 		mutex_lock(&pm_mutex);
 		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (!error) {
+			printk("Syncing filesystems ... ");
+			sys_sync();
+			printk("done.\n");
+
 			error = freeze_processes();
 			if (error)
 				thaw_processes();
