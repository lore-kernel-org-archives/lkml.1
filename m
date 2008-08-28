Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYH1Rny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYH1Rny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYH1Rmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:52433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbYH1Rmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:43 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] FUSE: implement direct lseek support
Date: Fri, 29 Aug 2008 02:41:00 +0900
Message-Id: <1219945263-21074-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow clients to implement private lseek.  The feature is negotiated
using FUSE_DIRECT_LSEEK flag during INIT.  If the client doesn't
request direct lseek, the original implicit lseek is used.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/file.c       |   52 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h     |    3 ++
 fs/fuse/inode.c      |    4 ++-
 include/linux/fuse.h |   14 +++++++++++++
 4 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9c44f9c..fa27edb 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1448,18 +1448,53 @@ static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 
 static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 {
-	loff_t retval;
+	loff_t retval = -EINVAL;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (is_bad_inode(inode))
+		return -EIO;
 
 	mutex_lock(&inode->i_mutex);
-	switch (origin) {
-	case SEEK_END:
-		offset += i_size_read(inode);
-		break;
-	case SEEK_CUR:
-		offset += file->f_pos;
+
+	if (fc->direct_lseek) {
+		struct fuse_file *ff = file->private_data;
+		struct fuse_lseek_in inarg = { .fh = ff->fh, .pos = file->f_pos,
+					   .offset = offset, .origin = origin };
+		struct fuse_lseek_out outarg;
+		struct fuse_req *req;
+		int err;
+
+		req = fuse_get_req(fc);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		req->in.h.opcode = FUSE_LSEEK;
+		req->in.h.nodeid = get_node_id(inode);
+		req->in.numargs = 1;
+		req->in.args[0].size = sizeof(inarg);
+		req->in.args[0].value = &inarg;
+		req->out.numargs = 1;
+		req->out.args[0].size = sizeof(outarg);
+		req->out.args[0].value = &outarg;
+		request_send(fc, req);
+		err = req->out.h.error;
+		fuse_put_request(fc, req);
+
+		if (err)
+			return err;
+
+		offset = outarg.pos;
+	} else {
+		switch (origin) {
+		case SEEK_END:
+			offset += i_size_read(inode);
+			break;
+		case SEEK_CUR:
+			offset += file->f_pos;
+		}
 	}
-	retval = -EINVAL;
+
 	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
@@ -1467,6 +1502,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 		}
 		retval = offset;
 	}
+
 	mutex_unlock(&inode->i_mutex);
 	return retval;
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e2b3b72..2bf2209 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -366,6 +366,9 @@ struct fuse_conn {
 	/** Do not send separate SETATTR request before open(O_TRUNC)  */
 	unsigned atomic_o_trunc : 1;
 
+	/** Do direct lseek */
+	unsigned direct_lseek : 1;
+
 	/** Filesystem supports NFS exporting.  Only set in INIT */
 	unsigned export_support : 1;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d2249f1..7693dfc 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -757,6 +757,8 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 			}
 			if (arg->flags & FUSE_BIG_WRITES)
 				fc->big_writes = 1;
+			if (arg->flags & FUSE_DIRECT_LSEEK)
+				fc->direct_lseek = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -781,7 +783,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
 	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
-		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES;
+		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES | FUSE_DIRECT_LSEEK;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 431666e..508d54e 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -118,6 +118,7 @@ struct fuse_file_lock {
 #define FUSE_ATOMIC_O_TRUNC	(1 << 3)
 #define FUSE_EXPORT_SUPPORT	(1 << 4)
 #define FUSE_BIG_WRITES		(1 << 5)
+#define FUSE_DIRECT_LSEEK	(1 << 6)
 
 /**
  * Release flags
@@ -188,6 +189,7 @@ enum fuse_opcode {
 	FUSE_INTERRUPT     = 36,
 	FUSE_BMAP          = 37,
 	FUSE_DESTROY       = 38,
+	FUSE_LSEEK         = 39,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
@@ -388,6 +390,18 @@ struct fuse_bmap_out {
 	__u64	block;
 };
 
+struct fuse_lseek_in {
+	__u64	fh;
+	__u64	pos;			/* current file position */
+	__u64	offset;			/* seek offset */
+	__u32	origin;			/* SEEK_* */
+	__u32	padding;
+};
+
+struct fuse_lseek_out {
+	__u64	pos;			/* new position */
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
-- 
1.5.4.5

