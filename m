Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbYEVVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbYEVVoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYEVVoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:44:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59917 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757479AbYEVVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:44:23 -0400
Date: Thu, 22 May 2008 22:31:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] dsp56k: BKL pushdown
Message-ID: <20080522223124.3a98798a@core>
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

Push the BKL down into the driver ioctl methods

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index a69c652..bf7937c 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -33,10 +33,11 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>	/* For put_user and get_user */
 
 #include <asm/atarihw.h>
 #include <asm/traps.h>
-#include <asm/uaccess.h>	/* For put_user and get_user */
 
 #include <asm/dsp56k.h>
 
@@ -321,8 +322,8 @@ static ssize_t dsp56k_write(struct file *file, const char __user *buf, size_t co
 	}
 }
 
-static int dsp56k_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long dsp56k_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int dev = iminor(inode) & 0x0f;
 	void __user *argp = (void __user *)arg;
@@ -349,8 +350,9 @@ static int dsp56k_ioctl(struct inode *inode, struct file *file,
 			if (len > DSP56K_MAX_BINARY_LENGTH) {
 				return -EINVAL;
 			}
-    
+			lock_kernel();
 			r = dsp56k_upload(bin, len);
+			unlock_kernel();
 			if (r < 0) {
 				return r;
 			}
@@ -360,12 +362,16 @@ static int dsp56k_ioctl(struct inode *inode, struct file *file,
 		case DSP56K_SET_TX_WSIZE:
 			if (arg > 4 || arg < 1)
 				return -EINVAL;
+			lock_kernel();
 			dsp56k.tx_wsize = (int) arg;
+			unlock_kernel();
 			break;
 		case DSP56K_SET_RX_WSIZE:
 			if (arg > 4 || arg < 1)
 				return -EINVAL;
+			lock_kernel();
 			dsp56k.rx_wsize = (int) arg;
+			unlock_kernel();
 			break;
 		case DSP56K_HOST_FLAGS:
 		{
@@ -377,6 +383,7 @@ static int dsp56k_ioctl(struct inode *inode, struct file *file,
 			if(get_user(out, &hf->out) < 0)
 				return -EFAULT;
 
+			lock_kernel();
 			if ((dir & 0x1) && (out & 0x1))
 				dsp56k_host_interface.icr |= DSP56K_ICR_HF0;
 			else if (dir & 0x1)
@@ -391,14 +398,16 @@ static int dsp56k_ioctl(struct inode *inode, struct file *file,
 			if (dsp56k_host_interface.icr & DSP56K_ICR_HF1) status |= 0x2;
 			if (dsp56k_host_interface.isr & DSP56K_ISR_HF2) status |= 0x4;
 			if (dsp56k_host_interface.isr & DSP56K_ISR_HF3) status |= 0x8;
-
+			unlock_kernel();
 			return put_user(status, &hf->status);
 		}
 		case DSP56K_HOST_CMD:
 			if (arg > 31 || arg < 0)
 				return -EINVAL;
+			lock_kernel();
 			dsp56k_host_interface.cvr = (u_char)((arg & DSP56K_CVR_HV_MASK) |
 							     DSP56K_CVR_HC);
+			unlock_kernel();
 			break;
 		default:
 			return -EINVAL;
@@ -485,7 +494,7 @@ static const struct file_operations dsp56k_fops = {
 	.owner		= THIS_MODULE,
 	.read		= dsp56k_read,
 	.write		= dsp56k_write,
-	.ioctl		= dsp56k_ioctl,
+	.unlocked_ioctl	= dsp56k_ioctl,
 	.open		= dsp56k_open,
 	.release	= dsp56k_release,
 };
