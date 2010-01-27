Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535Ab0A0QqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0A0QqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156Ab0A0QqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:46:23 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:45434 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0A0QqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:46:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/2] PM: really deprecate deprecated user ioctls
Date: Wed, 27 Jan 2010 17:46:17 +0100
Message-Id: <1264610778-13242-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were deprecated and removed from exported headers more than 2
years ago. Inform users about their removal in the future now.

(Switch cases needed to be reorderded for an easy fall through.)

And add an entry to feature-removal-schedule.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
---
 Documentation/feature-removal-schedule.txt |   11 +++++++++++
 kernel/power/user.c                        |   23 +++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0dc4dd7..a71a1c6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -64,6 +64,17 @@ Who:	Robin Getz <rgetz@blackfin.uclinux.org> & Matt Mackall <mpm@selenic.com>
 
 ---------------------------
 
+What:	Deprecated snapshot ioctls
+When:	2.6.36
+
+Why:	The ioctls in kernel/power/user.c were marked as deprecated long time
+	ago. Now they notify users about that so that they need to replace
+	their userspace. After some more time, remove them completely.
+
+Who:	Jiri Slaby <jirislaby@gmail.com>
+
+---------------------------
+
 What:	The ieee80211_regdom module parameter
 When:	March 2010 / desktop catchup
 
diff --git a/kernel/power/user.c b/kernel/power/user.c
index bf0014d..4d22896 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -195,6 +195,15 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 	return res;
 }
 
+static void snapshot_deprecated_ioctl(unsigned int cmd)
+{
+	if (printk_ratelimit())
+		printk(KERN_NOTICE "%pf: ioctl '%.8x' is deprecated and will "
+				"be removed soon, update your suspend-to-disk "
+				"utilities\n",
+				__builtin_return_address(0), cmd);
+}
+
 static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 							unsigned long arg)
 {
@@ -246,8 +255,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		data->frozen = 0;
 		break;
 
-	case SNAPSHOT_CREATE_IMAGE:
 	case SNAPSHOT_ATOMIC_SNAPSHOT:
+		snapshot_deprecated_ioctl(cmd);
+	case SNAPSHOT_CREATE_IMAGE:
 		if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
 			error = -EPERM;
 			break;
@@ -275,8 +285,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		data->ready = 0;
 		break;
 
-	case SNAPSHOT_PREF_IMAGE_SIZE:
 	case SNAPSHOT_SET_IMAGE_SIZE:
+		snapshot_deprecated_ioctl(cmd);
+	case SNAPSHOT_PREF_IMAGE_SIZE:
 		image_size = arg;
 		break;
 
@@ -290,15 +301,17 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = put_user(size, (loff_t __user *)arg);
 		break;
 
-	case SNAPSHOT_AVAIL_SWAP_SIZE:
 	case SNAPSHOT_AVAIL_SWAP:
+		snapshot_deprecated_ioctl(cmd);
+	case SNAPSHOT_AVAIL_SWAP_SIZE:
 		size = count_swap_pages(data->swap, 1);
 		size <<= PAGE_SHIFT;
 		error = put_user(size, (loff_t __user *)arg);
 		break;
 
-	case SNAPSHOT_ALLOC_SWAP_PAGE:
 	case SNAPSHOT_GET_SWAP_PAGE:
+		snapshot_deprecated_ioctl(cmd);
+	case SNAPSHOT_ALLOC_SWAP_PAGE:
 		if (data->swap < 0 || data->swap >= MAX_SWAPFILES) {
 			error = -ENODEV;
 			break;
@@ -321,6 +334,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_SET_SWAP_FILE: /* This ioctl is deprecated */
+		snapshot_deprecated_ioctl(cmd);
 		if (!swsusp_swap_in_use()) {
 			/*
 			 * User space encodes device types as two-byte values,
@@ -362,6 +376,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_PMOPS: /* This ioctl is deprecated */
+		snapshot_deprecated_ioctl(cmd);
 		error = -EINVAL;
 
 		switch (arg) {
-- 
1.6.6.1

