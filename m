Return-Path: <linux-kernel-owner+w=401wt.eu-S934694AbXLTO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbXLTO0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbXLTOMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:39 -0500
Received: from ns1.suse.de ([195.135.220.2]:40877 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbXLTOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:36 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:46 2007
Message-Id: <20071220140946.068298016@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:40 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 30/47] Make d_path() consistent across mount operations
Content-Disposition: inline; filename=mount-consistent-__d_path.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -1766,7 +1766,7 @@ shouldnt_be_hashed:
 static char *__d_path(struct path *path, struct path *root,
                      char *buffer, int buflen, int fail_deleted)
 {
-	int namelen, is_slash;
+    int namelen, is_slash, vfsmount_locked = 0;
 	struct dentry *dentry = path->dentry;
 	struct vfsmount *vfsmnt = path->mnt;
 
@@ -1791,14 +1791,14 @@ static char *__d_path(struct path *path,
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
@@ -1817,6 +1817,8 @@ static char *__d_path(struct path *path,
 		*--buffer = '/';
 
 out:
+	if (vfsmount_locked)
+		spin_unlock(&vfsmount_lock);
 	spin_unlock(&dcache_lock);
 	return buffer;
 

-- 

