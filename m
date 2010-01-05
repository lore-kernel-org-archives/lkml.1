Return-Path: <linux-kernel-owner+w=401wt.eu-S932187Ab0AEUHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0AEUHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556Ab0AEUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:54 -0500
Received: from kroah.org ([198.145.64.141]:50104 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab0AEUGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:04 2010
Message-Id: <20100105200304.069136093@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Theodore Tso <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>,
       Jan Kara <jack@suse.cz>
Subject: [39/39] ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 39bc680a8160bb9d6743f7873b535d553ff61058 upstream.

Unlock i_block_reservation_lock before vfs_dq_reserve_block().
This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=14739

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1859,19 +1859,17 @@ repeat:
 
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * Make quota reservation here to prevent quota overflow
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	if (vfs_dq_reserve_block(inode, total))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
@@ -1879,10 +1877,11 @@ repeat:
 		}
 		return -ENOSPC;
 	}
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
-
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
 	return 0;       /* success */
 }
 


