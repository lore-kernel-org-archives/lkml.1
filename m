Return-Path: <linux-kernel-owner+w=401wt.eu-S1751445AbZIHPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbZIHPJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZIHPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:09:33 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:53275 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZIHPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:09:30 -0400
From: Chris Mason <chris.mason@oracle.com>
To: jack@suse.cz, tytso@mit.edu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/2] Ext3: Fix race in ext3_mark_inode_dirty
Date: Tue,  8 Sep 2009 11:09:54 -0400
Message-Id: <1252422595-4554-2-git-send-email-chris.mason@oracle.com>
X-Mailer: git-send-email 1.6.4.1
In-Reply-To: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
References: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
X-Source-IP: abhmt015.oracle.com [141.146.116.24]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AA673A6.0126:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext3_mark_inode_dirty has no internal locking to make sure that
only one CPU is updating the buffer head at a time.  Generally this
works out ok because everyone that changes the inode then calls
ext3_mark_inode_dirty themselves.  Even though it races, eventually
someone updates the buffer heads and things move on.

But there is still a risk of the wrong values getting in, and the
data=guarded code seems to hit the race very often.

Since everyone that changes the inode also logs it, it should be
possible to fix this with some memory barriers.  I'll leave that as an
exercise to the reader and lock the buffer head instead.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 fs/ext3/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b49908a..a272365 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2892,6 +2892,10 @@ static int ext3_do_update_inode(handle_t *handle,
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
 
+again:
+	/* we can't allow multiple procs in here at once, its a bit racey */
+	lock_buffer(bh);
+
 	/* For fields not not tracking in the in-memory inode,
 	 * initialise them to zero for new inodes. */
 	if (ei->i_state & EXT3_STATE_NEW)
@@ -2951,16 +2955,20 @@ static int ext3_do_update_inode(handle_t *handle,
 			       /* If this is the first large file
 				* created, add a flag to the superblock.
 				*/
+				unlock_buffer(bh);
 				err = ext3_journal_get_write_access(handle,
 						EXT3_SB(sb)->s_sbh);
 				if (err)
 					goto out_brelse;
+
 				ext3_update_dynamic_rev(sb);
 				EXT3_SET_RO_COMPAT_FEATURE(sb,
 					EXT3_FEATURE_RO_COMPAT_LARGE_FILE);
 				handle->h_sync = 1;
 				err = ext3_journal_dirty_metadata(handle,
 						EXT3_SB(sb)->s_sbh);
+				/* get our lock and start over */
+				goto again;
 			}
 		}
 	}
@@ -2983,6 +2991,7 @@ static int ext3_do_update_inode(handle_t *handle,
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 
 	BUFFER_TRACE(bh, "call ext3_journal_dirty_metadata");
+	unlock_buffer(bh);
 	rc = ext3_journal_dirty_metadata(handle, bh);
 	if (!err)
 		err = rc;
@@ -2991,6 +3000,7 @@ static int ext3_do_update_inode(handle_t *handle,
 out_brelse:
 	brelse (bh);
 	ext3_std_error(inode->i_sb, err);
+
 	return err;
 }
 
-- 
1.6.4.1

