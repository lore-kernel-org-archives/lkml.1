Return-Path: <linux-kernel-owner+w=401wt.eu-S1764408AbYDYTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764408AbYDYTCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765176AbYDYSl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:26 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7456 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764909AbYDYSkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:39 -0400
Message-Id: <20080425183934.516655076@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:57 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 50/54] ISAPNP: fold isapnp_read_resources() back into isapnp_get_resources()
Content-Disposition: inline; filename=isapnp-fold-isapnp_read_resources
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isapnp_get_resources() does very little besides call
isapnp_read_resources(), so just fold them back together.

Based on a patch by Rene Herman <rene.herman@gmail.com>

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:15:13.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:15:14.000000000 -0600
@@ -929,62 +929,55 @@
 EXPORT_SYMBOL(isapnp_cfg_end);
 EXPORT_SYMBOL(isapnp_write_byte);
 
-static int isapnp_read_resources(struct pnp_dev *dev)
-{
-	struct pnp_resource *pnp_res;
-	int tmp, ret;
-
-	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
-	if (dev->active) {
-		for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
-			if (!ret)
-				continue;
-			pnp_res = pnp_add_io_resource(dev, ret, ret, 0);
-			if (pnp_res)
-				pnp_res->index = tmp;
-		}
-		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-			ret =
-			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
-			if (!ret)
-				continue;
-			pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
-			if (pnp_res)
-				pnp_res->index = tmp;
-		}
-		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-			ret =
-			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
-			     8);
-			if (!ret)
-				continue;
-			pnp_res = pnp_add_irq_resource(dev, ret, 0);
-			if (pnp_res)
-				pnp_res->index = tmp;
-		}
-		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
-			if (ret == 4)
-				continue;
-			pnp_res = pnp_add_dma_resource(dev, ret, 0);
-			if  (pnp_res)
-				pnp_res->index = tmp;
-		}
-	}
-	return 0;
-}
-
 static int isapnp_get_resources(struct pnp_dev *dev)
 {
-	int ret;
+	struct pnp_resource *pnp_res;
+	int i, ret;
 
 	dev_dbg(&dev->dev, "get resources\n");
 	pnp_init_resources(dev);
 	isapnp_cfg_begin(dev->card->number, dev->number);
-	ret = isapnp_read_resources(dev);
+	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
+	if (!dev->active)
+		goto __end;
+
+	for (i = 0; i < ISAPNP_MAX_PORT; i++) {
+		ret = isapnp_read_word(ISAPNP_CFG_PORT + (i << 1));
+		if (!ret)
+			continue;
+		pnp_res = pnp_add_io_resource(dev, ret, ret, 0);
+		if (pnp_res)
+			pnp_res->index = i;
+	}
+	for (i = 0; i < ISAPNP_MAX_MEM; i++) {
+		ret = isapnp_read_word(ISAPNP_CFG_MEM + (i << 3)) << 8;
+		if (!ret)
+			continue;
+		pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
+		if (pnp_res)
+			pnp_res->index = i;
+	}
+	for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
+		ret = (isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >>
+		     8);
+		if (!ret)
+			continue;
+		pnp_res = pnp_add_irq_resource(dev, ret, 0);
+		if (pnp_res)
+			pnp_res->index = i;
+	}
+	for (i = 0; i < ISAPNP_MAX_DMA; i++) {
+		ret = isapnp_read_byte(ISAPNP_CFG_DMA + i);
+		if (ret == 4)
+			continue;
+		pnp_res = pnp_add_dma_resource(dev, ret, 0);
+		if  (pnp_res)
+			pnp_res->index = i;
+	}
+
+__end:
 	isapnp_cfg_end();
-	return ret;
+	return 0;
 }
 
 static int isapnp_set_resources(struct pnp_dev *dev)

-- 
