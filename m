Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYDXLom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYDXLom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYDXLlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:41:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57212 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbYDXLkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:40:46 -0400
Message-Id: <20080424114009.672306626@szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Apr 2008 13:39:52 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 02/13] ecryptfs: clean up (un)lock_parent
Content-Disposition: inline; filename=ecryptfs_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

dget(dentry->d_parent) --> dget_parent(dentry)

unlock_parent() is racy and unnecessary.  Replace single caller with
unlock_dir().

There are several other suspect uses of ->d_parent in ecryptfs...

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-23 18:50:29.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-23 19:00:19.000000000 +0200
@@ -37,17 +37,11 @@ static struct dentry *lock_parent(struct
 {
 	struct dentry *dir;
 
-	dir = dget(dentry->d_parent);
+	dir = dget_parent(dentry);
 	mutex_lock_nested(&(dir->d_inode->i_mutex), I_MUTEX_PARENT);
 	return dir;
 }
 
-static void unlock_parent(struct dentry *dentry)
-{
-	mutex_unlock(&(dentry->d_parent->d_inode->i_mutex));
-	dput(dentry->d_parent);
-}
-
 static void unlock_dir(struct dentry *dir)
 {
 	mutex_unlock(&dir->d_inode->i_mutex);
@@ -426,8 +420,9 @@ static int ecryptfs_unlink(struct inode 
 	int rc = 0;
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
+	struct dentry *lower_dir_dentry;
 
-	lock_parent(lower_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
@@ -439,7 +434,7 @@ static int ecryptfs_unlink(struct inode 
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
-	unlock_parent(lower_dentry);
+	unlock_dir(lower_dir_dentry);
 	return rc;
 }
 

--
