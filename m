Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYGERuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYGERuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYGERiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:19 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33092 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755945AbYGERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 16/52] ext4: remove quota allocation when ext4_mb_new_blocks fails
Date: Sat,  5 Jul 2008 13:35:42 -0400
Message-Id: <1215279378-30504-17-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-16-git-send-email-tytso@mit.edu>
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen Feng <shen@cn.fujitsu.com>

Quota allocation is not removed when ext4_mb_new_blocks calls
kmem_cache_alloc failed.  Also make sure the allocation context is freed
on the error path.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 11acfe5..8b67414 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4052,8 +4052,9 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (!ac) {
+		ar->len = 0;
 		*errp = -ENOMEM;
-		return 0;
+		goto out1;
 	}
 
 	ext4_mb_poll_new_transaction(sb, handle);
@@ -4061,7 +4062,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	*errp = ext4_mb_initialize_context(ac, ar);
 	if (*errp) {
 		ar->len = 0;
-		goto out;
+		goto out2;
 	}
 
 	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
@@ -4109,11 +4110,12 @@ repeat:
 
 	ext4_mb_release_context(ac);
 
-out:
+out2:
+	kmem_cache_free(ext4_ac_cachep, ac);
+out1:
 	if (ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 
-	kmem_cache_free(ext4_ac_cachep, ac);
 	return block;
 }
 static void ext4_mb_poll_new_transaction(struct super_block *sb,
-- 
1.5.6.rc3.1.g36b7.dirty

