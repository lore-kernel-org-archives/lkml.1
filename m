Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbXJZHDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbXJZHDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759851AbXJZG5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:57:42 -0400
Received: from ns.suse.de ([195.135.220.2]:34812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760592AbXJZG5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:57:40 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:49 2007
Message-Id: <20071026064049.136556423@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:40 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 16/45] Call lsm hook before unhashing dentry in vfs_rmdir()
Content-Disposition: inline; filename=fix-vfs_rmdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we unhash the dentry before calling the security_inode_rmdir hook,
we cannot compute the file's pathname in the hook anymore. AppArmor
needs to know the filename in order to decide whether a file may be
deleted, though.

Signed-off-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/namei.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2125,6 +2125,10 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->rmdir)
 		return -EPERM;
 
+	error = security_inode_rmdir(dir, dentry, mnt);
+	if (error)
+		return error;
+
 	DQUOT_INIT(dir);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -2132,12 +2136,9 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
 	else {
-		error = security_inode_rmdir(dir, dentry, mnt);
-		if (!error) {
-			error = dir->i_op->rmdir(dir, dentry);
-			if (!error)
-				dentry->d_inode->i_flags |= S_DEAD;
-		}
+		error = dir->i_op->rmdir(dir, dentry);
+		if (!error)
+			dentry->d_inode->i_flags |= S_DEAD;
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	if (!error) {

-- 

