Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbXICCeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbXICCeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbXICC0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:05 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57683 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbXICCZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 14/32] Unionfs: file_revalidate updates
Date: Sun,  2 Sep 2007 22:20:37 -0400
Message-Id: <11887860571736-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Correctly revalidate a file and account for lower mnts, even when branches
are updated or inserted.  Better info upon file copyup.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 64bd0bd..612207a 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -333,6 +333,9 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	 */
 	if (!d_deleted(dentry) &&
 	    (sbgen > fgen || dbstart(dentry) != fbstart(file))) {
+		/* save orig branch ID */
+		int orig_brid =	UNIONFS_F(file)->saved_branch_ids[fbstart(file)];
+
 		/* First we throw out the existing files. */
 		cleanup_file(file);
 
@@ -359,22 +362,36 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 			if (err)
 				goto out;
 		} else {
+			int new_brid;
 			/* We only open the highest priority branch. */
 			err = open_highest_file(file, willwrite);
 			if (err)
 				goto out;
+			new_brid = UNIONFS_F(file)->
+			  saved_branch_ids[fbstart(file)];
+			if (new_brid != orig_brid && sbgen > fgen) {
+				/*
+				 * If we re-opened the file on a different
+				 * branch than the original one, and this
+				 * was due to a new branch inserted, then
+				 * update the mnt counts of the old and new
+				 * branches accordingly.
+				 */
+				unionfs_mntget(dentry, bstart);
+				unionfs_mntput(sb->s_root,
+					       branch_id_to_idx(sb, orig_brid));
+			}
 		}
 		atomic_set(&UNIONFS_F(file)->generation,
-			   atomic_read(&UNIONFS_I(dentry->d_inode)->
-				       generation));
+			   atomic_read(&UNIONFS_I(dentry->d_inode)->generation));
 	}
 
 	/* Copyup on the first write to a file on a readonly branch. */
 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
 	    is_robranch(dentry)) {
-		printk(KERN_DEBUG "unionfs: Doing delayed copyup of a "
-		       "read-write file on a read-only branch.\n");
+		printk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
+		       dentry->d_name.name);
 		err = do_delayed_copyup(file);
 	}
 
-- 
1.5.2.2.238.g7cbf2f2

