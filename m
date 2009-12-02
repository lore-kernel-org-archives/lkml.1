Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZLBPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZLBPFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZLBPFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:05:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41617 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZLBPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:05:40 -0500
Message-Id: <20091202150514.219225319@szeredi.hu>
References: <20091202150454.616582634@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 02 Dec 2009 16:04:57 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Trond.Myklebust@netapp.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 3/4] nfs: dont unhash target if renaming a directory
Content-Disposition: inline; filename=nfs_rename_dont_unhash_if_dir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move unhashing the target to after the check for existence and being a
non-directory.

If renaming a directory then the VFS already unhashes the target if it
is not busy.  If it's busy then acquiring more references during the
rename makes no difference.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |   58 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2009-12-02 15:10:44.000000000 +0100
+++ linux-2.6/fs/nfs/dir.c	2009-12-02 15:11:19.000000000 +0100
@@ -1579,15 +1579,6 @@ static int nfs_rename(struct inode *old_
 	struct dentry *dentry = NULL, *rehash = NULL;
 	int error = -EBUSY;
 
-	/*
-	 * To prevent any new references to the target during the rename,
-	 * we unhash the dentry in advance.
-	 */
-	if (!d_unhashed(new_dentry)) {
-		d_drop(new_dentry);
-		rehash = new_dentry;
-	}
-
 	dfprintk(VFS, "NFS: rename(%s/%s -> %s/%s, ct=%d)\n",
 		 old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		 new_dentry->d_parent->d_name.name, new_dentry->d_name.name,
@@ -1599,25 +1590,36 @@ static int nfs_rename(struct inode *old_
 	 * silly-rename succeeds, the copied dentry is hashed and becomes
 	 * the new target.
 	 */
-	if (new_inode && !S_ISDIR(new_inode->i_mode) &&
-	    atomic_read(&new_dentry->d_count) > 2) {
-		int err;
-		/* copy the target dentry's name */
-		dentry = d_alloc(new_dentry->d_parent,
-				 &new_dentry->d_name);
-		if (!dentry)
-			goto out;
-
-		/* silly-rename the existing target ... */
-		err = nfs_sillyrename(new_dir, new_dentry);
-		if (!err) {
-			new_dentry = rehash = dentry;
-			new_inode = NULL;
-			/* instantiate the replacement target */
-			d_instantiate(new_dentry, NULL);
-		} else if (atomic_read(&new_dentry->d_count) > 1)
-			/* dentry still busy? */
-			goto out;
+	if (new_inode && !S_ISDIR(new_inode->i_mode)) {
+		/*
+		 * To prevent any new references to the target during the
+		 * rename, we unhash the dentry in advance.
+		 */
+		if (!d_unhashed(new_dentry)) {
+			d_drop(new_dentry);
+			rehash = new_dentry;
+		}
+
+		if (atomic_read(&new_dentry->d_count) > 2) {
+			int err;
+
+			/* copy the target dentry's name */
+			dentry = d_alloc(new_dentry->d_parent,
+					 &new_dentry->d_name);
+			if (!dentry)
+				goto out;
+
+			/* silly-rename the existing target ... */
+			err = nfs_sillyrename(new_dir, new_dentry);
+			if (!err) {
+				new_dentry = rehash = dentry;
+				new_inode = NULL;
+				/* instantiate the replacement target */
+				d_instantiate(new_dentry, NULL);
+			} else if (atomic_read(&new_dentry->d_count) > 1)
+				/* dentry still busy? */
+				goto out;
+		}
 	}
 
 	/*

-- 
