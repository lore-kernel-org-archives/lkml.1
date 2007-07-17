Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbXGQQLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbXGQQLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbXGQQK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:10:56 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:43158 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760179AbXGQQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:10:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH] - Increase PNP_MAX_PORT. ACPI devices can have a lot IO resource declarations
Date: Tue, 17 Jul 2007 09:49:47 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Bernhard Walle <bwalle@suse.de>
References: <1184595667.19959.312.camel@queen.suse.de>
In-Reply-To: <1184595667.19959.312.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707170949.47346.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 08:21:07 am Thomas Renninger wrote:
> PNP0C02 devices normally have a lot more IO port declarations than
> currently defined in PNP_MAX_PORT

Yes.

> I also wonder whether other limits like:
>  #define PNP_MAX_MEM        4
>  #define PNP_MAX_IRQ        2
>  #define PNP_MAX_DMA        2
> could get exceeded with pnpacpi?

Definitely.  I think the current limits come from the PNP ISA spec
(sec 4.6).  I don't see similar limits in the PNPBIOS or ACPI specs,
so ideally I think they should be dynamically allocated as you suggest.

HPET devices often use more than two IRQs, so I worked up the following
patch a while ago.  I didn't post it because Adam had plans for a better
fix.  But I suspect he's otherwise occupied now :-)

It doesn't change PNP_MAX_PORT, so that would have to be updated.




PNP: increase number of resources devices can use

PNPACPI and PNPBIOS devices can use more than 2 IRQs, so bump PNP_MAX_IRQ
from 2 to 4.  For example, HPET devices can have up to 32 timers, each with
an IRQ.  (Current HPETs typically have 3 timers.)

Add ISAPNP_MAX_PORT, ISAPNP_MAX_MEM, ISAPNP_MAX_IRQ, and ISAPNP_MAX_DMA
because ISAPNP does limit the number of resources a device can use.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work-mm1/drivers/pnp/isapnp/core.c
===================================================================
--- work-mm1.orig/drivers/pnp/isapnp/core.c	2005-08-09 10:07:45.000000000 -0600
+++ work-mm1/drivers/pnp/isapnp/core.c	2005-08-09 14:03:03.000000000 -0600
@@ -950,28 +950,28 @@
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (dev->active) {
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
 			res->port_resource[tmp].start = ret;
 			res->port_resource[tmp].flags = IORESOURCE_IO;
 		}
-		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
 			res->mem_resource[tmp].start = ret;
 			res->mem_resource[tmp].flags = IORESOURCE_MEM;
 		}
-		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 			ret = (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >> 8);
 			if (!ret)
 				continue;
 			res->irq_resource[tmp].start = res->irq_resource[tmp].end = ret;
 			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
 		}
-		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
@@ -998,17 +998,17 @@
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
-	for (tmp = 0; tmp < PNP_MAX_PORT && (res->port_resource[tmp].flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO; tmp++)
+	for (tmp = 0; tmp < ISAPNP_MAX_PORT && (res->port_resource[tmp].flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO; tmp++)
 		isapnp_write_word(ISAPNP_CFG_PORT+(tmp<<1), res->port_resource[tmp].start);
-	for (tmp = 0; tmp < PNP_MAX_IRQ && (res->irq_resource[tmp].flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ; tmp++) {
+	for (tmp = 0; tmp < ISAPNP_MAX_IRQ && (res->irq_resource[tmp].flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ; tmp++) {
 		int irq = res->irq_resource[tmp].start;
 		if (irq == 2)
 			irq = 9;
 		isapnp_write_byte(ISAPNP_CFG_IRQ+(tmp<<1), irq);
 	}
-	for (tmp = 0; tmp < PNP_MAX_DMA && (res->dma_resource[tmp].flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA; tmp++)
+	for (tmp = 0; tmp < ISAPNP_MAX_DMA && (res->dma_resource[tmp].flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA; tmp++)
 		isapnp_write_byte(ISAPNP_CFG_DMA+tmp, res->dma_resource[tmp].start);
-	for (tmp = 0; tmp < PNP_MAX_MEM && (res->mem_resource[tmp].flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM; tmp++)
+	for (tmp = 0; tmp < ISAPNP_MAX_MEM && (res->mem_resource[tmp].flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM; tmp++)
 		isapnp_write_word(ISAPNP_CFG_MEM+(tmp<<3), (res->mem_resource[tmp].start >> 8) & 0xffff);
 	/* FIXME: We aren't handling 32bit mems properly here */
 	isapnp_activate(dev->number);
Index: work-mm1/include/linux/isapnp.h
===================================================================
--- work-mm1.orig/include/linux/isapnp.h	2005-06-17 13:48:29.000000000 -0600
+++ work-mm1/include/linux/isapnp.h	2005-08-09 14:35:31.000000000 -0600
@@ -24,6 +24,7 @@
 
 #include <linux/config.h>
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/pnp.h>
 
 /*
@@ -36,6 +37,11 @@
 #define ISAPNP_CFG_IRQ			0x70	/* 2 * word */
 #define ISAPNP_CFG_DMA			0x74	/* 2 * byte */
 
+#define ISAPNP_MAX_PORT			min(8, PNP_MAX_PORT)
+#define ISAPNP_MAX_MEM			min(4, PNP_MAX_MEM)
+#define ISAPNP_MAX_IRQ			min(2, PNP_MAX_IRQ)
+#define ISAPNP_MAX_DMA			min(2, PNP_MAX_DMA)
+
 /*
  *
  */
Index: work-mm1/include/linux/pnp.h
===================================================================
--- work-mm1.orig/include/linux/pnp.h	2005-08-09 10:07:46.000000000 -0600
+++ work-mm1/include/linux/pnp.h	2005-08-09 14:01:08.000000000 -0600
@@ -16,7 +16,7 @@
 
 #define PNP_MAX_PORT		8
 #define PNP_MAX_MEM		4
-#define PNP_MAX_IRQ		2
+#define PNP_MAX_IRQ		4
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
 
Index: work-mm1/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work-mm1.orig/drivers/pnp/pnpacpi/rsparser.c	2005-08-09 10:07:45.000000000 -0600
+++ work-mm1/drivers/pnp/pnpacpi/rsparser.c	2005-08-09 14:29:59.000000000 -0600
@@ -72,6 +72,10 @@
 	}
 }
 
+/*
+ * ACPI doesn't limit the number of resources a device can use, so
+ * we can use the generic PNP limits (PNP_MAX_IRQ, etc).
+ */
 static void
 pnpacpi_parse_allocated_irqresource(struct pnp_resource_table * res, u32 gsi,
 	int edge_level, int active_high_low)
Index: work-mm1/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work-mm1.orig/drivers/pnp/pnpbios/rsparser.c	2005-08-09 10:07:45.000000000 -0600
+++ work-mm1/drivers/pnp/pnpbios/rsparser.c	2005-08-09 14:29:37.000000000 -0600
@@ -51,6 +51,10 @@
  * Allocated Resources
  */
 
+/*
+ * PNPBIOS doesn't limit the number of resources a device can use, so
+ * we can use the generic PNP limits (PNP_MAX_IRQ, etc).
+ */
 static void
 pnpbios_parse_allocated_irqresource(struct pnp_resource_table * res, int irq)
 {
