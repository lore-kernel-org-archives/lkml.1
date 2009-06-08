Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZFHTcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZFHTcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZFHTXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:52 -0400
Received: from thunk.org ([69.25.196.29]:39604 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZFHTXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 25/49] ext4: fix the length returned by fiemap for an unallocated extent
Date: Mon,  8 Jun 2009 15:22:43 -0400
Message-Id: <1244488987-32564-26-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-25-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the file's blocks have not yet been allocated because of delayed
allocation, the length of the extent returned by fiemap is incorrect.
This commit fixes this bug.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5f72952..4fec6b7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3244,8 +3244,15 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
 	 */
 	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
-	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK)
+	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK) {
+		loff_t size = i_size_read(inode);
+		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
+
 		flags |= FIEMAP_EXTENT_LAST;
+		if ((flags & FIEMAP_EXTENT_DELALLOC) &&
+		    logical+length > size)
+			length = (size - logical + bs - 1) & ~(bs-1);
+	}
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
 					length, flags);
-- 
1.6.3.2.1.gb9f7d.dirty

