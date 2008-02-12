Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbYBLAq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbYBLAq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYBLAoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:44:55 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57945 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYBLAov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:44:51 -0500
Date: Mon, 11 Feb 2008 16:52:37 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] forcedeth: seperate handler for msix and normal int v2
In-reply-to: <47B06B9B.1000801@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Tom Herbert <therbert@google.com>
Message-id: <200802111652.37453.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200712291415.47835.yinghai.lu@sun.com>
 <47B06B9B.1000801@garzik.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we don't need to keep check np->msi_flags to see if NV_MSI_X_ENABLED is set in
handler

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.orig/drivers/net/forcedeth.c
+++ linux-2.6/drivers/net/forcedeth.c
@@ -2901,12 +2901,12 @@ static void nv_link_irq(struct net_device *dev)
 	dprintk(KERN_DEBUG "%s: link change notification done.\n", dev->name);
 }
 
-static irqreturn_t __nv_nic_irq(struct net_device *dev, bool optimized)
+static inline irqreturn_t __nv_nic_irq(struct net_device *dev, bool optimized,
+				bool msix)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = np->base;
 	u32 events, updmask = 0;
-	bool msix = np->msi_flags & NV_MSI_X_ENABLED;
 
 	dprintk(KERN_DEBUG "%s: __nv_nic_irq\n", dev->name);
 
@@ -2984,16 +2984,26 @@ out:
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t nv_nic_irq(int foo, void *data)
+static irqreturn_t nv_nic_irq_msix(int foo, void *data)
 {
 	struct net_device *dev = data;
-	return __nv_nic_irq(dev, false);
+	return __nv_nic_irq(dev, false, true);
+}
+static irqreturn_t nv_nic_irq_normal(int foo, void *data)
+{
+	struct net_device *dev = data;
+	return __nv_nic_irq(dev, false, false);
 }
 
-static irqreturn_t nv_nic_irq_optimized(int foo, void *data)
+static irqreturn_t nv_nic_irq_optimized_msix(int foo, void *data)
 {
 	struct net_device *dev = data;
-	return __nv_nic_irq(dev, true);
+	return __nv_nic_irq(dev, true, true);
+}
+static irqreturn_t nv_nic_irq_optimized_normal(int foo, void *data)
+{
+	struct net_device *dev = data;
+	return __nv_nic_irq(dev, true, false);
 }
 
 static int nv_napi_poll(struct napi_struct *napi, int budget)
@@ -3222,9 +3232,9 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 		handler = nv_nic_irq_test;
 	} else {
 		if (nv_optimized(np))
-			handler = nv_nic_irq_optimized;
+			handler = nv_nic_irq_optimized_normal;
 		else
-			handler = nv_nic_irq;
+			handler = nv_nic_irq_normal;
 	}
 
 	if (np->msi_flags & NV_MSI_X_CAPABLE) {
@@ -3262,6 +3272,10 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
 				set_msix_vector_map(dev, NV_MSI_X_VECTOR_TX, NVREG_IRQ_TX_ALL);
 				set_msix_vector_map(dev, NV_MSI_X_VECTOR_OTHER, NVREG_IRQ_OTHER);
 			} else {
+				if (nv_optimized(np))
+					handler = nv_nic_irq_optimized_msix;
+				else
+					handler = nv_nic_irq_msix;
 				/* Request irq for all interrupts */
 				if (request_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector, handler, IRQF_SHARED, dev->name, dev) != 0) {
 					printk(KERN_INFO "forcedeth: request_irq failed %d\n", ret);
@@ -3403,14 +3417,19 @@ static void nv_reset_task(struct work_struct *work)
 	pci_push(base);
 
 	if (!using_multi_irqs(dev)) {
-		if (nv_optimized(np))
-			nv_nic_irq_optimized(0, dev);
-		else
-			nv_nic_irq(0, dev);
-		if (np->msi_flags & NV_MSI_X_ENABLED)
+		if (np->msi_flags & NV_MSI_X_ENABLED) {
+			if (nv_optimized(np))
+				nv_nic_irq_optimized_msix(0, dev);
+			else
+				nv_nic_irq_msix(0, dev);
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
-		else
+		} else {
+			if (nv_optimized(np))
+				nv_nic_irq_optimized_normal(0, dev);
+			else
+				nv_nic_irq_normal(0, dev);
 			enable_irq_lockdep(np->pci_dev->irq);
+		}
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
 			nv_nic_irq_rx(0, dev);
