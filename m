Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYHMIln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYHMIln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbYHMIj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37125 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbYHMIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:26 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: increment commit number earlier
Date: Wed, 13 Aug 2008 13:17:41 +0300
Message-Id: <1218622675-28853-13-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0425 (UTC) FILETIME=[0A560710:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Increment the commit number at the beginnig of the commit, instead
of doing this after the commit. This is needed for further
optimizations.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/commit.c |    3 ++-
 fs/ubifs/log.c    |    2 +-
 fs/ubifs/orphan.c |    4 ++--
 fs/ubifs/ubifs.h  |    3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index 3b51631..0a6aa2c 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -74,6 +74,7 @@ static int do_commit(struct ubifs_info *c)
 			goto out_up;
 	}
 
+	c->cmt_no += 1;
 	err = ubifs_gc_start_commit(c);
 	if (err)
 		goto out_up;
@@ -115,7 +116,7 @@ static int do_commit(struct ubifs_info *c)
 		goto out;
 
 	mutex_lock(&c->mst_mutex);
-	c->mst_node->cmt_no      = cpu_to_le64(++c->cmt_no);
+	c->mst_node->cmt_no      = cpu_to_le64(c->cmt_no);
 	c->mst_node->log_lnum    = cpu_to_le32(new_ltail_lnum);
 	c->mst_node->root_lnum   = cpu_to_le32(zroot.lnum);
 	c->mst_node->root_offs   = cpu_to_le32(zroot.offs);
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index e14829e..3e0aa73 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -412,7 +412,7 @@ int ubifs_log_start_commit(struct ubifs_info *c, int *ltail_lnum)
 		return -ENOMEM;
 
 	cs->ch.node_type = UBIFS_CS_NODE;
-	cs->cmt_no = cpu_to_le64(c->cmt_no + 1);
+	cs->cmt_no = cpu_to_le64(c->cmt_no);
 	ubifs_prepare_node(c, cs, UBIFS_CS_NODE_SZ, 0);
 
 	/*
diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index 3afeb92..02d3462 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -310,10 +310,10 @@ static int write_orph_node(struct ubifs_info *c, int atomic)
 	c->cmt_orphans -= cnt;
 	spin_unlock(&c->orphan_lock);
 	if (c->cmt_orphans)
-		orph->cmt_no = cpu_to_le64(c->cmt_no + 1);
+		orph->cmt_no = cpu_to_le64(c->cmt_no);
 	else
 		/* Mark the last node of the commit */
-		orph->cmt_no = cpu_to_le64((c->cmt_no + 1) | (1ULL << 63));
+		orph->cmt_no = cpu_to_le64((c->cmt_no) | (1ULL << 63));
 	ubifs_assert(c->ohead_offs + len <= c->leb_size);
 	ubifs_assert(c->ohead_lnum >= c->orph_first);
 	ubifs_assert(c->ohead_lnum <= c->orph_last);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 6ddd1de..21502b6 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -865,7 +865,8 @@ struct ubifs_mount_opts {
  * @highest_inum: highest used inode number
  * @vfs_gen: VFS inode generation counter
  * @max_sqnum: current global sequence number
- * @cmt_no: commit number (last successfully completed commit)
+ * @cmt_no: commit number of the last successfully completed commit, protected
+ *          by @commit_sem
  * @cnt_lock: protects @highest_inum, @vfs_gen, and @max_sqnum counters
  * @fmt_version: UBIFS on-flash format version
  * @uuid: UUID from super block
-- 
1.5.4.1

