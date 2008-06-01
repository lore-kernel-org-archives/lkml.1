Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYFAX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYFAX3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbYFAX1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYFAX1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=RjrvfPDfaQxOtE96KVl+vVXK1KUnweZXu5CLiMO+rZfvZq7nBnLKwL6HeGzFta+npgZuthFNjYC8yvJcQ7WPfPPuWSgZyntCSQj96rOARCnmDrugM74DePOOImopH2w89CHdmyrzVBymvyrULetc//Pu3XsW9OhSRgHdR4RnM3s=
Message-Id: <20080601231520.950484943@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:36 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [patch -v2 07/23] s390: use simple_read_from_buffer
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
