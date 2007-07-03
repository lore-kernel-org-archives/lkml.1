Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbXGCW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbXGCW0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbXGCW0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:26:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761353AbXGCW0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:26:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 00:33:15 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707032259.59714.rjw@sisk.pl> <1183498518.3388.12.camel@localhost.localdomain>
In-Reply-To: <1183498518.3388.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707040033.16819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 23:35, Benjamin Herrenschmidt wrote:
> 
> > I don't think that would matter.
> > 
> > Still, I can remove the sync from the suspend code path only, leaving it in
> > the hibernation code path.  The patch will be bigger, but well.
> > 
> > Any objection to that?
> 
> Makes sense to sync before suspend tho, to limit the amount of dirty
> non-written pages in case things go wrong.

OK, below is the updated patch.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

The syncing of filesystems from within the freezer in not needed for suspend to
RAM and leads to problems with FUSE.  Change freeze_processes() so that it
doesn't execute sys_sync() and introduce the "syncing" version of it to be
called from the hibernation code paths.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   14 ++++++++++++--
 kernel/power/disk.c     |    2 +-
 kernel/power/main.c     |    6 ++++++
 kernel/power/process.c  |    8 +++++---
 kernel/power/user.c     |    2 +-
 5 files changed, 25 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc7/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc7.orig/include/linux/freezer.h	2007-07-04 00:21:26.000000000 +0200
+++ linux-2.6.22-rc7/include/linux/freezer.h	2007-07-04 00:22:37.000000000 +0200
@@ -62,7 +62,7 @@ static inline int thaw_process(struct ta
 }
 
 extern void refrigerator(void);
-extern int freeze_processes(void);
+extern int __freeze_processes(int sync_filesystems);
 extern void thaw_processes(void);
 
 static inline int try_to_freeze(void)
@@ -134,7 +134,7 @@ static inline void clear_freeze_flag(str
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
 static inline void refrigerator(void) {}
-static inline int freeze_processes(void) { BUG(); return 0; }
+static inline int __freeze_processes(int s) { BUG(); return 0; }
 static inline void thaw_processes(void) {}
 
 static inline int try_to_freeze(void) { return 0; }
@@ -145,4 +145,14 @@ static inline int freezer_should_skip(st
 static inline void set_freezable(void) {}
 #endif
 
+static inline int freeze_processes(void)
+{
+	return __freeze_processes(0);
+}
+
+static inline int freeze_processes_with_sync(void)
+{
+	return __freeze_processes(1);
+}
+
 #endif	/* FREEZER_H_INCLUDED */
Index: linux-2.6.22-rc7/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc7.orig/kernel/power/disk.c	2007-07-04 00:21:26.000000000 +0200
+++ linux-2.6.22-rc7/kernel/power/disk.c	2007-07-04 00:21:44.000000000 +0200
@@ -281,7 +281,7 @@ static int prepare_processes(void)
 	int error = 0;
 
 	pm_prepare_console();
-	if (freeze_processes()) {
+	if (freeze_processes_with_sync()) {
 		error = -EBUSY;
 		unprepare_processes();
 	}
Index: linux-2.6.22-rc7/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc7.orig/kernel/power/main.c	2007-07-04 00:21:26.000000000 +0200
+++ linux-2.6.22-rc7/kernel/power/main.c	2007-07-04 00:23:40.000000000 +0200
@@ -20,6 +20,7 @@
 #include <linux/resume-trace.h>
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
+#include <linux/syscalls.h>
 
 #include "power.h"
 
@@ -231,6 +232,11 @@ static int enter_state(suspend_state_t s
 
 	if (!valid_state(state))
 		return -ENODEV;
+
+	printk("Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
Index: linux-2.6.22-rc7/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc7.orig/kernel/power/process.c	2007-07-04 00:21:26.000000000 +0200
+++ linux-2.6.22-rc7/kernel/power/process.c	2007-07-04 00:21:44.000000000 +0200
@@ -179,9 +179,9 @@ static int try_to_freeze_tasks(int freez
 }
 
 /**
- *	freeze_processes - tell processes to enter the refrigerator
+ *	__freeze_processes - tell processes to enter the refrigerator
  */
-int freeze_processes(void)
+int __freeze_processes(int sync_filesystems)
 {
 	int error;
 
@@ -190,7 +190,9 @@ int freeze_processes(void)
 	if (error)
 		return error;
 
-	sys_sync();
+	if (sync_filesystems)
+		sys_sync();
+
 	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
 	if (error)
 		return error;
Index: linux-2.6.22-rc7/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc7.orig/kernel/power/user.c	2007-07-04 00:21:26.000000000 +0200
+++ linux-2.6.22-rc7/kernel/power/user.c	2007-07-04 00:21:44.000000000 +0200
@@ -153,7 +153,7 @@ static int snapshot_ioctl(struct inode *
 		mutex_lock(&pm_mutex);
 		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (!error) {
-			error = freeze_processes();
+			error = freeze_processes_with_sync();
 			if (error)
 				thaw_processes();
 		}
