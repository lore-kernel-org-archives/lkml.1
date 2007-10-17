Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXJQUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXJQUBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbXJQUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:01:05 -0400
Received: from ev1s-75-125-39-150.ev1servers.net ([75.125.39.150]:42338 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbXJQUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:01:03 -0400
Date: Wed, 17 Oct 2007 21:52:33 +0200
Message-Id: <200710171952.l9HJqXgq027920@colorfullife.mysite.adiungo.com>
From: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] forcedeth msi bugfix
To: jgarzik@pobox.com
Cc: AAbdulla@nvidia.com
Cc: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_enable_msi() replaces the INTx irq number in pci_dev->irq with the
new MSI irq number.
The forcedeth driver did not update the copy in netdevice->irq and
parts of the driver used the stale copy.
See bugzilla.kernel.org, bug 9047.

The patch
- updates netdevice->irq
- replaces all accesses to netdevice->irq with pci_dev->irq.

The patch is against 2.6.23.1. IMHO suitable for both 2.6.23 and 2.6.24

Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>

--- 2.6/drivers/net/forcedeth.c	2007-10-17 21:36:36.000000000 +0200
+++ build-2.6/drivers/net/forcedeth.c	2007-10-17 21:54:58.000000000 +0200
@@ -128,7 +128,7 @@
 #else
 #define DRIVERNAPI
 #endif
-#define FORCEDETH_VERSION		"0.60"
+#define FORCEDETH_VERSION		"0.61"
 #define DRV_NAME			"forcedeth"
 
 #include <linux/module.h>
@@ -988,7 +988,7 @@
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq(dev->irq);
+			enable_irq(np->pci_dev->irq);
 	} else {
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
@@ -1004,7 +1004,7 @@
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq(dev->irq);
+			disable_irq(np->pci_dev->irq);
 	} else {
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
@@ -1601,7 +1601,7 @@
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq(dev->irq);
+			disable_irq(np->pci_dev->irq);
 	} else {
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 	}
@@ -1619,7 +1619,7 @@
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq(dev->irq);
+			enable_irq(np->pci_dev->irq);
 	} else {
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 	}
@@ -3557,10 +3557,12 @@
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
 		if ((ret = pci_enable_msi(np->pci_dev)) == 0) {
 			np->msi_flags |= NV_MSI_ENABLED;
+			dev->irq = np->pci_dev->irq;
 			if (request_irq(np->pci_dev->irq, handler, IRQF_SHARED, dev->name, dev) != 0) {
 				printk(KERN_INFO "forcedeth: request_irq failed %d\n", ret);
 				pci_disable_msi(np->pci_dev);
 				np->msi_flags &= ~NV_MSI_ENABLED;
+				dev->irq = np->pci_dev->irq;
 				goto out_err;
 			}
 
@@ -3623,7 +3625,7 @@
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq_lockdep(dev->irq);
+			disable_irq_lockdep(np->pci_dev->irq);
 		mask = np->irqmask;
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
@@ -3641,6 +3643,8 @@
 	}
 	np->nic_poll_irq = 0;
 
+	/* disable_irq() contains synchronize_irq, thus no irq handler can run now */
+
 	if (np->recover_error) {
 		np->recover_error = 0;
 		printk(KERN_INFO "forcedeth: MAC in recoverable error state\n");
@@ -3677,7 +3681,6 @@
 		}
 	}
 
-	/* FIXME: Do we need synchronize_irq(dev->irq) here? */
 
 	writel(mask, base + NvRegIrqMask);
 	pci_push(base);
@@ -3690,7 +3693,7 @@
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq_lockdep(dev->irq);
+			enable_irq_lockdep(np->pci_dev->irq);
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
 			nv_nic_irq_rx(0, dev);
@@ -4943,7 +4946,7 @@
 	np->in_shutdown = 1;
 	spin_unlock_irq(&np->lock);
 	netif_poll_disable(dev);
-	synchronize_irq(dev->irq);
+	synchronize_irq(np->pci_dev->irq);
 
 	del_timer_sync(&np->oom_kick);
 	del_timer_sync(&np->nic_poll);

