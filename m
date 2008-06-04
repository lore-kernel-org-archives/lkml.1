Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYFDML4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYFDML4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760590AbYFDMKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:59724 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307AbYFDMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=uMP7fYr3h5Dzc4zvOCuKN1Ljiv7swMePfvNZjOaoJQiEes4s7sqjV6bqn2ML4Ta3AO
         qUhk3ROB1aMkJ6NzCLmW6gCCeU8EtyvdYjDenFMMlEWClcc/BWaSwIMSA8nzLg/kA7Re
         eFEIejm0gTMc4CfJeK3q6Q3qxFdKfvILWrRPo=
Message-Id: <20080604115731.998579106@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:39 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [patch -v3 06/22] s390: use simple_read_from_buffer
Content-Disposition: inline; filename=hypfs-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/hypfs/inode.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

Index: 2.6-git/arch/s390/hypfs/inode.c
===================================================================
--- 2.6-git.orig/arch/s390/hypfs/inode.c
+++ 2.6-git/arch/s390/hypfs/inode.c
@@ -150,33 +150,24 @@ static ssize_t hypfs_aio_read(struct kio
 			      unsigned long nr_segs, loff_t offset)
 {
 	char *data;
-	size_t len;
+	ssize_t ret;
 	struct file *filp = iocb->ki_filp;
 	/* XXX: temporary */
 	char __user *buf = iov[0].iov_base;
 	size_t count = iov[0].iov_len;
 
-	if (nr_segs != 1) {
-		count = -EINVAL;
-		goto out;
-	}
+	if (nr_segs != 1)
+		return -EINVAL;
 
 	data = filp->private_data;
-	len = strlen(data);
-	if (offset > len) {
-		count = 0;
-		goto out;
-	}
-	if (count > len - offset)
-		count = len - offset;
-	if (copy_to_user(buf, data + offset, count)) {
-		count = -EFAULT;
-		goto out;
-	}
-	iocb->ki_pos += count;
+	ret = simple_read_from_buffer(buf, count, &offset, data, strlen(data));
+	if (ret <= 0)
+		return ret;
+
+	iocb->ki_pos += ret;
 	file_accessed(filp);
-out:
-	return count;
+
+	return ret;
 }
 static ssize_t hypfs_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			      unsigned long nr_segs, loff_t offset)

-- 
