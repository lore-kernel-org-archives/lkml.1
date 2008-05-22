Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYEVUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYEVUlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYEVUlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:41:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60353 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757372AbYEVUlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:41:20 -0400
Date: Thu, 22 May 2008 21:28:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, balagi@justmail.de, akpm@osdl.org
Subject: [PATCH] pktcdvd: Push BKL down into driver
Message-ID: <20080522212843.42f76ee1@core>
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

Push the lock_kernel down into the driver and switch to unlocked_ioctl

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3ba1df9..7a1166b 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2796,9 +2796,14 @@ out_mem:
 	return ret;
 }
 
-static int pkt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct pktcdvd_device *pd = inode->i_bdev->bd_disk->private_data;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct pktcdvd_device *pd;
+	long ret;
+	
+	lock_kernel();
+	pd = inode->i_bdev->bd_disk->private_data;
 
 	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd, imajor(inode), iminor(inode));
 
@@ -2811,7 +2816,8 @@ static int pkt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, u
 	case CDROM_LAST_WRITTEN:
 	case CDROM_SEND_PACKET:
 	case SCSI_IOCTL_SEND_COMMAND:
-		return blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		ret = blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		break;
 
 	case CDROMEJECT:
 		/*
@@ -2820,14 +2826,15 @@ static int pkt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, u
 		 */
 		if (pd->refcnt == 1)
 			pkt_lock_door(pd, 0);
-		return blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		ret = blkdev_ioctl(pd->bdev->bd_inode, file, cmd, arg);
+		break;
 
 	default:
 		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
-
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 static int pkt_media_changed(struct gendisk *disk)
@@ -2849,7 +2856,7 @@ static struct block_device_operations pktcdvd_ops = {
 	.owner =		THIS_MODULE,
 	.open =			pkt_open,
 	.release =		pkt_close,
-	.ioctl =		pkt_ioctl,
+	.unlocked_ioctl =	pkt_ioctl,
 	.media_changed =	pkt_media_changed,
 };
 
@@ -3014,7 +3021,8 @@ static void pkt_get_status(struct pkt_ctrl_command *ctrl_cmd)
 	mutex_unlock(&ctl_mutex);
 }
 
-static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ctl_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
@@ -3031,16 +3039,22 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 	case PKT_CTRL_CMD_SETUP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		lock_kernel();
 		ret = pkt_setup_dev(new_decode_dev(ctrl_cmd.dev), &pkt_dev);
 		ctrl_cmd.pkt_dev = new_encode_dev(pkt_dev);
+		unlock_kernel();
 		break;
 	case PKT_CTRL_CMD_TEARDOWN:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		lock_kernel();
 		ret = pkt_remove_dev(new_decode_dev(ctrl_cmd.pkt_dev));
+		unlock_kernel();
 		break;
 	case PKT_CTRL_CMD_STATUS:
+		lock_kernel();
 		pkt_get_status(&ctrl_cmd);
+		unlock_kernel();
 		break;
 	default:
 		return -ENOTTY;
@@ -3053,7 +3067,7 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 
 
 static const struct file_operations pkt_ctl_fops = {
-	.ioctl	 = pkt_ctl_ioctl,
+	.unlocked_ioctl	 = pkt_ctl_ioctl,
 	.owner	 = THIS_MODULE,
 };
 
