Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbZDJFfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbZDJFfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762200AbZDJFdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:58978 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447AbZDJFdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:21 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Coly Li <coly.li@suse.de>
Subject: [PATCH 1/8] nilfs2: return f_fsid for statfs2
Date: Fri, 10 Apr 2009 14:27:54 +0900
Message-Id: <1239341281-20249-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This follows the change of Coly Li's series ("fs: return f_fsid for
statfs(2)"), and make nilfs2 return f_fsid info for statfs(2).

Cc: Coly Li <coly.li@suse.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index e117e1e..8a965f9 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -476,11 +476,12 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct the_nilfs *nilfs = sbi->s_nilfs;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 	unsigned long long blocks;
 	unsigned long overhead;
 	unsigned long nrsvblocks;
 	sector_t nfreeblocks;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
 	int err;
 
 	/*
@@ -514,6 +515,9 @@ static int nilfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = atomic_read(&sbi->s_inodes_count);
 	buf->f_ffree = 0; /* nilfs_count_free_inodes(sb); */
 	buf->f_namelen = NILFS_NAME_LEN;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
+
 	return 0;
 }
 
-- 
1.5.6.5

