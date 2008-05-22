Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbYEVLxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbYEVLxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbYEVLw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:52:28 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:49744 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYEVLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:52:26 -0400
Message-Id: <20080522114947.310735375@kerlabs.com>
References: <20080522114048.265996107@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 13:40:49 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: [RFC][PATCH 1/4] Prepare i_mutex lockdep subclasses for locking of variable path lengths
Content-Disposition: inline; filename=prepare-variable-path-lengths-inode-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some filesystems, like configfs, need to lock more than two regular inodes
recursively in a tree, which i_mutex lockdep subclasses do not permit.

This patch reorders the definitions (but not the semantics) of i_mutex lockdep
sub-classes so that nested i_mutex locking can be done with sub-classes
I_MUTEX_PARENT -> I_MUTEX_CHILD -> I_MUTEX_CHILD + 1 -> I_MUTEX_CHILD + 2 -> ...
until MAX_LOCKDEP_SUBCLASSES - 1.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 include/linux/fs.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)


Index: b/include/linux/fs.h
===================================================================
--- a/include/linux/fs.h	2008-05-21 09:40:28.000000000 +0200
+++ b/include/linux/fs.h	2008-05-22 12:20:20.000000000 +0200
@@ -660,20 +660,23 @@ struct inode {
  * inode->i_mutex nesting subclasses for the lock validator:
  *
  * 0: the object of the current VFS operation
- * 1: parent
- * 2: child/target
- * 3: quota file
+ * 1: xattrs
+ * 2: quota file
+ * 3: parent
+ * 4: child/target
+ * ...: lower-level children
  *
  * The locking order between these classes is
- * parent -> child -> normal -> xattr -> quota
+ * parent -> child -> sub-children... -> normal -> xattr -> quota
  */
 enum inode_i_mutex_lock_class
 {
 	I_MUTEX_NORMAL,
+	I_MUTEX_XATTR,
+	I_MUTEX_QUOTA,
 	I_MUTEX_PARENT,
 	I_MUTEX_CHILD,
-	I_MUTEX_XATTR,
-	I_MUTEX_QUOTA
+	/* Reserved for variable paths of nested inode locks */
 };
 
 extern void inode_double_lock(struct inode *inode1, struct inode *inode2);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

