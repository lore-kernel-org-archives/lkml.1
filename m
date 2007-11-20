Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbXKTRwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbXKTRwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbXKTRwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:52:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139AbXKTRwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:52:06 -0500
Subject: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to  
	pnp_clean_resource_table for cleanup reasons
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 18:52:04 +0100
Message-Id: <1195581124.23700.262.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass struct pnp_dev to pnp_clean_resource_table for cleanup reasons

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/manager.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6.24-rc2-mm1/drivers/pnp/manager.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/manager.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/manager.c
@@ -235,38 +235,38 @@ void pnp_init_resource_table(struct pnp_
  * pnp_clean_resources - clears resources that were not manually set
  * @res: the resources to clean
  */
-static void pnp_clean_resource_table(struct pnp_resource_table *res)
+static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
+		if (!(pnp_irq_flags(dev, idx) & IORESOURCE_AUTO))
 			continue;
-		res->irq_resource[idx].start = -1;
-		res->irq_resource[idx].flags =
+		pnp_irq_no(dev, idx) = -1;
+		pnp_irq_flags(dev, idx) =
 		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
+		if (!(pnp_dma_flags(dev, idx) & IORESOURCE_AUTO))
 			continue;
-		res->dma_resource[idx].start = -1;
-		res->dma_resource[idx].flags =
+		pnp_dma_no(dev, idx) = -1;
+		pnp_dma_flags(dev, idx) =
 		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
+		if (!(pnp_port_flags(dev, idx) & IORESOURCE_AUTO))
 			continue;
-		res->port_resource[idx].start = 0;
-		res->port_resource[idx].end = 0;
-		res->port_resource[idx].flags =
+		pnp_port_start(dev, idx) = 0;
+		pnp_port_end(dev, idx) = 0;
+		pnp_port_flags(dev, idx) =
 		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
+		if (!(pnp_mem_flags(dev, idx) & IORESOURCE_AUTO))
 			continue;
-		res->mem_resource[idx].start = 0;
-		res->mem_resource[idx].end = 0;
-		res->mem_resource[idx].flags =
+		pnp_mem_start(dev, idx) = 0;
+		pnp_mem_end(dev, idx) = 0;
+		pnp_mem_flags(dev, idx) =
 		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 }
@@ -290,7 +290,7 @@ static int pnp_assign_resources(struct p
 		return -ENODEV;
 
 	down(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
+	pnp_clean_resource_table(dev);	/* start with a fresh slate */
 	if (dev->independent) {
 		port = dev->independent->port;
 		mem = dev->independent->mem;
@@ -362,7 +362,7 @@ static int pnp_assign_resources(struct p
 	return 1;
 
 fail:
-	pnp_clean_resource_table(&dev->res);
+	pnp_clean_resource_table(dev);
 	up(&pnp_res_mutex);
 	return 0;
 }
@@ -546,7 +546,7 @@ int pnp_disable_dev(struct pnp_dev *dev)
 
 	/* release the resources so that other devices can use them */
 	down(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);
+	pnp_clean_resource_table(dev);
 	up(&pnp_res_mutex);
 
 	return 0;


