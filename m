Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935852Ab0CMAvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:51:06 -0500
Received: from kroah.org ([198.145.64.141]:47036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935478Ab0CMAbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:12 2010
Message-Id: <20100313002712.641656529@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [085/145] Driver-Core: devtmpfs - reset inode permissions before unlinking
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
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
@@ -295,6 +295,19 @@ int devtmpfs_delete_node(struct device *
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


