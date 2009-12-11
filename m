Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbZLKEgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbZLKEgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762179AbZLKEgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:37 -0500
Received: from kroah.org ([198.145.64.141]:36757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbZLKEfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:52 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:41 2009
Message-Id: <20091211042741.225776673@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [23/90] ext4: Assure that metadata blocks are written during fsync in no journal mode
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0023-ext4-Assure-that-metadata-blocks-are-written-during-.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit fe188c0e084bdf3038dc0ac963c21d764f53f7da)

When there is no journal present, we must attach buffer heads
associated with extent tree and indirect blocks to the inode's
mapping->private_list via mark_buffer_dirty_inode() so that
ext4_sync_file() --- which is called to service fsync() and
fdatasync() system calls --- can write out the inode's metadata blocks
by calling sync_mapping_buffers().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4_jbd2.c |    5 ++++-
 fs/ext4/fsync.c     |    9 +++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -89,7 +89,10 @@ int __ext4_handle_dirty_metadata(const c
 			ext4_journal_abort_handle(where, __func__, bh,
 						  handle, err);
 	} else {
-		mark_buffer_dirty(bh);
+		if (inode && bh)
+			mark_buffer_dirty_inode(bh, inode);
+		else
+			mark_buffer_dirty(bh);
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
 			if (buffer_req(bh) && !buffer_uptodate(bh)) {
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -50,7 +50,7 @@ int ext4_sync_file(struct file *file, st
 {
 	struct inode *inode = dentry->d_inode;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int ret = 0;
+	int err, ret = 0;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -79,6 +79,9 @@ int ext4_sync_file(struct file *file, st
 		goto out;
 	}
 
+	if (!journal)
+		ret = sync_mapping_buffers(inode->i_mapping);
+
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
 		goto out;
 
@@ -91,7 +94,9 @@ int ext4_sync_file(struct file *file, st
 			.sync_mode = WB_SYNC_ALL,
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
-		ret = sync_inode(inode, &wbc);
+		err = sync_inode(inode, &wbc);
+		if (ret == 0)
+			ret = err;
 	}
 out:
 	if (journal && (journal->j_flags & JBD2_BARRIER))


