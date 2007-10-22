Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbXJVG4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbXJVG4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXJVG4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:56:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45351 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbXJVG4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:56:40 -0400
Date: Mon, 22 Oct 2007 12:26:32 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] Remove path_release_on_umount()
Message-ID: <20071022065632.GD6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

path_release_on_umount() should only be called from sys_umount(). I merged the
function into sys_umount() instead of having in in namei.c.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c            |   10 ----------
 fs/namespace.c        |    4 +++-
 include/linux/namei.h |    1 -
 3 files changed, 3 insertions(+), 12 deletions(-)

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
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -73,7 +73,6 @@ extern int FASTCALL(path_lookup(const ch
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern void path_release(struct nameidata *);
-extern void path_release_on_umount(struct nameidata *);
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
