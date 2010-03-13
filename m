Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936442Ab0CMBZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:25:34 -0500
Received: from kroah.org ([198.145.64.141]:60728 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934817Ab0CMAUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:11 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001509.808784125@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 053/123] Driver-Core: devtmpfs - reset inode permissions before unlinking
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit 5e31d76f2817bd50258a092a7c5b15b3006fd61c upstream.

Before unlinking the inode, reset the current permissions of possible
references like hardlinks, so granted permissions can not be retained
across the device lifetime by creating hardlinks, in the unusual case
that there is a user-writable directory on the same filesystem.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/devtmpfs.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -301,6 +301,19 @@ int devtmpfs_delete_node(struct device *
 		if (dentry->d_inode) {
 			err = vfs_getattr(nd.path.mnt, dentry, &stat);
 			if (!err && dev_mynode(dev, dentry->d_inode, &stat)) {
+				struct iattr newattrs;
+				/*
+				 * before unlinking this node, reset permissions
+				 * of possible references like hardlinks
+				 */
+				newattrs.ia_uid = 0;
+				newattrs.ia_gid = 0;
+				newattrs.ia_mode = stat.mode & ~0777;
+				newattrs.ia_valid =
+					ATTR_UID|ATTR_GID|ATTR_MODE;
+				mutex_lock(&dentry->d_inode->i_mutex);
+				notify_change(dentry, &newattrs);
+				mutex_unlock(&dentry->d_inode->i_mutex);
 				err = vfs_unlink(nd.path.dentry->d_inode,
 						 dentry);
 				if (!err || err == -ENOENT)


