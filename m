Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZJ1SvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZJ1SvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZJ1SvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:51:07 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39415 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZJ1SvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:51:05 -0400
Subject: Driver-Core: devtmpfs - ignore umask while setting file mode
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 19:50:57 +0100
Message-Id: <1256755857.2618.320.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: devtmpfs - ignore umask while setting file mode

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
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

