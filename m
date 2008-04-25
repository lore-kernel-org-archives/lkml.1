Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbYDYSzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbYDYSzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764955AbYDYSko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:40:44 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:19297 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259AbYDYSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:17 -0400
Message-Id: <20080425183931.626226516@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:44 -0600
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
Subject: [patch 37/54] PNP: convert encoders to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-encoders-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.  This
path is used when telling a device what resources it should use.

This doesn't convert ISAPNP because ISA needs to know the config
register index in addition to the resource itself.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:14:59.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-25 11:15:06.000000000 -0600
@@ -1014,7 +1014,6 @@
 
 int pnpacpi_encode_resources(struct pnp_dev *dev, struct acpi_buffer *buffer)
 {
-	struct pnp_resource_table *res_table = &dev->res;
 	int i = 0;
 	/* pnpacpi_build_resource_template allocates extra mem */
 	int res_cnt = (buffer->length - 1) / sizeof(struct acpi_resource) - 1;
@@ -1026,45 +1025,43 @@
 		switch (resource->type) {
 		case ACPI_RESOURCE_TYPE_IRQ:
 			pnpacpi_encode_irq(dev, resource,
-					   &res_table->irq_resource[irq]);
+			       pnp_get_resource(dev, IORESOURCE_IRQ, irq));
 			irq++;
 			break;
 
 		case ACPI_RESOURCE_TYPE_DMA:
 			pnpacpi_encode_dma(dev, resource,
-					   &res_table->dma_resource[dma]);
+				pnp_get_resource(dev, IORESOURCE_DMA, dma));
 			dma++;
 			break;
 		case ACPI_RESOURCE_TYPE_IO:
 			pnpacpi_encode_io(dev, resource,
-					  &res_table->port_resource[port]);
+				pnp_get_resource(dev, IORESOURCE_IO, port));
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_IO:
 			pnpacpi_encode_fixed_io(dev, resource,
-						&res_table->
-						port_resource[port]);
+				pnp_get_resource(dev, IORESOURCE_IO, port));
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY24:
 			pnpacpi_encode_mem24(dev, resource,
-					     &res_table->mem_resource[mem]);
+				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY32:
 			pnpacpi_encode_mem32(dev, resource,
-					     &res_table->mem_resource[mem]);
+				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 			pnpacpi_encode_fixed_mem32(dev, resource,
-						   &res_table->
-						   mem_resource[mem]);
+				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
 			pnpacpi_encode_ext_irq(dev, resource,
-					       &res_table->irq_resource[irq]);
+				pnp_get_resource(dev, IORESOURCE_IRQ, irq));
 			irq++;
 			break;
 		case ACPI_RESOURCE_TYPE_START_DEPENDENT:
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:14:59.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-25 11:15:06.000000000 -0600
@@ -688,7 +688,6 @@
 							     unsigned char *p,
 							     unsigned char *end)
 {
-	struct pnp_resource_table *res = &dev->res;
 	unsigned int len, tag;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
@@ -711,42 +710,48 @@
 		case LARGE_TAG_MEM:
 			if (len != 9)
 				goto len_err;
-			pnpbios_encode_mem(dev, p, &res->mem_resource[mem]);
+			pnpbios_encode_mem(dev, p,
+				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 
 		case LARGE_TAG_MEM32:
 			if (len != 17)
 				goto len_err;
-			pnpbios_encode_mem32(dev, p, &res->mem_resource[mem]);
+			pnpbios_encode_mem32(dev, p,
+				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 
 		case LARGE_TAG_FIXEDMEM32:
 			if (len != 9)
 				goto len_err;
-			pnpbios_encode_fixed_mem32(dev, p, &res->mem_resource[mem]);
+			pnpbios_encode_fixed_mem32(dev, p,
+				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 
 		case SMALL_TAG_IRQ:
 			if (len < 2 || len > 3)
 				goto len_err;
-			pnpbios_encode_irq(dev, p, &res->irq_resource[irq]);
+			pnpbios_encode_irq(dev, p,
+				pnp_get_resource(dev, IORESOURCE_IRQ, irq));
 			irq++;
 			break;
 
 		case SMALL_TAG_DMA:
 			if (len != 2)
 				goto len_err;
-			pnpbios_encode_dma(dev, p, &res->dma_resource[dma]);
+			pnpbios_encode_dma(dev, p,
+				pnp_get_resource(dev, IORESOURCE_DMA, dma));
 			dma++;
 			break;
 
 		case SMALL_TAG_PORT:
 			if (len != 7)
 				goto len_err;
-			pnpbios_encode_port(dev, p, &res->port_resource[port]);
+			pnpbios_encode_port(dev, p,
+				pnp_get_resource(dev, IORESOURCE_IO, port));
 			port++;
 			break;
 
@@ -757,7 +762,8 @@
 		case SMALL_TAG_FIXEDPORT:
 			if (len != 3)
 				goto len_err;
-			pnpbios_encode_fixed_port(dev, p, &res->port_resource[port]);
+			pnpbios_encode_fixed_port(dev, p,
+				pnp_get_resource(dev, IORESOURCE_IO, port));
 			port++;
 			break;
 

-- 
