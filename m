Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYBDQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYBDQoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYBDQoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:44:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:45210 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753970AbYBDQop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:44:45 -0500
Date: Mon, 4 Feb 2008 17:44:43 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix private_list handling
Message-ID: <20080204164443.GE3426@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two possible races in handling of private_list in buffer cache.
1) When fsync_buffers_list() processes a private_list, it clears
b_assoc_mapping and moves buffer to its private list. Now drop_buffers() comes,
sees a buffer is on list so it calls __remove_assoc_queue() which complains
about b_assoc_mapping being cleared (as it cannot propagate possible IO error).
This race has been actually observed in the wild.
2) When fsync_buffers_list() processes a private_list,
mark_buffer_dirty_inode() can be called on bh which is already on the private
list of fsync_buffers_list(). As buffer is on some list (note that the check is
performed without private_lock), it is not readded to the mapping's
private_list and after fsync_buffers_list() finishes, we have a dirty buffer
which should be on private_list but it isn't. This race has not been reported,
probably because most (but not all) callers of mark_buffer_dirty_inode() hold
i_mutex and thus are serialized with fsync().

Fix these issues by not clearing b_assoc_map when fsync_buffers_list() moves
buffer to a dedicated list and by reinserting buffer in private_list when
it is found dirty after we have submitted buffer for IO. We also change the
tests whether a buffer is on a private list from
 !list_empty(&bh->b_assoc_buffers) to bh->b_assoc_map
so that they are single word reads and hence lockless checks are safe.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: Nick Piggin <npiggin@suse.de>

---
Hi Andrew,

this is the latest version of the fix for private_list handling races. The
changes are now smaller so I hope you'll like the patch more... Please
apply if you now think the patch is fine. Thanks.

									Honza

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..76e1ab4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -678,7 +678,7 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	} else {
 		BUG_ON(mapping->assoc_mapping != buffer_mapping);
 	}
-	if (list_empty(&bh->b_assoc_buffers)) {
+	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
 				&mapping->private_list);
@@ -794,6 +794,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct list_head tmp;
+	struct address_space *mapping;
 	int err = 0, err2;
 
 	INIT_LIST_HEAD(&tmp);
@@ -801,9 +802,14 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 	spin_lock(lock);
 	while (!list_empty(list)) {
 		bh = BH_ENTRY(list->next);
+		mapping = bh->b_assoc_map;
 		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
 		if (buffer_dirty(bh) || buffer_locked(bh)) {
 			list_add(&bh->b_assoc_buffers, &tmp);
+			bh->b_assoc_map = mapping;
 			if (buffer_dirty(bh)) {
 				get_bh(bh);
 				spin_unlock(lock);
@@ -822,8 +828,17 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 
 	while (!list_empty(&tmp)) {
 		bh = BH_ENTRY(tmp.prev);
-		list_del_init(&bh->b_assoc_buffers);
 		get_bh(bh);
+		mapping = bh->b_assoc_map;
+		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
+		if (buffer_dirty(bh)) {
+			list_add(&bh->b_assoc_buffers,
+				 &bh->b_assoc_map->private_list);
+			bh->b_assoc_map = mapping;
+		}
 		spin_unlock(lock);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
@@ -1195,7 +1210,7 @@ void __brelse(struct buffer_head * buf)
 void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
-	if (!list_empty(&bh->b_assoc_buffers)) {
+	if (bh->b_assoc_map) {
 		struct address_space *buffer_mapping = bh->b_page->mapping;
 
 		spin_lock(&buffer_mapping->private_lock);
@@ -3037,7 +3052,7 @@ drop_buffers(struct page *page, struct buffer_head **buffers_to_free)
 	do {
 		struct buffer_head *next = bh->b_this_page;
 
-		if (!list_empty(&bh->b_assoc_buffers))
+		if (bh->b_assoc_map)
 			__remove_assoc_queue(bh);
 		bh = next;
 	} while (bh != head);
