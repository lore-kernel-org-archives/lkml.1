Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYE1XOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYE1XOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYE1XO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:14:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46255 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYE1XO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:14:26 -0400
Date: Thu, 29 May 2008 00:13:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       Lawrence Greenfield <leg@google.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: support aio
Message-ID: <Pine.LNX.4.64.0805290007320.7969@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a request for tmpfs to support the AIO interface: easily done,
no more than replacing the old shmem_file_read by shmem_file_aio_read,
cribbed from generic_file_aio_read.  (In 2.6.25 its write side was
already changed to use generic_file_aio_write.)

Tests out fine with LTP's ltp-aiodio.sh, given hacks (not included)
to support O_DIRECT.  tmpfs cannot honestly support O_DIRECT: its
cache-avoiding-IO nature is at odds with direct IO-avoiding-cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Lawrence Greenfield <leg@google.com>
---

 mm/shmem.c |   57 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 20 deletions(-)

--- 2.6.26-rc4/mm/shmem.c	2008-05-03 21:55:12.000000000 +0100
+++ linux/mm/shmem.c	2008-05-28 23:51:24.000000000 +0100
@@ -1690,26 +1690,42 @@ static void do_shmem_file_read(struct fi
 	file_accessed(filp);
 }
 
-static ssize_t shmem_file_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
+static ssize_t shmem_file_aio_read(struct kiocb *iocb,
+		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
 {
-	read_descriptor_t desc;
-
-	if ((ssize_t) count < 0)
-		return -EINVAL;
-	if (!access_ok(VERIFY_WRITE, buf, count))
-		return -EFAULT;
-	if (!count)
-		return 0;
-
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.buf = buf;
-	desc.error = 0;
-
-	do_shmem_file_read(filp, ppos, &desc, file_read_actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
+	struct file *filp = iocb->ki_filp;
+	ssize_t retval;
+	unsigned long seg;
+	size_t count;
+	loff_t *ppos = &iocb->ki_pos;
+
+	count = 0;
+	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (retval)
+		return retval;
+
+	retval = 0;
+	if (count) {
+		for (seg = 0; seg < nr_segs; seg++) {
+			read_descriptor_t desc;
+
+			desc.written = 0;
+			desc.arg.buf = iov[seg].iov_base;
+			desc.count = iov[seg].iov_len;
+			if (desc.count == 0)
+				continue;
+			desc.error = 0;
+			do_shmem_file_read(filp, ppos, &desc, file_read_actor);
+			retval += desc.written;
+			if (desc.error) {
+				retval = retval ?: desc.error;
+				break;
+			}
+			if (desc.count > 0)
+				break;
+		}
+	}
+	return retval;
 }
 
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -2369,8 +2385,9 @@ static const struct file_operations shme
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
 	.llseek		= generic_file_llseek,
-	.read		= shmem_file_read,
+	.read		= do_sync_read,
 	.write		= do_sync_write,
+	.aio_read	= shmem_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= simple_sync_file,
 	.splice_read	= generic_file_splice_read,
