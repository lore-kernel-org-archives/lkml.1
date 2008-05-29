Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYE2Lem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYE2Lem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYE2LdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56691 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYE2LdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:16 -0400
Message-Id: <20080529113310.608958055@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:48 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [patch 3/8] Make d_path() consistent across mount operations
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

Fix this by grabbing the vfsmount_lock for the whole duration of
__d_path().

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-05-29 12:46:22.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-05-29 12:46:23.000000000 +0200
@@ -1784,6 +1784,7 @@ char *__d_path(const struct path *path, 
 	char *retval;
 	struct qstr *name;
 
+	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -1802,14 +1803,11 @@ char *__d_path(const struct path *path, 
 			break;
 		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
-			spin_lock(&vfsmount_lock);
 			if (vfsmnt->mnt_parent == vfsmnt) {
-				spin_unlock(&vfsmount_lock);
 				goto global_root;
 			}
 			dentry = vfsmnt->mnt_mountpoint;
 			vfsmnt = vfsmnt->mnt_parent;
-			spin_unlock(&vfsmount_lock);
 			continue;
 		}
 		parent = dentry->d_parent;
@@ -1822,6 +1820,8 @@ char *__d_path(const struct path *path, 
 		dentry = parent;
 	}
 
+out:
+	spin_unlock(&vfsmount_lock);
 	return retval;
 
 global_root:
@@ -1841,9 +1841,11 @@ global_root:
 	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
-	return retval;
+	goto out;
+
 Elong:
-	return ERR_PTR(-ENAMETOOLONG);
+	retval = ERR_PTR(-ENAMETOOLONG);
+	goto out;
 }
 
 /**

--
