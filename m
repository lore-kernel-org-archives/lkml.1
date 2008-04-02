Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYDBRAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYDBRAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbYDBRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:00:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53035 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbYDBRAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:00:40 -0400
To: mhalcrow@us.ibm.com
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] ecryptfs: add missing lock around notify_change
Message-Id: <E1Jh6Jy-0006Me-Bo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Apr 2008 19:00:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Caller of notify_change() need to hold i_mutex.

Compile tested only.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-02 18:47:17.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-02 18:49:18.000000000 +0200
@@ -908,7 +908,9 @@ static int ecryptfs_setattr(struct dentr
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = notify_change(lower_dentry, ia);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;
