Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYFHJAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYFHJAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYFHJAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:00:08 -0400
Received: from 1wt.eu ([62.212.114.60]:1543 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbYFHJAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:00:06 -0400
Date: Sun, 8 Jun 2008 10:59:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Missing patch from stable [3/7]
Message-ID: <20080608085923.GC6439@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch from mainline seems suitable for -stable, but was not proposed
for inclusion. I think we should include it for next review unless the
author disagrees.

Thanks,
Willy
--

>From 8dc4e37362a5dc910d704d52ac6542bfd49ddc2f Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@suse.cz>
Date: Mon, 12 May 2008 14:02:04 -0700
Subject: ecryptfs: clean up (un)lock_parent

dget(dentry->d_parent) --> dget_parent(dentry)

unlock_parent() is racy and unnecessary.  Replace single caller with
unlock_dir().

There are several other suspect uses of ->d_parent in ecryptfs...

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ecryptfs/inode.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0a13973..c92cc1c 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -37,17 +37,11 @@ static struct dentry *lock_parent(struct dentry *dentry)
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
@@ -426,8 +420,9 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
 	int rc = 0;
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
+	struct dentry *lower_dir_dentry;
 
-	lock_parent(lower_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
@@ -439,7 +434,7 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
-	unlock_parent(lower_dentry);
+	unlock_dir(lower_dir_dentry);
 	return rc;
 }
 
-- 
1.5.3.8

