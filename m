Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYAVRKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYAVRKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYAVRK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:10:27 -0500
Received: from styx.suse.cz ([82.119.242.94]:56368 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751929AbYAVRK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:10:27 -0500
Date: Tue, 22 Jan 2008 18:10:25 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] Minimal fix for private_list handling races
Message-ID: <20080122171025.GB4485@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  as I got no answer for a week, I'm resending this fix for races in
private_list handling. Andrew, do you like them more than the previous
version?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

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
it is found dirty after the IO has completed.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..3ffb2b6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -794,6 +794,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct list_head tmp;
+	struct address_space *mapping;
 	int err = 0, err2;
 
 	INIT_LIST_HEAD(&tmp);
@@ -801,9 +802,11 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 	spin_lock(lock);
 	while (!list_empty(list)) {
 		bh = BH_ENTRY(list->next);
+		mapping = bh->b_assoc_map;
 		__remove_assoc_queue(bh);
 		if (buffer_dirty(bh) || buffer_locked(bh)) {
 			list_add(&bh->b_assoc_buffers, &tmp);
+			bh->b_assoc_map = mapping;
 			if (buffer_dirty(bh)) {
 				get_bh(bh);
 				spin_unlock(lock);
@@ -828,8 +831,13 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			err = -EIO;
-		brelse(bh);
 		spin_lock(lock);
+		if (buffer_dirty(bh) && list_empty(&bh->b_assoc_buffers)) {
+			BUG_ON(!bh->b_assoc_map);
+			list_add(&bh->b_assoc_buffers,
+				 &bh->b_assoc_map->private_list);
+		}
+		brelse(bh);
 	}
 	
 	spin_unlock(lock);
