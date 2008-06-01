Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYFAXaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYFAXaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYFAX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:24561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYFAX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=YdJlNZjcFBakCaPIzkXZAxGrGGUNT+2Rv2VeB2nws8RKXDPv8f/vq6jadkmUvfBUAg/ciYptRhP2RwLCS0CPP7rHj/z+Uwfzfb2F1zngUyfg8+CneWQDCu0ElXbGokThUJF7yr4lOBfQqMeqeFdeFnXQpTJbgbwYZe3RY5Tf3CI=
Message-Id: <20080601231526.261902592@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:37 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [patch -v2 08/23] nwflash: use simple_read_from_buffer
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
