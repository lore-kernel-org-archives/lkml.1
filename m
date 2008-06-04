Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbYFDMMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbYFDMMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760661AbYFDMKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:05 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbYFDMJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=l4w2j97tjlXhQXqXIL53SkiQG0o2vIjRTAzUUPHb1NflELEZjwyqSIX8w8f+0FDMNt
         T75bMjd8OBa0PpzgXXK6mFnNekuba32Bd8yOX+R3/Uaj2DdCNzqqaVv8BCTnMgBux+z7
         TsrrqcF6xowUM2/2H8Hv2h5ZgVdLiyyGaN1mQ=
Message-Id: <20080604115737.373540920@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:40 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [patch -v3 07/22] nwflash: use simple_read_from_buffer
Content-Disposition: inline; filename=nwflash-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 drivers/char/nwflash.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

Index: 2.6-git/drivers/char/nwflash.c
===================================================================
--- 2.6-git.orig/drivers/char/nwflash.c
+++ 2.6-git/drivers/char/nwflash.c
@@ -122,35 +122,20 @@ static int flash_ioctl(struct inode *ino
 static ssize_t flash_read(struct file *file, char __user *buf, size_t size,
 			  loff_t *ppos)
 {
-	unsigned long p = *ppos;
-	unsigned int count = size;
-	int ret = 0;
+	ssize_t ret;
 
 	if (flashdebug)
 		printk(KERN_DEBUG "flash_read: flash_read: offset=0x%lX, "
 		       "buffer=%p, count=0x%X.\n", p, buf, count);
+	/*
+	 * We now lock against reads and writes. --rmk
+	 */
+	if (mutex_lock_interruptible(&nwflash_mutex))
+		return -ERESTARTSYS;
 
-	if (count)
-		ret = -ENXIO;
+	ret = simple_read_from_buffer(buf, size, ppos, FLASH_BASE, gbFlashSize);
+	mutex_unlock(&nwflash_mutex);
 
-	if (p < gbFlashSize) {
-		if (count > gbFlashSize - p)
-			count = gbFlashSize - p;
-
-		/*
-		 * We now lock against reads and writes. --rmk
-		 */
-		if (mutex_lock_interruptible(&nwflash_mutex))
-			return -ERESTARTSYS;
-
-		ret = copy_to_user(buf, (void *)(FLASH_BASE + p), count);
-		if (ret == 0) {
-			ret = count;
-			*ppos += count;
-		} else
-			ret = -EFAULT;
-		mutex_unlock(&nwflash_mutex);
-	}
 	return ret;
 }
 

-- 
