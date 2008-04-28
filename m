Return-Path: <linux-kernel-owner+w=401wt.eu-S934858AbYD1OkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbYD1OkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934094AbYD1Oiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:38:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933530AbYD1Ois (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:38:48 -0400
Message-Id: <20080428163732.201203178@T61.localnet>
User-Agent: quilt/0.46_cvs20080326-8
Date: Mon, 28 Apr 2008 18:37:34 +0200
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-fsdevel Mailinglist <linux-fsdevel@vger.kernel.org>
Cc: raven@themaw.net, autofs@linux.kernel.org
Subject: [PATCH 3/3] AutoFS: path_{get,put}() cleanups
References: <20080428163731.774191296@T61.localnet>
Content-Disposition: inline; filename=vfs/path_get_put-cleanups-autofs.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more places where path_{get,put}() can be used instead of
dput()/mntput() pair. Besides that it fixes a bug in autofs4_mount_busy()
where mntput() was called before dput().

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/autofs4/expire.c |    2 +-
 fs/autofs4/root.c   |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: b/fs/autofs4/expire.c
===================================================================
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -73,8 +73,8 @@ static int autofs4_mount_busy(struct vfs
 	status = 0;
 done:
 	DPRINTK("returning = %d", status);
-	mntput(mnt);
 	dput(dentry);
+	mntput(mnt);
 	return status;
 }
 
Index: b/fs/autofs4/root.c
===================================================================
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -146,17 +146,17 @@ static int autofs4_dir_open(struct inode
 
 	if (d_mountpoint(dentry)) {
 		struct file *fp = NULL;
-		struct vfsmount *fp_mnt = mntget(mnt);
-		struct dentry *fp_dentry = dget(dentry);
+		struct path fp_path = { .dentry = dentry, .mnt = mnt };
 
-		if (!autofs4_follow_mount(&fp_mnt, &fp_dentry)) {
-			dput(fp_dentry);
-			mntput(fp_mnt);
+		path_get(&fp_path);
+
+		if (!autofs4_follow_mount(&fp_path.mnt, &fp_path.dentry)) {
+			path_put(&fp_path);
 			dcache_dir_close(inode, file);
 			goto out;
 		}
 
-		fp = dentry_open(fp_dentry, fp_mnt, file->f_flags);
+		fp = dentry_open(fp_path.dentry, fp_path.mnt, file->f_flags);
 		status = PTR_ERR(fp);
 		if (IS_ERR(fp)) {
 			dcache_dir_close(inode, file);


