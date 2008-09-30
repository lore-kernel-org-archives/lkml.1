Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYI3Ho0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYI3Ho0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbYI3HmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:03 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58930 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYI3Hl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:41:57 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: use bit-fields when possible
Date: Tue, 30 Sep 2008 12:19:05 +0300
Message-Id: <1222766358-21886-10-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0944 (UTC) FILETIME=[F7E6C300:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The "bulk_read" and "no_chk_data_crc" have only 2 values -
0 and 1. We already have bit-fields in corresponding data
structers, so make "bulk_read" and "no_chk_data_crc"
bit-fields as well.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/ubifs.h |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index d6ae3f7..542cbaf 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -331,6 +331,7 @@ struct ubifs_gced_idx_leb {
  *               this inode
  * @dirty: non-zero if the inode is dirty
  * @xattr: non-zero if this is an extended attribute inode
+ * @bulk_read: non-zero if bulk-read should be used
  * @ui_mutex: serializes inode write-back with the rest of VFS operations,
  *            serializes "clean <-> dirty" state changes, serializes bulk-read,
  *            protects @dirty, @ui_size, and @xattr_size
@@ -343,7 +344,6 @@ struct ubifs_gced_idx_leb {
  * @compr_type: default compression type used for this inode
  * @last_page_read: page number of last page read (for bulk read)
  * @read_in_a_row: number of consecutive pages read in a row (for bulk read)
- * @bulk_read: indicates whether bulk-read should be used
  * @data_len: length of the data attached to the inode
  * @data: inode's data
  *
@@ -385,6 +385,7 @@ struct ubifs_inode {
 	unsigned int xattr_names;
 	unsigned int dirty:1;
 	unsigned int xattr:1;
+	unsigned int bulk_read:1;
 	struct mutex ui_mutex;
 	spinlock_t ui_lock;
 	loff_t synced_i_size;
@@ -393,7 +394,6 @@ struct ubifs_inode {
 	int compr_type;
 	pgoff_t last_page_read;
 	pgoff_t read_in_a_row;
-	int bulk_read;
 	int data_len;
 	void *data;
 };
@@ -940,6 +940,7 @@ struct ubifs_mount_opts {
  * @cmt_state: commit state
  * @cs_lock: commit state lock
  * @cmt_wq: wait queue to sleep on if the log is full and a commit is running
+ *
  * @fast_unmount: do not run journal commit before un-mounting
  * @big_lpt: flag that LPT is too big to write whole during commit
  * @check_lpt_free: flag that indicates LPT GC may be needed
@@ -947,6 +948,9 @@ struct ubifs_mount_opts {
  *           optimization)
  * @nospace_rp: the same as @nospace, but additionally means that even reserved
  *              pool is full
+ * @no_chk_data_crc: do not check CRCs when reading data nodes (except during
+ *                   recovery)
+ * @bulk_read: enable bulk-reads
  *
  * @tnc_mutex: protects the Tree Node Cache (TNC), @zroot, @cnext, @enext, and
  *             @calc_idx_sz
@@ -970,6 +974,7 @@ struct ubifs_mount_opts {
  * @mst_node: master node
  * @mst_offs: offset of valid master node
  * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
+ * @bulk_read_buf_size: buffer size for bulk-reads
  *
  * @log_lebs: number of logical eraseblocks in the log
  * @log_bytes: log size in bytes
@@ -1000,12 +1005,6 @@ struct ubifs_mount_opts {
  * @old_leb_cnt: count of logical eraseblocks before re-size
  * @ro_media: the underlying UBI volume is read-only
  *
- * @bulk_read: enable bulk-reads
- * @bulk_read_buf_size: buffer size for bulk-reads
- *
- * @no_chk_data_crc: do not check CRCs when reading data nodes (except during
- *                   recovery)
- *
  * @dirty_pg_cnt: number of dirty pages (not used)
  * @dirty_zn_cnt: number of dirty znodes
  * @clean_zn_cnt: number of clean znodes
@@ -1188,11 +1187,14 @@ struct ubifs_info {
 	int cmt_state;
 	spinlock_t cs_lock;
 	wait_queue_head_t cmt_wq;
+
 	unsigned int fast_unmount:1;
 	unsigned int big_lpt:1;
 	unsigned int check_lpt_free:1;
 	unsigned int nospace:1;
 	unsigned int nospace_rp:1;
+	unsigned int no_chk_data_crc:1;
+	unsigned int bulk_read:1;
 
 	struct mutex tnc_mutex;
 	struct ubifs_zbranch zroot;
@@ -1217,6 +1219,7 @@ struct ubifs_info {
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
 	struct mutex mst_mutex;
+	int bulk_read_buf_size;
 
 	int log_lebs;
 	long long log_bytes;
@@ -1247,11 +1250,6 @@ struct ubifs_info {
 	int old_leb_cnt;
 	int ro_media;
 
-	int bulk_read;
-	int bulk_read_buf_size;
-
-	int no_chk_data_crc;
-
 	atomic_long_t dirty_pg_cnt;
 	atomic_long_t dirty_zn_cnt;
 	atomic_long_t clean_zn_cnt;
-- 
1.5.4.1

