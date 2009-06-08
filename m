Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZFHT2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZFHT2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZFHTXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:35 -0400
Received: from thunk.org ([69.25.196.29]:39573 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbZFHTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 35/49] ext4: Clean up ext4_get_blocks() so it does not depend on bh_result->b_state
Date: Mon,  8 Jun 2009 15:22:53 -0400
Message-Id: <1244488987-32564-36-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-35-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ext4_get_blocks() function was depending on the value of
bh_result->b_state as an input parameter to decide whether or not
update the delalloc accounting statistics by calling
ext4_da_update_reserve_space().  We now use a separate flag,
EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE, to requests this update, so that
all callers of ext4_get_blocks() can clear map_bh.b_state before
calling ext4_get_blocks() without worrying about any consistency
issues.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |   15 +++++++++----
 fs/ext4/inode.c |   56 ++++++++++++++++++++++++++++++------------------------
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 17feb4a..d164f12 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -318,16 +318,21 @@ struct ext4_new_group_data {
  */
 	/* Allocate any needed blocks and/or convert an unitialized
 	   extent to be an initialized ext4 */
-#define EXT4_GET_BLOCKS_CREATE			1
+#define EXT4_GET_BLOCKS_CREATE			0x0001
 	/* Request the creation of an unitialized extent */
-#define EXT4_GET_BLOCKS_UNINIT_EXT		2
+#define EXT4_GET_BLOCKS_UNINIT_EXT		0x0002
 #define EXT4_GET_BLOCKS_CREATE_UNINIT_EXT	(EXT4_GET_BLOCKS_UNINIT_EXT|\
 						 EXT4_GET_BLOCKS_CREATE)
 	/* Update the ext4_inode_info i_disksize field */
-#define EXT4_GET_BLOCKS_EXTEND_DISKSIZE		4
+#define EXT4_GET_BLOCKS_EXTEND_DISKSIZE		0x0004
 	/* Caller is from the delayed allocation writeout path,
-	   so the filesystem blocks have already been accounted for */
-#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	8
+	   so set the magic i_delalloc_reserve_flag after taking the 
+	   inode allocation semaphore for */
+#define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0008
+	/* Call ext4_da_update_reserve_space() after successfully 
+	   allocating the blocks */
+#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0010
+
 
 /*
  * ioctl commands
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bfe50a2..d7b7480 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1234,16 +1234,15 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 		}
 	}
 
-	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		EXT4_I(inode)->i_delalloc_reserved_flag = 0;
-		/*
-		 * Update reserved blocks/metadata blocks
-		 * after successful block allocation
-		 * which were deferred till now
-		 */
-		if ((retval > 0) && buffer_delay(bh))
-			ext4_da_update_reserve_space(inode, retval);
-	}
+
+	/*
+	 * Update reserved blocks/metadata blocks after successful
+	 * block allocation which had been deferred till now.
+	 */
+	if ((retval > 0) && (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
+		ext4_da_update_reserve_space(inode, retval);
 
 	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
@@ -2015,7 +2014,7 @@ static void ext4_print_free_blocks(struct inode *inode)
  */
 static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
-	int err, blks;
+	int err, blks, get_blocks_flags;
 	struct buffer_head new;
 	sector_t next = mpd->b_blocknr;
 	unsigned max_blocks = mpd->b_size >> mpd->inode->i_blkbits;
@@ -2040,23 +2039,30 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	BUG_ON(!handle);
 
 	/*
-	 * We need to make sure the BH_Delay flag is passed down to
-	 * ext4_da_get_block_write(), since it calls ext4_get_blocks()
-	 * with the EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.  This flag
-	 * causes ext4_get_blocks() to call
-	 * ext4_da_update_reserve_space() if the passed buffer head
-	 * has the BH_Delay flag set.  In the future, once we clean up
-	 * the interfaces to ext4_get_blocks(), we should pass in a
-	 * separate flag which requests that the delayed allocation
-	 * statistics should be updated, instead of depending on the
-	 * state information getting passed down via the map_bh's
-	 * state bitmasks plus the magic
-	 * EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.
+	 * Call ext4_get_blocks() to allocate any delayed allocation
+	 * blocks, or to convert an uninitialized extent to be
+	 * initialized (in the case where we have written into
+	 * one or more preallocated blocks).
+	 *
+	 * We pass in the magic EXT4_GET_BLOCKS_DELALLOC_RESERVE to
+	 * indicate that we are on the delayed allocation path.  This
+	 * affects functions in many different parts of the allocation
+	 * call path.  This flag exists primarily because we don't
+	 * want to change *many* call functions, so ext4_get_blocks()
+	 * will set the magic i_delalloc_reserved_flag once the
+	 * inode's allocation semaphore is taken.
+	 *
+	 * If the blocks in questions were delalloc blocks, set
+	 * EXT4_GET_BLOCKS_DELALLOC_RESERVE so the delalloc accounting
+	 * variables are updated after the blocks have been allocated.
 	 */
-	new.b_state = mpd->b_state & (1 << BH_Delay);
+	new.b_state = 0;
+	get_blocks_flags = (EXT4_GET_BLOCKS_CREATE |
+			    EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+	if (mpd->b_state & (1 << BH_Delay))
+		get_blocks_flags |= EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE;
 	blks = ext4_get_blocks(handle, mpd->inode, next, max_blocks,
-			       &new, EXT4_GET_BLOCKS_CREATE|
-			       EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+			       &new, get_blocks_flags);
 	if (blks < 0) {
 		err = blks;
 		/*
-- 
1.6.3.2.1.gb9f7d.dirty

