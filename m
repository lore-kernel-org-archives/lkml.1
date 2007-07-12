Return-Path: <linux-kernel-owner+w=401wt.eu-S1765934AbXGLQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765934AbXGLQJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbXGLQJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:09:42 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:57411 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbXGLQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:09:41 -0400
Date: Thu, 12 Jul 2007 12:09:39 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Jens Axboe <jens.axboe@oracle.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH] security: revalidate rw permissions for sys_splice and
 sys_vmsplice
Message-ID: <Line.LNX.4.64.0707121207380.7550@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Revalidate read/write permissions for splice(2) and vmslice(2), in case 
security policy has changed since the files were opened.

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---

Updated version against latest Linus git.  Jens, I dropped your initial 
signed-off-by due to the rework.

Please review and apply if ok.


 fs/splice.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index ed2ce99..ef80822 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
+#include <linux/security.h>
 
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
@@ -961,6 +962,10 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(out, MAY_WRITE);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
@@ -983,6 +988,10 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	if (unlikely(ret < 0))
 		return ret;
 
+	ret = security_file_permission(in, MAY_READ);
+	if (unlikely(ret < 0))
+		return ret;
+
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
 
-- 
1.5.2.1

