Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYF0XBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYF0XBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762885AbYF0W6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:58:51 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:39342 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761636AbYF0W6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:45 -0400
Message-Id: <20080627225758.640132043@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:56:53 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 02/28] PNP: remove pnp_resource.index
Content-Disposition: inline; filename=pnp-remove-pnp_resource-index
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used pnp_resource.index to keep track of which ISAPNP configuration
register a resource should be written to.  We needed this only to
handle the case where a register is disabled but a subsequent register
in the same set is enabled.

Rather than explicitly maintaining the pnp_resource.index, this patch
adds a resource every time we read an ISAPNP configuration register
and marks the resource as IORESOURCE_DISABLED when appropriate.  This
makes the position in the pnp_resource_table always correspond to the
config register index.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h        |    1 
 drivers/pnp/interface.c   |   20 ++---------
 drivers/pnp/isapnp/core.c |   80 ++++++++++++++--------------------------------
 drivers/pnp/manager.c     |    4 --
 4 files changed, 29 insertions(+), 76 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-05-15 15:22:36.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-05-15 15:23:24.000000000 -0600
@@ -57,7 +57,6 @@ struct pnp_resource *pnp_get_pnp_resourc
 
 struct pnp_resource {
 	struct resource res;
-	unsigned int index;		/* ISAPNP config register index */
 };
 
 struct pnp_resource_table {
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-05-15 15:22:36.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-05-15 15:23:24.000000000 -0600
@@ -320,7 +320,6 @@ pnp_set_current_resources(struct device 
 			  const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
-	struct pnp_resource *pnp_res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
 	resource_size_t start, end;
@@ -368,7 +367,6 @@ pnp_set_current_resources(struct device 
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -391,10 +389,7 @@ pnp_set_current_resources(struct device 
 					end = simple_strtoul(buf, &buf, 0);
 				} else
 					end = start;
-				pnp_res = pnp_add_io_resource(dev, start, end,
-							      0);
-				if (pnp_res)
-					pnp_res->index = nport++;
+				pnp_add_io_resource(dev, start, end, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
@@ -411,10 +406,7 @@ pnp_set_current_resources(struct device 
 					end = simple_strtoul(buf, &buf, 0);
 				} else
 					end = start;
-				pnp_res = pnp_add_mem_resource(dev, start, end,
-							       0);
-				if (pnp_res)
-					pnp_res->index = nmem++;
+				pnp_add_mem_resource(dev, start, end, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
@@ -422,9 +414,7 @@ pnp_set_current_resources(struct device 
 				while (isspace(*buf))
 					++buf;
 				start = simple_strtoul(buf, &buf, 0);
-				pnp_res = pnp_add_irq_resource(dev, start, 0);
-				if (pnp_res)
-					pnp_res->index = nirq++;
+				pnp_add_irq_resource(dev, start, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
@@ -432,9 +422,7 @@ pnp_set_current_resources(struct device 
 				while (isspace(*buf))
 					++buf;
 				start = simple_strtoul(buf, &buf, 0);
-				pnp_res = pnp_add_dma_resource(dev, start, 0);
-				if (pnp_res)
-					pnp_res->index = ndma++;
+				pnp_add_dma_resource(dev, start, 0);
 				continue;
 			}
 			break;
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-05-15 15:21:53.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-05-15 15:23:24.000000000 -0600
@@ -928,7 +928,6 @@ EXPORT_SYMBOL(isapnp_write_byte);
 
 static int isapnp_get_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource *pnp_res;
 	int i, ret;
 
 	dev_dbg(&dev->dev, "get resources\n");
@@ -940,35 +939,23 @@ static int isapnp_get_resources(struct p
 
 	for (i = 0; i < ISAPNP_MAX_PORT; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_PORT + (i << 1));
-		if (ret) {
-			pnp_res = pnp_add_io_resource(dev, ret, ret, 0);
-			if (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_io_resource(dev, ret, ret,
+				    ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
 	for (i = 0; i < ISAPNP_MAX_MEM; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_MEM + (i << 3)) << 8;
-		if (ret) {
-			pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
-			if (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_mem_resource(dev, ret, ret,
+				     ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
 	for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >> 8;
-		if (ret) {
-			pnp_res = pnp_add_irq_resource(dev, ret, 0);
-			if (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_irq_resource(dev, ret,
+				     ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
 	for (i = 0; i < ISAPNP_MAX_DMA; i++) {
 		ret = isapnp_read_byte(ISAPNP_CFG_DMA + i);
-		if (ret != 4) {
-			pnp_res = pnp_add_dma_resource(dev, ret, 0);
-			if  (pnp_res)
-				pnp_res->index = i;
-		}
+		pnp_add_dma_resource(dev, ret,
+				     ret == 4 ? IORESOURCE_DISABLED : 0);
 	}
 
 __end:
@@ -978,62 +965,49 @@ __end:
 
 static int isapnp_set_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int tmp, index;
+	int tmp;
 
 	dev_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
-			index = pnp_res->index;
+		res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			dev_dbg(&dev->dev, "  set io  %d to %#llx\n",
-				index, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_PORT + (index << 1),
+				tmp, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 					  res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
+		res = pnp_get_resource(dev, IORESOURCE_IRQ, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			int irq = res->start;
 			if (irq == 2)
 				irq = 9;
-			index = pnp_res->index;
-			dev_dbg(&dev->dev, "  set irq %d to %d\n", index, irq);
-			isapnp_write_byte(ISAPNP_CFG_IRQ + (index << 1), irq);
+			dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
+			isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
-			index = pnp_res->index;
+		res = pnp_get_resource(dev, IORESOURCE_DMA, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
-				index, (unsigned long long) res->start);
-			isapnp_write_byte(ISAPNP_CFG_DMA + index, res->start);
+				tmp, (unsigned long long) res->start);
+			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
-		pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, tmp);
-		if (!pnp_res)
-			continue;
-		res = &pnp_res->res;
-		if (pnp_resource_valid(res)) {
-			index = pnp_res->index;
+		res = pnp_get_resource(dev, IORESOURCE_MEM, tmp);
+		if (res && pnp_resource_valid(res) &&
+		    !(res->flags & IORESOURCE_DISABLED)) {
 			dev_dbg(&dev->dev, "  set mem %d to %#llx\n",
-				index, (unsigned long long) res->start);
-			isapnp_write_word(ISAPNP_CFG_MEM + (index << 3),
+				tmp, (unsigned long long) res->start);
+			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
 					  (res->start >> 8) & 0xffff);
 		}
 	}
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-05-15 15:21:53.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-05-15 15:23:24.000000000 -0600
@@ -40,7 +40,6 @@ static int pnp_assign_port(struct pnp_de
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IO;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -90,7 +89,6 @@ static int pnp_assign_mem(struct pnp_dev
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_MEM;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -155,7 +153,6 @@ static int pnp_assign_irq(struct pnp_dev
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_IRQ;
 	res->flags &= ~IORESOURCE_UNSET;
 
@@ -214,7 +211,6 @@ static void pnp_assign_dma(struct pnp_de
 	}
 
 	/* set the initial values */
-	pnp_res->index = idx;
 	res->flags |= rule->flags | IORESOURCE_DMA;
 	res->flags &= ~IORESOURCE_UNSET;
 

-- 
