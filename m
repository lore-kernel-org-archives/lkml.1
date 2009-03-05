Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZCEQMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZCEQMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZCEQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:11:26 -0500
Received: from sh.osrg.net ([192.16.179.4]:40821 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbZCEQLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:11:20 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH -mm 1/5] nilfs2: super block operations fix endian bug
Date: Fri,  6 Mar 2009 01:07:45 +0900
Message-Id: <1236269269-512-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1236269269-512-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Mar 2009 01:11:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a missing endian conversion of checksum field in the super
block.  This fixes compatibility issue on big endian machines which
will come to surface after supporting recovery of super block.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index d0639a6..b7519c3 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -287,9 +287,9 @@ int nilfs_commit_super(struct nilfs_sb_info *sbi)
 	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
 	sbp->s_wtime = cpu_to_le64(get_seconds());
 	sbp->s_sum = 0;
-	sbp->s_sum = crc32_le(nilfs->ns_crc_seed, (unsigned char *)sbp,
-			      le16_to_cpu(sbp->s_bytes));
-
+	sbp->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
+					  (unsigned char *)sbp,
+					  le16_to_cpu(sbp->s_bytes)));
 	sbi->s_super->s_dirt = 0;
 	return nilfs_sync_super(sbi);
 }
-- 
1.5.6.5

