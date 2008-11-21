Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbYKUPq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbYKUPq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYKUPoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:20 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58966 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYKUPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:12 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: do not allocate too much
Date: Fri, 21 Nov 2008 19:19:29 +0200
Message-Id: <1227287970-14684-8-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 21 Nov 2008 15:44:06.0069 (UTC) FILETIME=[FC67AE50:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Bulk-read allocates 128KiB or more using kmalloc. The allocation
starts failing often when the memory gets fragmented. UBIFS still
works fine in this case, because it falls-back to standard
(non-optimized) read method, though. This patch teaches bulk-read
to allocate exactly the amount of memory it needs, instead of
allocating 128KiB every time.

This patch is also a preparation to the further fix where we'll
have a pre-allocated bulk-read buffer as well. For example, now
the @bu object is prepared in 'ubifs_bulk_read()', so we could
path either pre-allocated or allocated information to
'ubifs_do_bulk_read()' later. Or teaching 'ubifs_do_bulk_read()'
not to allocate 'bu->buf' if it is already there.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/file.c  |   70 +++++++++++++++++++++++++++++++++++------------------
 fs/ubifs/super.c |   12 ++++----
 fs/ubifs/tnc.c   |    7 ++++-
 fs/ubifs/ubifs.h |    4 +-
 4 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 8be827c..0c5c27d 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -691,32 +691,22 @@ out_err:
 /**
  * ubifs_do_bulk_read - do bulk-read.
  * @c: UBIFS file-system description object
- * @page1: first page
+ * @bu: bulk-read information
+ * @page1: first page to read
  *
  * This function returns %1 if the bulk-read is done, otherwise %0 is returned.
  */
-static int ubifs_do_bulk_read(struct ubifs_info *c, struct page *page1)
+static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
+			      struct page *page1)
 {
 	pgoff_t offset = page1->index, end_index;
 	struct address_space *mapping = page1->mapping;
 	struct inode *inode = mapping->host;
 	struct ubifs_inode *ui = ubifs_inode(inode);
-	struct bu_info *bu;
 	int err, page_idx, page_cnt, ret = 0, n = 0;
+	int allocate = bu->buf ? 0 : 1;
 	loff_t isize;
 
-	bu = kmalloc(sizeof(struct bu_info), GFP_NOFS | __GFP_NOWARN);
-	if (!bu)
-		return 0;
-
-	bu->buf_len = c->bulk_read_buf_size;
-	bu->buf = kmalloc(bu->buf_len, GFP_NOFS | __GFP_NOWARN);
-	if (!bu->buf)
-		goto out_free;
-
-	data_key_init(c, &bu->key, inode->i_ino,
-		      offset << UBIFS_BLOCKS_PER_PAGE_SHIFT);
-
 	err = ubifs_tnc_get_bu_keys(c, bu);
 	if (err)
 		goto out_warn;
@@ -735,12 +725,25 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct page *page1)
 		 * together. If all the pages were like this, bulk-read would
 		 * reduce performance, so we turn it off for a while.
 		 */
-		ui->read_in_a_row = 0;
-		ui->bulk_read = 0;
-		goto out_free;
+		goto out_bu_off;
 	}
 
 	if (bu->cnt) {
+		if (allocate) {
+			/*
+			 * Allocate bulk-read buffer depending on how many data
+			 * nodes we are going to read.
+			 */
+			bu->buf_len = bu->zbranch[bu->cnt - 1].offs +
+				      bu->zbranch[bu->cnt - 1].len -
+				      bu->zbranch[0].offs;
+			ubifs_assert(bu->buf_len > 0);
+			ubifs_assert(bu->buf_len <= c->leb_size);
+			bu->buf = kmalloc(bu->buf_len, GFP_NOFS | __GFP_NOWARN);
+			if (!bu->buf)
+				goto out_bu_off;
+		}
+
 		err = ubifs_tnc_bulk_read(c, bu);
 		if (err)
 			goto out_warn;
@@ -779,13 +782,17 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct page *page1)
 	ui->last_page_read = offset + page_idx - 1;
 
 out_free:
-	kfree(bu->buf);
-	kfree(bu);
+	if (allocate)
+		kfree(bu->buf);
 	return ret;
 
 out_warn:
 	ubifs_warn("ignoring error %d and skipping bulk-read", err);
 	goto out_free;
+
+out_bu_off:
+	ui->read_in_a_row = ui->bulk_read = 0;
+	goto out_free;
 }
 
 /**
@@ -803,18 +810,20 @@ static int ubifs_bulk_read(struct page *page)
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	pgoff_t index = page->index, last_page_read = ui->last_page_read;
-	int ret = 0;
+	struct bu_info *bu;
+	int err = 0;
 
 	ui->last_page_read = index;
-
 	if (!c->bulk_read)
 		return 0;
+
 	/*
 	 * Bulk-read is protected by ui_mutex, but it is an optimization, so
 	 * don't bother if we cannot lock the mutex.
 	 */
 	if (!mutex_trylock(&ui->ui_mutex))
 		return 0;
+
 	if (index != last_page_read + 1) {
 		/* Turn off bulk-read if we stop reading sequentially */
 		ui->read_in_a_row = 1;
@@ -822,6 +831,7 @@ static int ubifs_bulk_read(struct page *page)
 			ui->bulk_read = 0;
 		goto out_unlock;
 	}
+
 	if (!ui->bulk_read) {
 		ui->read_in_a_row += 1;
 		if (ui->read_in_a_row < 3)
@@ -829,10 +839,22 @@ static int ubifs_bulk_read(struct page *page)
 		/* Three reads in a row, so switch on bulk-read */
 		ui->bulk_read = 1;
 	}
-	ret = ubifs_do_bulk_read(c, page);
+
+	bu = kmalloc(sizeof(struct bu_info), GFP_NOFS | __GFP_NOWARN);
+	if (!bu)
+		return 0;
+
+	bu->buf = NULL;
+	bu->buf_len = c->max_bu_buf_len;
+	data_key_init(c, &bu->key, inode->i_ino,
+		      page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT);
+
+	err = ubifs_do_bulk_read(c, bu, page);
+	kfree(bu);
+
 out_unlock:
 	mutex_unlock(&ui->ui_mutex);
-	return ret;
+	return err;
 }
 
 static int ubifs_readpage(struct file *file, struct page *page)
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ea493e6..1d51156 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -569,16 +569,16 @@ static int init_constants_early(struct ubifs_info *c)
 	c->leb_overhead = c->leb_size % UBIFS_MAX_DATA_NODE_SZ;
 
 	/* Buffer size for bulk-reads */
-	c->bulk_read_buf_size = UBIFS_MAX_BULK_READ * UBIFS_MAX_DATA_NODE_SZ;
-	if (c->bulk_read_buf_size > c->leb_size)
-		c->bulk_read_buf_size = c->leb_size;
-	if (c->bulk_read_buf_size > UBIFS_KMALLOC_OK) {
+	c->max_bu_buf_len = UBIFS_MAX_BULK_READ * UBIFS_MAX_DATA_NODE_SZ;
+	if (c->max_bu_buf_len > c->leb_size)
+		c->max_bu_buf_len = c->leb_size;
+	if (c->max_bu_buf_len > UBIFS_KMALLOC_OK) {
 		/* Check if we can kmalloc that much */
-		void *try = kmalloc(c->bulk_read_buf_size,
+		void *try = kmalloc(c->max_bu_buf_len,
 				    GFP_KERNEL | __GFP_NOWARN);
 		kfree(try);
 		if (!try)
-			c->bulk_read_buf_size = UBIFS_KMALLOC_OK;
+			c->max_bu_buf_len = UBIFS_KMALLOC_OK;
 	}
 	return 0;
 }
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 99e9a74..6eef534 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1501,7 +1501,12 @@ out:
  * @bu: bulk-read parameters and results
  *
  * Lookup consecutive data node keys for the same inode that reside
- * consecutively in the same LEB.
+ * consecutively in the same LEB. This function returns zero in case of success
+ * and a negative error code in case of failure.
+ *
+ * Note, if the bulk-read buffer length (@bu->buf_len) is known, this function
+ * makes sure bulk-read nodes fit the buffer. Otherwise, this function prepares
+ * maxumum possible amount of nodes for bulk-read.
  */
 int ubifs_tnc_get_bu_keys(struct ubifs_info *c, struct bu_info *bu)
 {
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 06ba51e..870b5c4 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -969,7 +969,7 @@ struct ubifs_mount_opts {
  * @mst_node: master node
  * @mst_offs: offset of valid master node
  * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
- * @bulk_read_buf_size: buffer size for bulk-reads
+ * @max_bu_buf_len: maximum bulk-read buffer length
  *
  * @log_lebs: number of logical eraseblocks in the log
  * @log_bytes: log size in bytes
@@ -1217,7 +1217,7 @@ struct ubifs_info {
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
 	struct mutex mst_mutex;
-	int bulk_read_buf_size;
+	int max_bu_buf_len;
 
 	int log_lebs;
 	long long log_bytes;
-- 
1.5.4.3

