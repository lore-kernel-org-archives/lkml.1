Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZASCP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZASCP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbZASCPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:15:17 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:55586 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbZASCPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:15:16 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question 
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <10394.1232214142@jrobl>
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com> <496FAFE2.8020102@linux.vnet.ibm.com> <9829.1232091366@jrobl> <1232125169.15209.19.camel@norville.austin.ibm.com> <7210.1232172192@jrobl> <1232210546.7015.8.camel@norville.austin.ibm.com> <10394.1232214142@jrobl>
Date: Mon, 19 Jan 2009 11:15:09 +0900
Message-ID: <7070.1232331309@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, testing by d_unhashed() is best, I think.
> But all inode attributes are maintained by ecryptfs_interpose(), so you
> don't need to handle them.
> 
> And I found another bug in ecryptfs_link().
> Here is a patch including that.

I forgot i_count.
Here is the fixed one.

J. R. Okajima

----------------------------------------------------------------------
refine ecryptfs_link()

ecryptfs_link() doesn't need to,,,
- copy i_nlink and i_size for the target inode since they are already
  handled by ecryptfs_interpose(). (I don't know why i_size was
  necessary)
- maintain dir attributes based upon the lower dir, instead of
  lower_new_dentry. (another bug)
- several d_drop()s. do it only when the lower_new_dentry is d_drop()ed
  by the lower fs or vfs_link() failed.
- testing lower_new_dentry->d_inode after vfs_link() succeeded.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>

diff -u -p -r1.1 inode.c
--- fs/ecryptfs/inode.c	19 Dec 2008 03:05:27 -0000	1.1
+++ fs/ecryptfs/inode.c	18 Jan 2009 05:22:35 -0000
@@ -405,10 +407,8 @@ static int ecryptfs_link(struct dentry *
 	struct dentry *lower_old_dentry;
 	struct dentry *lower_new_dentry;
 	struct dentry *lower_dir_dentry;
-	u64 file_size_save;
 	int rc;
 
-	file_size_save = i_size_read(old_dentry->d_inode);
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
@@ -416,23 +416,26 @@ static int ecryptfs_link(struct dentry *
 	lower_dir_dentry = lock_parent(lower_new_dentry);
 	rc = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
 		      lower_new_dentry);
-	if (rc || !lower_new_dentry->d_inode)
-		goto out_lock;
-	rc = ecryptfs_interpose(lower_new_dentry, new_dentry, dir->i_sb, 0);
-	if (rc)
-		goto out_lock;
-	fsstack_copy_attr_times(dir, lower_new_dentry->d_inode);
-	fsstack_copy_inode_size(dir, lower_new_dentry->d_inode);
-	old_dentry->d_inode->i_nlink =
-		ecryptfs_inode_to_lower(old_dentry->d_inode)->i_nlink;
-	i_size_write(new_dentry->d_inode, file_size_save);
-out_lock:
+	if (!rc) {
+		fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
+		fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
+		if (!d_unhashed(lower_new_dentry)
+		    /* && lower_new_dentry->d_inode */) {
+			rc = ecryptfs_interpose(lower_new_dentry, new_dentry,
+						dir->i_sb, 0);
+			if (!rc) {
+				/* ecryptfs_interpose() doesn't increment */
+				atomic_inc(&inode->i_count);
+				goto out_lock; /* success */
+			}
+		}
+	}
+ out_drop:
+	d_drop(new_dentry);
+ out_lock:
 	unlock_dir(lower_dir_dentry);
 	dput(lower_new_dentry);
 	dput(lower_old_dentry);
-	d_drop(lower_old_dentry);
-	d_drop(new_dentry);
-	d_drop(old_dentry);
 	return rc;
 }
 
