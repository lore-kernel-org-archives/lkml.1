Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZFHTX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZFHTX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZFHTXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:11 -0400
Received: from thunk.org ([69.25.196.29]:39514 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZFHTXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 01/49] ext4: Properly initialize the buffer_head state
Date: Mon,  8 Jun 2009 15:22:19 -0400
Message-Id: <1244488987-32564-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-1-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

These struct buffer_heads are allocated on the stack (and hence are
initialized with stack garbage).  They are only used to call a
get_blocks() function, so that's mostly OK, but b_state must be
initialized to be 0 so we don't have any unexpected BH_* flags set by
accident, such as BH_Unwritten or BH_Delay.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |   15 ++++++++++++++-
 fs/mpage.c        |    6 ++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e3a55eb..a953214 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3150,6 +3150,7 @@ retry:
 			ret = PTR_ERR(handle);
 			break;
 		}
+		map_bh.b_state = 0;
 		ret = ext4_get_blocks_wrap(handle, inode, block,
 					  max_blocks, &map_bh,
 					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2a9ffd5..d7ad0bb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2055,7 +2055,20 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if ((mpd->b_state  & (1 << BH_Mapped)) &&
 	    !(mpd->b_state & (1 << BH_Delay)))
 		return 0;
-	new.b_state = mpd->b_state;
+	/*
+	 * We need to make sure the BH_Delay flag is passed down to
+	 * ext4_da_get_block_write(), since it calls
+	 * ext4_get_blocks_wrap() with the EXT4_DELALLOC_RSVED flag.
+	 * This flag causes ext4_get_blocks_wrap() to call
+	 * ext4_da_update_reserve_space() if the passed buffer head
+	 * has the BH_Delay flag set.  In the future, once we clean up
+	 * the interfaces to ext4_get_blocks_wrap(), we should pass in
+	 * a separate flag which requests that the delayed allocation
+	 * statistics should be updated, instead of depending on the
+	 * state information getting passed down via the map_bh's
+	 * state bitmasks plus the magic EXT4_DELALLOC_RSVED flag.
+	 */
+	new.b_state = mpd->b_state & (1 << BH_Delay);
 	new.b_blocknr = 0;
 	new.b_size = mpd->b_size;
 	next = mpd->b_blocknr;
diff --git a/fs/mpage.c b/fs/mpage.c
index 680ba60..42381bd 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -379,7 +379,8 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
-	clear_buffer_mapped(&map_bh);
+	map_bh.b_state = 0;
+	map_bh.b_size = 0;
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
 		struct page *page = list_entry(pages->prev, struct page, lru);
 
@@ -412,7 +413,8 @@ int mpage_readpage(struct page *page, get_block_t get_block)
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
-	clear_buffer_mapped(&map_bh);
+	map_bh.b_state = 0;
+	map_bh.b_size = 0;
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
 			&map_bh, &first_logical_block, get_block);
 	if (bio)
-- 
1.6.3.2.1.gb9f7d.dirty

