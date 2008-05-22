Return-Path: <linux-kernel-owner+w=401wt.eu-S934611AbYEVLxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbYEVLxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbYEVLw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:52:57 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:37527 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbYEVLw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:52:28 -0400
Message-Id: <20080522114947.449481659@kerlabs.com>
References: <20080522114048.265996107@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 13:40:50 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: [RFC][PATCH 2/4] Prepare vfs_rmdir() for further nested i_mutex locking
Content-Disposition: inline; filename=prepare-vfs-rmdir-for-further-nested-inode-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

configfs_rmdir() needs to lock recursively a whole tree of i_mutex in order to
provide userspace and client sub-systems with atomic semantics. However,
vfs_rmdir() locks the to-be-removed inode with sub-class I_MUTEX_NORMAL, which
does not allow futher I_MUTEX_CHILD + x nested locks. Luckily this is a case of
I_MUTEX_PARENT -> I_MUTEX_CHILD lock dependency pattern, where do_rmdir() takes
parent's inode with sub-class I_MUTEX_PARENT.

This patch changes the sub-class of i_mutex lock in vfs_rmdir() from
I_MUTEX_NORMAL to I_MUTEX_CHILD, which allows further nested i_mutex locking as
configfs needs. Existing lock dependencies should not be impacted since
I_MUTEX_CHILD can only preceed I_MUTEX_NORMAL in locking order, and nobody locks
with sub-class I_MUTEX_CHILD before calling vfs_rmdir().

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c	2008-05-21 09:40:26.000000000 +0200
+++ b/fs/namei.c	2008-05-22 12:21:27.000000000 +0200
@@ -2232,7 +2232,7 @@ int vfs_rmdir(struct inode *dir, struct 
 
 	DQUOT_INIT(dir);
 
-	mutex_lock(&dentry->d_inode->i_mutex);
+	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	dentry_unhash(dentry);
 	if (d_mountpoint(dentry))
 		error = -EBUSY;

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

