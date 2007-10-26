Return-Path: <linux-kernel-owner+w=401wt.eu-S1764697AbXJZHIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764697AbXJZHIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbXJZG6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:34902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025AbXJZG6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:33 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:51 2007
Message-Id: <20071026064051.135893654@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:54 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
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
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/dcache.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1785,7 +1785,7 @@ static char *__d_path(struct dentry *den
 		      struct dentry *root, struct vfsmount *rootmnt,
 		      char *buffer, int buflen, int fail_deleted)
 {
-	int namelen, is_slash;
+	int namelen, is_slash, vfsmount_locked = 0;
 
 	if (buflen < 2)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1808,14 +1808,14 @@ static char *__d_path(struct dentry *den
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
@@ -1834,6 +1834,8 @@ static char *__d_path(struct dentry *den
 		*--buffer = '/';
 
 out:
+	if (vfsmount_locked)
+		spin_unlock(&vfsmount_lock);
 	spin_unlock(&dcache_lock);
 	return buffer;
 

-- 

