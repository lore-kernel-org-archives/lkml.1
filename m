Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbYKUPqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbYKUPqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYKUPoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:22 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58967 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYKUPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:12 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: pre-allocate bulk-read buffer
Date: Fri, 21 Nov 2008 19:19:30 +0200
Message-Id: <1227287970-14684-9-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 21 Nov 2008 15:44:06.0085 (UTC) FILETIME=[FC6A1F50:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

To avoid memory allocation failure during bulk-read, pre-allocate
a bulk-read buffer, so that if there is only one bulk-reader at
a time, it would just use the pre-allocated buffer and would not
do any memory allocation. However, if there are more than 1 bulk-
reader, then only one reader would use the pre-allocated buffer,
while the other reader would allocate the buffer for itself.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/file.c  |   31 ++++++++++++++++++++--------
 fs/ubifs/super.c |   57 +++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ubifs/ubifs.h |    6 +++++
 3 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 0c5c27d..2624411 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -811,15 +811,15 @@ static int ubifs_bulk_read(struct page *page)
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	pgoff_t index = page->index, last_page_read = ui->last_page_read;
 	struct bu_info *bu;
-	int err = 0;
+	int err = 0, allocated = 0;
 
 	ui->last_page_read = index;
 	if (!c->bulk_read)
 		return 0;
 
 	/*
-	 * Bulk-read is protected by ui_mutex, but it is an optimization, so
-	 * don't bother if we cannot lock the mutex.
+	 * Bulk-read is protected by @ui->ui_mutex, but it is an optimization,
+	 * so don't bother if we cannot lock the mutex.
 	 */
 	if (!mutex_trylock(&ui->ui_mutex))
 		return 0;
@@ -840,17 +840,30 @@ static int ubifs_bulk_read(struct page *page)
 		ui->bulk_read = 1;
 	}
 
-	bu = kmalloc(sizeof(struct bu_info), GFP_NOFS | __GFP_NOWARN);
-	if (!bu)
-		return 0;
+	/*
+	 * If possible, try to use pre-allocated bulk-read information, which
+	 * is protected by @c->bu_mutex.
+	 */
+	if (mutex_trylock(&c->bu_mutex))
+		bu = &c->bu;
+	else {
+		bu = kmalloc(sizeof(struct bu_info), GFP_NOFS | __GFP_NOWARN);
+		if (!bu)
+			goto out_unlock;
+
+		bu->buf = NULL;
+		allocated = 1;
+	}
 
-	bu->buf = NULL;
 	bu->buf_len = c->max_bu_buf_len;
 	data_key_init(c, &bu->key, inode->i_ino,
 		      page->index << UBIFS_BLOCKS_PER_PAGE_SHIFT);
-
 	err = ubifs_do_bulk_read(c, bu, page);
-	kfree(bu);
+
+	if (!allocated)
+		mutex_unlock(&c->bu_mutex);
+	else
+		kfree(bu);
 
 out_unlock:
 	mutex_unlock(&ui->ui_mutex);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1d51156..d80b2ae 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -572,14 +572,6 @@ static int init_constants_early(struct ubifs_info *c)
 	c->max_bu_buf_len = UBIFS_MAX_BULK_READ * UBIFS_MAX_DATA_NODE_SZ;
 	if (c->max_bu_buf_len > c->leb_size)
 		c->max_bu_buf_len = c->leb_size;
-	if (c->max_bu_buf_len > UBIFS_KMALLOC_OK) {
-		/* Check if we can kmalloc that much */
-		void *try = kmalloc(c->max_bu_buf_len,
-				    GFP_KERNEL | __GFP_NOWARN);
-		kfree(try);
-		if (!try)
-			c->max_bu_buf_len = UBIFS_KMALLOC_OK;
-	}
 	return 0;
 }
 
@@ -999,6 +991,34 @@ static void destroy_journal(struct ubifs_info *c)
 }
 
 /**
+ * bu_init - initialize bulk-read information.
+ * @c: UBIFS file-system description object
+ */
+static void bu_init(struct ubifs_info *c)
+{
+	ubifs_assert(c->bulk_read == 1);
+
+	if (c->bu.buf)
+		return; /* Already initialized */
+
+again:
+	c->bu.buf = kmalloc(c->max_bu_buf_len, GFP_KERNEL | __GFP_NOWARN);
+	if (!c->bu.buf) {
+		if (c->max_bu_buf_len > UBIFS_KMALLOC_OK) {
+			c->max_bu_buf_len = UBIFS_KMALLOC_OK;
+			goto again;
+		}
+
+		/* Just disable bulk-read */
+		ubifs_warn("Cannot allocate %d bytes of memory for bulk-read, "
+			   "disabling it", c->max_bu_buf_len);
+		c->mount_opts.bulk_read = 1;
+		c->bulk_read = 0;
+		return;
+	}
+}
+
+/**
  * mount_ubifs - mount UBIFS file-system.
  * @c: UBIFS file-system description object
  *
@@ -1066,6 +1086,13 @@ static int mount_ubifs(struct ubifs_info *c)
 			goto out_free;
 	}
 
+	if (c->bulk_read == 1)
+		bu_init(c);
+
+	/*
+	 * We have to check all CRCs, even for data nodes, when we mount the FS
+	 * (specifically, when we are replaying).
+	 */
 	c->always_chk_crc = 1;
 
 	err = ubifs_read_superblock(c);
@@ -1296,6 +1323,7 @@ out_cbuf:
 out_dereg:
 	dbg_failure_mode_deregistration(c);
 out_free:
+	kfree(c->bu.buf);
 	vfree(c->ileb_buf);
 	vfree(c->sbuf);
 	kfree(c->bottom_up_buf);
@@ -1332,10 +1360,11 @@ static void ubifs_umount(struct ubifs_info *c)
 	kfree(c->cbuf);
 	kfree(c->rcvrd_mst_node);
 	kfree(c->mst_node);
+	kfree(c->bu.buf);
+	vfree(c->ileb_buf);
 	vfree(c->sbuf);
 	kfree(c->bottom_up_buf);
 	UBIFS_DBG(vfree(c->dbg_buf));
-	vfree(c->ileb_buf);
 	dbg_failure_mode_deregistration(c);
 }
 
@@ -1633,6 +1662,7 @@ static int ubifs_remount_fs(struct super_block *sb, int *flags, char *data)
 		ubifs_err("invalid or unknown remount parameter");
 		return err;
 	}
+
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
 		err = ubifs_remount_rw(c);
 		if (err)
@@ -1640,6 +1670,14 @@ static int ubifs_remount_fs(struct super_block *sb, int *flags, char *data)
 	} else if (!(sb->s_flags & MS_RDONLY) && (*flags & MS_RDONLY))
 		ubifs_remount_ro(c);
 
+	if (c->bulk_read == 1)
+		bu_init(c);
+	else {
+		dbg_gen("disable bulk-read");
+		kfree(c->bu.buf);
+		c->bu.buf = NULL;
+	}
+
 	return 0;
 }
 
@@ -1730,6 +1768,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&c->log_mutex);
 	mutex_init(&c->mst_mutex);
 	mutex_init(&c->umount_mutex);
+	mutex_init(&c->bu_mutex);
 	init_waitqueue_head(&c->cmt_wq);
 	c->buds = RB_ROOT;
 	c->old_idx = RB_ROOT;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 870b5c4..46b1725 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -969,7 +969,10 @@ struct ubifs_mount_opts {
  * @mst_node: master node
  * @mst_offs: offset of valid master node
  * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
+ *
  * @max_bu_buf_len: maximum bulk-read buffer length
+ * @bu_mutex: protects the pre-allocated bulk-read buffer and @c->bu
+ * @bu: pre-allocated bulk-read information
  *
  * @log_lebs: number of logical eraseblocks in the log
  * @log_bytes: log size in bytes
@@ -1217,7 +1220,10 @@ struct ubifs_info {
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
 	struct mutex mst_mutex;
+
 	int max_bu_buf_len;
+	struct mutex bu_mutex;
+	struct bu_info bu;
 
 	int log_lebs;
 	long long log_bytes;
-- 
1.5.4.3

