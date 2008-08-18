Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYHRMxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYHRMxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYHRMxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:53:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:50609 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754075AbYHRMxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:53:19 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Ingo Oeser <ioe-lkml@rameria.de>
Subject: [PATCH REVIEW] udf: Fix lock inversion between iprune_mutex and alloc_mutex (v2)
Date: Mon, 18 Aug 2008 14:53:17 +0200
Message-Id: <12190639982548-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: y
References: y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A memory allocation inside alloc_mutex must not recurse back into the
filesystem itself because that leads to lock inversion between iprune_mutex and
alloc_mutex (and thus to deadlocks - see traces below). alloc_mutex is actually
needed only to update allocation statistics in the superblock so we can drop it
before we start allocating memory for the inode.

tar           D ffff81015b9c8c90     0  6614   6612
 ffff8100d5a21a20 0000000000000086 0000000000000000 00000000ffff0000
 ffff81015b9c8c90 ffff81015b8f0cd0 ffff81015b9c8ee0 0000000000000000
 0000000000000003 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff803c1d8a>] __mutex_lock_slowpath+0x64/0x9b
 [<ffffffff803c1bef>] mutex_lock+0xa/0xb
 [<ffffffff8027f8c2>] shrink_icache_memory+0x38/0x200
 [<ffffffff80257742>] shrink_slab+0xe3/0x15b
 [<ffffffff802579db>] try_to_free_pages+0x221/0x30d
 [<ffffffff8025657e>] isolate_pages_global+0x0/0x31
 [<ffffffff8025324b>] __alloc_pages_internal+0x252/0x3ab
 [<ffffffff8026b08b>] cache_alloc_refill+0x22e/0x47b
 [<ffffffff8026ae37>] kmem_cache_alloc+0x3b/0x61
 [<ffffffff8026b15b>] cache_alloc_refill+0x2fe/0x47b
 [<ffffffff8026b34e>] __kmalloc+0x76/0x9c
 [<ffffffffa00751f2>] :udf:udf_new_inode+0x202/0x2e2
 [<ffffffffa007ae5e>] :udf:udf_create+0x2f/0x16d
 [<ffffffffa0078f27>] :udf:udf_lookup+0xa6/0xad
...
kswapd0       D ffff81015b9d9270     0   125      2
 ffff81015b903c28 0000000000000046 ffffffff8028cbb0 00000000fffffffb
 ffff81015b9d9270 ffff81015b8f0cd0 ffff81015b9d94c0 000000000271b490
 ffffe2000271b458 ffffe2000271b420 ffffe20002728dc8 ffffe20002728d90
Call Trace:
 [<ffffffff8028cbb0>] __set_page_dirty+0xeb/0xf5
 [<ffffffff8025403a>] get_dirty_limits+0x1d/0x22f
 [<ffffffff803c1d8a>] __mutex_lock_slowpath+0x64/0x9b
 [<ffffffff803c1bef>] mutex_lock+0xa/0xb
 [<ffffffffa0073f58>] :udf:udf_bitmap_free_blocks+0x47/0x1eb
 [<ffffffffa007df31>] :udf:udf_discard_prealloc+0xc6/0x172
 [<ffffffffa007875a>] :udf:udf_clear_inode+0x1e/0x48
 [<ffffffff8027f121>] clear_inode+0x6d/0xc4
 [<ffffffff8027f7f2>] dispose_list+0x56/0xee
 [<ffffffff8027fa5a>] shrink_icache_memory+0x1d0/0x200
 [<ffffffff80257742>] shrink_slab+0xe3/0x15b
 [<ffffffff80257e93>] kswapd+0x346/0x447
...

Reported-by: Tibor Tajti <tibor.tajti@gmail.com>
CC: Ingo Oeser <ioe-lkml@rameria.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/ialloc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index eb9cfa2..c4943c8 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -111,6 +111,7 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		lvhd->uniqueID = cpu_to_le64(uniqueID);
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
+	mutex_unlock(&sbi->s_alloc_mutex);
 	inode->i_mode = mode;
 	inode->i_uid = current->fsuid;
 	if (dir->i_mode & S_ISGID) {
@@ -145,7 +146,6 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	if (!iinfo->i_ext.i_data) {
 		iput(inode);
 		*err = -ENOMEM;
-		mutex_unlock(&sbi->s_alloc_mutex);
 		return NULL;
 	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
@@ -158,7 +158,6 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		iinfo->i_crtime = current_fs_time(inode->i_sb);
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
-	mutex_unlock(&sbi->s_alloc_mutex);
 
 	if (DQUOT_ALLOC_INODE(inode)) {
 		DQUOT_DROP(inode);
-- 
1.5.2.4

