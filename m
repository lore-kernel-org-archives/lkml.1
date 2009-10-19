Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZJSH4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZJSH4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZJSH4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:56:31 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:49440 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZJSH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=FA1qqd60or93ChjHUdkMj6jOWbNPmsoFPIoE3knXIUGngwmPg/BlzITfCE6dtbB7Zr
         q7sxvUlm6iSbqTCFm/mgAVJrWqq7sGi6fQfVl8wlj89e6cVs/i6oNlDqMgVOx9JKq1Mv
         ziXnJjiQBkDudzVt4TR6jw63fCGuzpj/Xt4eA=
Message-ID: <4ADC1BAE.9060508@gmail.com>
Date: Mon, 19 Oct 2009 15:56:30 +0800
From: Changli Gao <xiaosuo@gmail.com>
Reply-To: xiaosuo@gmail.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090505)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xiaosuo <xiaosuo@gmail.com>
Subject: PATCH: sendfile() checks f_op.sendpage() instead of f_op.splice_write()
 wrongly
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
file, which supports splice_write() not only mmap(2).

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
fs/read_write.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -826,7 +826,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (!(out_file->f_mode & FMODE_WRITE))
 		goto fput_out;
 	retval = -EINVAL;
-	if (!out_file->f_op || !out_file->f_op->sendpage)
+	if (!out_file->f_op || !out_file->f_op->splice_write)
 		goto fput_out;
 	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;


