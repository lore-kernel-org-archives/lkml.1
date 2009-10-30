Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZJ3Fil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZJ3Fil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZJ3Fil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:38:41 -0400
Received: from msa105.auone-net.jp ([61.117.18.165]:39582 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZJ3Fik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:38:40 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2009 01:38:40 EDT
Date: Fri, 30 Oct 2009 14:31:46 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Don't ignore MS_RDONLY in bind and not remount case.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20091030053146.BC2176FC03B@msa105.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A readonly bind mount needed to be created in 2 steps

# mount --bind
# mount --bind -o remount,ro

instead of single

# mount --bind -o ro

because MS_RDONLY is ignored in bind and not remount case.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 fs/namespace.c |   14 +++++++++-----
 fs/pnode.h     |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bdc3cb4..1d350e2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -562,6 +562,8 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 		}
 
 		mnt->mnt_flags = old->mnt_flags;
+		if (flag & CL_READONLY)
+			mnt->mnt_flags |= MNT_READONLY;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
@@ -1447,7 +1449,7 @@ static int do_change_type(struct path *path, int flag)
  * do loopback mount.
  */
 static int do_loopback(struct path *path, char *old_name,
-				int recurse)
+				int flags)
 {
 	struct path old_path;
 	struct vfsmount *mnt = NULL;
@@ -1469,10 +1471,12 @@ static int do_loopback(struct path *path, char *old_name,
 		goto out;
 
 	err = -ENOMEM;
-	if (recurse)
-		mnt = copy_tree(old_path.mnt, old_path.dentry, 0);
+	if (flags & MS_REC)
+		mnt = copy_tree(old_path.mnt, old_path.dentry,
+				flags & MS_RDONLY ? CL_READONLY : 0);
 	else
-		mnt = clone_mnt(old_path.mnt, old_path.dentry, 0);
+		mnt = clone_mnt(old_path.mnt, old_path.dentry,
+				flags & MS_RDONLY ? CL_READONLY : 0);
 
 	if (!mnt)
 		goto out;
@@ -1959,7 +1963,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&path, dev_name, flags & MS_REC);
+		retval = do_loopback(&path, dev_name, flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)
diff --git a/fs/pnode.h b/fs/pnode.h
index 958665d..59769bb 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -23,6 +23,7 @@
 #define CL_MAKE_SHARED 		0x08
 #define CL_PROPAGATION 		0x10
 #define CL_PRIVATE 		0x20
+#define CL_READONLY 		0x40
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
-- 
1.6.5

