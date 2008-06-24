Return-Path: <linux-kernel-owner+w=401wt.eu-S1762365AbYFXOwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762365AbYFXOwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYFXOuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:50:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58197 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845AbYFXOuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:50:50 -0400
Message-Id: <20080624145046.609698202@szeredi.hu>
References: <20080624145011.722691277@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jun 2008 16:50:15 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [patch 4/5] vfs: reuse local variable in vfs_link()
Content-Disposition: inline; filename=vfs-reuse-local-variable-in-vfs_link.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

Why not reuse "inode" which is assigned as

  struct inode *inode = old_dentry->d_inode;

in the beginning of vfs_link() ?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-06-24 16:13:32.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-06-24 16:26:00.000000000 +0200
@@ -2498,19 +2498,19 @@ int vfs_link(struct dentry *old_dentry, 
 		return -EPERM;
 	if (!dir->i_op || !dir->i_op->link)
 		return -EPERM;
-	if (S_ISDIR(old_dentry->d_inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
 	error = security_inode_link(old_dentry, dir, new_dentry);
 	if (error)
 		return error;
 
-	mutex_lock(&old_dentry->d_inode->i_mutex);
+	mutex_lock(&inode->i_mutex);
 	DQUOT_INIT(dir);
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
-	mutex_unlock(&old_dentry->d_inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 	if (!error)
-		fsnotify_link(dir, old_dentry->d_inode, new_dentry);
+		fsnotify_link(dir, inode, new_dentry);
 	return error;
 }
 

--
