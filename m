Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbXJOQeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbXJOQeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763491AbXJOQdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:33:52 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58420 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbXJOQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:33:50 -0400
Message-id: <2571023650266415239@pripojeni.net>
In-reply-to: <3012721321185026886@pripojeni.net>
Subject: [PATCH 3/3] Misc: phantom, improved data passing
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:33:50 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

phantom, improved data passing

this new version guarantees amb_bit switch in small enough intervals, so
that the device won't stop working in the middle of a movement anymore.
However it preserves old (openhaptics) functionality.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit e820ffda8d5f6c8a1d463955f6df7cf18544ca92
tree bba23481215cfcb6f3b7d6fec1d57d6902dc1098
parent 931e139b87d4fdb9fcae6a39cc0a157ff2fc07e1
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 16:03:38 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 16:03:38 +0200

 drivers/misc/phantom.c  |   79 +++++++++++++++++++++++++++++++++++++----------
 include/linux/phantom.h |    6 +++-
 2 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index bc532ac..4a610cc 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -25,13 +25,14 @@
 #include <asm/atomic.h>
 #include <asm/io.h>
 
-#define PHANTOM_VERSION		"n0.9.5"
+#define PHANTOM_VERSION		"n0.9.7"
 
 #define PHANTOM_MAX_MINORS	8
 
 #define PHN_IRQCTL		0x4c    /* irq control in caddr space */
 
 #define PHB_RUNNING		1
+#define PHB_NOT_OH		2
 
 static struct class *phantom_class;
 static int phantom_major;
@@ -48,7 +49,11 @@ struct phantom_device {
 	struct cdev cdev;
 
 	struct mutex open_lock;
-	spinlock_t ioctl_lock;
+	spinlock_t regs_lock;
+
+	/* used in NOT_OH mode */
+	struct phm_regs oregs;
+	u32 ctl_reg;
 };
 
 static unsigned char phantom_devices[PHANTOM_MAX_MINORS];
@@ -83,6 +88,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 	struct phm_regs rs;
 	struct phm_reg r;
 	void __user *argp = (void __user *)arg;
+	unsigned long flags;
 	unsigned int i;
 
 	if (_IOC_TYPE(cmd) != PH_IOC_MAGIC ||
@@ -97,32 +103,42 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		if (r.reg > 7)
 			return -EINVAL;
 
-		spin_lock(&dev->ioctl_lock);
+		spin_lock_irqsave(&dev->regs_lock, flags);
 		if (r.reg == PHN_CONTROL && (r.value & PHN_CTL_IRQ) &&
 				phantom_status(dev, dev->status | PHB_RUNNING)){
-			spin_unlock(&dev->ioctl_lock);
+			spin_unlock_irqrestore(&dev->regs_lock, flags);
 			return -ENODEV;
 		}
 
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
+
+		/* preserve amp bit (don't allow to change it when in NOT_OH) */
+		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH))
+			dev->ctl_reg = r.value = (r.value & ~PHN_CTL_AMP) |
+				(dev->ctl_reg & PHN_CTL_AMP);
+
 		iowrite32(r.value, dev->iaddr + r.reg);
 		ioread32(dev->iaddr); /* PCI posting */
 
 		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
-		spin_unlock(&dev->ioctl_lock);
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
 	case PHN_SET_REGS:
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
 		pr_debug("phantom: SRS %u regs %x\n", rs.count, rs.mask);
-		spin_lock(&dev->ioctl_lock);
-		for (i = 0; i < min(rs.count, 8U); i++)
-			if ((1 << i) & rs.mask)
-				iowrite32(rs.values[i], dev->oaddr + i);
-		ioread32(dev->iaddr); /* PCI posting */
-		spin_unlock(&dev->ioctl_lock);
+		spin_lock_irqsave(&dev->regs_lock, flags);
+		if (dev->status & PHB_NOT_OH)
+			memcpy(&dev->oregs, &rs, sizeof(rs));
+		else {
+			for (i = 0; i < min(rs.count, 8U); i++)
+				if (rs.mask & BIT(i))
+					iowrite32(rs.values[i], dev->oaddr + i);
+			ioread32(dev->iaddr); /* PCI posting */
+		}
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
 	case PHN_GET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
@@ -141,15 +157,26 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 
 		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
-		spin_lock(&dev->ioctl_lock);
+		spin_lock_irqsave(&dev->regs_lock, flags);
 		for (i = 0; i < min(rs.count, 8U); i++)
-			if ((1 << i) & rs.mask)
+			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
-		spin_unlock(&dev->ioctl_lock);
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
 			return -EFAULT;
 		break;
+	case PHN_NOT_OH:
+		spin_lock_irqsave(&dev->regs_lock, flags);
+		if (dev->status & PHB_RUNNING) {
+			printk(KERN_ERR "phantom: you need to set NOT_OH "
+					"before you start the device!\n");
+			spin_unlock_irqrestore(&dev->regs_lock, flags);
+			return -EINVAL;
+		}
+		dev->status |= PHB_NOT_OH;
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
+		break;
 	default:
 		return -ENOTTY;
 	}
@@ -172,8 +199,11 @@ static int phantom_open(struct inode *inode, struct file *file)
 		return -EINVAL;
 	}
 
+	WARN_ON(dev->status & PHB_NOT_OH);
+
 	file->private_data = dev;
 
+	atomic_set(&dev->counter, 0);
 	dev->opened++;
 	mutex_unlock(&dev->open_lock);
 
@@ -188,6 +218,7 @@ static int phantom_release(struct inode *inode, struct file *file)
 
 	dev->opened = 0;
 	phantom_status(dev, dev->status & ~PHB_RUNNING);
+	dev->status &= ~PHB_NOT_OH;
 
 	mutex_unlock(&dev->open_lock);
 
@@ -221,12 +252,28 @@ static struct file_operations phantom_file_ops = {
 static irqreturn_t phantom_isr(int irq, void *data)
 {
 	struct phantom_device *dev = data;
+	unsigned int i;
+	u32 ctl;
 
-	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
+	spin_lock(&dev->regs_lock);
+	ctl = ioread32(dev->iaddr + PHN_CONTROL);
+	if (!(ctl & PHN_CTL_IRQ)) {
+		spin_unlock(&dev->regs_lock);
 		return IRQ_NONE;
+	}
 
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
+
+	if (dev->status & PHB_NOT_OH)
+		for (i = 0; i < min(dev->oregs.count, 8U); i++)
+			if (dev->oregs.mask & BIT(i))
+				iowrite32(dev->oregs.values[i], dev->oaddr + i);
+
+	dev->ctl_reg ^= PHN_CTL_AMP;
+	iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
+	spin_unlock(&dev->regs_lock);
+
 	ioread32(dev->iaddr); /* PCI posting */
 
 	atomic_inc(&dev->counter);
@@ -298,7 +345,7 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 	}
 
 	mutex_init(&pht->open_lock);
-	spin_lock_init(&pht->ioctl_lock);
+	spin_lock_init(&pht->regs_lock);
 	init_waitqueue_head(&pht->wait);
 	cdev_init(&pht->cdev, &phantom_file_ops);
 	pht->cdev.owner = THIS_MODULE;
diff --git a/include/linux/phantom.h b/include/linux/phantom.h
index d3ebbfa..96f4048 100644
--- a/include/linux/phantom.h
+++ b/include/linux/phantom.h
@@ -30,7 +30,11 @@ struct phm_regs {
 #define PHN_SET_REG		_IOW (PH_IOC_MAGIC, 1, struct phm_reg *)
 #define PHN_GET_REGS		_IOWR(PH_IOC_MAGIC, 2, struct phm_regs *)
 #define PHN_SET_REGS		_IOW (PH_IOC_MAGIC, 3, struct phm_regs *)
-#define PH_IOC_MAXNR		3
+/* this ioctl tells the driver, that the caller is not OpenHaptics and might
+ * use improved registers update (no more phantom switchoffs when using
+ * libphantom) */
+#define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
+#define PH_IOC_MAXNR		4
 
 #define PHN_CONTROL		0x6     /* control byte in iaddr space */
 #define PHN_CTL_AMP		0x1     /*   switch after torques change */
