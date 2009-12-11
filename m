Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbZLKEhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbZLKEhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbZLKEhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:05 -0500
Received: from kroah.org ([198.145.64.141]:36916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760795AbZLKEgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:13 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:58 2009
Message-Id: <20091211042758.055563900@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Frank Mayhar <fmayhar@google.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [46/90] ext4: Avoid updating the inode table bh twice in no journal mode
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0046-ext4-Avoid-updating-the-inode-table-bh-twice-in-no-j.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 830156c79b0a99ddf0f62496bcf4de640f9f52cd)

This is a cleanup of commit 91ac6f4.  Since ext4_mark_inode_dirty()
has already called ext4_mark_iloc_dirty(), which in turn calls
ext4_do_update_inode(), it's not necessary to have ext4_write_inode()
call ext4_do_update_inode() in no journal mode.  Indeed, it would be
duplicated work.

Reviewed-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Frank Mayhar <fmayhar@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4981,8 +4981,7 @@ static int ext4_inode_blocks_set(handle_
  */
 static int ext4_do_update_inode(handle_t *handle,
 				struct inode *inode,
-				struct ext4_iloc *iloc,
-				int do_sync)
+				struct ext4_iloc *iloc)
 {
 	struct ext4_inode *raw_inode = ext4_raw_inode(iloc);
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -5083,22 +5082,10 @@ static int ext4_do_update_inode(handle_t
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
-	/*
-	 * If we're not using a journal and we were called from
-	 * ext4_write_inode() to sync the inode (making do_sync true),
-	 * we can just use sync_dirty_buffer() directly to do our dirty
-	 * work.  Testing s_journal here is a bit redundant but it's
-	 * worth it to avoid potential future trouble.
-	 */
-	if (EXT4_SB(inode->i_sb)->s_journal == NULL && do_sync) {
-		BUFFER_TRACE(bh, "call sync_dirty_buffer");
-		sync_dirty_buffer(bh);
-	} else {
-		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-		rc = ext4_handle_dirty_metadata(handle, inode, bh);
-		if (!err)
-			err = rc;
-	}
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	rc = ext4_handle_dirty_metadata(handle, inode, bh);
+	if (!err)
+		err = rc;
 	ei->i_state &= ~EXT4_STATE_NEW;
 
 out_brelse:
@@ -5166,8 +5153,16 @@ int ext4_write_inode(struct inode *inode
 		err = ext4_get_inode_loc(inode, &iloc);
 		if (err)
 			return err;
-		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
-					   inode, &iloc, wait);
+		if (wait)
+			sync_dirty_buffer(iloc.bh);
+		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
+			ext4_error(inode->i_sb, __func__,
+				   "IO error syncing inode, "
+				   "inode=%lu, block=%llu",
+				   inode->i_ino,
+				   (unsigned long long)iloc.bh->b_blocknr);
+			err = -EIO;
+		}
 	}
 	return err;
 }
@@ -5463,7 +5458,7 @@ int ext4_mark_iloc_dirty(handle_t *handl
 	get_bh(iloc->bh);
 
 	/* ext4_do_update_inode() does jbd2_journal_dirty_metadata */
-	err = ext4_do_update_inode(handle, inode, iloc, 0);
+	err = ext4_do_update_inode(handle, inode, iloc);
 	put_bh(iloc->bh);
 	return err;
 }


