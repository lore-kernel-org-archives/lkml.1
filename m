Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYKUPp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYKUPp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYKUPoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:18 -0500
Received: from smtp.nokia.com ([192.100.122.230]:59043 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYKUPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:11 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: do not print scary memory allocation warnings
Date: Fri, 21 Nov 2008 19:19:28 +0200
Message-Id: <1227287970-14684-7-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 21 Nov 2008 15:44:06.0054 (UTC) FILETIME=[FC656460:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Bulk-read allocates a lot of memory with 'kmalloc()', and when it
is/gets fragmented 'kmalloc()' fails with a scarry warning. But
because bulk-read is just an optimization, UBIFS keeps working fine.
Supress the warning by passing __GFP_NOWARN option to 'kmalloc()'.

This patch also introduces a macro for the magic 128KiB constant.
This is just neater.

Note, this is not really fixes the problem we had, but just hides
the warnings. The further patches fix the problem.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/file.c  |    4 ++--
 fs/ubifs/super.c |   17 ++++++++++++-----
 fs/ubifs/ubifs.h |    2 +-
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 9124eee..8be827c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -705,12 +705,12 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct page *page1)
 	int err, page_idx, page_cnt, ret = 0, n = 0;
 	loff_t isize;
 
-	bu = kmalloc(sizeof(struct bu_info), GFP_NOFS);
+	bu = kmalloc(sizeof(struct bu_info), GFP_NOFS | __GFP_NOWARN);
 	if (!bu)
 		return 0;
 
 	bu->buf_len = c->bulk_read_buf_size;
-	bu->buf = kmalloc(bu->buf_len, GFP_NOFS);
+	bu->buf = kmalloc(bu->buf_len, GFP_NOFS | __GFP_NOWARN);
 	if (!bu->buf)
 		goto out_free;
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 8780efb..ea493e6 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -36,6 +36,12 @@
 #include <linux/mount.h>
 #include "ubifs.h"
 
+/*
+ * Maximum amount of memory we may 'kmalloc()' without worrying that we are
+ * allocating too much.
+ */
+#define UBIFS_KMALLOC_OK (128*1024)
+
 /* Slab cache for UBIFS inodes */
 struct kmem_cache *ubifs_inode_slab;
 
@@ -561,17 +567,18 @@ static int init_constants_early(struct ubifs_info *c)
 	 * calculations when reporting free space.
 	 */
 	c->leb_overhead = c->leb_size % UBIFS_MAX_DATA_NODE_SZ;
+
 	/* Buffer size for bulk-reads */
 	c->bulk_read_buf_size = UBIFS_MAX_BULK_READ * UBIFS_MAX_DATA_NODE_SZ;
 	if (c->bulk_read_buf_size > c->leb_size)
 		c->bulk_read_buf_size = c->leb_size;
-	if (c->bulk_read_buf_size > 128 * 1024) {
-		/* Check if we can kmalloc more than 128KiB */
-		void *try = kmalloc(c->bulk_read_buf_size, GFP_KERNEL);
-
+	if (c->bulk_read_buf_size > UBIFS_KMALLOC_OK) {
+		/* Check if we can kmalloc that much */
+		void *try = kmalloc(c->bulk_read_buf_size,
+				    GFP_KERNEL | __GFP_NOWARN);
 		kfree(try);
 		if (!try)
-			c->bulk_read_buf_size = 128 * 1024;
+			c->bulk_read_buf_size = UBIFS_KMALLOC_OK;
 	}
 	return 0;
 }
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index a7bd32f..06ba51e 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -753,7 +753,7 @@ struct ubifs_znode {
 };
 
 /**
- * struct bu_info - bulk-read information
+ * struct bu_info - bulk-read information.
  * @key: first data node key
  * @zbranch: zbranches of data nodes to bulk read
  * @buf: buffer to read into
-- 
1.5.4.3

