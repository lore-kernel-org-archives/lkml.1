Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbYCDTLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbYCDTLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765587AbYCDTLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:11:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:56014 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762389AbYCDTLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:11:41 -0500
Date: Tue, 4 Mar 2008 20:11:40 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Fix NULL pointer dereference in fsync_buffers_list()
Message-ID: <20080304191140.GE24335@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NULL pointer dereference in fsync_buffers_list() introduced by recent fix
of races in private_list handling. Since bh->b_assoc_map has been cleared in
__remove_assoc_queue() we should really use original value stored in the
'mapping' variable.

Signed-off-by: Jan Kara <jack@suse.cz>
---

Hmm, somehow testing of private_list handling patch on ext2 never hit the code path with
the bug :(. UDF did... Please push to Linus. Thanks.

diff --git a/fs/buffer.c b/fs/buffer.c
index 897cd74..ddfdd2c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -835,7 +835,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 		smp_mb();
 		if (buffer_dirty(bh)) {
 			list_add(&bh->b_assoc_buffers,
-				 &bh->b_assoc_map->private_list);
+				 &mapping->private_list);
 			bh->b_assoc_map = mapping;
 		}
 		spin_unlock(lock);
