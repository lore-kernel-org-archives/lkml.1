Return-Path: <linux-kernel-owner+w=401wt.eu-S965154AbYBAE7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbYBAE7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYBAEn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:43:28 -0500
Received: from mga05.intel.com ([192.55.52.89]:61240 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754854AbYBAEly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516552"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 05/37] Hibernation: Introduce exportable suspend ioctls header (rev. 2)
Date: Thu, 31 Jan 2008 23:36:36 -0500
Message-Id: <f07d2c9078e140323301a72140c6caeb372448dc.1201840183.git.len.brown@intel.com>
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

Move the definitions of hibernation ioctls to a separate header file in
include/linux, which can be exported to the user space.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/power/userland-swsusp.txt |   10 ++++----
 include/linux/Kbuild                    |    1 +
 include/linux/suspend_ioctls.h          |   32 +++++++++++++++++++++++++++++++
 kernel/power/power.h                    |   29 +---------------------------
 4 files changed, 39 insertions(+), 33 deletions(-)
 create mode 100644 include/linux/suspend_ioctls.h

diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.txt
index af52d53..7b99636 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -14,7 +14,7 @@ are going to develop your own suspend/resume utilities.
 
 The interface consists of a character device providing the open(),
 release(), read(), and write() operations as well as several ioctl()
-commands defined in kernel/power/power.h.  The major and minor
+commands defined in include/linux/suspend_ioctls.h .  The major and minor
 numbers of the device are, respectively, 10 and 231, and they can
 be read from /sys/class/misc/snapshot/dev.
 
@@ -70,10 +70,10 @@ SNAPSHOT_FREE_SWAP_PAGES - free all swap pages allocated by
 SNAPSHOT_SET_SWAP_AREA - set the resume partition and the offset (in <PAGE_SIZE>
 	units) from the beginning of the partition at which the swap header is
 	located (the last ioctl() argument should point to a struct
-	resume_swap_area, as defined in kernel/power/power.h, containing the
-	resume device specification and the offset); for swap partitions the
-	offset is always 0, but it is different from zero for swap files (see
-	Documentation/swsusp-and-swap-files.txt for details).
+	resume_swap_area, as defined in kernel/power/suspend_ioctls.h,
+	containing the resume device specification and the offset); for swap
+	partitions the offset is always 0, but it is different from zero for
+	swap files (see Documentation/swsusp-and-swap-files.txt for details).
 
 SNAPSHOT_PLATFORM_SUPPORT - enable/disable the hibernation platform support,
 	depending on the argument value (enable, if the argument is nonzero)
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 85b2482..c0f9bb7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -143,6 +143,7 @@ header-y += snmp.h
 header-y += sockios.h
 header-y += som.h
 header-y += sound.h
+header-y += suspend_ioctls.h
 header-y += taskstats.h
 header-y += telephony.h
 header-y += termios.h
diff --git a/include/linux/suspend_ioctls.h b/include/linux/suspend_ioctls.h
new file mode 100644
index 0000000..2c6faec
--- /dev/null
+++ b/include/linux/suspend_ioctls.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_SUSPEND_IOCTLS_H
+#define _LINUX_SUSPEND_IOCTLS_H
+
+/*
+ * This structure is used to pass the values needed for the identification
+ * of the resume swap area from a user space to the kernel via the
+ * SNAPSHOT_SET_SWAP_AREA ioctl
+ */
+struct resume_swap_area {
+	loff_t offset;
+	u_int32_t dev;
+} __attribute__((packed));
+
+#define SNAPSHOT_IOC_MAGIC	'3'
+#define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
+#define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
+#define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
+#define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
+#define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
+#define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
+#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
+							struct resume_swap_area)
+#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
+#define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
+#define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
+#define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
+#define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
+#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
+#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
+#define SNAPSHOT_IOC_MAXNR	20
+
+#endif /* _LINUX_SUSPEND_IOCTLS_H */
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 0dd66fa..ef90605 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -1,4 +1,5 @@
 #include <linux/suspend.h>
+#include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
 
 struct swsusp_info {
@@ -134,34 +135,6 @@ extern int snapshot_write_next(struct snapshot_handle *handle, size_t count);
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
-/*
- * This structure is used to pass the values needed for the identification
- * of the resume swap area from a user space to the kernel via the
- * SNAPSHOT_SET_SWAP_AREA ioctl
- */
-struct resume_swap_area {
-	loff_t offset;
-	u_int32_t dev;
-} __attribute__((packed));
-
-#define SNAPSHOT_IOC_MAGIC	'3'
-#define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
-#define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
-#define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
-#define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
-#define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
-#define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
-#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
-							struct resume_swap_area)
-#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
-#define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
-#define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
-#define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
-#define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
-#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
-#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
-#define SNAPSHOT_IOC_MAXNR	20
-
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
 
-- 
1.5.4.rc5.16.gc0279

