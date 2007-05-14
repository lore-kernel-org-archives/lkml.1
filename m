Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbXENLlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbXENLlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030684AbXENLdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:33:19 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27936 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762223AbXENLcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:41 -0400
Message-Id: <20070514110613.785404825@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:23 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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
