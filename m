Return-Path: <linux-kernel-owner+w=401wt.eu-S933019AbYEVV56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbYEVV56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbYEVV5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:57:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53901 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756228AbYEVV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:57:48 -0400
Date: Thu, 22 May 2008 22:45:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
Subject: [PATCH] spi: Push the BKL down into the drivers
Message-ID: <20080522224509.29ede566@core>
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

Another step to removing ->ioctl and to removing the BKL

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index b3518ca..67e907c 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -29,6 +29,7 @@
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -240,9 +241,8 @@ done:
 	return status;
 }
 
-static int
-spidev_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+static long
+spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int			err = 0;
 	int			retval = 0;
@@ -269,6 +269,7 @@ spidev_ioctl(struct inode *inode, struct file *filp,
 	if (err)
 		return -EFAULT;
 
+	lock_kernel();
 	spidev = filp->private_data;
 	spi = spidev->spi;
 
@@ -357,7 +358,8 @@ spidev_ioctl(struct inode *inode, struct file *filp,
 		/* segmented and/or full-duplex I/O request */
 		if (_IOC_NR(cmd) != _IOC_NR(SPI_IOC_MESSAGE(0))
 				|| _IOC_DIR(cmd) != _IOC_WRITE)
-			return -ENOTTY;
+			retval = -ENOTTY;
+			break;
 
 		tmp = _IOC_SIZE(cmd);
 		if ((tmp % sizeof(struct spi_ioc_transfer)) != 0) {
@@ -385,6 +387,7 @@ spidev_ioctl(struct inode *inode, struct file *filp,
 		kfree(ioc);
 		break;
 	}
+	unlock_kernel();
 	return retval;
 }
 
@@ -447,7 +450,7 @@ static struct file_operations spidev_fops = {
 	 */
 	.write =	spidev_write,
 	.read =		spidev_read,
-	.ioctl =	spidev_ioctl,
+	.unlocked_ioctl = spidev_ioctl,
 	.open =		spidev_open,
 	.release =	spidev_release,
 };
