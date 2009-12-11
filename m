Return-Path: <linux-kernel-owner+w=401wt.eu-S1762348AbZLKE4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348AbZLKE4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbZLKEz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:55:59 -0500
Received: from kroah.org ([198.145.64.141]:36764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759936AbZLKEfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:53 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:42 2009
Message-Id: <20091211042741.985036844@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Frank Mayhar <fmayhar@google.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [24/90] ext4: Make non-journal fsync work properly
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0024-ext4-Make-non-journal-fsync-work-properly.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 91ac6f43317c0bf99969665f98016548011dfa38)

Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
mode:  If we're not using a journal, ext4_write_inode() now calls
ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
with a new "do_sync" parameter.  If that parameter is nonzero _and_ we're
not using a journal, ext4_do_update_inode() calls sync_dirty_buffer()
instead of ext4_handle_dirty_metadata().

This problem was found in power-fail testing, checking the amount of
loss of files and blocks after a power failure when using fsync() and
when not using fsync().  It turned out that using fsync() was actually
worse than not doing so, possibly because it increased the likelihood
that the inodes would remain unflushed and would therefore be lost at
the power failure.

Signed-off-by: Frank Mayhar <fmayhar@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   54 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4550,7 +4550,8 @@ static int ext4_inode_blocks_set(handle_
  */
 static int ext4_do_update_inode(handle_t *handle,
 				struct inode *inode,
-				struct ext4_iloc *iloc)
+				struct ext4_iloc *iloc,
+				int do_sync)
 {
 	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -4652,10 +4653,22 @@ static int ext4_do_update_inode(handle_t
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
-	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-	rc = ext4_handle_dirty_metadata(handle, inode, bh);
-	if (!err)
-		err = rc;
+	/*
+	 * If we're not using a journal and we were called from
+	 * ext4_write_inode() to sync the inode (making do_sync true),
+	 * we can just use sync_dirty_buffer() directly to do our dirty
+	 * work.  Testing s_journal here is a bit redundant but it's
+	 * worth it to avoid potential future trouble.
+	 */
+	if (EXT4_SB(inode->i_sb)->s_journal == NULL && do_sync) {
+		BUFFER_TRACE(bh, "call sync_dirty_buffer");
+		sync_dirty_buffer(bh);
+	} else {
+		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		rc = ext4_handle_dirty_metadata(handle, inode, bh);
+		if (!err)
+			err = rc;
+	}
 	ei->i_state &= ~EXT4_STATE_NEW;
 
 out_brelse:
@@ -4701,19 +4714,32 @@ out_brelse:
  */
 int ext4_write_inode(struct inode *inode, int wait)
 {
+	int err;
+
 	if (current->flags & PF_MEMALLOC)
 		return 0;
 
-	if (ext4_journal_current_handle()) {
-		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
-		dump_stack();
-		return -EIO;
-	}
+	if (EXT4_SB(inode->i_sb)->s_journal) {
+		if (ext4_journal_current_handle()) {
+			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
+			dump_stack();
+			return -EIO;
+		}
 
-	if (!wait)
-		return 0;
+		if (!wait)
+			return 0;
+
+		err = ext4_force_commit(inode->i_sb);
+	} else {
+		struct ext4_iloc iloc;
 
-	return ext4_force_commit(inode->i_sb);
+		err = ext4_get_inode_loc(inode, &iloc);
+		if (err)
+			return err;
+		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
+					   inode, &iloc, wait);
+	}
+	return err;
 }
 
 /*
@@ -5007,7 +5033,7 @@ int ext4_mark_iloc_dirty(handle_t *handl
 	get_bh(iloc->bh);
 
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
-	err = ext4_do_update_inode(handle, inode, iloc);
+	err = ext4_do_update_inode(handle, inode, iloc, 0);
 	put_bh(iloc->bh);
 	return err;
 }


