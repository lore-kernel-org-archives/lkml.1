Return-Path: <linux-kernel-owner+w=401wt.eu-S1031340AbXECP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031340AbXECP3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031349AbXECP3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:29:01 -0400
Received: from av1.karneval.cz ([81.27.192.123]:25412 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031340AbXECP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:28:59 -0400
Message-id: <31885154322964216743@karneval.cz>
Subject: [PATCH 1/1] Misc: phantom, diff to -v3
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Thu,  3 May 2007 17:28:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, there are suggested changes in the attached patch. Maybe merge it with
misc-add-sensable-phantom-driver.patch if possible.

--

phantom, diff to -v3

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit b5c1fc64195b18d3919bfa7dddfb76e9f2a05786
tree 0d7e83a45f816b146b3b99ea0fe096ff1456b72f
parent d8cb58f904b80e250383e68832204fafaf02da8b
author Jiri Slaby <jirislaby@gmail.com> Thu, 03 May 2007 16:45:33 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 03 May 2007 16:45:33 +0200

 drivers/misc/phantom.c |   24 ++++++++++++++----------
 include/linux/Kbuild   |    1 +
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index bca00a0..35b139b 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -21,6 +21,7 @@
 #include <linux/cdev.h>
 #include <linux/phantom.h>
 
+#include <asm/atomic.h>
 #include <asm/io.h>
 
 #define PHANTOM_VERSION		"n0.9.5"
@@ -40,7 +41,7 @@ struct phantom_device {
 	u32 __iomem *iaddr;
 	u32 __iomem *oaddr;
 	unsigned long status;
-	unsigned int counter;
+	atomic_t counter;
 
 	wait_queue_head_t wait;
 	struct cdev cdev;
@@ -55,6 +56,7 @@ static int phantom_status(struct phantom_device *dev, unsigned long newstat)
 	pr_debug("phantom_status %lx %lx\n", dev->status, newstat);
 
 	if (!(dev->status & PHB_RUNNING) && (newstat & PHB_RUNNING)) {
+		atomic_set(&dev->counter, 0);
 		iowrite32(PHN_CTL_IRQ, dev->iaddr + PHN_CONTROL);
 		iowrite32(0x43, dev->caddr + PHN_IRQCTL);
 	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
@@ -145,6 +147,8 @@ static int phantom_open(struct inode *inode, struct file *file)
 	struct phantom_device *dev = container_of(inode->i_cdev,
 			struct phantom_device, cdev);
 
+	nonseekable_open(inode, file);
+
 	if (mutex_lock_interruptible(&dev->open_lock))
 		return -ERESTARTSYS;
 
@@ -165,8 +169,7 @@ static int phantom_release(struct inode *inode, struct file *file)
 {
 	struct phantom_device *dev = file->private_data;
 
-	if (mutex_lock_interruptible(&dev->open_lock))
-		return -ERESTARTSYS;
+	mutex_lock(&dev->open_lock);
 
 	dev->opened = 0;
 	phantom_status(dev, dev->status & ~PHB_RUNNING);
@@ -181,14 +184,14 @@ static unsigned int phantom_poll(struct file *file, poll_table *wait)
 	struct phantom_device *dev = file->private_data;
 	unsigned int mask = 0;
 
-	pr_debug("phantom_poll: %u\n", dev->counter);
+	pr_debug("phantom_poll: %d\n", atomic_read(&dev->counter));
 	poll_wait(file, &dev->wait, wait);
-	if (dev->counter) {
+	if (atomic_read(&dev->counter)) {
 		mask = POLLIN | POLLRDNORM;
-		dev->counter--;
+		atomic_dec(&dev->counter);
 	} else if ((dev->status & PHB_RUNNING) == 0)
 		mask = POLLIN | POLLRDNORM | POLLERR;
-	pr_debug("phantom_poll end: %x/%u\n", mask, dev->counter);
+	pr_debug("phantom_poll end: %x/%d\n", mask, atomic_read(&dev->counter));
 
 	return mask;
 }
@@ -210,7 +213,7 @@ static irqreturn_t phantom_isr(int irq, void *data)
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
 
-	dev->counter++;
+	atomic_inc(&dev->counter);
 	wake_up_interruptible(&dev->wait);
 
 	return IRQ_HANDLED;
@@ -367,6 +370,9 @@ static int phantom_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+#else
+#define phantom_suspend	NULL
+#define phantom_resume	NULL
 #endif
 
 static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
@@ -381,10 +387,8 @@ static struct pci_driver phantom_pci_driver = {
 	.id_table = phantom_pci_tbl,
 	.probe = phantom_probe,
 	.remove = __devexit_p(phantom_remove),
-#ifdef CONFIG_PM
 	.suspend = phantom_suspend,
 	.resume = phantom_resume
-#endif
 };
 
 static ssize_t phantom_show_version(struct class *cls, char *buf)
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e81badd..0aa1c55 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -122,6 +122,7 @@ header-y += pci_regs.h
 header-y += personality.h
 header-y += pfkeyv2.h
 header-y += pg.h
+header-y += phantom.h
 header-y += pkt_cls.h
 header-y += pkt_sched.h
 header-y += posix_types.h
