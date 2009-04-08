Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbZDHHGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbZDHHGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761485AbZDHHGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:06:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbZDHHGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:06:19 -0400
Message-ID: <49DC4D0E.9090807@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:06:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: chris.mason@oracle.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
In-Reply-To: <49DC4CC0.9050805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user().

Note this changes some GFP_NOFS to GFP_KERNEL, since copy_from_user() may
cause pagefault, it's pointless to pass GFP_NOFS to kmalloc().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   49 ++++++++++++-------------------------------------
 fs/btrfs/super.c |   13 ++++---------
 2 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7594bec..9f135e8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -461,15 +461,9 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
-
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
@@ -545,7 +539,6 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 
 out_unlock:
 	mutex_unlock(&root->fs_info->volume_mutex);
-out:
 	kfree(vol_args);
 	return ret;
 }
@@ -565,15 +558,9 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
-
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
@@ -675,19 +662,13 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
-out:
 	kfree(vol_args);
 	return ret;
 }
@@ -703,19 +684,13 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
-	if (!vol_args)
-		return -ENOMEM;
-
-	if (copy_from_user(vol_args, arg, sizeof(*vol_args))) {
-		ret = -EFAULT;
-		goto out;
-	}
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_rm_device(root, vol_args->name);
 
-out:
 	kfree(vol_args);
 	return ret;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9744af9..a7acfe6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -635,14 +635,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	vol = kmalloc(sizeof(*vol), GFP_KERNEL);
-	if (!vol)
-		return -ENOMEM;
-
-	if (copy_from_user(vol, (void __user *)arg, sizeof(*vol))) {
-		ret = -EFAULT;
-		goto out;
-	}
+	vol = memdup_user((void __user *)arg, sizeof(*vol));
+	if (IS_ERR(vol))
+		return PTR_ERR(vol);
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
@@ -650,7 +645,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 					    &btrfs_fs_type, &fs_devices);
 		break;
 	}
-out:
+
 	kfree(vol);
 	return ret;
 }
-- 
1.5.4.rc3


