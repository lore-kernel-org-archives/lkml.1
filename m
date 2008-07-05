Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYGERxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYGERxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYGERij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:39 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33122 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756158AbYGERge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 29/52] ext4: use atomic functions to set bh_state
Date: Sat,  5 Jul 2008 13:35:55 -0400
Message-Id: <1215279378-30504-30-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-29-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Use the BUFFER_FNS functions (set_buffer_foo) to set buffer
head state atomically instead of nonatomic __set_bit().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 555155d..bb36a28 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2622,8 +2622,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 				 */
 				if (allocated > max_blocks)
 					allocated = max_blocks;
-				/* mark the buffer unwritten */
-				__set_bit(BH_Unwritten, &bh_result->b_state);
+				set_buffer_unwritten(bh_result);
 				goto out2;
 			}
 
@@ -2729,7 +2728,7 @@ outnew:
 	if (extend_disksize && inode->i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = inode->i_size;
 
-	__set_bit(BH_New, &bh_result->b_state);
+	set_buffer_new(bh_result);
 
 	/* Cache only when it is _not_ an uninitialized extent */
 	if (create != EXT4_CREATE_UNINITIALIZED_EXT)
@@ -2739,7 +2738,7 @@ out:
 	if (allocated > max_blocks)
 		allocated = max_blocks;
 	ext4_ext_show_leaf(inode, path);
-	__set_bit(BH_Mapped, &bh_result->b_state);
+	set_buffer_mapped(bh_result);
 	bh_result->b_bdev = inode->i_sb->s_bdev;
 	bh_result->b_blocknr = newblock;
 out2:
-- 
1.5.6.rc3.1.g36b7.dirty

