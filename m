Return-Path: <linux-kernel-owner+w=401wt.eu-S1765746AbYEVV7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765746AbYEVV7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbYEVV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:58:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56088 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756228AbYEVV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:58:53 -0400
Date: Thu, 22 May 2008 22:46:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] auerwald: Push down the BKL into the driver
Message-ID: <20080522224625.6fe88245@core>
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

Also fix the unknown ioctl return code

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/usb/misc/auerswald.c b/drivers/usb/misc/auerswald.c
index 0939386..d2f61d5 100644
--- a/drivers/usb/misc/auerswald.c
+++ b/drivers/usb/misc/auerswald.c
@@ -1421,7 +1421,8 @@ ofail:	mutex_unlock(&cp->mutex);
 
 
 /* IOCTL functions */
-static int auerchar_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long auerchar_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	pauerchar_t ccp = (pauerchar_t) file->private_data;
 	int ret = 0;
@@ -1452,7 +1453,7 @@ static int auerchar_ioctl (struct inode *inode, struct file *file, unsigned int
 		mutex_unlock(&ccp->mutex);
                 return -ENODEV;
 	}
-
+	lock_kernel();
 	switch (cmd) {
 
 	/* return != 0 if Transmitt channel ready to send */
@@ -1547,9 +1548,10 @@ static int auerchar_ioctl (struct inode *inode, struct file *file, unsigned int
 
 	default:
 		dbg ("IOCTL_AU_UNKNOWN");
-		ret = -ENOIOCTLCMD;
+		ret = -ENOTTY;
 		break;
         }
+        unlock_kernel();
 	/* release the mutexes */
 	mutex_unlock(&cp->mutex);
 	mutex_unlock(&ccp->mutex);
@@ -1860,7 +1862,7 @@ static const struct file_operations auerswald_fops =
 	.llseek =	no_llseek,
 	.read =		auerchar_read,
 	.write =        auerchar_write,
-	.ioctl =	auerchar_ioctl,
+	.unlocked_ioctl = auerchar_ioctl,
 	.open =		auerchar_open,
 	.release =	auerchar_release,
 };
