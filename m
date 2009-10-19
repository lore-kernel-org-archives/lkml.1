Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZJSJ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZJSJ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZJSJ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:28:07 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:64380 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbZJSJ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OdY9oS72pFw8kgblKzpkE5JWgFrvFysYePT41+4Q/g5SsHwgnu4i7jPOFaaXbyB14s
         DWeLQ5RI/fpms3rH3pXlTjIXCz6pNhFl/UjodEVgl0gYokrZrFtbo6yjNBx/4ky7j6f8
         pM9S5DcKjYBnl+AHo9i8+QzNVkTigmvV9VVps=
Message-ID: <4ADC2F46.9020802@gmail.com>
Date: Mon, 19 Oct 2009 17:20:06 +0800
From: Changli Gao <xiaosuo@gmail.com>
Reply-To: xiaosuo@gmail.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090505)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xiaosuo <xiaosuo@gmail.com>
Subject: PATCH: sendfile() checks f_op.sendpage() instead of f_op.splice_write()
 wrongly
References: <4ADC1BAE.9060508@gmail.com>
In-Reply-To: <4ADC1BAE.9060508@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sendfile(2) checks f_op.sendpage() instead of f_op.splice_write() wrongly.

sendfile(2) was reworked with the splice infrastructure, but it still
checks f_op.sendpage() instead of f_op.splice_write() wrongly. Although
if f_op.sendpage() exists, f_op.splice_write() always exists at the same
time currently, the assumption will be broken in future silently. This
patch also brings a side effect: sendfile(2) can work with any output
file. Some security checks related to f_op are added too.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----

read_write.c | 2 --
splice.c | 24 +++++++++++++++---------
2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3ac2898..b7f4a1f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -826,8 +826,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (!(out_file->f_mode & FMODE_WRITE))
 		goto fput_out;
 	retval = -EINVAL;
-	if (!out_file->f_op || !out_file->f_op->sendpage)
-		goto fput_out;
 	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
diff --git a/fs/splice.c b/fs/splice.c
index 7394e9e..5724845 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -648,9 +648,11 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 	ret = buf->ops->confirm(pipe, buf);
 	if (!ret) {
 		more = (sd->flags & SPLICE_F_MORE) || sd->len < sd->total_len;
-
-		ret = file->f_op->sendpage(file, buf->page, buf->offset,
-					   sd->len, &pos, more);
+		if (file->f_op && file->f_op->sendpage)
+			ret = file->f_op->sendpage(file, buf->page, buf->offset,
+						   sd->len, &pos, more);
+		else
+			ret = -EINVAL;
 	}
 
 	return ret;
@@ -1068,8 +1070,9 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(ret < 0))
 		return ret;
 
-	splice_write = out->f_op->splice_write;
-	if (!splice_write)
+	if (out->f_op && out->f_op->splice_write)
+		splice_write = out->f_op->splice_write;
+	else
 		splice_write = default_file_splice_write;
 
 	return splice_write(pipe, out, ppos, len, flags);
@@ -1093,8 +1096,9 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 	if (unlikely(ret < 0))
 		return ret;
 
-	splice_read = in->f_op->splice_read;
-	if (!splice_read)
+	if (in->f_op && in->f_op->splice_read)
+		splice_read = in->f_op->splice_read;
+	else
 		splice_read = default_file_splice_read;
 
 	return splice_read(in, ppos, pipe, len, flags);
@@ -1316,7 +1320,8 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
-			if (out->f_op->llseek == no_llseek)
+			if (!out->f_op || !out->f_op->llseek ||
+			    out->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
@@ -1336,7 +1341,8 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
-			if (in->f_op->llseek == no_llseek)
+			if (!in->f_op || !in->f_op->llseek ||
+			    in->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;


