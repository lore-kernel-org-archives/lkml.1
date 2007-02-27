Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbXB0U4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbXB0U4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXB0U4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:56:39 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:47212 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXB0U4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:56:39 -0500
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, netdev@vger.kernel.org
Subject: [PATCH] sk98lin: handle pci_enable_device() return value in skge_resume() [resend]
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Tue, 27 Feb 2007 23:57:00 +0300
Message-ID: <87fy8r9v4z.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/net/sk98lin/skge.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/sk98lin/skge.c b/drivers/net/sk98lin/skge.c
index e94ab25..eea753a 100644
--- a/drivers/net/sk98lin/skge.c
+++ b/drivers/net/sk98lin/skge.c
@@ -5125,7 +5125,12 @@ static int skge_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		printk(KERN_WARNING "sk98lin: unable to enable device %s "
+				"in resume\n", dev->name);
+		goto err_out;
+	}	
 	pci_set_master(pdev);
 	if (pAC->GIni.GIMacsFound == 2)
 		ret = request_irq(dev->irq, SkGeIsr, IRQF_SHARED, "sk98lin", dev);
@@ -5133,10 +5138,8 @@ static int skge_resume(struct pci_dev *pdev)
 		ret = request_irq(dev->irq, SkGeIsrOnePort, IRQF_SHARED, "sk98lin", dev);
 	if (ret) {
 		printk(KERN_WARNING "sk98lin: unable to acquire IRQ %d\n", dev->irq);
-		pAC->AllocFlag &= ~SK_ALLOC_IRQ;
-		dev->irq = 0;
-		pci_disable_device(pdev);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_out_disable_pdev;
 	}
 
 	netif_device_attach(dev);
@@ -5153,6 +5156,13 @@ static int skge_resume(struct pci_dev *pdev)
 	}
 
 	return 0;
+
+err_out_disable_pdev:
+	pci_disable_device(pdev);
+err_out:
+	pAC->AllocFlag &= ~SK_ALLOC_IRQ;
+	dev->irq = 0;
+	return ret;
 }
 #else
 #define skge_suspend NULL
-- 
1.4.4.4

