Return-Path: <linux-kernel-owner+w=401wt.eu-S1762578AbZENCB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762578AbZENCB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762072AbZENCA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:00:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:50287 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZENCAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iJhHPdeIdEJPJnKQGDjKLzcq/HnE/K5Zwxy2Ha6hkpD/SMxQfRy4U6gzertutTuU6x
         H/ZUaDDjyosdjmkEbitQ49my+ODofdUs9C0VmfyLqghk1iA1hFTJ4xwjSv+W2mJYdywL
         I/gII8tOeOlYVxxylASy0whr4f9Odtbd2kJyU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] kill-the-bkl/reiserfs: unlock only when needed in search_by_key
Date: Thu, 14 May 2009 04:00:49 +0200
Message-Id: <1242266449-21121-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1242266449-21121-1-git-send-email-fweisbec@gmail.com>
References: <1242266449-21121-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

search_by_key() is the site which most requires the lock.
This is mostly because it is a very central function and also
because it releases/reaqcuires the write lock at least once each
time it is called.

Such release/reacquire creates a lot of contention in this place and
also opens more the window which let another thread changing the tree.
When it happens, the current path searching over the tree must be
retried from the beggining (the root) which is a wasteful and
time consuming recovery.

This patch factorizes two release/reacquire sequences:

- reading leaf nodes blocks
- reading current block

The latter immediately follows the former.

The whole sequence is safe as a single unlocked section because
we check just after if the tree has changed during these operations.

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/stree.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 960c911..6b025a4 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -519,12 +519,22 @@ static int is_tree_node(struct buffer_head *bh, int level)
 
 #define SEARCH_BY_KEY_READA 16
 
-/* The function is NOT SCHEDULE-SAFE! */
-static void search_by_key_reada(struct super_block *s,
+/*
+ * The function is NOT SCHEDULE-SAFE!
+ * It might unlock the write lock if we needed to wait for a block
+ * to be read. Note that in this case it won't recover the lock to avoid
+ * high contention resulting from too much lock requests, especially
+ * the caller (search_by_key) will perform other schedule-unsafe
+ * operations just after calling this function.
+ *
+ * @return true if we have unlocked
+ */
+static bool search_by_key_reada(struct super_block *s,
 				struct buffer_head **bh,
 				b_blocknr_t *b, int num)
 {
 	int i, j;
+	bool unlocked = false;
 
 	for (i = 0; i < num; i++) {
 		bh[i] = sb_getblk(s, b[i]);
@@ -536,16 +546,21 @@ static void search_by_key_reada(struct super_block *s,
 	 * the lock. But it's still fine because we check later
 	 * if the tree changed
 	 */
-	reiserfs_write_unlock(s);
 	for (j = 0; j < i; j++) {
 		/*
 		 * note, this needs attention if we are getting rid of the BKL
 		 * you have to make sure the prepared bit isn't set on this buffer
 		 */
-		if (!buffer_uptodate(bh[j]))
+		if (!buffer_uptodate(bh[j])) {
+			if (!unlocked) {
+				reiserfs_write_unlock(s);
+				unlocked = true;
+			}
 			ll_rw_block(READA, 1, bh + j);
+		}
 		brelse(bh[j]);
 	}
+	return unlocked;
 }
 
 /**************************************************************************
@@ -633,15 +648,26 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
 		   have a pointer to it. */
 		if ((bh = last_element->pe_buffer =
 		     sb_getblk(sb, block_number))) {
+			bool unlocked = false;
+
 			if (!buffer_uptodate(bh) && reada_count > 1)
-				/* will unlock the write lock */
-				search_by_key_reada(sb, reada_bh,
+				/* may unlock the write lock */
+				unlocked = search_by_key_reada(sb, reada_bh,
 						    reada_blocks, reada_count);
-			else
+			/*
+			 * If we haven't already unlocked the write lock,
+			 * then we need to do that here before reading
+			 * the current block
+			 */
+			if (!buffer_uptodate(bh) && !unlocked) {
 				reiserfs_write_unlock(sb);
+				unlocked = true;
+			}
 			ll_rw_block(READ, 1, &bh);
 			wait_on_buffer(bh);
-			reiserfs_write_lock(sb);
+
+			if (unlocked)
+				reiserfs_write_lock(sb);
 			if (!buffer_uptodate(bh))
 				goto io_error;
 		} else {
-- 
1.6.2.3

