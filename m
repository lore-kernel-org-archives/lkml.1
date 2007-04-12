Return-Path: <linux-kernel-owner+w=401wt.eu-S1946023AbXDLJnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023AbXDLJnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946009AbXDLJns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:43:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023AbXDLJkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:37 -0400
Message-Id: <20070412090847.018972000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:41 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 32/41] Make d_path() consistent across mount operations
Content-Disposition: inline; filename=mount-consistent-d_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, the path that __d_path() computes can become slightly
inconsistent when it races with mount operations: it grabs the
vfsmount_lock when traversing mount points, but immediately drops it
again, only to re-grab it when it reaches the next mount point.
The result is that the filename computed is not always consisent, and
the file may never have had that name. (This is unlikely, but still
possible.)

We can easily fix this by grabbing the vfsmount_lock when the first
mount point is reached, and holding onto it until the d_cache lookup is
completed.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/dcache.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1754,7 +1754,7 @@ static char *__d_path(struct dentry *den
 		      struct dentry *root, struct vfsmount *rootmnt,
 		      char *buffer, int buflen, int fail_deleted)
 {
-	int namelen, is_slash;
+	int namelen, is_slash, vfsmount_locked = 0;
 
 	if (buflen < 2)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1777,14 +1777,14 @@ static char *__d_path(struct dentry *den
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
@@ -1803,6 +1803,8 @@ static char *__d_path(struct dentry *den
 		*--buffer = '/';
 
 out:
+	if (vfsmount_locked)
+		spin_unlock(&vfsmount_lock);
 	spin_unlock(&dcache_lock);
 	return buffer;
 

-- 
