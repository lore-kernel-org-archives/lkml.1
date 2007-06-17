Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbXFQTOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbXFQTOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760796AbXFQTKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36889 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761209AbXFQTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:11 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 10/16] Unionfs: merge find_new_branch_index and branch_id_to_idx into one function
Date: Sun, 17 Jun 2007 15:09:17 -0400
Message-Id: <1182107364965-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Useful code cleanup and consolidation between the ODF code and non-ODF code.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   35 +++++++++--------------------------
 fs/unionfs/fanout.h     |   24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 0222393..731e3a9 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -90,31 +90,6 @@ out:
 }
 
 /*
- * Find new index of matching branch with an open file, since branches could
- * have been added/deleted causing the one with open files to shift.
- *
- * @file: current file whose branches may have changed
- * @bindex: index of branch within current file (could be old branch)
- * @new_sb: the new superblock which may have new branch IDs
- * Returns index of newly found branch (0 or greater), -1 otherwise.
- */
-static int find_new_branch_index(struct file *file, int bindex,
-				 struct super_block *new_sb)
-{
-	int old_branch_id = UNIONFS_F(file)->saved_branch_ids[bindex];
-	int i;
-
-	for (i = 0; i < sbmax(new_sb); i++)
-		if (old_branch_id == branch_id(new_sb, i))
-			return i;
-	/*
-	 * XXX: maybe we should BUG_ON if not found new branch index?
-	 * (really that should never happen).
-	 */
-	return -1;
-}
-
-/*
  * put all references held by upper struct file and free lower file pointer
  * array
  */
@@ -130,8 +105,16 @@ static void cleanup_file(struct file *file)
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		if (unionfs_lower_file_idx(file, bindex)) {
+			/*
+			 * Find new index of matching branch with an open
+			 * file, since branches could have been added or
+			 * deleted causing the one with open files to shift.
+			 */
 			int i;	/* holds (possibly) updated branch index */
-			i = find_new_branch_index(file, bindex, sb);
+			int old_bid;
+
+			old_bid = UNIONFS_F(file)->saved_branch_ids[bindex];
+			i = branch_id_to_idx(sb, old_bid);
 			if (i < 0)
 				printk(KERN_ERR "unionfs: no superblock for "
 				       "file %p\n", file);
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 71052a3..0319835 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -55,6 +55,30 @@ static inline void new_branch_id(struct super_block *sb, int index)
 	set_branch_id(sb, index, ++UNIONFS_SB(sb)->high_branch_id);
 }
 
+/*
+ * Find new index of matching branch with an existing superblock a a known
+ * (possibly old) id.  This is needed because branches could have been
+ * added/deleted causing the branchs of any open files to shift.
+ *
+ * @sb: the new superblock which may have new/different branch IDs
+ * @id: the old/existing id we're looking for
+ * Returns index of newly found branch (0 or greater), -1 otherwise.
+ */
+static inline int branch_id_to_idx(struct super_block *sb, int id)
+{
+	int i;
+	for (i = 0; i < sbmax(sb); i++) {
+		if (branch_id(sb, i) == id)
+			return i;
+	}
+	/*
+	 * XXX: maybe we should BUG_ON if not found new branch index?
+	 * (really that should never happen).
+	 */
+	printk(KERN_WARNING "unionfs: cannot find branch with id %d\n", id);
+	return -1;
+}
+
 /* File to lower file. */
 static inline struct file *unionfs_lower_file(const struct file *f)
 {
-- 
1.5.2.rc1.165.gaf9b

