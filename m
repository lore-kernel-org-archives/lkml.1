Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXENLlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXENLlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbXENLdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:33:22 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27931 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762247AbXENLcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:42 -0400
Message-Id: <20070514110618.530920481@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:37 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 30/45] Make d_path() consistent across mount operations
Content-Disposition: inline; filename=mount-consistent-__d_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The path that __d_path() computes can become slightly inconsistent when it
races with mount operations: it grabs the vfsmount_lock when traversing mount
points but immediately drops it again, only to re-grab it when it reaches the
next mount point.  The result is that the filename computed is not always
consisent, and the file may never have had that name. (This is unlikely, but
still possible.)

Fix this by grabbing the vfsmount_lock when the first mount point is reached,
and holding onto it until the d_cache lookup is completed.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/dcache.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1783,7 +1783,7 @@ static char *__d_path(struct dentry *den
 		      struct dentry *root, struct vfsmount *rootmnt,
 		      char *buffer, int buflen, int fail_deleted)
 {
-	int namelen, is_slash;
+	int namelen, is_slash, vfsmount_locked = 0;
 
 	if (buflen < 2)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1806,14 +1806,14 @@ static char *__d_path(struct dentry *den
 		struct dentry * parent;
 
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
-			spin_lock(&vfsmount_lock);
-			if (vfsmnt->mnt_parent == vfsmnt) {
-				spin_unlock(&vfsmount_lock);
-				goto global_root;
+			if (!vfsmount_locked) {
+				spin_lock(&vfsmount_lock);
+				vfsmount_locked = 1;
 			}
+			if (vfsmnt->mnt_parent == vfsmnt)
+				goto global_root;
 			dentry = vfsmnt->mnt_mountpoint;
 			vfsmnt = vfsmnt->mnt_parent;
-			spin_unlock(&vfsmount_lock);
 			continue;
 		}
 		parent = dentry->d_parent;
@@ -1832,6 +1832,8 @@ static char *__d_path(struct dentry *den
 		*--buffer = '/';
 
 out:
+	if (vfsmount_locked)
+		spin_unlock(&vfsmount_lock);
 	spin_unlock(&dcache_lock);
 	return buffer;
 

-- 
