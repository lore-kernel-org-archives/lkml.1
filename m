Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbYA1WWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbYA1WWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYA1WRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:17:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:58454 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763411AbYA1WRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:17:00 -0500
Date: Mon, 28 Jan 2008 23:16:56 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Message-ID: <20080128221655.GC4145@duck.suse.cz>
References: <20080122171025.GB4485@duck.suse.cz> <200801240205.17005.nickpiggin@yahoo.com.au> <20080123154818.GD10144@duck.suse.cz> <200801251934.08160.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801251934.08160.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-01-08 19:34:07, Nick Piggin wrote:
> > > But let's see... there must be a memory ordering problem here in existing
> > > code anyway, because I don't see any barriers. Between b_assoc_buffers
> > > and b_state (via buffer_dirty); fsync_buffers_list vs
> > > mark_buffer_dirty_inode, right?
> >
> >   I'm not sure. What exactly to you mean? BTW: spin_lock is a memory
> > barrier, isn't it?
> 
> In existing code:
> 
> mark_buffer_dirty_inode():              fsync_buffers_list():
>  test_set_buffer_dirty(bh);              list_del_init(&bh->b_assoc_buffers);
>  if (list_empty(&bh->b_assoc_buffers))   if (buffer_dirty(bh)) {
>      ...                                   list_add(&bh->b_assoc_buffers, );
> 
> These two code sequences can run concurrently because only fsync_buffers_list
> takes the lock.
> 
> So fsync_buffers_list can speculatively load bh->b_state before
> its stores to clear b_assoc_buffers propagate to the CPU running
> mark_buffer_dirty_inode.
> 
> So if there is a !dirty buffer on the list, then fsync_buffers_list will
> remove it from the list, but mark_buffer_dirty_inode won't see it has been
> removed from the list and won't re-add it. I think.
> 
> This is actually even possible to hit on x86 because they reorder loads
> past stores. It needs a smp_mb() before if (buffer_dirty(bh) {}.
> 
> Actually I very much dislike testing list entries locklessly, because they
> are not trivially atomic operations like single stores... which is another
> reason why I like your first patch.
  OK, Nick, how do you like the patch below?

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
it is found dirty after we have submitted buffer for IO.

Signed-off-by: Jan Kara <jack@suse.cz>

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
