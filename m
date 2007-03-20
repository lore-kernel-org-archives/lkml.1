Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXCTV1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXCTV1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXCTV07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:26:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbXCTV0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:26:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] swsusp: Use GFP_KERNEL for creating basic data structures
Date: Tue, 20 Mar 2007 22:28:54 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703122214.02657.rjw@sisk.pl> <20070319173127.72c3419d.akpm@linux-foundation.org> <200703202218.16820.rjw@sisk.pl>
In-Reply-To: <200703202218.16820.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202228.55012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make swsusp call create_basic_memory_bitmaps() before processes are frozen,
so that GFP_KERNEL allocations can be made in it.  Additionally, ensure
that the swsusp's userland interface won't be used while either
pm_suspend_disk() or software_resume() is being executed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c     |   37 ++++++++++++++++++++++++++-----------
 kernel/power/power.h    |    3 +++
 kernel/power/snapshot.c |    8 ++++----
 kernel/power/user.c     |   10 +++++-----
 4 files changed, 38 insertions(+), 20 deletions(-)

Index: linux-2.6.21-rc4-mm1/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/power/disk.c	2007-03-20 21:35:59.000000000 +0100
+++ linux-2.6.21-rc4-mm1/kernel/power/disk.c	2007-03-20 21:36:03.000000000 +0100
@@ -119,28 +119,33 @@ int pm_suspend_disk(void)
 {
 	int error;
 
+	/* The snapshot device should not be opened while we're running */
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
+		return -EBUSY;
+
+	/* Allocate memory management structures */
+	error = create_basic_memory_bitmaps();
+	if (error)
+		goto Exit;
+
 	error = prepare_processes();
 	if (error)
-		return error;
+		goto Finish;
 
 	if (pm_disk_mode == PM_DISK_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
 		goto Thaw;
 	}
-	/* Allocate memory management structures */
-	error = create_basic_memory_bitmaps();
-	if (error)
-		goto Thaw;
 
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		goto Finish;
+		goto Thaw;
 
 	error = platform_prepare();
 	if (error)
-		goto Finish;
+		goto Thaw;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -175,7 +180,7 @@ int pm_suspend_disk(void)
 			power_down(pm_disk_mode);
 		else {
 			swsusp_free();
-			goto Finish;
+			goto Thaw;
 		}
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
@@ -188,10 +193,12 @@ int pm_suspend_disk(void)
 	platform_finish();
 	device_resume();
 	resume_console();
- Finish:
-	free_basic_memory_bitmaps();
  Thaw:
 	unprepare_processes();
+ Finish:
+	free_basic_memory_bitmaps();
+ Exit:
+	atomic_inc(&snapshot_device_available);
 	return error;
 }
 
@@ -239,9 +246,15 @@ static int software_resume(void)
 	if (error)
 		goto Unlock;
 
+	/* The snapshot device should not be opened while we're running */
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+		error = -EBUSY;
+		goto Unlock;
+	}
+
 	error = create_basic_memory_bitmaps();
 	if (error)
-		goto Unlock;
+		goto Finish;
 
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
@@ -288,6 +301,8 @@ static int software_resume(void)
 	unprepare_processes();
  Done:
 	free_basic_memory_bitmaps();
+ Finish:
+	atomic_inc(&snapshot_device_available);
 	/* For success case, the suspend path will release the lock */
  Unlock:
 	mutex_unlock(&pm_mutex);
Index: linux-2.6.21-rc4-mm1/kernel/power/power.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/power/power.h	2007-03-20 21:35:59.000000000 +0100
+++ linux-2.6.21-rc4-mm1/kernel/power/power.h	2007-03-20 21:36:03.000000000 +0100
@@ -141,6 +141,9 @@ struct resume_swap_area {
 #define PMOPS_ENTER	2
 #define PMOPS_FINISH	3
 
+/* If unset, the snapshot device cannot be open. */
+extern atomic_t snapshot_device_available;
+
 /**
  *	The bitmap is used for tracing allocated swap pages
  *
Index: linux-2.6.21-rc4-mm1/kernel/power/snapshot.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/power/snapshot.c	2007-03-20 21:35:59.000000000 +0100
+++ linux-2.6.21-rc4-mm1/kernel/power/snapshot.c	2007-03-20 21:36:03.000000000 +0100
@@ -723,19 +723,19 @@ int create_basic_memory_bitmaps(void)
 
 	BUG_ON(forbidden_pages_map || free_pages_map);
 
-	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
+	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
 	if (!bm1)
 		return -ENOMEM;
 
-	error = memory_bm_create(bm1, GFP_ATOMIC | __GFP_COLD, PG_ANY);
+	error = memory_bm_create(bm1, GFP_KERNEL, PG_ANY);
 	if (error)
 		goto Free_first_object;
 
-	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
+	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
 	if (!bm2)
 		goto Free_first_bitmap;
 
-	error = memory_bm_create(bm2, GFP_ATOMIC | __GFP_COLD, PG_ANY);
+	error = memory_bm_create(bm2, GFP_KERNEL, PG_ANY);
 	if (error)
 		goto Free_second_object;
 
Index: linux-2.6.21-rc4-mm1/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/power/user.c	2007-03-20 21:35:59.000000000 +0100
+++ linux-2.6.21-rc4-mm1/kernel/power/user.c	2007-03-20 21:36:03.000000000 +0100
@@ -40,21 +40,21 @@ static struct snapshot_data {
 	char platform_suspend;
 } snapshot_state;
 
-static atomic_t device_available = ATOMIC_INIT(1);
+atomic_t snapshot_device_available = ATOMIC_INIT(1);
 
 static int snapshot_open(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
 
-	if (!atomic_add_unless(&device_available, -1, 0))
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
 		return -EBUSY;
 
 	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
-		atomic_inc(&device_available);
+		atomic_inc(&snapshot_device_available);
 		return -ENOSYS;
 	}
 	if(create_basic_memory_bitmaps()) {
-		atomic_inc(&device_available);
+		atomic_inc(&snapshot_device_available);
 		return -ENOMEM;
 	}
 	nonseekable_open(inode, filp);
@@ -92,7 +92,7 @@ static int snapshot_release(struct inode
 		enable_nonboot_cpus();
 		mutex_unlock(&pm_mutex);
 	}
-	atomic_inc(&device_available);
+	atomic_inc(&snapshot_device_available);
 	return 0;
 }
 
