Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbXJLQ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbXJLQ0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbXJLQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760453AbXJLQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/52] CRED: Pass credentials through the quota_write() op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:38 +0100
Message-ID: <20071012160838.15119.47184.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the quota_write() op.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/super.c    |    7 ++++---
 fs/quota_v2.c      |    9 ++++++---
 include/linux/fs.h |    3 ++-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 208065a..348bb6b 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -617,7 +617,8 @@ static int ext3_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off, struct cred *cred);
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
-				const char *data, size_t len, loff_t off);
+				const char *data, size_t len, loff_t off,
+				struct cred *cred);
 
 static struct dquot_operations ext3_quota_operations = {
 	.initialize	= ext3_dquot_initialize,
@@ -2709,9 +2710,9 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 /* Write to quotafile (we know the transaction is already started and has
  * enough credits) */
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
-				const char *data, size_t len, loff_t off)
+				const char *data, size_t len, loff_t off,
+				struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	sector_t blk = off >> EXT3_BLOCK_SIZE_BITS(sb);
 	int err = 0;
diff --git a/fs/quota_v2.c b/fs/quota_v2.c
index d4c5ba8..c259bc4 100644
--- a/fs/quota_v2.c
+++ b/fs/quota_v2.c
@@ -74,6 +74,7 @@ static int v2_read_file_info(struct super_block *sb, int type)
 /* Write information header to quota file */
 static int v2_write_file_info(struct super_block *sb, int type)
 {
+	struct cred *cred = &init_cred;
 	struct v2_disk_dqinfo dinfo;
 	struct mem_dqinfo *info = sb_dqopt(sb)->info+type;
 	ssize_t size;
@@ -88,7 +89,7 @@ static int v2_write_file_info(struct super_block *sb, int type)
 	dinfo.dqi_free_blk = cpu_to_le32(info->u.v2_i.dqi_free_blk);
 	dinfo.dqi_free_entry = cpu_to_le32(info->u.v2_i.dqi_free_entry);
 	size = sb->s_op->quota_write(sb, type, (char *)&dinfo,
-	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF);
+	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF, cred);
 	if (size != sizeof(struct v2_disk_dqinfo)) {
 		printk(KERN_WARNING "Can't write info structure on device %s.\n",
 			sb->s_id);
@@ -145,8 +146,9 @@ static inline ssize_t read_blk(struct super_block *sb, int type, uint blk, dqbuf
 
 static inline ssize_t write_blk(struct super_block *sb, int type, uint blk, dqbuf_t buf)
 {
+	struct cred *cred = &init_cred;
 	return sb->s_op->quota_write(sb, type, (char *)buf,
-	       V2_DQBLKSIZE, blk << V2_DQBLKSIZE_BITS);
+	       V2_DQBLKSIZE, blk << V2_DQBLKSIZE_BITS, cred);
 }
 
 /* Remove empty block from list and return it */
@@ -394,6 +396,7 @@ static inline int dq_insert_tree(struct dquot *dquot)
  */
 static int v2_write_dquot(struct dquot *dquot)
 {
+	struct cred *cred = &init_cred;
 	int type = dquot->dq_type;
 	ssize_t ret;
 	struct v2_disk_dqblk ddquot, empty;
@@ -414,7 +417,7 @@ static int v2_write_dquot(struct dquot *dquot)
 		ddquot.dqb_itime = cpu_to_le64(1);
 	spin_unlock(&dq_data_lock);
 	ret = dquot->dq_sb->s_op->quota_write(dquot->dq_sb, type,
-	      (char *)&ddquot, sizeof(struct v2_disk_dqblk), dquot->dq_off);
+	      (char *)&ddquot, sizeof(struct v2_disk_dqblk), dquot->dq_off, cred);
 	if (ret != sizeof(struct v2_disk_dqblk)) {
 		printk(KERN_WARNING "VFS: dquota write failed on dev %s\n", dquot->dq_sb->s_id);
 		if (ret >= 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6d52f69..88f9e49 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1207,7 +1207,8 @@ struct super_operations {
 #ifdef CONFIG_QUOTA
 	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t,
 			      struct cred *);
-	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t,
+			       loff_t, struct cred *);
 #endif
 };
 

