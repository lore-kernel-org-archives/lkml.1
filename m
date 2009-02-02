Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBBMcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBBMcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZBBMcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:32:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:42744 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbZBBMcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:32:05 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm] nilfs2: fix wrong counting of checkpoints and dirty segments
Date: Mon,  2 Feb 2009 21:26:27 +0900
Message-Id: <1233577587-27606-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 02 Feb 2009 21:31:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reinoud Zandijk found that counters for the number of checkpoints and
the number of dirty segments go wrong after a garbage collection.

This problem turns out to be a bug of counter operations using
le64_cpu_add() with a negative variable like:

  le64_cpu_add(&counter, -n);

where the variable n was not u64.

This fixes the problem by casting the delta to (u64).

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/cpfile.c |    2 +-
 fs/nilfs2/sufile.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 3ac0bb4..a4c9550 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -357,7 +357,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
-		le64_add_cpu(&header->ch_ncheckpoints, -tnicps);
+		le64_add_cpu(&header->ch_ncheckpoints, -(u64)tnicps);
 		nilfs_mdt_mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 		kunmap_atomic(kaddr, KM_USER0);
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index d672924..b3674a8 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -325,7 +325,7 @@ int nilfs_sufile_freev(struct inode *sufile, __u64 *segnum, size_t nsegs)
 	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
 	le64_add_cpu(&header->sh_ncleansegs, nsegs);
-	le64_add_cpu(&header->sh_ndirtysegs, -nsegs);
+	le64_add_cpu(&header->sh_ndirtysegs, -(u64)nsegs);
 	kunmap_atomic(kaddr, KM_USER0);
 	nilfs_mdt_mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(sufile);
-- 
1.5.6.5

