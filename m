Return-Path: <linux-kernel-owner+w=401wt.eu-S1423006AbXDSX5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423006AbXDSX5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423014AbXDSX5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:57:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:35297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422995AbXDSXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:54:59 -0400
Message-Id: <20070419234704.016789754@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:05 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu> <20070419232303.300441585@schurl.suse.de>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 2/7] Make d_path() consistent across mount operations
Content-Disposition: inline; filename=mount-consistent-__d_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The path that __d_path() computes can become slightly inconsistent when it
races with mount operations: it grabs the vfsmount_lock when traversing mount
points, but immediately drops it again, only to re-grab it when it reaches the
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
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX Products GmbH
GF: Markus Rex, HRB 16746 (AG Nuernberg)

GPG: AF77 FAD1 1819 D442 400F  4BC8 409A 6903 4FDD EE02

