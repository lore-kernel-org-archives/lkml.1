Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYFDMKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYFDMKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbYFDMJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:09:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbYFDMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:subject
         :content-disposition;
        b=fPWYUtHfggIvoSFSgZ7QW7Hn9dBw8Mlp9AITD82zfCt4drPf9g6Kx6+e0gKp82BAJa
         qblXVYUL+AEKI9Qdh5yiG5yXmxIKylk3fJrTY9haEcde7n4K90sVDCAqLZRW4Tygy/bK
         BMHgEZjoOPgSTHsWSxdd4FDhn3DcmOHA/xhYI=
Message-Id: <20080604115706.178544047@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:34 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch -v3 01/22] binfmt_misc: use simple_read_from_buffer
Content-Disposition: inline; filename=binfmt-misc-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/binfmt_misc.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

Index: 2.6-git/fs/binfmt_misc.c
===================================================================
--- 2.6-git.orig/fs/binfmt_misc.c
+++ 2.6-git/fs/binfmt_misc.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/syscalls.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 
@@ -535,31 +536,16 @@ static ssize_t
 bm_entry_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
 {
 	Node *e = file->f_path.dentry->d_inode->i_private;
-	loff_t pos = *ppos;
 	ssize_t res;
 	char *page;
-	int len;
 
 	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
 	entry_status(e, page);
-	len = strlen(page);
 
-	res = -EINVAL;
-	if (pos < 0)
-		goto out;
-	res = 0;
-	if (pos >= len)
-		goto out;
-	if (len < pos + nbytes)
-		nbytes = len - pos;
-	res = -EFAULT;
-	if (copy_to_user(buf, page + pos, nbytes))
-		goto out;
-	*ppos = pos + nbytes;
-	res = nbytes;
-out:
+	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
+
 	free_page((unsigned long) page);
 	return res;
 }

-- 
