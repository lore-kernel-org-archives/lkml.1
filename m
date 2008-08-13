Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbYHMIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbYHMIrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYHMIjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37220 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYHMIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:47 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: always set i_generation to 0
Date: Wed, 13 Aug 2008 13:17:53 +0300
Message-Id: <1218622675-28853-25-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:04.0566 (UTC) FILETIME=[0B042160:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

UBIFS does not presently re-use inode numbers, so leaving
i_generation zero is most appropriate for now.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/dir.c   |    1 -
 fs/ubifs/super.c |    2 --
 fs/ubifs/ubifs.h |    4 +---
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index eba3a8a..0d1ab89 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -165,7 +165,6 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, const struct inode *dir,
 	}
 
 	inode->i_ino = ++c->highest_inum;
-	inode->i_generation = ++c->vfs_gen;
 	/*
 	 * The creation sequence number remains with this inode for its
 	 * lifetime. All nodes for this inode have a greater sequence number,
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 6cc4175..2c268a4 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
-#include <linux/random.h>
 #include <linux/kthread.h>
 #include <linux/parser.h>
 #include <linux/seq_file.h>
@@ -1671,7 +1670,6 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	INIT_LIST_HEAD(&c->orph_new);
 
 	c->highest_inum = UBIFS_FIRST_INO;
-	get_random_bytes(&c->vfs_gen, sizeof(int));
 	c->lhead_lnum = c->ltail_lnum = UBIFS_LOG_LNUM;
 
 	ubi_get_volume_info(ubi, &c->vi);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 73ca8a0..f2dd749 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -876,11 +876,10 @@ struct ubifs_mount_opts {
  * @bdi: backing device info object to make VFS happy and disable read-ahead
  *
  * @highest_inum: highest used inode number
- * @vfs_gen: VFS inode generation counter
  * @max_sqnum: current global sequence number
  * @cmt_no: commit number of the last successfully completed commit, protected
  *          by @commit_sem
- * @cnt_lock: protects @highest_inum, @vfs_gen, and @max_sqnum counters
+ * @cnt_lock: protects @highest_inum and @max_sqnum counters
  * @fmt_version: UBIFS on-flash format version
  * @uuid: UUID from super block
  *
@@ -1117,7 +1116,6 @@ struct ubifs_info {
 	struct backing_dev_info bdi;
 
 	ino_t highest_inum;
-	unsigned int vfs_gen;
 	unsigned long long max_sqnum;
 	unsigned long long cmt_no;
 	spinlock_t cnt_lock;
-- 
1.5.4.1

