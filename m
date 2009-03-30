Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZC3SRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZC3SRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZC3SPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:56592 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZC3SPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:14 -0400
Message-Id: <20090330181009.574081558@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:18 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 03/35 error-handling] reiserfs: use buffer_info for leaf_paste_entries
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-buffer-info-for-balance.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch makes leaf_paste_entries more consistent with respect to the
 other leaf operations. Using buffer_info instead of buffer_head directly
 allows us to get a superblock pointer for use in error handling.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/reiserfs/do_balan.c      |   17 +++++++----------
 fs/reiserfs/lbalance.c      |    5 +++--
 include/linux/reiserfs_fs.h |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -449,8 +449,7 @@ static int balance_leaf(struct tree_bala
 							/* when we have merge directory item, pos_in_item has been changed too */
 
 							/* paste new directory entry. 1 is entry number */
-							leaf_paste_entries(bi.
-									   bi_bh,
+							leaf_paste_entries(&bi,
 									   n +
 									   item_pos
 									   -
@@ -699,7 +698,7 @@ static int balance_leaf(struct tree_bala
 							   n + item_pos -
 							   ret_val);
 					if (is_direntry_le_ih(pasted))
-						leaf_paste_entries(bi.bi_bh,
+						leaf_paste_entries(&bi,
 								   n +
 								   item_pos -
 								   ret_val,
@@ -894,8 +893,7 @@ static int balance_leaf(struct tree_bala
 							     tb->insert_size[0],
 							     body, zeros_num);
 							/* paste entry */
-							leaf_paste_entries(bi.
-									   bi_bh,
+							leaf_paste_entries(&bi,
 									   0,
 									   paste_entry_position,
 									   1,
@@ -1096,7 +1094,7 @@ static int balance_leaf(struct tree_bala
 							   tb->rnum[0]);
 					if (is_direntry_le_ih(pasted)
 					    && pos_in_item >= 0) {
-						leaf_paste_entries(bi.bi_bh,
+						leaf_paste_entries(&bi,
 								   item_pos -
 								   n +
 								   tb->rnum[0],
@@ -1339,8 +1337,7 @@ static int balance_leaf(struct tree_bala
 							     tb->insert_size[0],
 							     body, zeros_num);
 							/* paste new directory entry */
-							leaf_paste_entries(bi.
-									   bi_bh,
+							leaf_paste_entries(&bi,
 									   0,
 									   pos_in_item
 									   -
@@ -1505,7 +1502,7 @@ static int balance_leaf(struct tree_bala
 							   item_pos - n +
 							   snum[i]);
 					if (is_direntry_le_ih(pasted)) {
-						leaf_paste_entries(bi.bi_bh,
+						leaf_paste_entries(&bi,
 								   item_pos -
 								   n + snum[i],
 								   pos_in_item,
@@ -1606,7 +1603,7 @@ static int balance_leaf(struct tree_bala
 								     zeros_num);
 
 						/* paste entry */
-						leaf_paste_entries(bi.bi_bh,
+						leaf_paste_entries(&bi,
 								   item_pos,
 								   pos_in_item,
 								   1,
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -111,7 +111,7 @@ static void leaf_copy_dir_entries(struct
 	item_num_in_dest =
 	    (last_first == FIRST_TO_LAST) ? (B_NR_ITEMS(dest) - 1) : 0;
 
-	leaf_paste_entries(dest_bi->bi_bh, item_num_in_dest,
+	leaf_paste_entries(dest_bi, item_num_in_dest,
 			   (last_first ==
 			    FIRST_TO_LAST) ? I_ENTRY_COUNT(B_N_PITEM_HEAD(dest,
 									  item_num_in_dest))
@@ -1191,7 +1191,7 @@ static void leaf_delete_items_entirely(s
 }
 
 /* paste new_entry_count entries (new_dehs, records) into position before to item_num-th item */
-void leaf_paste_entries(struct buffer_head *bh,
+void leaf_paste_entries(struct buffer_info *bi,
 			int item_num,
 			int before,
 			int new_entry_count,
@@ -1203,6 +1203,7 @@ void leaf_paste_entries(struct buffer_he
 	struct reiserfs_de_head *deh;
 	char *insert_point;
 	int i, old_entry_num;
+	struct buffer_head *bh = bi->bi_bh;
 
 	if (new_entry_count == 0)
 		return;
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2026,7 +2026,7 @@ void leaf_paste_in_buffer(struct buffer_
 			  int zeros_number);
 void leaf_cut_from_buffer(struct buffer_info *bi, int cut_item_num,
 			  int pos_in_item, int cut_size);
-void leaf_paste_entries(struct buffer_head *bh, int item_num, int before,
+void leaf_paste_entries(struct buffer_info *bi, int item_num, int before,
 			int new_entry_count, struct reiserfs_de_head *new_dehs,
 			const char *records, int paste_size);
 /* ibalance.c */


