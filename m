Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZEUJXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZEUJXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZEUJW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:22:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50302 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZEUJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:22:58 -0400
Message-Id: <20090521092249.788100020@szeredi.hu>
References: <20090521092231.979256687@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 21 May 2009 11:22:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk
Subject: [patch 3/5] union-directory: Some checks during namespace changes
Content-Disposition: inline; filename=union-directory-mount.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add some additional checks when mounting something into an union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2009-05-20 15:07:46.000000000 +0200
+++ linux-2.6/fs/namespace.c	2009-05-20 15:10:05.000000000 +0200
@@ -32,6 +32,7 @@
 #include <asm/unistd.h>
 #include "pnode.h"
 #include "internal.h"
+#include "union.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -1456,6 +1457,10 @@ static int do_change_type(struct path *p
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't change the type of union mounts */
+	if (IS_MNT_UNION(path->mnt))
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
@@ -1477,7 +1482,7 @@ static int do_change_type(struct path *p
  * do loopback mount.
  */
 static int do_loopback(struct path *path, char *old_name,
-				int recurse)
+				int recurse, int mnt_flags)
 {
 	struct path old_path;
 	struct vfsmount *mnt = NULL;
@@ -1507,6 +1512,9 @@ static int do_loopback(struct path *path
 	if (!mnt)
 		goto out;
 
+	if (mnt_flags & MNT_UNION)
+		mnt->mnt_flags |= MNT_UNION;
+
 	err = graft_tree(mnt, path);
 	if (err) {
 		LIST_HEAD(umount_list);
@@ -1600,6 +1608,13 @@ static int do_move_mount(struct path *pa
 	if (err)
 		return err;
 
+	/* moving to or from a union mount is not supported */
+	err = -EINVAL;
+	if (IS_MNT_UNION(path->mnt))
+		goto exit;
+	if (IS_MNT_UNION(old_path.mnt))
+		goto exit;
+
 	down_write(&namespace_sem);
 	while (d_mountpoint(path->dentry) &&
 	       follow_down(&path->mnt, &path->dentry))
@@ -1657,6 +1672,7 @@ out:
 	up_write(&namespace_sem);
 	if (!err)
 		path_put(&parent_path);
+exit:
 	path_put(&old_path);
 	return err;
 }
@@ -1974,7 +1990,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&path, dev_name, flags & MS_REC);
+		retval = do_loopback(&path, dev_name, flags & MS_REC, mnt_flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)

--
