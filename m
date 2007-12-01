Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbXLAUbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbXLAUbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXLAUbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:31:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:3791 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbXLAUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eri/EvQ8yo7P78eILy7+f0wG2G+fzvo8isKRuEKEZPDYq+P+oMvbfaySXAPkOBZTIfhKPDZH2B2LKFqlTY4DdUeCFgQjt/yQ9CRcFZrX9xFSNopckh6llSialxqIa83LDyrlSUVgoRvTAUK3euUgLhmuQf+fKCJy/be6kwtl7qs=
Message-ID: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com>
Date: Sun, 2 Dec 2007 04:31:09 +0800
From: "rae l" <crquan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Since sysfs_mount is static and used only in sysfs_init function, it could be just an automatic variable.
Cc: gregkh@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
and I still have questions about this code:
1. Why here kern_mount is needed?
	Or the first time user space `mount -t sysfs` won't do that?
2. If root executes many mounts to mount sysfs on /sys and many other places,
	are there many instances of struct vfsmount those have only
mnt_mountpoint different?

	For most common case, mount a virtual filesystem(proc, sysfs, ...) on
multiple mounting point,
	how to handle it more efficiently?

and where is a detailed explaination on kern_mount? could someone give
some comments or documentation pointers on this?

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 7416826..add0dda 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -22,7 +22,6 @@
 /* Random magic number */
 #define SYSFS_MAGIC 0x62656572

-static struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;

@@ -98,11 +97,10 @@ int __init sysfs_init(void)

 	err = register_filesystem(&sysfs_fs_type);
 	if (!err) {
-		sysfs_mount = kern_mount(&sysfs_fs_type);
+		struct vfsmount *sysfs_mount = kern_mount(&sysfs_fs_type);
 		if (IS_ERR(sysfs_mount)) {
 			printk(KERN_ERR "sysfs: could not mount!\n");
 			err = PTR_ERR(sysfs_mount);
-			sysfs_mount = NULL;
 			unregister_filesystem(&sysfs_fs_type);
 			goto out_err;
 		}

-- 
Denis Cheng
