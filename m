Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYH1Rmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYH1Rmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYH1Rmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:52420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYH1Rma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:30 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] FUSE: pass nonblock flag to client
Date: Fri, 29 Aug 2008 02:40:58 +0900
Message-Id: <1219945263-21074-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass O_NONBLOCK to client on reads and writes using FUSE_READ_NONBLOCK
and FUSE_WRITE_NONBLOCK respectively.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/file.c       |   10 +++++++---
 include/linux/fuse.h |    3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2bada6b..d405865 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -386,14 +386,15 @@ static size_t fuse_send_read(struct fuse_req *req, struct file *file,
 			     fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_read_in *inarg = &req->misc.read.in;
 
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (owner != NULL) {
-		struct fuse_read_in *inarg = &req->misc.read.in;
-
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
 	}
+	if (file->f_flags & O_NONBLOCK)
+		inarg->read_flags |= FUSE_READ_NONBLOCK;
 	request_send(fc, req);
 	return req->out.args[0].size;
 }
@@ -628,12 +629,15 @@ static size_t fuse_send_write(struct fuse_req *req, struct file *file,
 			      fl_owner_t owner)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_write_in *inarg = &req->misc.write.in;
+
 	fuse_write_fill(req, file, file->private_data, inode, pos, count, 0);
 	if (owner != NULL) {
-		struct fuse_write_in *inarg = &req->misc.write.in;
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
 	}
+	if (file->f_flags & O_NONBLOCK)
+		inarg->write_flags |= FUSE_WRITE_NONBLOCK;
 	request_send(fc, req);
 	return req->misc.write.out.size;
 }
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 776ab72..724ca19 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -137,14 +137,17 @@ struct fuse_file_lock {
  *
  * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
  * FUSE_WRITE_LOCKOWNER: lock_owner field is valid
+ * FUSE_WRITE_NONBLOCK: perform non-blocking write
  */
 #define FUSE_WRITE_CACHE	(1 << 0)
 #define FUSE_WRITE_LOCKOWNER	(1 << 1)
+#define FUSE_WRITE_NONBLOCK	(1 << 2)
 
 /**
  * Read flags
  */
 #define FUSE_READ_LOCKOWNER	(1 << 1)
+#define FUSE_READ_NONBLOCK	(1 << 2)
 
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
-- 
1.5.4.5

