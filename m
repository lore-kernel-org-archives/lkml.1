Return-Path: <linux-kernel-owner+w=401wt.eu-S934440AbZLKEry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440AbZLKEry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933333AbZLKErv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:47:51 -0500
Received: from kroah.org ([198.145.64.141]:37024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761931AbZLKEga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:30 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:08 2009
Message-Id: <20091211042807.711256423@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [63/90] ext4: make sure directory and symlink blocks are revoked
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0063-ext4-make-sure-directory-and-symlink-blocks-are-revo.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 50689696867d95b38d9c7be640a311494a04fb86)

When an inode gets unlinked, the functions ext4_clear_blocks() and
ext4_remove_blocks() call ext4_forget() for all the buffer heads
corresponding to the deleted inode's data blocks.  If the inode is a
directory or a symlink, the is_metadata parameter must be non-zero so
ext4_forget() will revoke them via jbd2_journal_revoke().  Otherwise,
if these blocks are reused for a data file, and the system crashes
before a journal checkpoint, the journal replay could end up
corrupting these data blocks.

Thanks to Curt Wohlgemuth for pointing out potential problems in this
area.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2055,7 +2055,7 @@ static int ext4_remove_blocks(handle_t *
 		ext_debug("free last %u blocks starting %llu\n", num, start);
 		for (i = 0; i < num; i++) {
 			bh = sb_find_get_block(inode->i_sb, start + i);
-			ext4_forget(handle, 0, inode, bh, start + i);
+			ext4_forget(handle, metadata, inode, bh, start + i);
 		}
 		ext4_free_blocks(handle, inode, start, num, metadata);
 	} else if (from == le32_to_cpu(ex->ee_block)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4110,6 +4110,8 @@ static void ext4_clear_blocks(handle_t *
 			      __le32 *last)
 {
 	__le32 *p;
+	int	is_metadata = S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode);
+
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
 			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
@@ -4140,11 +4142,11 @@ static void ext4_clear_blocks(handle_t *
 
 			*p = 0;
 			tbh = sb_find_get_block(inode->i_sb, nr);
-			ext4_forget(handle, 0, inode, tbh, nr);
+			ext4_forget(handle, is_metadata, inode, tbh, nr);
 		}
 	}
 
-	ext4_free_blocks(handle, inode, block_to_free, count, 0);
+	ext4_free_blocks(handle, inode, block_to_free, count, is_metadata);
 }
 
 /**


