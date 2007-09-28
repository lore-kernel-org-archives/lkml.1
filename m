Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbXI1Ui7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbXI1Ui7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXI1Uiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:38:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbXI1Uiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:38:51 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 09/10] Use struct path in fs_struct
Date: Fri, 28 Sep 2007 22:39:48 +0200
User-Agent: KMail/1.9.5
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       tiwai@suse.de
References: <20070927141200.820970144@X40.localnet> <20070927141229.008500593@X40.localnet> <20070928184214.GI14269@lst.de>
In-Reply-To: <20070928184214.GI14269@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709282239.49088.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 20:42, Christoph Hellwig wrote:
> __d_path should probably switch to taking a struct path * aswell.

Indeed, it now easily can. Here we go...


One less parameter to __d_path

All callers to __d_path pass the dentry and vfsmount of a struct
path to __d_path. Pass the struct path directly, instead.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1781,9 +1781,8 @@ shouldnt_be_hashed:
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
@@ -1808,7 +1807,7 @@ static char * __d_path( struct dentry *d
 	for (;;) {
 		struct dentry * parent;
 
-		if (dentry == root && vfsmnt == rootmnt)
+		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
@@ -1870,7 +1869,7 @@ char * d_path(struct dentry *dentry, str
 	root = *path_get(&current->fs->root);
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
