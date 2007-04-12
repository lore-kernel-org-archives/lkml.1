Return-Path: <linux-kernel-owner+w=401wt.eu-S1945968AbXDLJ5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968AbXDLJ5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965564AbXDLJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:57:12 -0400
Received: from ns.suse.de ([195.135.220.2]:57873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945973AbXDLJkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:31 -0400
Message-Id: <20070412090842.085942000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:27 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, John Johansen <jjohansen@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 18/41] call lsm hook before unhashing dentry in vfs_rmdir()
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
@@ -2016,6 +2016,10 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->rmdir)
 		return -EPERM;
 
+	error = security_inode_rmdir(dir, dentry, mnt);
+	if (error)
+		return error;
+
 	DQUOT_INIT(dir);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -2023,12 +2027,9 @@ int vfs_rmdir(struct inode *dir, struct 
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
