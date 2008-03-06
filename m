Return-Path: <linux-kernel-owner+w=401wt.eu-S935319AbYCFSKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319AbYCFSKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758330AbYCFSKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:10:24 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:31778 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYCFSKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ciwr5yWM3f+iYGVrmHkDMohNMW1AofDLeY1QRyPVmI5zsTOAij+ux1LCDTuAjA8BQbEep39CU99jaQ0O7M9RuR+KyTPMUBEejUv0GfhQxeEAqxBmkRWu6i3mMRF0/0s6si86IAY6XBdtHcX0xKSXxNqaVAcNVsgTEeks6fG4ZmM=
Date: Thu, 6 Mar 2008 21:09:27 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [CRIS] driver: i2c - convert ioctl to unlocked_ioctl
Message-ID: <20080306180927.GB7547@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C driver ioctl handler is protected by spinlock
anyway (not in obvious form though) - there is no need
to use ioctl so we are able to use unlocked_ioctl instead

Also a bit cleanup is done

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

It's an arch I don't have - so test it please ;)
Any comments are welcome

 arch-v10/drivers/i2c.c |   24 ++++++++++--------------
 arch-v32/drivers/i2c.c |   15 ++++++---------
 2 files changed, 16 insertions(+), 23 deletions(-)


Index: linux-2.6.git/arch/cris/arch-v10/drivers/i2c.c
===================================================================
--- linux-2.6.git.orig/arch/cris/arch-v10/drivers/i2c.c	2008-02-09 12:09:27.000000000 +0300
+++ linux-2.6.git/arch/cris/arch-v10/drivers/i2c.c	2008-03-06 21:05:17.000000000 +0300
@@ -577,19 +577,15 @@ i2c_release(struct inode *inode, struct 
 
 /* Main device API. ioctl's to write or read to/from i2c registers.
  */
-
-static int
-i2c_ioctl(struct inode *inode, struct file *file,
-	  unsigned int cmd, unsigned long arg)
+static long i2c_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	if(_IOC_TYPE(cmd) != ETRAXI2C_IOCTYPE) {
+	if (_IOC_TYPE(cmd) != ETRAXI2C_IOCTYPE)
 		return -EINVAL;
-	}
 
 	switch (_IOC_NR(cmd)) {
 		case I2C_WRITEREG:
 			/* write to an i2c slave */
-			D(printk("i2cw %d %d %d\n", 
+			D(printk("i2cw %d %d %d\n",
 				 I2C_ARGSLAVE(arg),
 				 I2C_ARGREG(arg),
 				 I2C_ARGVALUE(arg)));
@@ -601,26 +597,26 @@ i2c_ioctl(struct inode *inode, struct fi
 		{
 			unsigned char val;
 			/* read from an i2c slave */
-			D(printk("i2cr %d %d ", 
+			D(printk("i2cr %d %d ",
 				I2C_ARGSLAVE(arg),
 				I2C_ARGREG(arg)));
 			val = i2c_readreg(I2C_ARGSLAVE(arg), I2C_ARGREG(arg));
 			D(printk("= %d\n", val));
 			return val;
-		}					    
+		}
 		default:
 			return -EINVAL;
 
 	}
-	
+
 	return 0;
 }
 
 static const struct file_operations i2c_fops = {
-	.owner    = THIS_MODULE,
-	.ioctl    = i2c_ioctl,
-	.open     = i2c_open,
-	.release  = i2c_release,
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= i2c_ioctl,
+	.open		= i2c_open,
+	.release	= i2c_release,
 };
 
 int __init
Index: linux-2.6.git/arch/cris/arch-v32/drivers/i2c.c
===================================================================
--- linux-2.6.git.orig/arch/cris/arch-v32/drivers/i2c.c	2008-02-09 12:09:27.000000000 +0300
+++ linux-2.6.git/arch/cris/arch-v32/drivers/i2c.c	2008-03-06 21:05:11.000000000 +0300
@@ -648,13 +648,10 @@ i2c_release(struct inode *inode, struct 
 /* Main device API. ioctl's to write or read to/from i2c registers.
  */
 
-static int
-i2c_ioctl(struct inode *inode, struct file *file,
-	  unsigned int cmd, unsigned long arg)
+static long i2c_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	if(_IOC_TYPE(cmd) != ETRAXI2C_IOCTYPE) {
+	if (_IOC_TYPE(cmd) != ETRAXI2C_IOCTYPE)
 		return -ENOTTY;
-	}
 
 	switch (_IOC_NR(cmd)) {
 		case I2C_WRITEREG:
@@ -687,10 +684,10 @@ i2c_ioctl(struct inode *inode, struct fi
 }
 
 static const struct file_operations i2c_fops = {
-	.owner =    THIS_MODULE,
-	.ioctl =    i2c_ioctl,
-	.open =     i2c_open,
-	.release =  i2c_release,
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= i2c_ioctl,
+	.open		= i2c_open,
+	.release	= i2c_release,
 };
 
 static int __init i2c_init(void)
