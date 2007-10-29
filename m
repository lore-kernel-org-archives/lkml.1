Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXKAVg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXKAVg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXKAVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:35:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbXKAVfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:35:46 -0400
Message-Id: <20071029124120.979011558@weierstrass.suse.de>
References: <20071029124120.528997881@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 29 Oct 2007 13:41:21 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH 1/7] One less parameter to __d_path
Content-Disposition: inline; filename=vfs/one-less-parameter-to-__d_path.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All callers to __d_path pass the dentry and vfsmount of a struct
path to __d_path. Pass the struct path directly, instead.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/dcache.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: b/fs/dcache.c
===================================================================
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1778,9 +1778,8 @@ shouldnt_be_hashed:
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-static char * __d_path( struct dentry *dentry, struct vfsmount *vfsmnt,
-			struct dentry *root, struct vfsmount *rootmnt,
-			char *buffer, int buflen)
+static char * __d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+		       struct path *root, char *buffer, int buflen)
 {
 	char * end = buffer+buflen;
 	char * retval;
@@ -1805,7 +1804,7 @@ static char * __d_path( struct dentry *d
 	for (;;) {
 		struct dentry * parent;
 
-		if (dentry == root && vfsmnt == rootmnt)
+		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
@@ -1868,7 +1867,7 @@ char * d_path(struct dentry *dentry, str
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, root.dentry, root.mnt, buf, buflen);
+	res = __d_path(dentry, vfsmnt, &root, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1936,8 +1935,7 @@ asmlinkage long sys_getcwd(char __user *
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, root.dentry, root.mnt,
-			       page, PAGE_SIZE);
+		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);

-- 

