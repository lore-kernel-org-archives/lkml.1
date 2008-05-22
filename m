Return-Path: <linux-kernel-owner+w=401wt.eu-S1761404AbYEVV2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404AbYEVV2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbYEVV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:28:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33425 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbYEVV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:28:40 -0400
Date: Thu, 22 May 2008 22:16:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Subject: [PATCH] nwflash: Push down BKL
Message-ID: <20080522221610.5b339e0d@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push the BKL down into the driver ready for the BKL ioctl removal

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index ba012c2..02d882b 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -95,8 +95,11 @@ static int get_flash_id(void)
 	return c2;
 }
 
-static int flash_ioctl(struct inode *inodep, struct file *filep, unsigned int cmd, unsigned long arg)
+static long flash_ioctl(struct file *filep, unsigned int cmd,
+							unsigned long arg)
 {
+	long ret = 0;
+	lock_kernel();
 	switch (cmd) {
 	case CMD_WRITE_DISABLE:
 		gbWriteBase64Enable = 0;
@@ -114,9 +117,10 @@ static int flash_ioctl(struct inode *inodep, struct file *filep, unsigned int cm
 	default:
 		gbWriteBase64Enable = 0;
 		gbWriteEnable = 0;
-		return -EINVAL;
+		ret = -ENOTTY;
 	}
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 static ssize_t flash_read(struct file *file, char __user *buf, size_t size,
@@ -647,7 +651,7 @@ static const struct file_operations flash_fops =
 	.llseek		= flash_llseek,
 	.read		= flash_read,
 	.write		= flash_write,
-	.ioctl		= flash_ioctl,
+	.unlocked_ioctl	= flash_ioctl,
 };
 
 static struct miscdevice flash_miscdev =
