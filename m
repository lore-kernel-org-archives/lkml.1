Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbXLRWPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbXLRWPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXLRWO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:14:58 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60931 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXLRWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:14:57 -0500
Date: Tue, 18 Dec 2007 22:14:14 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] unionfs: restructure unionfs_setattr
In-Reply-To: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182213300.28390@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to fix unionfs truncation, we need to move the lower notify_change
out of the loop in unionfs_setattr.  But when I came to do that, I couldn't
understand that loop at all: its continues and breaks and gotos are obscure,
most particularly the "if (copyup || (bindex != bstart)) continue;" which
seems to make a nonsense of the whole thing.

Here's my attempt to restructure it, prior to making the functional change
in the next patch; but I may have misunderstood badly, please check - I've
not tested it beyond my degenerate dirs=/tmpfs case, which hardly tests it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/unionfs/inode.c |   64 ++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

--- 2.6.24-rc5-mm1/fs/unionfs/inode.c	2007-12-05 10:38:38.000000000 +0000
+++ unionfs3/fs/unionfs/inode.c	2007-12-05 18:50:52.000000000 +0000
@@ -1004,11 +1004,10 @@ static int unionfs_setattr(struct dentry
 {
 	int err = 0;
 	struct dentry *lower_dentry;
-	struct inode *inode = NULL;
-	struct inode *lower_inode = NULL;
+	struct inode *inode;
+	struct inode *lower_inode;
 	int bstart, bend, bindex;
-	int i;
-	int copyup = 0;
+	loff_t size;
 
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
@@ -1029,50 +1028,43 @@ static int unionfs_setattr(struct dentry
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
-	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
-	     bindex++) {
-		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!lower_dentry)
-			continue;
-		BUG_ON(lower_dentry->d_inode == NULL);
-
+	lower_dentry = unionfs_lower_dentry(dentry);
+	if (lower_dentry) {
 		/* If the file is on a read only branch */
-		if (is_robranch_super(dentry->d_sb, bindex)
+		if (is_robranch_super(dentry->d_sb, bstart)
 		    || IS_RDONLY(lower_dentry->d_inode)) {
-			if (copyup || (bindex != bstart))
-				continue;
-			/* Only if its the leftmost file, copyup the file */
-			for (i = bstart - 1; i >= 0; i--) {
-				loff_t size = i_size_read(dentry->d_inode);
-				if (ia->ia_valid & ATTR_SIZE)
-					size = ia->ia_size;
+
+			if (ia->ia_valid & ATTR_SIZE)
+				size = ia->ia_size;
+			else
+				size = i_size_read(inode);
+
+			for (bindex = bstart - 1; bindex >= 0; bindex--) {
 				err = copyup_dentry(dentry->d_parent->d_inode,
-						    dentry, bstart, i,
+						    dentry, bstart, bindex,
 						    dentry->d_name.name,
 						    dentry->d_name.len,
 						    NULL, size);
-
-				if (!err) {
-					copyup = 1;
-					lower_dentry =
-						unionfs_lower_dentry(dentry);
+				if (!err)
 					break;
-				}
-				/*
-				 * if error is in the leftmost branch, pass
-				 * it up.
-				 */
-				if (i == 0)
-					goto out;
 			}
 
+			if (err)
+				goto out;
+			lower_dentry = unionfs_lower_dentry(dentry);
+		}
+	} else {
+		for (bindex = bstart + 1; bindex <= bend; bindex++) {
+			lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+			if (lower_dentry)
+				break;
 		}
-		err = notify_change(lower_dentry, ia);
-		if (err)
-			goto out;
-		break;
 	}
 
+	err = notify_change(lower_dentry, ia);
+	if (err)
+		goto out;
+
 	/* for mmap */
 	if (ia->ia_valid & ATTR_SIZE) {
 		if (ia->ia_size != i_size_read(inode)) {
