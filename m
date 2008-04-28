Return-Path: <linux-kernel-owner+w=401wt.eu-S935097AbYD1Ojp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097AbYD1Ojp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933797AbYD1Oiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:38:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbYD1Oir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:38:47 -0400
Message-Id: <20080428163731.946190111@T61.localnet>
User-Agent: quilt/0.46_cvs20080326-8
Date: Mon, 28 Apr 2008 18:37:32 +0200
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-fsdevel Mailinglist <linux-fsdevel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk
Subject: [PATCH 1/3] VFS: path_{get,put}() cleanups
References: <20080428163731.774191296@T61.localnet>
Content-Disposition: inline; filename=vfs/path_get_put-cleanups.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more places where path_{get,put}() can be used instead of
dput()/mntput() pair.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c |   11 +++++------
 fs/pipe.c  |   10 ++++------
 2 files changed, 9 insertions(+), 12 deletions(-)

Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -582,15 +582,13 @@ static __always_inline int link_path_wal
 	int result;
 
 	/* make sure the stuff we saved doesn't go away */
-	dget(save.dentry);
-	mntget(save.mnt);
+	path_get(&save);
 
 	result = __link_path_walk(name, nd);
 	if (result == -ESTALE) {
 		/* nd->path had been dropped */
 		nd->path = save;
-		dget(nd->path.dentry);
-		mntget(nd->path.mnt);
+		path_get(&nd->path);
 		nd->flags |= LOOKUP_REVAL;
 		result = __link_path_walk(name, nd);
 	}
@@ -1217,8 +1215,9 @@ int vfs_path_lookup(struct dentry *dentr
 	nd->flags = flags;
 	nd->depth = 0;
 
-	nd->path.mnt = mntget(mnt);
-	nd->path.dentry = dget(dentry);
+	nd->path.dentry = dentry;
+	nd->path.mnt = mnt;
+	path_get(&nd->path);
 
 	retval = path_walk(name, nd);
 	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
Index: b/fs/pipe.c
===================================================================
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -999,8 +999,7 @@ struct file *create_write_pipe(void)
 void free_write_pipe(struct file *f)
 {
 	free_pipe_info(f->f_dentry->d_inode);
-	dput(f->f_path.dentry);
-	mntput(f->f_path.mnt);
+	path_put(&f->f_path);
 	put_filp(f);
 }
 
@@ -1011,8 +1010,8 @@ struct file *create_read_pipe(struct fil
 		return ERR_PTR(-ENFILE);
 
 	/* Grab pipe from the writer */
-	f->f_path.mnt = mntget(wrf->f_path.mnt);
-	f->f_path.dentry = dget(wrf->f_path.dentry);
+	f->f_path = wrf->f_path;
+	path_get(&wrf->f_path);
 	f->f_mapping = wrf->f_path.dentry->d_inode->i_mapping;
 
 	f->f_pos = 0;
@@ -1064,8 +1063,7 @@ int do_pipe(int *fd)
  err_fdr:
 	put_unused_fd(fdr);
  err_read_pipe:
-	dput(fr->f_dentry);
-	mntput(fr->f_vfsmnt);
+	path_put(&fr->f_path);
 	put_filp(fr);
  err_write_pipe:
 	free_write_pipe(fw);


