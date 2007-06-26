Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbXFZXRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbXFZXRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759691AbXFZXKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:10:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:53733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759932AbXFZXKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:10:44 -0400
Message-Id: <20070626230958.643642585@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:12 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 16/44] Call lsm hook before unhashing dentry in vfs_rmdir()
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
@@ -2034,6 +2034,10 @@ int vfs_rmdir(struct inode *dir, struct 
 	if (!dir->i_op || !dir->i_op->rmdir)
 		return -EPERM;
 
+	error = security_inode_rmdir(dir, dentry, mnt);
+	if (error)
+		return error;
+
 	DQUOT_INIT(dir);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -2041,12 +2045,9 @@ int vfs_rmdir(struct inode *dir, struct 
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
