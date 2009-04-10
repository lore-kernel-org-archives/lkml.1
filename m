Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbZDJFeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbZDJFeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbZDJFdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:33:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:58963 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882AbZDJFdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:33:14 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 6/8] nilfs2: fix wrong accounting and duplicate brelse in nilfs_sufile_set_error
Date: Fri, 10 Apr 2009 14:27:59 +0900
Message-Id: <1239341281-20249-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1239341281-20249-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 14:33:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nilfs_sufile_set_error() function wrongly adjusts the number of
dirty segments instead of the number of clean segments.  In addition,
the function calls brelse() twice for the same buffer head.

This fixes these bugs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/sufile.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 1ef2b4d..8b2f93c 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -523,7 +523,7 @@ int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 	struct nilfs_segment_usage *su;
 	struct nilfs_sufile_header *header;
 	void *kaddr;
-	int ret;
+	int suclean, ret;
 
 	if (unlikely(segnum >= nilfs_sufile_get_nsegments(sufile))) {
 		printk(KERN_WARNING "%s: invalid segment number: %llu\n",
@@ -546,16 +546,19 @@ int nilfs_sufile_set_error(struct inode *sufile, __u64 segnum)
 		brelse(su_bh);
 		goto out_header;
 	}
+	suclean = nilfs_segment_usage_clean(su);
 
 	nilfs_segment_usage_set_error(su);
 	kunmap_atomic(kaddr, KM_USER0);
-	brelse(su_bh);
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
-	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
-	le64_add_cpu(&header->sh_ndirtysegs, -1);
-	kunmap_atomic(kaddr, KM_USER0);
-	nilfs_mdt_mark_buffer_dirty(header_bh);
+	if (suclean) {
+		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		header = nilfs_sufile_block_get_header(sufile, header_bh,
+						       kaddr);
+		le64_add_cpu(&header->sh_ncleansegs, -1);
+		kunmap_atomic(kaddr, KM_USER0);
+		nilfs_mdt_mark_buffer_dirty(header_bh);
+	}
 	nilfs_mdt_mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);
 	brelse(su_bh);
-- 
1.5.6.5

