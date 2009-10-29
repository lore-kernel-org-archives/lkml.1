Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZJ2T3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZJ2T3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbZJ2T3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:29:07 -0400
Received: from kroah.org ([198.145.64.141]:34062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZJ2T3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:29:06 -0400
Subject: patch driver-core-devtmpfs-ignore-umask-while-setting-file-mode.patch added to gregkh-2.6 tree
To: kay.sievers@vrfy.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 29 Oct 2009 12:29:05 -0700
In-Reply-To: <1256755857.2618.320.camel@yio.site>
Message-ID: <12568445454148@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Driver Core: devtmpfs: ignore umask while setting file mode

to my gregkh-2.6 tree.  Its filename is

    driver-core-devtmpfs-ignore-umask-while-setting-file-mode.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kay.sievers@vrfy.org  Thu Oct 29 11:59:08 2009
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 28 Oct 2009 19:50:57 +0100
Subject: Driver Core: devtmpfs: ignore umask while setting file mode
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1256755857.2618.320.camel@yio.site>


From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/devtmpfs.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -156,34 +156,38 @@ int devtmpfs_create_node(struct device *
 		mode |= S_IFCHR;
 
 	curr_cred = override_creds(&init_cred);
+
 	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
 			      nodename, LOOKUP_PARENT, &nd);
 	if (err == -ENOENT) {
-		/* create missing parent directories */
 		create_path(nodename);
 		err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
 				      nodename, LOOKUP_PARENT, &nd);
-		if (err)
-			goto out;
 	}
+	if (err)
+		goto out;
 
 	dentry = lookup_create(&nd, 0);
 	if (!IS_ERR(dentry)) {
-		int umask;
-
-		umask = sys_umask(0000);
 		err = vfs_mknod(nd.path.dentry->d_inode,
 				dentry, mode, dev->devt);
-		sys_umask(umask);
-		/* mark as kernel created inode */
-		if (!err)
+		if (!err) {
+			struct iattr newattrs;
+
+			/* fixup possibly umasked mode */
+			newattrs.ia_mode = mode;
+			newattrs.ia_valid = ATTR_MODE;
+			notify_change(dentry, &newattrs);
+
+			/* mark as kernel-created inode */
 			dentry->d_inode->i_private = &dev_mnt;
+		}
 		dput(dentry);
 	} else {
 		err = PTR_ERR(dentry);
 	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_put(&nd.path);
 out:
 	kfree(tmp);

