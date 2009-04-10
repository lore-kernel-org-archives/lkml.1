Return-Path: <linux-kernel-owner+w=401wt.eu-S935780AbZDJFhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935780AbZDJFhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbZDJFdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:58969 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759414AbZDJFdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:16 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 2/8] nilfs2: fix lockdep recursive locking warning on bmap
Date: Fri, 10 Apr 2009 14:27:55 +0900
Message-Id: <1239341281-20249-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bmap semaphore of DAT file can be held while a bmap of other files
is locked.  This has caused the following false detection of lockdep
check:

mount.nilfs2/4667 is trying to acquire lock:
 (&bmap->b_sem){..--}, at: [<d0c6c4b4>] nilfs_bmap_lookup_at_level+0x1a/0x74 [nilfs2]

but task is already holding lock:
 (&bmap->b_sem){..--}, at: [<d0c6c4b4>] nilfs_bmap_lookup_at_level+0x1a/0x74 [nilfs2]

This will fix the false detection by distinguishing semaphores of the
DAT and other files.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/bmap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 24638e0..064279e 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -688,6 +688,8 @@ static const struct nilfs_bmap_ptr_operations nilfs_bmap_ptr_ops_gc = {
 	.bpop_translate		=	NULL,
 };
 
+static struct lock_class_key nilfs_bmap_dat_lock_key;
+
 /**
  * nilfs_bmap_read - read a bmap from an inode
  * @bmap: bmap
@@ -715,6 +717,7 @@ int nilfs_bmap_read(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 		bmap->b_pops = &nilfs_bmap_ptr_ops_p;
 		bmap->b_last_allocated_key = 0;	/* XXX: use macro */
 		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
+		lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 		break;
 	case NILFS_CPFILE_INO:
 	case NILFS_SUFILE_INO:
@@ -772,6 +775,7 @@ void nilfs_bmap_init_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
 {
 	memcpy(gcbmap, bmap, sizeof(union nilfs_bmap_union));
 	init_rwsem(&gcbmap->b_sem);
+	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 	gcbmap->b_inode = &NILFS_BMAP_I(gcbmap)->vfs_inode;
 }
 
@@ -779,5 +783,6 @@ void nilfs_bmap_commit_gcdat(struct nilfs_bmap *gcbmap, struct nilfs_bmap *bmap)
 {
 	memcpy(bmap, gcbmap, sizeof(union nilfs_bmap_union));
 	init_rwsem(&bmap->b_sem);
+	lockdep_set_class(&bmap->b_sem, &nilfs_bmap_dat_lock_key);
 	bmap->b_inode = &NILFS_BMAP_I(bmap)->vfs_inode;
 }
-- 
1.5.6.5

