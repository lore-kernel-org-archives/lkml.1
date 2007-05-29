Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXE2UWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXE2UWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXE2UWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:22:22 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:52474 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXE2UWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:22:21 -0400
Date: Tue, 29 May 2007 16:22:19 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH][RFC] security: revalidate rw permissions for sys_splice and
 sys_vmsplice
Message-ID: <Line.LNX.4.64.0705291617260.9955@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revalidate read/write permissions for splice(2) and vmslice(2), in case 
security policy has changed since the files were opened.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

---

Please review.  Note that this brings the splice code into line with other
mechanisms for reading and writing files, where an LSM check is made on   
open, then revalidated on read or write as a form of partial revocation.

 fs/splice.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 12f2828..e0f68d9 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
+#include <linux/security.h>
 
 struct partial_page {
 	unsigned int offset;
@@ -912,6 +913,10 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(out, MAY_WRITE);
+	if (unlikely(ret < 0))
+		return ret;
+	
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
@@ -935,6 +940,10 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(in, MAY_READ);
+	if (unlikely(ret < 0))
+		return ret;
+
 	isize = i_size_read(in->f_mapping->host);
 	if (unlikely(*ppos >= isize))
 		return 0;
@@ -1263,6 +1272,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 static long do_vmsplice(struct file *file, const struct iovec __user *iov,
 			unsigned long nr_segs, unsigned int flags)
 {
+	long err;
 	struct pipe_inode_info *pipe;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
@@ -1281,6 +1291,10 @@ static long do_vmsplice(struct file *file, const struct iovec __user *iov,
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

