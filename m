Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbXERUfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbXERUfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXERUe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:34:56 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:56093 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752100AbXERUe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:34:56 -0400
Message-id: <20644182862815412171@wsc.cz>
Subject: [PATCH 1/1] Misc: phantom, move to unlocked_ioctl
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 18 May 2007 22:34:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

phantom, move to unlocked_ioctl

phantom's ioctl is often (4000 times a sec or so) invoked, don't acquire BKL
and block other processes.

Signed-off-by: Jiri Slaby <xslaby@phantom.fi.muni.cz>

---
commit 79b7336ec18e967de0026d2cc08de47da6333761
tree d180d46c4bf38ee42adf8949e9f746f893aae32b
parent 34762198ff54f921aa49be10dcc21efaf53f4a4c
author Jiri Slaby <xslaby@phantom.fi.muni.cz> Fri, 18 May 2007 22:02:59 +0200
committer Jiri Slaby <xslaby@phantom.fi.muni.cz> Fri, 18 May 2007 22:02:59 +0200

 drivers/misc/phantom.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 35b139b..6249767 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -47,6 +47,7 @@ struct phantom_device {
 	struct cdev cdev;
 
 	struct mutex open_lock;
+	spinlock_t ioctl_lock;
 };
 
 static unsigned char phantom_devices[PHANTOM_MAX_MINORS];
@@ -71,8 +72,8 @@ static int phantom_status(struct phantom_device *dev, unsigned long newstat)
  * File ops
  */
 
-static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
-	u_long arg)
+static long phantom_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
 	struct phantom_device *dev = file->private_data;
 	struct phm_regs rs;
@@ -92,24 +93,30 @@ static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
 		if (r.reg > 7)
 			return -EINVAL;
 
+		spin_lock(&dev->ioctl_lock);
 		if (r.reg == PHN_CONTROL && (r.value & PHN_CTL_IRQ) &&
-				phantom_status(dev, dev->status | PHB_RUNNING))
+				phantom_status(dev, dev->status | PHB_RUNNING)){
+			spin_unlock(&dev->ioctl_lock);
 			return -ENODEV;
+		}
 
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
 		iowrite32(r.value, dev->iaddr + r.reg);
 
 		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
+		spin_unlock(&dev->ioctl_lock);
 		break;
 	case PHN_SET_REGS:
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
 		pr_debug("phantom: SRS %u regs %x\n", rs.count, rs.mask);
+		spin_lock(&dev->ioctl_lock);
 		for (i = 0; i < min(rs.count, 8U); i++)
 			if ((1 << i) & rs.mask)
 				iowrite32(rs.values[i], dev->oaddr + i);
+		spin_unlock(&dev->ioctl_lock);
 		break;
 	case PHN_GET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
@@ -118,7 +125,9 @@ static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
 		if (r.reg > 7)
 			return -EINVAL;
 
+		spin_lock(&dev->ioctl_lock);
 		r.value = ioread32(dev->iaddr + r.reg);
+		spin_unlock(&dev->ioctl_lock);
 
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
@@ -128,9 +137,11 @@ static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
 			return -EFAULT;
 
 		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
+		spin_lock(&dev->ioctl_lock);
 		for (i = 0; i < min(rs.count, 8U); i++)
 			if ((1 << i) & rs.mask)
 				rs.values[i] = ioread32(dev->iaddr + i);
+		spin_unlock(&dev->ioctl_lock);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
 			return -EFAULT;
@@ -199,7 +210,7 @@ static unsigned int phantom_poll(struct file *file, poll_table *wait)
 static struct file_operations phantom_file_ops = {
 	.open = phantom_open,
 	.release = phantom_release,
-	.ioctl = phantom_ioctl,
+	.unlocked_ioctl = phantom_ioctl,
 	.poll = phantom_poll,
 };
 
@@ -282,6 +293,7 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 	}
 
 	mutex_init(&pht->open_lock);
+	spin_lock_init(&pht->ioctl_lock);
 	init_waitqueue_head(&pht->wait);
 	cdev_init(&pht->cdev, &phantom_file_ops);
 	pht->cdev.owner = THIS_MODULE;
