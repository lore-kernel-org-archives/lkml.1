Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbYBAEnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbYBAEnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYBAEl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:41:58 -0500
Received: from mga05.intel.com ([192.55.52.89]:61240 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753903AbYBAElx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516543"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 02/37] Hibernation: Rework platform support ioctls (rev. 2)
Date: Thu, 31 Jan 2008 23:36:33 -0500
Message-Id: <6ef4bd5a2709f3f8d28e0ce83c911ed2a8af5afe.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Modify the hibernation userland interface by adding two new ioctls to it,
SNAPSHOT_PLATFORM_SUPPORT and SNAPSHOT_POWER_OFF, that can be used,
respectively, to switch the hibernation platform support on/off and to make the
kernel transition the system to the hibernation state (eg. ACPI S4) using the
platform (eg. ACPI) driver.

These ioctls are intended to replace the misdesigned SNAPSHOT_PMOPS ioctl,
which from now is regarded as obsolete and will be removed in the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/power/userland-swsusp.txt |   24 ++++--------------
 kernel/power/power.h                    |    9 ++----
 kernel/power/user.c                     |   39 +++++++++++++++++++++++--------
 3 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.txt
index 32f1874..381e9c0 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -85,6 +85,12 @@ SNAPSHOT_SET_SWAP_AREA - set the resume partition and the offset (in <PAGE_SIZE>
 	recommended to always use this call, because the code to set the resume
 	partition may be removed from future kernels
 
+SNAPSHOT_PLATFORM_SUPPORT - enable/disable the hibernation platform support,
+	depending on the argument value (enable, if the argument is nonzero)
+
+SNAPSHOT_POWER_OFF - make the kernel transition the system to the hibernation
+	state (eg. ACPI S4) using the platform (eg. ACPI) driver
+
 SNAPSHOT_S2RAM - suspend to RAM; using this call causes the kernel to
 	immediately enter the suspend-to-RAM state, so this call must always
 	be preceded by the SNAPSHOT_FREEZE call and it is also necessary
@@ -95,24 +101,6 @@ SNAPSHOT_S2RAM - suspend to RAM; using this call causes the kernel to
 	to resume the system from RAM if there's enough battery power or restore
 	its state on the basis of the saved suspend image otherwise)
 
-SNAPSHOT_PMOPS - enable the usage of the hibernation_ops->prepare,
-	hibernate_ops->enter and hibernation_ops->finish methods (the in-kernel
-	swsusp knows these as the "platform method") which are needed on many
-	machines to (among others) speed up the resume by letting the BIOS skip
-	some steps or to let the system recognise the correct state of the
-	hardware after the resume (in particular on many machines this ensures
-	that unplugged AC adapters get correctly detected and that kacpid does
-	not run wild after the resume).  The last ioctl() argument can take one
-	of the three values, defined in kernel/power/power.h:
-	PMOPS_PREPARE - make the kernel carry out the
-		hibernation_ops->prepare() operation
-	PMOPS_ENTER - make the kernel power off the system by calling
-		hibernation_ops->enter()
-	PMOPS_FINISH - make the kernel carry out the
-		hibernation_ops->finish() operation
-	Note that the actual constants are misnamed because they surface
-	internal kernel implementation details that have changed.
-
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:
 - you cannot read() more than one virtual memory page at a time
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 23c1703..6ca85fd 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -156,15 +156,12 @@ struct resume_swap_area {
 #define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
 #define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
-#define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
 							struct resume_swap_area)
 #define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
-#define SNAPSHOT_IOC_MAXNR	14
-
-#define PMOPS_PREPARE	1
-#define PMOPS_ENTER	2
-#define PMOPS_FINISH	3
+#define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
+#define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
+#define SNAPSHOT_IOC_MAXNR	16
 
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 88aac26..de3fb43 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -28,6 +28,18 @@
 
 #include "power.h"
 
+/*
+ * NOTE: The SNAPSHOT_PMOPS ioctl is obsolete and will be removed in the
+ * future.  It is only preserved here for compatibility with existing userland
+ * utilities.
+ */
+#define SNAPSHOT_PMOPS		_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
+
+#define PMOPS_PREPARE	1
+#define PMOPS_ENTER	2
+#define PMOPS_FINISH	3
+
+
 #define SNAPSHOT_MINOR	231
 
 static struct snapshot_data {
@@ -36,7 +48,7 @@ static struct snapshot_data {
 	int mode;
 	char frozen;
 	char ready;
-	char platform_suspend;
+	char platform_support;
 } snapshot_state;
 
 atomic_t snapshot_device_available = ATOMIC_INIT(1);
@@ -70,7 +82,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	}
 	data->frozen = 0;
 	data->ready = 0;
-	data->platform_suspend = 0;
+	data->platform_support = 0;
 
 	return 0;
 }
@@ -183,7 +195,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 			error = -EPERM;
 			break;
 		}
-		error = hibernation_snapshot(data->platform_suspend);
+		error = hibernation_snapshot(data->platform_support);
 		if (!error)
 			error = put_user(in_suspend, (unsigned int __user *)arg);
 		if (!error)
@@ -197,7 +209,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 			error = -EPERM;
 			break;
 		}
-		error = hibernation_restore(data->platform_suspend);
+		error = hibernation_restore(data->platform_support);
 		break;
 
 	case SNAPSHOT_FREE:
@@ -285,26 +297,33 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		mutex_unlock(&pm_mutex);
 		break;
 
-	case SNAPSHOT_PMOPS:
+	case SNAPSHOT_PLATFORM_SUPPORT:
+		data->platform_support = !!arg;
+		break;
+
+	case SNAPSHOT_POWER_OFF:
+		if (data->platform_support)
+			error = hibernation_platform_enter();
+		break;
+
+	case SNAPSHOT_PMOPS: /* This ioctl is deprecated */
 		error = -EINVAL;
 
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			data->platform_suspend = 1;
+			data->platform_support = 1;
 			error = 0;
 			break;
 
 		case PMOPS_ENTER:
-			if (data->platform_suspend)
+			if (data->platform_support)
 				error = hibernation_platform_enter();
-
 			break;
 
 		case PMOPS_FINISH:
-			if (data->platform_suspend)
+			if (data->platform_support)
 				error = 0;
-
 			break;
 
 		default:
-- 
1.5.4.rc5.16.gc0279

