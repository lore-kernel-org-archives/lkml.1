Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXJBPxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXJBPxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbXJBPwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:34 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:56345 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXJBPwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:32 -0400
Message-Id: <20071002155223.324004626@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 10/12] fuse: add helper for asynchronous writes
Content-Disposition: inline; filename=fuse_fill_write.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This patch adds a new helper function fuse_write_fill() which makes it
possible to send WRITE requests asynchronously.

A new flag for WRITE requests is also added which indicates that this
a write from the page cache, and not a "normal" file write.

This patch is in preparation for writable mmap support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-09-25 21:19:14.000000000 +0200
+++ linux/fs/fuse/file.c	2007-09-25 21:19:15.000000000 +0200
@@ -443,30 +443,37 @@ out:
 	return err;
 }
 
-static size_t fuse_send_write(struct fuse_req *req, struct file *file,
-			      struct inode *inode, loff_t pos, size_t count)
-{
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
-	struct fuse_write_in inarg;
-	struct fuse_write_out outarg;
-
-	memset(&inarg, 0, sizeof(struct fuse_write_in));
-	inarg.fh = ff->fh;
-	inarg.offset = pos;
-	inarg.size = count;
+static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
+			    struct inode *inode, loff_t pos, size_t count,
+			    int writepage)
+{
+	struct fuse_write_in *inarg = &req->misc.write.in;
+	struct fuse_write_out *outarg = &req->misc.write.out;
+
+	memset(inarg, 0, sizeof(struct fuse_write_in));
+	inarg->fh = ff->fh;
+	inarg->offset = pos;
+	inarg->size = count;
+	inarg->write_flags = writepage ? FUSE_WRITE_CACHE : 0;
 	req->in.h.opcode = FUSE_WRITE;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.argpages = 1;
 	req->in.numargs = 2;
 	req->in.args[0].size = sizeof(struct fuse_write_in);
-	req->in.args[0].value = &inarg;
+	req->in.args[0].value = inarg;
 	req->in.args[1].size = count;
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(struct fuse_write_out);
-	req->out.args[0].value = &outarg;
+	req->out.args[0].value = outarg;
+}
+
+static size_t fuse_send_write(struct fuse_req *req, struct file *file,
+			      struct inode *inode, loff_t pos, size_t count)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	fuse_write_fill(req, file->private_data, inode, pos, count, 0);
 	request_send(fc, req);
-	return outarg.size;
+	return req->misc.write.out.size;
 }
 
 static int fuse_write_begin(struct file *file, struct address_space *mapping,
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-09-25 21:19:14.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-09-25 21:19:15.000000000 +0200
@@ -219,6 +219,10 @@ struct fuse_req {
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
 		struct fuse_read_in read_in;
+		struct {
+			struct fuse_write_in in;
+			struct fuse_write_out out;
+		} write;
 		struct fuse_lk_in lk_in;
 	} misc;
 
Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-25 21:19:14.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-25 21:19:15.000000000 +0200
@@ -119,6 +119,13 @@ struct fuse_file_lock {
  */
 #define FUSE_LK_FLOCK		(1 << 0)
 
+/**
+ * WRITE flags
+ *
+ * FUSE_WRITE_CACHE: delayed write from page cache, file handle is guessed
+ */
+#define FUSE_WRITE_CACHE	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */

--
