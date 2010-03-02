Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0CBX4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:56:44 -0500
Received: from kroah.org ([198.145.64.141]:38534 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0CBX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/62] Driver-Core: devtmpfs - reset inode permissions before unlinking
Date: Tue,  2 Mar 2010 15:28:17 -0800
Message-Id: <1267572541-410-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Before unlinking the inode, reset the current permissions of possible
references like hardlinks, so granted permissions can not be retained
across the device lifetime by creating hardlinks, in the unusual case
that there is a user-writable directory on the same filesystem.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 42ae452..dac478c 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -301,6 +301,19 @@ int devtmpfs_delete_node(struct device *dev)
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
-- 
1.7.0.1

