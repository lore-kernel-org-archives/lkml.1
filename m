Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXGEUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXGEUYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759783AbXGEUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:24:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55189 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703AbXGEUYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:24:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Date: Thu, 5 Jul 2007 22:31:26 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
References: <200707041658.59588.rjw@sisk.pl> <200707051328.50845.rjw@sisk.pl> <200707052137.58164.nigel@nigel.suspend2.net>
In-Reply-To: <200707052137.58164.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707052231.27780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The syncing of filesystems from within the freezer is generally not needed.
Change freeze_processes() so that it doesn't execute sys_sync() and make the
suspend and hibernation code path sync filesystems independently of the freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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
@@ -297,6 +297,10 @@ int hibernate(void)
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
 
@@ -234,9 +235,14 @@ static int enter_state(suspend_state_t s
 
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
