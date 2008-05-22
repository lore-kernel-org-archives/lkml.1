Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYEVVbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYEVVbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbYEVVay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:30:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33428 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754014AbYEVVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:30:51 -0400
Date: Thu, 22 May 2008 22:17:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cm4000_cs: Switch to unlocked_ioctl
Message-ID: <20080522221749.46166d27@core>
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

Gack....

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 4a933d4..6b4f78d 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -32,8 +32,9 @@
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/bitrev.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/smp_lock.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
@@ -1405,11 +1406,11 @@ static void stop_monitor(struct cm4000_dev *dev)
 	DEBUGP(3, dev, "<- stop_monitor\n");
 }
 
-static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		     unsigned long arg)
+static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
 	unsigned int iobase = dev->p_dev->io.BasePort1;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
@@ -1426,38 +1427,42 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 	DEBUGP(3, dev, "cmm_ioctl(device=%d.%d) %s\n", imajor(inode),
 	       iminor(inode), ioctl_names[_IOC_NR(cmd)]);
 
+	lock_kernel();
+	rc = -ENODEV;
 	link = dev_table[iminor(inode)];
 	if (!pcmcia_dev_present(link)) {
 		DEBUGP(4, dev, "DEV_OK false\n");
-		return -ENODEV;
+		goto out;
 	}
 
 	if (test_bit(IS_CMM_ABSENT, &dev->flags)) {
 		DEBUGP(4, dev, "CMM_ABSENT flag set\n");
-		return -ENODEV;
+		goto out;
 	}
+	rc = EINVAL;
 
 	if (_IOC_TYPE(cmd) != CM_IOC_MAGIC) {
 		DEBUGP(4, dev, "ioctype mismatch\n");
-		return -EINVAL;
+		goto out;
 	}
 	if (_IOC_NR(cmd) > CM_IOC_MAXNR) {
 		DEBUGP(4, dev, "iocnr mismatch\n");
-		return -EINVAL;
+		goto out;
 	}
 	size = _IOC_SIZE(cmd);
-	rc = 0;
+	rc = -EFAULT;
 	DEBUGP(4, dev, "iocdir=%.4x iocr=%.4x iocw=%.4x iocsize=%d cmd=%.4x\n",
 	      _IOC_DIR(cmd), _IOC_READ, _IOC_WRITE, size, cmd);
 
 	if (_IOC_DIR(cmd) & _IOC_READ) {
 		if (!access_ok(VERIFY_WRITE, argp, size))
-			return -EFAULT;
+			goto out;
 	}
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		if (!access_ok(VERIFY_READ, argp, size))
-			return -EFAULT;
+			goto out;
 	}
+	rc = 0;
 
 	switch (cmd) {
 	case CM_IOCGSTATUS:
@@ -1477,9 +1482,9 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			if (test_bit(IS_BAD_CARD, &dev->flags))
 				status |= CM_BAD_CARD;
 			if (copy_to_user(argp, &status, sizeof(int)))
-				return -EFAULT;
+				rc = -EFAULT;
 		}
-		return 0;
+		break;
 	case CM_IOCGATR:
 		DEBUGP(4, dev, "... in CM_IOCGATR\n");
 		{
@@ -1492,25 +1497,29 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      || (test_bit(IS_ATR_PRESENT, (void *)&dev->flags)
 				  != 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 
+			rc = -EFAULT;
 			if (test_bit(IS_ATR_VALID, &dev->flags) == 0) {
 				tmp = -1;
 				if (copy_to_user(&(atreq->atr_len), &tmp,
 						 sizeof(int)))
-					return -EFAULT;
+					break;
 			} else {
 				if (copy_to_user(atreq->atr, dev->atr,
 						 dev->atr_len))
-					return -EFAULT;
+					break;
 
 				tmp = dev->atr_len;
 				if (copy_to_user(&(atreq->atr_len), &tmp, sizeof(int)))
-					return -EFAULT;
+					break;
 			}
-			return 0;
+			rc = 0;
+			break;
 		}
 	case CM_IOCARDOFF:
 
@@ -1538,8 +1547,10 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      || (test_and_set_bit(LOCK_IO, (void *)&dev->flags)
 				  == 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 			/* Set Flags0 = 0x42 */
 			DEBUGP(4, dev, "Set Flags0=0x42 \n");
@@ -1554,8 +1565,10 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      || (test_bit(IS_ATR_VALID, (void *)&dev->flags) !=
 				  0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 		}
 		/* release lock */
@@ -1568,8 +1581,10 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			struct ptsreq krnptsreq;
 
 			if (copy_from_user(&krnptsreq, argp,
-					   sizeof(struct ptsreq)))
-				return -EFAULT;
+					   sizeof(struct ptsreq))) {
+				rc = -EFAULT;
+				break;
+			}
 
 			rc = 0;
 			DEBUGP(4, dev, "... in CM_IOCSPTS\n");
@@ -1580,8 +1595,10 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      || (test_bit(IS_ATR_PRESENT, (void *)&dev->flags)
 				  != 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 			/* get IO lock */
 			if (wait_event_interruptible
@@ -1590,8 +1607,10 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      || (test_and_set_bit(LOCK_IO, (void *)&dev->flags)
 				  == 0)))) {
 				if (filp->f_flags & O_NONBLOCK)
-					return -EAGAIN;
-				return -ERESTARTSYS;
+					rc = -EAGAIN;
+				else
+					rc = -ERESTARTSYS;
+				break;
 			}
 
 			if ((rc = set_protocol(dev, &krnptsreq)) != 0) {
@@ -1604,7 +1623,7 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			wake_up_interruptible(&dev->ioq);
 
 		}
-		return rc;
+		break;
 #ifdef PCMCIA_DEBUG
 	case CM_IOSDBGLVL:	/* set debug log level */
 		{
@@ -1612,18 +1631,20 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 
 			old_pc_debug = pc_debug;
 			if (copy_from_user(&pc_debug, argp, sizeof(int)))
-				return -EFAULT;
-
-			if (old_pc_debug != pc_debug)
+				rc = -EFAULT;
+			else if (old_pc_debug != pc_debug)
 				DEBUGP(0, dev, "Changed debug log level "
 				       "to %i\n", pc_debug);
 		}
-		return rc;
+		break;
 #endif
 	default:
 		DEBUGP(4, dev, "... in default (unknown IOCTL code)\n");
-		return -EINVAL;
+		rc = -ENOTTY;
 	}
+out:
+	unlock_kernel();
+	return rc;
 }
 
 static int cmm_open(struct inode *inode, struct file *filp)
@@ -1897,7 +1918,7 @@ static const struct file_operations cm4000_fops = {
 	.owner	= THIS_MODULE,
 	.read	= cmm_read,
 	.write	= cmm_write,
-	.ioctl	= cmm_ioctl,
+	.unlocked_ioctl	= cmm_ioctl,
 	.open	= cmm_open,
 	.release= cmm_close,
 };
