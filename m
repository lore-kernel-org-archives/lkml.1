Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbXJXJGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbXJXJGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXJXJE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:04:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:50694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbXJXJEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:04:55 -0400
Message-Id: <20071024081405.526553000@nick.local0.net>
References: <20071024081305.906617000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 24 Oct 2007 18:13:10 +1000
From: npiggin@nick.local0.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/5] fs: use lock bitops for the buffer lock
Content-Disposition: inline; filename=buffer_lock-use-lock-bitops.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Like the page lock change, this also requires name change, so convert the
raw test_and_set bitop to a trylock.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 fs/buffer.c                 |    7 +++----
 fs/jbd/commit.c             |    2 +-
 fs/jbd2/commit.c            |    2 +-
 fs/ntfs/aops.c              |    2 +-
 fs/ntfs/compress.c          |    2 +-
 fs/ntfs/mft.c               |    4 ++--
 fs/reiserfs/inode.c         |    2 +-
 fs/reiserfs/journal.c       |    4 ++--
 include/linux/buffer_head.h |    8 ++++++--
 9 files changed, 18 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c
+++ linux-2.6/fs/jbd/commit.c
@@ -208,7 +208,7 @@ write_out_data:
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c
+++ linux-2.6/fs/jbd2/commit.c
@@ -208,7 +208,7 @@ write_out_data:
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -76,8 +76,7 @@ EXPORT_SYMBOL(__lock_buffer);
 
 void fastcall unlock_buffer(struct buffer_head *bh)
 {
-	smp_mb__before_clear_bit();
-	clear_buffer_locked(bh);
+	clear_bit_unlock(BH_Lock, &bh->b_state);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
 }
@@ -1688,7 +1687,7 @@ static int __block_write_full_page(struc
 		 */
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
-		} else if (test_set_buffer_locked(bh)) {
+		} else if (!trylock_buffer(bh)) {
 			redirty_page_for_writepage(wbc, page);
 			continue;
 		}
@@ -2943,7 +2942,7 @@ void ll_rw_block(int rw, int nr, struct 
 
 		if (rw == SWRITE)
 			lock_buffer(bh);
-		else if (test_set_buffer_locked(bh))
+		else if (!trylock_buffer(bh))
 			continue;
 
 		if (rw == WRITE || rw == SWRITE) {
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h
+++ linux-2.6/include/linux/buffer_head.h
@@ -115,7 +115,6 @@ BUFFER_FNS(Uptodate, uptodate)
 BUFFER_FNS(Dirty, dirty)
 TAS_BUFFER_FNS(Dirty, dirty)
 BUFFER_FNS(Lock, locked)
-TAS_BUFFER_FNS(Lock, locked)
 BUFFER_FNS(Req, req)
 TAS_BUFFER_FNS(Req, req)
 BUFFER_FNS(Mapped, mapped)
@@ -318,10 +317,15 @@ static inline void wait_on_buffer(struct
 		__wait_on_buffer(bh);
 }
 
+static inline int trylock_buffer(struct buffer_head *bh)
+{
+	return likely(!test_and_set_bit_lock(BH_Lock, &bh->b_state));
+}
+
 static inline void lock_buffer(struct buffer_head *bh)
 {
 	might_sleep();
-	if (test_set_buffer_locked(bh))
+	if (!trylock_buffer(bh))
 		__lock_buffer(bh);
 }
 
Index: linux-2.6/fs/ntfs/aops.c
===================================================================
--- linux-2.6.orig/fs/ntfs/aops.c
+++ linux-2.6/fs/ntfs/aops.c
@@ -1183,7 +1183,7 @@ lock_retry_remap:
 		tbh = bhs[i];
 		if (!tbh)
 			continue;
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			BUG();
 		/* The buffer dirty state is now irrelevant, just clean it. */
 		clear_buffer_dirty(tbh);
Index: linux-2.6/fs/ntfs/compress.c
===================================================================
--- linux-2.6.orig/fs/ntfs/compress.c
+++ linux-2.6/fs/ntfs/compress.c
@@ -655,7 +655,7 @@ lock_retry_remap:
 	for (i = 0; i < nr_bhs; i++) {
 		struct buffer_head *tbh = bhs[i];
 
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			continue;
 		if (unlikely(buffer_uptodate(tbh))) {
 			unlock_buffer(tbh);
Index: linux-2.6/fs/ntfs/mft.c
===================================================================
--- linux-2.6.orig/fs/ntfs/mft.c
+++ linux-2.6/fs/ntfs/mft.c
@@ -586,7 +586,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vo
 		for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
 			struct buffer_head *tbh = bhs[i_bhs];
 
-			if (unlikely(test_set_buffer_locked(tbh)))
+			if (!trylock_buffer(tbh))
 				BUG();
 			BUG_ON(!buffer_uptodate(tbh));
 			clear_buffer_dirty(tbh);
@@ -779,7 +779,7 @@ int write_mft_record_nolock(ntfs_inode *
 	for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
 		struct buffer_head *tbh = bhs[i_bhs];
 
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			BUG();
 		BUG_ON(!buffer_uptodate(tbh));
 		clear_buffer_dirty(tbh);
Index: linux-2.6/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/inode.c
+++ linux-2.6/fs/reiserfs/inode.c
@@ -2433,7 +2433,7 @@ static int reiserfs_write_full_page(stru
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
 		} else {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				redirty_page_for_writepage(wbc, page);
 				continue;
 			}
Index: linux-2.6/fs/reiserfs/journal.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/journal.c
+++ linux-2.6/fs/reiserfs/journal.c
@@ -857,7 +857,7 @@ static int write_ordered_buffers(spinloc
 		jh = JH_ENTRY(list->next);
 		bh = jh->bh;
 		get_bh(bh);
-		if (test_set_buffer_locked(bh)) {
+		if (!trylock_buffer(bh)) {
 			if (!buffer_dirty(bh)) {
 				list_move(&jh->list, &tmp);
 				goto loop_next;
@@ -3877,7 +3877,7 @@ int reiserfs_prepare_for_journal(struct 
 {
 	PROC_INFO_INC(p_s_sb, journal.prepare);
 
-	if (test_set_buffer_locked(bh)) {
+	if (!trylock_buffer(bh)) {
 		if (!wait)
 			return 0;
 		lock_buffer(bh);

-- 

