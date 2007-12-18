Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXLRWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXLRWP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbXLRWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:15:51 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55289 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXLRWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:15:51 -0500
Date: Tue, 18 Dec 2007 22:14:58 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] unionfs: fix truncation order
In-Reply-To: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182214180.28390@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsx-linux in a unionfs soon fails (with oops on tmpfs): truncation doesn't
work right.

When shrinking a file, unionfs_setattr needs to vmtruncate the upper level
before notifying change to the lower level, to eliminate those dirty pages
beyond new eof which otherwise drift down to the lower level's writepage,
writing beyond its eof (and later uncovered when the file is expanded).

Also truncate the upper level first when expanding, in the case when
the upper level's s_maxbytes is more limiting than the lower level's.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/unionfs/inode.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- unionfs3/fs/unionfs/inode.c	2007-12-05 18:50:52.000000000 +0000
+++ unionfs4/fs/unionfs/inode.c	2007-12-05 18:58:51.000000000 +0000
@@ -1060,23 +1060,30 @@ static int unionfs_setattr(struct dentry
 				break;
 		}
 	}
+	lower_inode = unionfs_lower_inode(inode);
 
-	err = notify_change(lower_dentry, ia);
-	if (err)
-		goto out;
-
-	/* for mmap */
+	/*
+	 * If shrinking, first truncate upper level to cancel writing dirty
+	 * pages beyond the new eof; and also if its maxbytes is more limiting
+	 * (fail with -EFBIG before making any change to the lower level).
+	 * There is no need to vmtruncate the upper level afterwards in the
+	 * other cases: we fsstack_copy_inode_size from the lower level.
+	 */
 	if (ia->ia_valid & ATTR_SIZE) {
-		if (ia->ia_size != i_size_read(inode)) {
+		size = i_size_read(inode);
+		if (ia->ia_size < size || (ia->ia_size > size &&
+		    inode->i_sb->s_maxbytes < lower_inode->i_sb->s_maxbytes)) {
 			err = vmtruncate(inode, ia->ia_size);
 			if (err)
-				printk(KERN_ERR
-				       "unionfs: setattr: vmtruncate failed\n");
+				goto out;
 		}
 	}
 
-	/* get the size from the first lower inode */
-	lower_inode = unionfs_lower_inode(inode);
+	err = notify_change(lower_dentry, ia);
+	if (err)
+		goto out;
+
+	/* get attributes from the first lower inode */
 	unionfs_copy_attr_all(inode, lower_inode);
 	/*
 	 * unionfs_copy_attr_all will copy the lower times to our inode if
