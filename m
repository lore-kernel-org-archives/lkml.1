Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYFPL3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYFPL3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYFPL2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:28:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53234 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYFPL2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:28:33 -0400
Message-Id: <20080616112830.003942737@szeredi.hu>
References: <20080616112804.930095761@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 16 Jun 2008 13:28:07 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 3/3] vfs: make d_path() consistent across mount operations
Content-Disposition: inline; filename=vfs-make-d_path-consistent-across-mount-operations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

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
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 fs/dcache.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2008-06-13 13:13:01.000000000 +0200
+++ linux-2.6/fs/dcache.c	2008-06-13 13:13:04.000000000 +0200
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
