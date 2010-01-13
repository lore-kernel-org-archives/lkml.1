Return-Path: <linux-kernel-owner+w=401wt.eu-S932078Ab0AMNQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0AMNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725Ab0AMNQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:16:57 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55572 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0AMNQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:16:57 -0500
Subject: Driver-Core: devtmpfs - reset inode permissions before unlinking
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 14:16:36 +0100
Message-ID: <1263388596.26006.1.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: devtmpfs - reset inode permissions before unlinking

Before unlinking the inode, reset the current permissions of possible
references like hardlinks, so granted permissions can not be retained
across the device lifetime by creating hardlinks, in the unusual case
that there is a user-writable directory on the same filesystem.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
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


