Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbXJLQZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbXJLQZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbXJLQIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:08:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485AbXJLQIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:08:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 38/52] CRED: Pass credentials through the quota_read() op
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:08:33 +0100
Message-ID: <20071012160833.15119.73523.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the quota_read() op.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/super.c    |    5 ++---
 fs/quota_v2.c      |   13 +++++++++----
 include/linux/fs.h |    3 ++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 3b89509..208065a 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -615,7 +615,7 @@ static int ext3_write_info(struct super_block *sb, int type);
 static int ext3_quota_on(struct super_block *sb, int type, int format_id, char *path);
 static int ext3_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
-			       size_t len, loff_t off);
+			       size_t len, loff_t off, struct cred *cred);
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
@@ -2671,9 +2671,8 @@ static int ext3_quota_on(struct super_block *sb, int type, int format_id,
  * itself serializes the operations (and noone else should touch the files)
  * we don't have to be afraid of races */
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
-			       size_t len, loff_t off)
+			       size_t len, loff_t off, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	sector_t blk = off >> EXT3_BLOCK_SIZE_BITS(sb);
 	int err = 0;
diff --git a/fs/quota_v2.c b/fs/quota_v2.c
index c519a58..d4c5ba8 100644
--- a/fs/quota_v2.c
+++ b/fs/quota_v2.c
@@ -28,12 +28,14 @@ typedef char *dqbuf_t;
 /* Check whether given file is really vfsv0 quotafile */
 static int v2_check_quota_file(struct super_block *sb, int type)
 {
+	struct cred *cred = &init_cred;
 	struct v2_disk_dqheader dqhead;
 	ssize_t size;
 	static const uint quota_magics[] = V2_INITQMAGICS;
 	static const uint quota_versions[] = V2_INITQVERSIONS;
  
-	size = sb->s_op->quota_read(sb, type, (char *)&dqhead, sizeof(struct v2_disk_dqheader), 0);
+	size = sb->s_op->quota_read(sb, type, (char *)&dqhead,
+				    sizeof(struct v2_disk_dqheader), 0, cred);
 	if (size != sizeof(struct v2_disk_dqheader)) {
 		printk("quota_v2: failed read expected=%zd got=%zd\n",
 			sizeof(struct v2_disk_dqheader), size);
@@ -48,12 +50,13 @@ static int v2_check_quota_file(struct super_block *sb, int type)
 /* Read information header from quota file */
 static int v2_read_file_info(struct super_block *sb, int type)
 {
+	struct cred *cred = &init_cred;
 	struct v2_disk_dqinfo dinfo;
 	struct mem_dqinfo *info = sb_dqopt(sb)->info+type;
 	ssize_t size;
 
 	size = sb->s_op->quota_read(sb, type, (char *)&dinfo,
-	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF);
+	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF, cred);
 	if (size != sizeof(struct v2_disk_dqinfo)) {
 		printk(KERN_WARNING "Can't read info structure on device %s.\n",
 			sb->s_id);
@@ -134,9 +137,10 @@ static inline void freedqbuf(dqbuf_t buf)
 
 static inline ssize_t read_blk(struct super_block *sb, int type, uint blk, dqbuf_t buf)
 {
+	struct cred *cred = &init_cred;
 	memset(buf, 0, V2_DQBLKSIZE);
 	return sb->s_op->quota_read(sb, type, (char *)buf,
-	       V2_DQBLKSIZE, blk << V2_DQBLKSIZE_BITS);
+	       V2_DQBLKSIZE, blk << V2_DQBLKSIZE_BITS, cred);
 }
 
 static inline ssize_t write_blk(struct super_block *sb, int type, uint blk, dqbuf_t buf)
@@ -603,6 +607,7 @@ static inline loff_t find_dqentry(struct dquot *dquot)
 
 static int v2_read_dquot(struct dquot *dquot)
 {
+	struct cred *cred = &init_cred;
 	int type = dquot->dq_type;
 	loff_t offset;
 	struct v2_disk_dqblk ddquot, empty;
@@ -628,7 +633,7 @@ static int v2_read_dquot(struct dquot *dquot)
 	else {
 		dquot->dq_off = offset;
 		if ((ret = dquot->dq_sb->s_op->quota_read(dquot->dq_sb, type,
-		    (char *)&ddquot, sizeof(struct v2_disk_dqblk), offset))
+		    (char *)&ddquot, sizeof(struct v2_disk_dqblk), offset, cred))
 		    != sizeof(struct v2_disk_dqblk)) {
 			if (ret >= 0)
 				ret = -EIO;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 53130df..6d52f69 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1205,7 +1205,8 @@ struct super_operations {
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
-	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
+	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t,
+			      struct cred *);
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 };

