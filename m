Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbZDJFhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbZDJFhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbZDJFd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:58971 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759476AbZDJFdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:17 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 3/8] nilfs2: fix lockdep recursive locking warning on meta data files
Date: Fri, 10 Apr 2009 14:27:56 +0900
Message-Id: <1239341281-20249-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following false detection of lockdep against nilfs meta
data files:

=============================================
[ INFO: possible recursive locking detected ]
2.6.29 #26
---------------------------------------------
mount.nilfs2/4185 is trying to acquire lock:
 (&mi->mi_sem){----}, at: [<d0c7925b>] nilfs_sufile_get_stat+0x1e/0x105 [nilfs2]
 but task is already holding lock:
  (&mi->mi_sem){----}, at: [<d0c72026>] nilfs_count_free_blocks+0x48/0x84 [nilfs2]

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/the_nilfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 33400cf..7f65b3b 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -115,6 +115,7 @@ void put_nilfs(struct the_nilfs *nilfs)
 static int nilfs_load_super_root(struct the_nilfs *nilfs,
 				 struct nilfs_sb_info *sbi, sector_t sr_block)
 {
+	static struct lock_class_key dat_lock_key;
 	struct buffer_head *bh_sr;
 	struct nilfs_super_root *raw_sr;
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
@@ -163,6 +164,9 @@ static int nilfs_load_super_root(struct the_nilfs *nilfs,
 	if (unlikely(err))
 		goto failed_sufile;
 
+	lockdep_set_class(&NILFS_MDT(nilfs->ns_dat)->mi_sem, &dat_lock_key);
+	lockdep_set_class(&NILFS_MDT(nilfs->ns_gc_dat)->mi_sem, &dat_lock_key);
+
 	nilfs_mdt_set_shadow(nilfs->ns_dat, nilfs->ns_gc_dat);
 	nilfs_mdt_set_entry_size(nilfs->ns_cpfile, checkpoint_size,
 				 sizeof(struct nilfs_cpfile_header));
-- 
1.5.6.5

