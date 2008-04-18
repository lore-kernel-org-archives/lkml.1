Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbYDRVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbYDRVD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761431AbYDRUws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:52:48 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:29907 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562AbYDRUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:13 -0400
Message-Id: <20080418205053.141145787@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:24 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 29/53] PNP: convert sysfs interface to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-proc-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Note that this does not allow adding new resources beyond the
preallocated ones, so even though it does not reference
pnp_resource_table directly, it is still limited to the
fixed size of that table.  When the preallocation is removed,
we'll have to change this so it can add new resources.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/interface.c
===================================================================
--- work8.orig/drivers/pnp/interface.c	2008-04-10 16:09:39.000000000 -0600
+++ work8/drivers/pnp/interface.c	2008-04-10 16:15:48.000000000 -0600
@@ -323,6 +323,7 @@
 			  const char *ubuf, size_t count)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
 
@@ -382,76 +383,72 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				dev->res.port_resource[nport].start =
-				    simple_strtoul(buf, &buf, 0);
+				res = pnp_get_resource(dev, IORESOURCE_IO,
+						       nport);
+				if (!res)
+					break;
+				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.port_resource[nport].end =
-					    simple_strtoul(buf, &buf, 0);
+					res->end = simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.port_resource[nport].end =
-					    dev->res.port_resource[nport].start;
-				dev->res.port_resource[nport].flags =
-				    IORESOURCE_IO;
+					res->end = res->start;
+				res->flags = IORESOURCE_IO;
 				nport++;
-				if (nport >= PNP_MAX_PORT)
-					break;
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.mem_resource[nmem].start =
-				    simple_strtoul(buf, &buf, 0);
+				res = pnp_get_resource(dev, IORESOURCE_MEM,
+						       nmem);
+				if (!res)
+					break;
+				res->start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.mem_resource[nmem].end =
-					    simple_strtoul(buf, &buf, 0);
+					res->end = simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.mem_resource[nmem].end =
-					    dev->res.mem_resource[nmem].start;
-				dev->res.mem_resource[nmem].flags =
-				    IORESOURCE_MEM;
+					res->end = res->start;
+				res->flags = IORESOURCE_MEM;
 				nmem++;
-				if (nmem >= PNP_MAX_MEM)
-					break;
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.irq_resource[nirq].start =
-				    dev->res.irq_resource[nirq].end =
+				res = pnp_get_resource(dev, IORESOURCE_IRQ,
+						       nirq);
+				if (!res)
+					break;
+				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
-				dev->res.irq_resource[nirq].flags =
-				    IORESOURCE_IRQ;
+				res->flags = IORESOURCE_IRQ;
 				nirq++;
-				if (nirq >= PNP_MAX_IRQ)
-					break;
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.dma_resource[ndma].start =
-				    dev->res.dma_resource[ndma].end =
+				res = pnp_get_resource(dev, IORESOURCE_DMA,
+						       ndma);
+				if (!res)
+					break;
+				res->start = res->end =
 				    simple_strtoul(buf, &buf, 0);
-				dev->res.dma_resource[ndma].flags =
-				    IORESOURCE_DMA;
+				res->flags = IORESOURCE_DMA;
 				ndma++;
-				if (ndma >= PNP_MAX_DMA)
-					break;
 				continue;
 			}
 			break;

-- 
