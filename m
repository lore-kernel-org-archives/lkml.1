Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZASM6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZASM6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbZASM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:57:56 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:20024 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212AbZASM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:57:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pMw49YZQCSXieZwBthGdk9h+3WsUQb+XZoruarigTtUJluhSUXZcxT30gTJmxJecgm
         T7MHLTU/qvYvId02r9rU901liGrKXXOVEeTLlfXKeAQiAPGlOoiILoT3Zj0eU+h1jO/u
         UeWE25qLdod3tgTLrqUqakGXL+3EDBqdS2LRY=
Date: Mon, 19 Jan 2009 20:57:32 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
	btrfs_ioctl_vol_args
Message-ID: <20090119125732.GA7424@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
it also looks that this one is more proper.

Kill BTRFS_PATH_NAME_MAX since no one will use it.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Chris Mason <chris.mason@oracle.com>

---
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c2aa33e..f229950 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -472,7 +472,7 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 		goto out;
 	}
 
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
 
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -576,7 +576,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		goto out;
 	}
 
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
 	if (strchr(vol_args->name, '/')) {
 		ret = -EINVAL;
@@ -685,7 +685,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 		ret = -EFAULT;
 		goto out;
 	}
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
 out:
@@ -713,7 +713,7 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 		ret = -EFAULT;
 		goto out;
 	}
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	ret = btrfs_rm_device(root, vol_args->name);
 
 out:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index b320b10..f5d182a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -22,12 +22,10 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
 
-/* this should be 4k */
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
-	char name[BTRFS_PATH_NAME_MAX + 1];
+	char name[BTRFS_VOL_NAME_MAX + 1];
 };
 
 struct btrfs_ioctl_clone_range_args {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db9fb3b..5facdbf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -593,7 +593,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = -EFAULT;
 		goto out;
 	}
-	len = strnlen(vol->name, BTRFS_PATH_NAME_MAX);
+	len = strnlen(vol->name, BTRFS_VOL_NAME_MAX);
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:

