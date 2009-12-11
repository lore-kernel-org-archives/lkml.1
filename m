Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbZLKWZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbZLKWZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762739AbZLKWZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:11 -0500
Received: from kroah.org ([198.145.64.141]:60992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762678AbZLKWYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/27] Driver Core: devtmpfs: ignore umask while setting file mode
Date: Fri, 11 Dec 2009 14:24:25 -0800
Message-Id: <1260570289-6997-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index a1cb5af..48526b9 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -156,34 +156,40 @@ int devtmpfs_create_node(struct device *dev)
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
+			mutex_lock(&dentry->d_inode->i_mutex);
+			notify_change(dentry, &newattrs);
+			mutex_unlock(&dentry->d_inode->i_mutex);
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
-- 
1.6.5.5

