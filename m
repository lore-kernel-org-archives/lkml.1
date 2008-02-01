Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbYBAErJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbYBAErJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764706AbYBAEmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:15 -0500
Received: from mga05.intel.com ([192.55.52.89]:61252 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756184AbYBAElz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516559"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 08/37] Hibernation: Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers (rev. 2)
Date: Thu, 31 Jan 2008 23:36:39 -0500
Message-Id: <f0c5038e08f04af6f6aa0536c7efed6e128520fe.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

Add PM_RESTORE_PREPARE and PM_POST_RESTORE notifiers to the PM core, to be used
in analogy with the existing PM_HIBERNATION_PREPARE and PM_POST_HIBERNATION
notifiers.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/power/notifiers.txt |    8 ++++++++
 include/linux/notifier.h          |    2 ++
 kernel/power/disk.c               |    5 +++++
 kernel/power/user.c               |   31 +++++++++++++++++++------------
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/Documentation/power/notifiers.txt b/Documentation/power/notifiers.txt
index 9293e4b..ae1b7ec 100644
--- a/Documentation/power/notifiers.txt
+++ b/Documentation/power/notifiers.txt
@@ -28,6 +28,14 @@ PM_POST_HIBERNATION	The system memory state has been restored from a
 			hibernation.  Device drivers' .resume() callbacks have
 			been executed and tasks have been thawed.
 
+PM_RESTORE_PREPARE	The system is going to restore a hibernation image.
+			If all goes well the restored kernel will issue a
+			PM_POST_HIBERNATION notification.
+
+PM_POST_RESTORE		An error occurred during the hibernation restore.
+			Device drivers' .resume() callbacks have been executed
+			and tasks have been thawed.
+
 PM_SUSPEND_PREPARE	The system is preparing for a suspend.
 
 PM_POST_SUSPEND		The system has just resumed or an error occured during
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 5dfbc68..f4df400 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -228,6 +228,8 @@ static inline int notifier_to_errno(int ret)
 #define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
 #define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
 #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
+#define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
+#define PM_POST_RESTORE		0x0006 /* Restore failed */
 
 /* Console keyboard events.
  * Note: KBD_KEYCODE is always sent before KBD_UNBOUND_KEYCODE, KBD_UNICODE and
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index b138b43..6597365 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -499,6 +499,10 @@ static int software_resume(void)
 		goto Unlock;
 	}
 
+	error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
+	if (error)
+		goto Finish;
+
 	error = create_basic_memory_bitmaps();
 	if (error)
 		goto Finish;
@@ -522,6 +526,7 @@ static int software_resume(void)
  Done:
 	free_basic_memory_bitmaps();
  Finish:
+	pm_notifier_call_chain(PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 	/* For success case, the suspend path will release the lock */
  Unlock:
diff --git a/kernel/power/user.c b/kernel/power/user.c
index b902a7e..f5512cb 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -67,6 +67,7 @@ atomic_t snapshot_device_available = ATOMIC_INIT(1);
 static int snapshot_open(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
+	int error;
 
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
 		return -EBUSY;
@@ -87,9 +88,19 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 		data->swap = swsusp_resume_device ?
 			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
+		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
+		if (error)
+			pm_notifier_call_chain(PM_POST_RESTORE);
 	} else {
 		data->swap = -1;
 		data->mode = O_WRONLY;
+		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+		if (error)
+			pm_notifier_call_chain(PM_POST_HIBERNATION);
+	}
+	if (error) {
+		atomic_inc(&snapshot_device_available);
+		return error;
 	}
 	data->frozen = 0;
 	data->ready = 0;
@@ -111,6 +122,8 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 		thaw_processes();
 		mutex_unlock(&pm_mutex);
 	}
+	pm_notifier_call_chain(data->mode == O_WRONLY ?
+			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
 	return 0;
 }
@@ -174,18 +187,13 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		if (data->frozen)
 			break;
 		mutex_lock(&pm_mutex);
-		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
-		if (!error) {
-			printk("Syncing filesystems ... ");
-			sys_sync();
-			printk("done.\n");
-
-			error = freeze_processes();
-			if (error)
-				thaw_processes();
-		}
+		printk("Syncing filesystems ... ");
+		sys_sync();
+		printk("done.\n");
+
+		error = freeze_processes();
 		if (error)
-			pm_notifier_call_chain(PM_POST_HIBERNATION);
+			thaw_processes();
 		mutex_unlock(&pm_mutex);
 		if (!error)
 			data->frozen = 1;
@@ -196,7 +204,6 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
-		pm_notifier_call_chain(PM_POST_HIBERNATION);
 		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
-- 
1.5.4.rc5.16.gc0279

