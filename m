Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbYBAFAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbYBAFAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYBAEnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:43:31 -0500
Received: from mga05.intel.com ([192.55.52.89]:61249 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754413AbYBAEly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516550"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 04/37] Hibernation: Correct definitions of some ioctls (rev. 2)
Date: Thu, 31 Jan 2008 23:36:35 -0500
Message-Id: <f5147875db58350b7c29856b83ef1e38e88a387b.1201840183.git.len.brown@intel.com>
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

Three ioctl numbers belonging to the hibernation userland interface,
SNAPSHOT_ATOMIC_SNAPSHOT, SNAPSHOT_AVAIL_SWAP, SNAPSHOT_GET_SWAP_PAGE,
are defined in a wrong way (eg. not portable).  Provide new ioctl numbers for
these ioctls and mark the existing ones as deprecated.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/power/userland-swsusp.txt |   26 +++++++++++++-------------
 kernel/power/power.h                    |   10 +++++-----
 kernel/power/user.c                     |   18 ++++++++++++++++--
 3 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.txt
index 0785500..af52d53 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -27,17 +27,17 @@ once at a time.
 The ioctl() commands recognized by the device are:
 
 SNAPSHOT_FREEZE - freeze user space processes (the current process is
-	not frozen); this is required for SNAPSHOT_ATOMIC_SNAPSHOT
+	not frozen); this is required for SNAPSHOT_CREATE_IMAGE
 	and SNAPSHOT_ATOMIC_RESTORE to succeed
 
 SNAPSHOT_UNFREEZE - thaw user space processes frozen by SNAPSHOT_FREEZE
 
-SNAPSHOT_ATOMIC_SNAPSHOT - create a snapshot of the system memory; the
+SNAPSHOT_CREATE_IMAGE - create a snapshot of the system memory; the
 	last argument of ioctl() should be a pointer to an int variable,
 	the value of which will indicate whether the call returned after
 	creating the snapshot (1) or after restoring the system memory state
 	from it (0) (after resume the system finds itself finishing the
-	SNAPSHOT_ATOMIC_SNAPSHOT ioctl() again); after the snapshot
+	SNAPSHOT_CREATE_IMAGE ioctl() again); after the snapshot
 	has been created the read() operation can be used to transfer
 	it out of the kernel
 
@@ -49,23 +49,23 @@ SNAPSHOT_ATOMIC_RESTORE - restore the system memory state from the
 
 SNAPSHOT_FREE - free memory allocated for the snapshot image
 
-SNAPSHOT_SET_IMAGE_SIZE - set the preferred maximum size of the image
+SNAPSHOT_PREF_IMAGE_SIZE - set the preferred maximum size of the image
 	(the kernel will do its best to ensure the image size will not exceed
 	this number, but if it turns out to be impossible, the kernel will
 	create the smallest image possible)
 
 SNAPSHOT_GET_IMAGE_SIZE - return the actual size of the hibernation image
 
-SNAPSHOT_AVAIL_SWAP - return the amount of available swap in bytes (the last
-	argument should be a pointer to an unsigned int variable that will
+SNAPSHOT_AVAIL_SWAP_SIZE - return the amount of available swap in bytes (the
+	last argument should be a pointer to an unsigned int variable that will
 	contain the result if the call is successful).
 
-SNAPSHOT_GET_SWAP_PAGE - allocate a swap page from the resume partition
+SNAPSHOT_ALLOC_SWAP_PAGE - allocate a swap page from the resume partition
 	(the last argument should be a pointer to a loff_t variable that
 	will contain the swap page offset if the call is successful)
 
-SNAPSHOT_FREE_SWAP_PAGES - free all swap pages allocated with
-	SNAPSHOT_GET_SWAP_PAGE
+SNAPSHOT_FREE_SWAP_PAGES - free all swap pages allocated by
+	SNAPSHOT_ALLOC_SWAP_PAGE
 
 SNAPSHOT_SET_SWAP_AREA - set the resume partition and the offset (in <PAGE_SIZE>
 	units) from the beginning of the partition at which the swap header is
@@ -102,7 +102,7 @@ The device's write() operation is used for uploading the system memory snapshot
 into the kernel.  It has the same limitations as the read() operation.
 
 The release() operation frees all memory allocated for the snapshot image
-and all swap pages allocated with SNAPSHOT_GET_SWAP_PAGE (if any).
+and all swap pages allocated with SNAPSHOT_ALLOC_SWAP_PAGE (if any).
 Thus it is not necessary to use either SNAPSHOT_FREE or
 SNAPSHOT_FREE_SWAP_PAGES before closing the device (in fact it will also
 unfreeze user space processes frozen by SNAPSHOT_UNFREEZE if they are
@@ -113,7 +113,7 @@ snapshot image from/to the kernel will use a swap parition, called the resume
 partition, or a swap file as storage space (if a swap file is used, the resume
 partition is the partition that holds this file).  However, this is not really
 required, as they can use, for example, a special (blank) suspend partition or
-a file on a partition that is unmounted before SNAPSHOT_ATOMIC_SNAPSHOT and
+a file on a partition that is unmounted before SNAPSHOT_CREATE_IMAGE and
 mounted afterwards.
 
 These utilities MUST NOT make any assumptions regarding the ordering of
@@ -135,7 +135,7 @@ means, such as checksums, to ensure the integrity of the snapshot image.
 The suspending and resuming utilities MUST lock themselves in memory,
 preferrably using mlockall(), before calling SNAPSHOT_FREEZE.
 
-The suspending utility MUST check the value stored by SNAPSHOT_ATOMIC_SNAPSHOT
+The suspending utility MUST check the value stored by SNAPSHOT_CREATE_IMAGE
 in the memory location pointed to by the last argument of ioctl() and proceed
 in accordance with it:
 1. 	If the value is 1 (ie. the system memory snapshot has just been
@@ -149,7 +149,7 @@ in accordance with it:
 		image has been saved.
 	(b)	The suspending utility SHOULD NOT attempt to perform any
 		file system operations (including reads) on the file systems
-		that were mounted before SNAPSHOT_ATOMIC_SNAPSHOT has been
+		that were mounted before SNAPSHOT_CREATE_IMAGE has been
 		called.  However, it MAY mount a file system that was not
 		mounted at that time and perform some operations on it (eg.
 		use it for saving the image).
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 8837ea3..0dd66fa 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -147,12 +147,8 @@ struct resume_swap_area {
 #define SNAPSHOT_IOC_MAGIC	'3'
 #define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
 #define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
-#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
 #define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
 #define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
-#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
-#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
-#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
 #define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
@@ -160,7 +156,11 @@ struct resume_swap_area {
 #define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
 #define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
 #define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
-#define SNAPSHOT_IOC_MAXNR	16
+#define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
+#define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
+#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
+#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
+#define SNAPSHOT_IOC_MAXNR	20
 
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 5e866e0..b902a7e 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -40,6 +40,16 @@
 #define PMOPS_ENTER	2
 #define PMOPS_FINISH	3
 
+/*
+ * NOTE: The following ioctl definitions are wrong and have been replaced with
+ * correct ones.  They are only preserved here for compatibility with existing
+ * userland utilities and will be removed in the future.
+ */
+#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
+#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
+#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
+#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
+
 
 #define SNAPSHOT_MINOR	231
 
@@ -191,6 +201,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		data->frozen = 0;
 		break;
 
+	case SNAPSHOT_CREATE_IMAGE:
 	case SNAPSHOT_ATOMIC_SNAPSHOT:
 		if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
 			error = -EPERM;
@@ -198,7 +209,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		}
 		error = hibernation_snapshot(data->platform_support);
 		if (!error)
-			error = put_user(in_suspend, (unsigned int __user *)arg);
+			error = put_user(in_suspend, (int __user *)arg);
 		if (!error)
 			data->ready = 1;
 		break;
@@ -219,6 +230,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		data->ready = 0;
 		break;
 
+	case SNAPSHOT_PREF_IMAGE_SIZE:
 	case SNAPSHOT_SET_IMAGE_SIZE:
 		image_size = arg;
 		break;
@@ -233,12 +245,14 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		error = put_user(size, (loff_t __user *)arg);
 		break;
 
+	case SNAPSHOT_AVAIL_SWAP_SIZE:
 	case SNAPSHOT_AVAIL_SWAP:
 		size = count_swap_pages(data->swap, 1);
 		size <<= PAGE_SHIFT;
 		error = put_user(size, (loff_t __user *)arg);
 		break;
 
+	case SNAPSHOT_ALLOC_SWAP_PAGE:
 	case SNAPSHOT_GET_SWAP_PAGE:
 		if (data->swap < 0 || data->swap >= MAX_SWAPFILES) {
 			error = -ENODEV;
@@ -247,7 +261,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		offset = alloc_swapdev_block(data->swap);
 		if (offset) {
 			offset <<= PAGE_SHIFT;
-			error = put_user(offset, (sector_t __user *)arg);
+			error = put_user(offset, (loff_t __user *)arg);
 		} else {
 			error = -ENOSPC;
 		}
-- 
1.5.4.rc5.16.gc0279

