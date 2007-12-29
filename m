Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXL2WLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXL2WLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXL2WLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:11:12 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49019 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXL2WLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:11:10 -0500
Date: Sat, 29 Dec 2007 14:15:47 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] forcedeth: seperate handler for msix and normal int.
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200712291415.47835.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] forcedeth: seperate handler for msix and normal int.

so we don't need to keep checking np->msi_flags to see if NV_MSI_X_ENABLED is set in
handler

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.orig/drivers/net/forcedeth.c
+++ linux-2.6/drivers/net/forcedeth.c
@@ -2979,7 +2979,7 @@ static void nv_link_irq(struct net_devic
 	dprintk(KERN_DEBUG "%s: link change notification done.\n", dev->name);
 }
 
-static irqreturn_t nv_nic_irq(int foo, void *data)
+static inline irqreturn_t nv_nic_irq_x(int foo, void *data, int msix)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -2990,7 +2990,7 @@ static irqreturn_t nv_nic_irq(int foo, v
 	dprintk(KERN_DEBUG "%s: nv_nic_irq\n", dev->name);
 
 	for (i=0; ; i++) {
-		if (!(np->msi_flags & NV_MSI_X_ENABLED)) {
+		if (!msix) {
 			events = readl(base + NvRegIrqStatus) & NVREG_IRQSTAT_MASK;
 			writel(NVREG_IRQSTAT_MASK, base + NvRegIrqStatus);
 		} else {
@@ -3013,7 +3013,7 @@ static irqreturn_t nv_nic_irq(int foo, v
 			spin_lock(&np->lock);
 			np->irqmask &= ~NVREG_IRQ_RX_ALL;
 
-			if (np->msi_flags & NV_MSI_X_ENABLED)
+			if (msix)
 				writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
 			else
 				writel(np->irqmask, base + NvRegIrqMask);
@@ -3051,7 +3051,7 @@ static irqreturn_t nv_nic_irq(int foo, v
 		if (unlikely(events & NVREG_IRQ_RECOVER_ERROR)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
-			if (!(np->msi_flags & NV_MSI_X_ENABLED))
+			if (!msix)
 				writel(0, base + NvRegIrqMask);
 			else
 				writel(np->irqmask, base + NvRegIrqMask);
@@ -3068,7 +3068,7 @@ static irqreturn_t nv_nic_irq(int foo, v
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
-			if (!(np->msi_flags & NV_MSI_X_ENABLED))
+			if (!msix)
 				writel(0, base + NvRegIrqMask);
 			else
 				writel(np->irqmask, base + NvRegIrqMask);
@@ -3089,12 +3089,23 @@ static irqreturn_t nv_nic_irq(int foo, v
 	return IRQ_RETVAL(i);
 }
 
+static irqreturn_t nv_nic_irq_msix(int foo, void *data)
+{
+	return nv_nic_irq_x(foo, data, 1);
+}
+
+static irqreturn_t nv_nic_irq_normal(int foo, void *data)
+{
+	return nv_nic_irq_x(foo, data, 0);
+}
+
+
 /**
  * All _optimized functions are used to help increase performance
  * (reduce CPU and increase throughput). They use descripter version 3,
  * compiler directives, and reduce memory accesses.
  */
-static irqreturn_t nv_nic_irq_optimized(int foo, void *data)
+static inline irqreturn_t nv_nic_irq_optimized_x(int foo, void *data, int msix)
 {
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
@@ -3105,7 +3116,7 @@ static irqreturn_t nv_nic_irq_optimized(
 	dprintk(KERN_DEBUG "%s: nv_nic_irq_optimized\n", dev->name);
 
 	for (i=0; ; i++) {
-		if (!(np->msi_flags & NV_MSI_X_ENABLED)) {
+		if (!msix) {
 			events = readl(base + NvRegIrqStatus) & NVREG_IRQSTAT_MASK;
 			writel(NVREG_IRQSTAT_MASK, base + NvRegIrqStatus);
 		} else {
@@ -3128,7 +3139,7 @@ static irqreturn_t nv_nic_irq_optimized(
 			spin_lock(&np->lock);
 			np->irqmask &= ~NVREG_IRQ_RX_ALL;
 
-			if (np->msi_flags & NV_MSI_X_ENABLED)
+			if (msix)
 				writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
 			else
 				writel(np->irqmask, base + NvRegIrqMask);
@@ -3166,7 +3177,7 @@ static irqreturn_t nv_nic_irq_optimized(
 		if (unlikely(events & NVREG_IRQ_RECOVER_ERROR)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
-			if (!(np->msi_flags & NV_MSI_X_ENABLED))
+			if (!msix)
 				writel(0, base + NvRegIrqMask);
 			else
 				writel(np->irqmask, base + NvRegIrqMask);
@@ -3184,7 +3195,7 @@ static irqreturn_t nv_nic_irq_optimized(
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
-			if (!(np->msi_flags & NV_MSI_X_ENABLED))
+			if (!msix)
 				writel(0, base + NvRegIrqMask);
 			else
 				writel(np->irqmask, base + NvRegIrqMask);
@@ -3205,6 +3216,16 @@ static irqreturn_t nv_nic_irq_optimized(
 	return IRQ_RETVAL(i);
 }
 
+static irqreturn_t nv_nic_irq_optimized_msix(int foo, void *data)
+{
+	return nv_nic_irq_optimized_x(foo, data, 1);
+}
+
+static irqreturn_t nv_nic_irq_optimized_normal(int foo, void *data)
+{
+	return nv_nic_irq_optimized_x(foo, data, 0);
+}
+
 static irqreturn_t nv_nic_irq_tx(int foo, void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
@@ -3503,9 +3524,9 @@ static int nv_request_irq(struct net_dev
 		handler = nv_nic_irq_test;
 	} else {
 		if (np->desc_ver == DESC_VER_3)
-			handler = nv_nic_irq_optimized;
+			handler = nv_nic_irq_optimized_normal;
 		else
-			handler = nv_nic_irq;
+			handler = nv_nic_irq_normal;
 	}
 
 	if (np->msi_flags & NV_MSI_X_CAPABLE) {
@@ -3543,6 +3564,13 @@ static int nv_request_irq(struct net_dev
 				set_msix_vector_map(dev, NV_MSI_X_VECTOR_TX, NVREG_IRQ_TX_ALL);
 				set_msix_vector_map(dev, NV_MSI_X_VECTOR_OTHER, NVREG_IRQ_OTHER);
 			} else {
+				if (!intr_test) {
+					if (np->desc_ver == DESC_VER_3)
+						handler = nv_nic_irq_optimized_msix;
+					else
+						handler = nv_nic_irq_msix;
+				}
+
 				/* Request irq for all interrupts */
 				if (request_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector, handler, IRQF_SHARED, dev->name, dev) != 0) {
 					printk(KERN_INFO "forcedeth: request_irq failed %d\n", ret);
@@ -3689,10 +3717,17 @@ static void nv_do_nic_poll(unsigned long
 	pci_push(base);
 
 	if (!using_multi_irqs(dev)) {
-		if (np->desc_ver == DESC_VER_3)
-			nv_nic_irq_optimized(0, dev);
-		else
-			nv_nic_irq(0, dev);
+		if (np->msi_flags & NV_MSI_X_ENABLED) {
+			if (np->desc_ver == DESC_VER_3)
+				nv_nic_irq_optimized_msix(0, dev);
+			else
+				nv_nic_irq_msix(0, dev);
+		} else {
+			if (np->desc_ver == DESC_VER_3)
+				nv_nic_irq_optimized_normal(0, dev);
+			else
+				nv_nic_irq_normal(0, dev);
+		}
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
