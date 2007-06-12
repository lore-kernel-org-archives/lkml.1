Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbXFLHCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbXFLHCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbXFLHAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:36 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 9/18] sendfile: convert nfsd to splice_direct_to_actor()
Date: Tue, 12 Jun 2007 08:58:05 +0200
Message-Id: <1181631495732-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/nfsd/vfs.c                     |   47 ++++++++++++++++++++++++------------
 include/linux/sunrpc/svc.h        |    2 +-
 net/sunrpc/auth_gss/svcauth_gss.c |    2 +-
 net/sunrpc/svc.c                  |    2 +-
 4 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7e6aa24..96f76e2 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -23,7 +23,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/major.h>
-#include <linux/ext2_fs.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -801,26 +801,32 @@ found:
 }
 
 /*
- * Grab and keep cached pages assosiated with a file in the svc_rqst
- * so that they can be passed to the netowork sendmsg/sendpage routines
- * directrly. They will be released after the sending has completed.
+ * Grab and keep cached pages associated with a file in the svc_rqst
+ * so that they can be passed to the network sendmsg/sendpage routines
+ * directly. They will be released after the sending has completed.
  */
 static int
-nfsd_read_actor(read_descriptor_t *desc, struct page *page, unsigned long offset , unsigned long size)
+nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+		  struct splice_desc *sd)
 {
-	unsigned long count = desc->count;
-	struct svc_rqst *rqstp = desc->arg.data;
+	struct svc_rqst *rqstp = sd->data;
 	struct page **pp = rqstp->rq_respages + rqstp->rq_resused;
+	struct page *page = buf->page;
+	size_t size;
+	int ret;
+
+	ret = buf->ops->pin(pipe, buf);
+	if (unlikely(ret))
+		return ret;
 
-	if (size > count)
-		size = count;
+	size = sd->len;
 
 	if (rqstp->rq_res.page_len == 0) {
 		get_page(page);
 		put_page(*pp);
 		*pp = page;
 		rqstp->rq_resused++;
-		rqstp->rq_res.page_base = offset;
+		rqstp->rq_res.page_base = buf->offset;
 		rqstp->rq_res.page_len = size;
 	} else if (page != pp[-1]) {
 		get_page(page);
@@ -832,11 +838,15 @@ nfsd_read_actor(read_descriptor_t *desc, struct page *page, unsigned long offset
 	} else
 		rqstp->rq_res.page_len += size;
 
-	desc->count = count - size;
-	desc->written += size;
 	return size;
 }
 
+static int nfsd_direct_splice_actor(struct pipe_inode_info *pipe,
+				    struct splice_desc *sd)
+{
+	return __splice_from_pipe(pipe, sd, nfsd_splice_actor);
+}
+
 static __be32
 nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
               loff_t offset, struct kvec *vec, int vlen, unsigned long *count)
@@ -861,10 +871,15 @@ nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	if (ra && ra->p_set)
 		file->f_ra = ra->p_ra;
 
-	if (file->f_op->sendfile && rqstp->rq_sendfile_ok) {
-		rqstp->rq_resused = 1;
-		host_err = file->f_op->sendfile(file, &offset, *count,
-						 nfsd_read_actor, rqstp);
+	if (file->f_op->splice_read && rqstp->rq_splice_ok) {
+		struct splice_desc sd = {
+			.len		= 0,
+			.total_len	= *count,
+			.pos		= offset,
+		};
+
+		sd.data = rqstp;
+		host_err = splice_direct_to_actor(file, &sd, nfsd_direct_splice_actor);
 	} else {
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 4a7ae8a..129d50f 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -253,7 +253,7 @@ struct svc_rqst {
 						 * determine what device number
 						 * to report (real or virtual)
 						 */
-	int			rq_sendfile_ok; /* turned off in gss privacy
+	int			rq_splice_ok;   /* turned off in gss privacy
 						 * to prevent encrypting page
 						 * cache pages */
 	wait_queue_head_t	rq_wait;	/* synchronization */
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 099a983..c094583 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -853,7 +853,7 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	u32 priv_len, maj_stat;
 	int pad, saved_len, remaining_len, offset;
 
-	rqstp->rq_sendfile_ok = 0;
+	rqstp->rq_splice_ok = 0;
 
 	priv_len = svc_getnl(&buf->head[0]);
 	if (rqstp->rq_deferred) {
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index e673ef9..55ea6df 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -814,7 +814,7 @@ svc_process(struct svc_rqst *rqstp)
 	rqstp->rq_res.tail[0].iov_base = NULL;
 	rqstp->rq_res.tail[0].iov_len = 0;
 	/* Will be turned off only in gss privacy case: */
-	rqstp->rq_sendfile_ok = 1;
+	rqstp->rq_splice_ok = 1;
 	/* tcp needs a space for the record length... */
 	if (rqstp->rq_prot == IPPROTO_TCP)
 		svc_putnl(resv, 0);
-- 
1.5.2.1.174.gcd03

