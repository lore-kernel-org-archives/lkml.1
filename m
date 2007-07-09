Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXGIC6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXGIC6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925AbXGIC6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:58:09 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:49760 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbXGIC6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:58:08 -0400
Date: Sun, 8 Jul 2007 22:58:05 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] security: revalidate rw permissions for sys_splice
 and sys_vmsplice
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082257390.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revalidate read/write permissions for splice(2) and vmslice(2), in case 
security policy has changed since the files were opened.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
---
 fs/splice.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index e7d7080..98025ec 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
+#include <linux/security.h>
 
 struct partial_page {
 	unsigned int offset;
@@ -931,6 +932,10 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(out, MAY_WRITE);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
@@ -953,6 +958,10 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(in, MAY_READ);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
 
@@ -1271,6 +1280,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 static long do_vmsplice(struct file *file, const struct iovec __user *iov,
 			unsigned long nr_segs, unsigned int flags)
 {
+	long err;
 	struct pipe_inode_info *pipe;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
@@ -1289,6 +1299,10 @@ static long do_vmsplice(struct file *file, const struct iovec __user *iov,
 	else if (unlikely(!nr_segs))
 		return 0;
 
+	err = security_file_permission(file, MAY_WRITE);
+	if (unlikely(err < 0))
+		return err;
+
 	spd.nr_pages = get_iovec_page_array(iov, nr_segs, pages, partial,
 					    flags & SPLICE_F_GIFT);
 	if (spd.nr_pages <= 0)
-- 
1.5.0.6

