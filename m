Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXLTOSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXLTOSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932919AbXLTOLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:56639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbXLTOLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:39 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:44 2007
Message-Id: <20071220140943.818929776@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:26 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 16/47] Call lsm hook before unhashing dentry in vfs_rmdir()
Content-Disposition: inline; filename=fix-vfs_rmdir.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -2212,6 +2212,10 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->rmdir)
 		return -EPERM;
 
+	error = security_inode_rmdir(dir, dentry, mnt);
+	if (error)
+		return error;
+
 	DQUOT_INIT(dir);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -2219,12 +2223,9 @@ int vfs_rmdir(struct inode *dir, struct 
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

