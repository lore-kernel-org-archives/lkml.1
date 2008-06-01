Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYFAX1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYFAX1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYFAX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:24561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYFAX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:subject:content-disposition;
        b=GF1iKvTZqw55TY/S50QUwh5SBY6DqRHnr8kfXRQGcz63wQU9lU9pWoRrZDmJGK53fuDYNM9hnlC0ZVb062k6PakCTLAPMDty6TUSGBvpkxAXSaAaEAt603LoQMxO8gDgnrp0+EEUl7Xyjn5xADuphnvpkRKuPBbqS7wFj2MND90=
Message-Id: <20080601231456.753947900@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:31 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [patch -v2 02/23] binfmt_misc: use simple_read_from_buffer
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
