Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbXESJwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbXESJwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 05:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXESJwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 05:52:38 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:40516 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754767AbXESJwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 05:52:37 -0400
Message-id: <318982783300624876@wsc.cz>
In-reply-to: <37615320526925076@wsc.cz>
Subject: [PATCH 2/2] Misc: phantom, take care of pci posting
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 19 May 2007 11:52:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

phantom, take care of pci posting

thanks to akpm for pointing this out

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 3b8e2acb7e4ba32f6a26f97976848163ba1b00a6
tree 80f35d057630ad6d34bca5b5e868978731695e3f
parent fd826c7ffca5d1052a742d04f819c0251856cc6b
author Jiri Slaby <jirislaby@gmail.com> Sat, 19 May 2007 11:50:39 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 19 May 2007 11:50:39 +0200

 drivers/misc/phantom.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 4b5959b..5108b7c 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -60,8 +60,11 @@ static int phantom_status(struct phantom_device *dev, unsigned long newstat)
 		atomic_set(&dev->counter, 0);
 		iowrite32(PHN_CTL_IRQ, dev->iaddr + PHN_CONTROL);
 		iowrite32(0x43, dev->caddr + PHN_IRQCTL);
-	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
+		ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
+	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING)) {
 		iowrite32(0, dev->caddr + PHN_IRQCTL);
+		ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
+	}
 
 	dev->status = newstat;
 
@@ -102,6 +105,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
 		iowrite32(r.value, dev->iaddr + r.reg);
+		ioread32(dev->iaddr); /* PCI posting */
 
 		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
@@ -116,6 +120,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		for (i = 0; i < min(rs.count, 8U); i++)
 			if ((1 << i) & rs.mask)
 				iowrite32(rs.values[i], dev->oaddr + i);
+		ioread32(dev->iaddr); /* PCI posting */
 		spin_unlock(&dev->ioctl_lock);
 		break;
 	case PHN_GET_REG:
@@ -221,6 +226,7 @@ static irqreturn_t phantom_isr(int irq, void *data)
 
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
+	ioread32(dev->iaddr); /* PCI posting */
 
 	atomic_inc(&dev->counter);
 	wake_up_interruptible(&dev->wait);
@@ -297,6 +303,7 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 	pht->cdev.owner = THIS_MODULE;
 
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	retval = request_irq(pdev->irq, phantom_isr,
 			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
 	if (retval) {
@@ -347,6 +354,7 @@ static void __devexit phantom_remove(struct pci_dev *pdev)
 	cdev_del(&pht->cdev);
 
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	free_irq(pdev->irq, pht);
 
 	pci_iounmap(pdev, pht->oaddr);
@@ -368,6 +376,7 @@ static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct phantom_device *dev = pci_get_drvdata(pdev);
 
 	iowrite32(0, dev->caddr + PHN_IRQCTL);
+	ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
 
 	return 0;
 }
