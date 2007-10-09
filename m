Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbXJISIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbXJISIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXJISHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:07:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbXJISHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:07:42 -0400
Message-Id: <20071009180512.524561417@X40.localnet>
References: <20071009180503.075306583@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Tue, 09 Oct 2007 20:05:06 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [patch 03/10] Remove path_release_on_umount()
Content-Disposition: inline; filename=vfs/remove-path_release_on_umount.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

path_release_on_umount() should only be called from sys_umount(). I merged the
function into sys_umount() instead of having in in namei.c.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c            |   10 ----------
 fs/namespace.c        |    4 +++-
 include/linux/namei.h |    1 -
 3 files changed, 3 insertions(+), 12 deletions(-)

Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -368,16 +368,6 @@ void path_release(struct nameidata *nd)
 	mntput(nd->mnt);
 }
 
-/*
- * umount() mustn't call path_release()/mntput() as that would clear
- * mnt_expiry_mark
- */
-void path_release_on_umount(struct nameidata *nd)
-{
-	dput(nd->dentry);
-	mntput_no_expire(nd->mnt);
-}
-
 /**
  * release_open_intent - free up open intent resources
  * @nd: pointer to nameidata
Index: b/fs/namespace.c
===================================================================
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -988,7 +988,9 @@ asmlinkage long sys_umount(char __user *
 
 	retval = do_umount(nd.mnt, flags);
 dput_and_out:
-	path_release_on_umount(&nd);
+	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
+	dput(nd.dentry);
+	mntput_no_expire(nd.mnt);
 out:
 	return retval;
 }
Index: b/include/linux/namei.h
===================================================================
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -73,7 +73,6 @@ extern int FASTCALL(path_lookup(const ch
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern void path_release(struct nameidata *);
-extern void path_release_on_umount(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);

-- 

