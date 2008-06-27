Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbYF0XKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbYF0XKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764739AbYF0W7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:38 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46205 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764579AbYF0W7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:09 -0400
Message-Id: <20080627225802.341406126@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:11 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
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
Subject: [patch 20/28] PNP: centralize resource option allocations
Content-Disposition: inline; filename=pnp-centralize-option-allocs
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all the option allocations (pnp_mem, pnp_port, etc)
into the pnp_register_{mem,port,irq,dma}_resource() functions.  This
will make it easier to rework the option data structures.

The non-trivial part of this patch is the IRQ handling.  The backends
have to allocate a local pnp_irq_mask_t bitmap, populate it, and pass
a pointer to pnp_register_irq_resource().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/base.h             |   12 ++-
 drivers/pnp/isapnp/core.c      |  115 +++++++++++++------------------
 drivers/pnp/pnpacpi/rsparser.c |  149 +++++++++++++----------------------------
 drivers/pnp/pnpbios/rsparser.c |  112 ++++++++++++------------------
 drivers/pnp/resource.c         |   58 +++++++++++++--
 5 files changed, 200 insertions(+), 246 deletions(-)

Index: work14/drivers/pnp/base.h
===================================================================
--- work14.orig/drivers/pnp/base.h	2008-06-17 15:52:22.000000000 -0600
+++ work14/drivers/pnp/base.h	2008-06-17 15:52:27.000000000 -0600
@@ -74,13 +74,17 @@ struct pnp_option *pnp_register_independ
 struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
 						 int priority);
 int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_irq *data);
+			      pnp_irq_mask_t *map, unsigned char flags);
 int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_dma *data);
+			      unsigned char map, unsigned char flags);
 int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option,
-			       struct pnp_port *data);
+			       resource_size_t min, resource_size_t max,
+			       resource_size_t align, resource_size_t size,
+			       unsigned char flags);
 int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_mem *data);
+			      resource_size_t min, resource_size_t max,
+			      resource_size_t align, resource_size_t size,
+			      unsigned char flags);
 void pnp_init_resources(struct pnp_dev *dev);
 
 void pnp_fixup_device(struct pnp_dev *dev);
Index: work14/drivers/pnp/isapnp/core.c
===================================================================
--- work14.orig/drivers/pnp/isapnp/core.c	2008-06-17 15:52:20.000000000 -0600
+++ work14/drivers/pnp/isapnp/core.c	2008-06-17 15:52:27.000000000 -0600
@@ -433,20 +433,20 @@ static void __init isapnp_parse_irq_reso
 					     int size)
 {
 	unsigned char tmp[3];
-	struct pnp_irq *irq;
 	unsigned long bits;
+	pnp_irq_mask_t map;
+	unsigned char flags = IORESOURCE_IRQ_HIGHEDGE;
 
 	isapnp_peek(tmp, size);
-	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
-	if (!irq)
-		return;
 	bits = (tmp[1] << 8) | tmp[0];
-	bitmap_copy(irq->map.bits, &bits, 16);
+
+	bitmap_zero(map.bits, PNP_IRQ_NR);
+	bitmap_copy(map.bits, &bits, 16);
+
 	if (size > 2)
-		irq->flags = tmp[2];
-	else
-		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
-	pnp_register_irq_resource(dev, option, irq);
+		flags = tmp[2];
+
+	pnp_register_irq_resource(dev, option, &map, flags);
 }
 
 /*
@@ -457,15 +457,9 @@ static void __init isapnp_parse_dma_reso
 					     int size)
 {
 	unsigned char tmp[2];
-	struct pnp_dma *dma;
 
 	isapnp_peek(tmp, size);
-	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
-	if (!dma)
-		return;
-	dma->map = tmp[0];
-	dma->flags = tmp[1];
-	pnp_register_dma_resource(dev, option, dma);
+	pnp_register_dma_resource(dev, option, tmp[0], tmp[1]);
 }
 
 /*
@@ -476,18 +470,16 @@ static void __init isapnp_parse_port_res
 					      int size)
 {
 	unsigned char tmp[7];
-	struct pnp_port *port;
+	resource_size_t min, max, align, len;
+	unsigned char flags;
 
 	isapnp_peek(tmp, size);
-	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!port)
-		return;
-	port->min = (tmp[2] << 8) | tmp[1];
-	port->max = (tmp[4] << 8) | tmp[3];
-	port->align = tmp[5];
-	port->size = tmp[6];
-	port->flags = tmp[0] ? IORESOURCE_IO_16BIT_ADDR : 0;
-	pnp_register_port_resource(dev, option, port);
+	min = (tmp[2] << 8) | tmp[1];
+	max = (tmp[4] << 8) | tmp[3];
+	align = tmp[5];
+	len = tmp[6];
+	flags = tmp[0] ? IORESOURCE_IO_16BIT_ADDR : 0;
+	pnp_register_port_resource(dev, option, min, max, align, len, flags);
 }
 
 /*
@@ -498,17 +490,13 @@ static void __init isapnp_parse_fixed_po
 						    int size)
 {
 	unsigned char tmp[3];
-	struct pnp_port *port;
+	resource_size_t base, len;
 
 	isapnp_peek(tmp, size);
-	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!port)
-		return;
-	port->min = port->max = (tmp[1] << 8) | tmp[0];
-	port->size = tmp[2];
-	port->align = 0;
-	port->flags = IORESOURCE_IO_FIXED;
-	pnp_register_port_resource(dev, option, port);
+	base = (tmp[1] << 8) | tmp[0];
+	len = tmp[2];
+	pnp_register_port_resource(dev, option, base, base, 0, len,
+				   IORESOURCE_IO_FIXED);
 }
 
 /*
@@ -519,18 +507,16 @@ static void __init isapnp_parse_mem_reso
 					     int size)
 {
 	unsigned char tmp[9];
-	struct pnp_mem *mem;
+	resource_size_t min, max, align, len;
+	unsigned char flags;
 
 	isapnp_peek(tmp, size);
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = ((tmp[2] << 8) | tmp[1]) << 8;
-	mem->max = ((tmp[4] << 8) | tmp[3]) << 8;
-	mem->align = (tmp[6] << 8) | tmp[5];
-	mem->size = ((tmp[8] << 8) | tmp[7]) << 8;
-	mem->flags = tmp[0];
-	pnp_register_mem_resource(dev, option, mem);
+	min = ((tmp[2] << 8) | tmp[1]) << 8;
+	max = ((tmp[4] << 8) | tmp[3]) << 8;
+	align = (tmp[6] << 8) | tmp[5];
+	len = ((tmp[8] << 8) | tmp[7]) << 8;
+	flags = tmp[0];
+	pnp_register_mem_resource(dev, option, min, max, align, len, flags);
 }
 
 /*
@@ -541,20 +527,16 @@ static void __init isapnp_parse_mem32_re
 					       int size)
 {
 	unsigned char tmp[17];
-	struct pnp_mem *mem;
+	resource_size_t min, max, align, len;
+	unsigned char flags;
 
 	isapnp_peek(tmp, size);
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
-	mem->max = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
-	mem->align =
-	    (tmp[12] << 24) | (tmp[11] << 16) | (tmp[10] << 8) | tmp[9];
-	mem->size =
-	    (tmp[16] << 24) | (tmp[15] << 16) | (tmp[14] << 8) | tmp[13];
-	mem->flags = tmp[0];
-	pnp_register_mem_resource(dev, option, mem);
+	min = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
+	max = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
+	align = (tmp[12] << 24) | (tmp[11] << 16) | (tmp[10] << 8) | tmp[9];
+	len = (tmp[16] << 24) | (tmp[15] << 16) | (tmp[14] << 8) | tmp[13];
+	flags = tmp[0];
+	pnp_register_mem_resource(dev, option, min, max, align, len, flags);
 }
 
 /*
@@ -565,18 +547,14 @@ static void __init isapnp_parse_fixed_me
 						     int size)
 {
 	unsigned char tmp[9];
-	struct pnp_mem *mem;
+	resource_size_t base, len;
+	unsigned char flags;
 
 	isapnp_peek(tmp, size);
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = mem->max =
-	    (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
-	mem->size = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
-	mem->align = 0;
-	mem->flags = tmp[0];
-	pnp_register_mem_resource(dev, option, mem);
+	base = (tmp[4] << 24) | (tmp[3] << 16) | (tmp[2] << 8) | tmp[1];
+	len = (tmp[8] << 24) | (tmp[7] << 16) | (tmp[6] << 8) | tmp[5];
+	flags = tmp[0];
+	pnp_register_mem_resource(dev, option, base, base, 0, len, flags);
 }
 
 /*
Index: work14/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work14.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-17 15:52:20.000000000 -0600
+++ work14/drivers/pnp/pnpacpi/rsparser.c	2008-06-17 15:52:27.000000000 -0600
@@ -411,20 +411,16 @@ static __init void pnpacpi_parse_dma_opt
 					    struct acpi_resource_dma *p)
 {
 	int i;
-	struct pnp_dma *dma;
+	unsigned char map = 0, flags;
 
 	if (p->channel_count == 0)
 		return;
-	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
-	if (!dma)
-		return;
 
 	for (i = 0; i < p->channel_count; i++)
-		dma->map |= 1 << p->channels[i];
-
-	dma->flags = dma_flags(p->type, p->bus_master, p->transfer);
+		map |= 1 << p->channels[i];
 
-	pnp_register_dma_resource(dev, option, dma);
+	flags = dma_flags(p->type, p->bus_master, p->transfer);
+	pnp_register_dma_resource(dev, option, map, flags);
 }
 
 static __init void pnpacpi_parse_irq_option(struct pnp_dev *dev,
@@ -432,20 +428,19 @@ static __init void pnpacpi_parse_irq_opt
 					    struct acpi_resource_irq *p)
 {
 	int i;
-	struct pnp_irq *irq;
+	pnp_irq_mask_t map;
+	unsigned char flags;
 
 	if (p->interrupt_count == 0)
 		return;
-	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
-	if (!irq)
-		return;
 
+	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], irq->map.bits);
-	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
+			__set_bit(p->interrupts[i], map.bits);
 
-	pnp_register_irq_resource(dev, option, irq);
+	flags = irq_flags(p->triggering, p->polarity, p->sharable);
+	pnp_register_irq_resource(dev, option, &map, flags);
 }
 
 static __init void pnpacpi_parse_ext_irq_option(struct pnp_dev *dev,
@@ -453,123 +448,90 @@ static __init void pnpacpi_parse_ext_irq
 					struct acpi_resource_extended_irq *p)
 {
 	int i;
-	struct pnp_irq *irq;
+	pnp_irq_mask_t map;
+	unsigned char flags;
 
 	if (p->interrupt_count == 0)
 		return;
-	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
-	if (!irq)
-		return;
 
+	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], irq->map.bits);
-	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
+			__set_bit(p->interrupts[i], map.bits);
 
-	pnp_register_irq_resource(dev, option, irq);
+	flags = irq_flags(p->triggering, p->polarity, p->sharable);
+	pnp_register_irq_resource(dev, option, &map, flags);
 }
 
 static __init void pnpacpi_parse_port_option(struct pnp_dev *dev,
 					     struct pnp_option *option,
 					     struct acpi_resource_io *io)
 {
-	struct pnp_port *port;
+	unsigned char flags = 0;
 
 	if (io->address_length == 0)
 		return;
-	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!port)
-		return;
-	port->min = io->minimum;
-	port->max = io->maximum;
-	port->align = io->alignment;
-	port->size = io->address_length;
-	port->flags = ACPI_DECODE_16 == io->io_decode ?
-	    IORESOURCE_IO_16BIT_ADDR : 0;
-	pnp_register_port_resource(dev, option, port);
+
+	if (io->io_decode == ACPI_DECODE_16)
+		flags = IORESOURCE_IO_16BIT_ADDR;
+	pnp_register_port_resource(dev, option, io->minimum, io->maximum,
+				   io->alignment, io->address_length, flags);
 }
 
 static __init void pnpacpi_parse_fixed_port_option(struct pnp_dev *dev,
 						   struct pnp_option *option,
 					struct acpi_resource_fixed_io *io)
 {
-	struct pnp_port *port;
-
 	if (io->address_length == 0)
 		return;
-	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!port)
-		return;
-	port->min = port->max = io->address;
-	port->size = io->address_length;
-	port->align = 0;
-	port->flags = IORESOURCE_IO_FIXED;
-	pnp_register_port_resource(dev, option, port);
+
+	pnp_register_port_resource(dev, option, io->address, io->address, 0,
+				   io->address_length, IORESOURCE_IO_FIXED);
 }
 
 static __init void pnpacpi_parse_mem24_option(struct pnp_dev *dev,
 					      struct pnp_option *option,
 					      struct acpi_resource_memory24 *p)
 {
-	struct pnp_mem *mem;
+	unsigned char flags = 0;
 
 	if (p->address_length == 0)
 		return;
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = p->minimum;
-	mem->max = p->maximum;
-	mem->align = p->alignment;
-	mem->size = p->address_length;
 
-	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
-	    IORESOURCE_MEM_WRITEABLE : 0;
-
-	pnp_register_mem_resource(dev, option, mem);
+	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
+		flags = IORESOURCE_MEM_WRITEABLE;
+	pnp_register_mem_resource(dev, option, p->minimum, p->maximum,
+				  p->alignment, p->address_length, flags);
 }
 
 static __init void pnpacpi_parse_mem32_option(struct pnp_dev *dev,
 					      struct pnp_option *option,
 					      struct acpi_resource_memory32 *p)
 {
-	struct pnp_mem *mem;
+	unsigned char flags = 0;
 
 	if (p->address_length == 0)
 		return;
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = p->minimum;
-	mem->max = p->maximum;
-	mem->align = p->alignment;
-	mem->size = p->address_length;
 
-	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
-	    IORESOURCE_MEM_WRITEABLE : 0;
-
-	pnp_register_mem_resource(dev, option, mem);
+	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
+		flags = IORESOURCE_MEM_WRITEABLE;
+	pnp_register_mem_resource(dev, option, p->minimum, p->maximum,
+				  p->alignment, p->address_length, flags);
 }
 
 static __init void pnpacpi_parse_fixed_mem32_option(struct pnp_dev *dev,
 						    struct pnp_option *option,
 					struct acpi_resource_fixed_memory32 *p)
 {
-	struct pnp_mem *mem;
+	unsigned char flags = 0;
 
 	if (p->address_length == 0)
 		return;
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = mem->max = p->address;
-	mem->size = p->address_length;
-	mem->align = 0;
 
-	mem->flags = (ACPI_READ_WRITE_MEMORY == p->write_protect) ?
-	    IORESOURCE_MEM_WRITEABLE : 0;
-
-	pnp_register_mem_resource(dev, option, mem);
+	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
+		flags = IORESOURCE_MEM_WRITEABLE;
+	pnp_register_mem_resource(dev, option, p->address, p->address,
+				  0, p->address_length, flags);
 }
 
 static __init void pnpacpi_parse_address_option(struct pnp_dev *dev,
@@ -578,8 +540,7 @@ static __init void pnpacpi_parse_address
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
-	struct pnp_mem *mem;
-	struct pnp_port *port;
+	unsigned char flags = 0;
 
 	status = acpi_resource_to_address64(r, p);
 	if (!ACPI_SUCCESS(status)) {
@@ -592,26 +553,14 @@ static __init void pnpacpi_parse_address
 		return;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
-		mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-		if (!mem)
-			return;
-		mem->min = mem->max = p->minimum;
-		mem->size = p->address_length;
-		mem->align = 0;
-		mem->flags = (p->info.mem.write_protect ==
-			      ACPI_READ_WRITE_MEMORY) ? IORESOURCE_MEM_WRITEABLE
-		    : 0;
-		pnp_register_mem_resource(dev, option, mem);
-	} else if (p->resource_type == ACPI_IO_RANGE) {
-		port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-		if (!port)
-			return;
-		port->min = port->max = p->minimum;
-		port->size = p->address_length;
-		port->align = 0;
-		port->flags = IORESOURCE_IO_FIXED;
-		pnp_register_port_resource(dev, option, port);
-	}
+		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
+			flags = IORESOURCE_MEM_WRITEABLE;
+		pnp_register_mem_resource(dev, option, p->minimum, p->minimum,
+					  0, p->address_length, flags);
+	} else if (p->resource_type == ACPI_IO_RANGE)
+		pnp_register_port_resource(dev, option, p->minimum, p->minimum,
+					   0, p->address_length,
+					   IORESOURCE_IO_FIXED);
 }
 
 struct acpipnp_parse_option_s {
Index: work14/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work14.orig/drivers/pnp/pnpbios/rsparser.c	2008-06-17 15:52:20.000000000 -0600
+++ work14/drivers/pnp/pnpbios/rsparser.c	2008-06-17 15:52:27.000000000 -0600
@@ -218,116 +218,96 @@ static __init void pnpbios_parse_mem_opt
 					    unsigned char *p, int size,
 					    struct pnp_option *option)
 {
-	struct pnp_mem *mem;
+	resource_size_t min, max, align, len;
+	unsigned char flags;
 
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = ((p[5] << 8) | p[4]) << 8;
-	mem->max = ((p[7] << 8) | p[6]) << 8;
-	mem->align = (p[9] << 8) | p[8];
-	mem->size = ((p[11] << 8) | p[10]) << 8;
-	mem->flags = p[3];
-	pnp_register_mem_resource(dev, option, mem);
+	min = ((p[5] << 8) | p[4]) << 8;
+	max = ((p[7] << 8) | p[6]) << 8;
+	align = (p[9] << 8) | p[8];
+	len = ((p[11] << 8) | p[10]) << 8;
+	flags = p[3];
+	pnp_register_mem_resource(dev, option, min, max, align, len, flags);
 }
 
 static __init void pnpbios_parse_mem32_option(struct pnp_dev *dev,
 					      unsigned char *p, int size,
 					      struct pnp_option *option)
 {
-	struct pnp_mem *mem;
+	resource_size_t min, max, align, len;
+	unsigned char flags;
 
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = (p[7] << 24) | (p[6] << 16) | (p[5] << 8) | p[4];
-	mem->max = (p[11] << 24) | (p[10] << 16) | (p[9] << 8) | p[8];
-	mem->align = (p[15] << 24) | (p[14] << 16) | (p[13] << 8) | p[12];
-	mem->size = (p[19] << 24) | (p[18] << 16) | (p[17] << 8) | p[16];
-	mem->flags = p[3];
-	pnp_register_mem_resource(dev, option, mem);
+	min = (p[7] << 24) | (p[6] << 16) | (p[5] << 8) | p[4];
+	max = (p[11] << 24) | (p[10] << 16) | (p[9] << 8) | p[8];
+	align = (p[15] << 24) | (p[14] << 16) | (p[13] << 8) | p[12];
+	len = (p[19] << 24) | (p[18] << 16) | (p[17] << 8) | p[16];
+	flags = p[3];
+	pnp_register_mem_resource(dev, option, min, max, align, len, flags);
 }
 
 static __init void pnpbios_parse_fixed_mem32_option(struct pnp_dev *dev,
 						    unsigned char *p, int size,
 						    struct pnp_option *option)
 {
-	struct pnp_mem *mem;
+	resource_size_t base, len;
+	unsigned char flags;
 
-	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!mem)
-		return;
-	mem->min = mem->max = (p[7] << 24) | (p[6] << 16) | (p[5] << 8) | p[4];
-	mem->size = (p[11] << 24) | (p[10] << 16) | (p[9] << 8) | p[8];
-	mem->align = 0;
-	mem->flags = p[3];
-	pnp_register_mem_resource(dev, option, mem);
+	base = (p[7] << 24) | (p[6] << 16) | (p[5] << 8) | p[4];
+	len = (p[11] << 24) | (p[10] << 16) | (p[9] << 8) | p[8];
+	flags = p[3];
+	pnp_register_mem_resource(dev, option, base, base, 0, len, flags);
 }
 
 static __init void pnpbios_parse_irq_option(struct pnp_dev *dev,
 					    unsigned char *p, int size,
 					    struct pnp_option *option)
 {
-	struct pnp_irq *irq;
 	unsigned long bits;
+	pnp_irq_mask_t map;
+	unsigned char flags = IORESOURCE_IRQ_HIGHEDGE;
 
-	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
-	if (!irq)
-		return;
 	bits = (p[2] << 8) | p[1];
-	bitmap_copy(irq->map.bits, &bits, 16);
+
+	bitmap_zero(map.bits, PNP_IRQ_NR);
+	bitmap_copy(map.bits, &bits, 16);
+
 	if (size > 2)
-		irq->flags = p[3];
-	else
-		irq->flags = IORESOURCE_IRQ_HIGHEDGE;
-	pnp_register_irq_resource(dev, option, irq);
+		flags = p[3];
+
+	pnp_register_irq_resource(dev, option, &map, flags);
 }
 
 static __init void pnpbios_parse_dma_option(struct pnp_dev *dev,
 					    unsigned char *p, int size,
 					    struct pnp_option *option)
 {
-	struct pnp_dma *dma;
-
-	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
-	if (!dma)
-		return;
-	dma->map = p[1];
-	dma->flags = p[2];
-	pnp_register_dma_resource(dev, option, dma);
+	pnp_register_dma_resource(dev, option, p[1], p[2]);
 }
 
 static __init void pnpbios_parse_port_option(struct pnp_dev *dev,
 					     unsigned char *p, int size,
 					     struct pnp_option *option)
 {
-	struct pnp_port *port;
+	resource_size_t min, max, align, len;
+	unsigned char flags;
 
-	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!port)
-		return;
-	port->min = (p[3] << 8) | p[2];
-	port->max = (p[5] << 8) | p[4];
-	port->align = p[6];
-	port->size = p[7];
-	port->flags = p[1] ? IORESOURCE_IO_16BIT_ADDR : 0;
-	pnp_register_port_resource(dev, option, port);
+	min = (p[3] << 8) | p[2];
+	max = (p[5] << 8) | p[4];
+	align = p[6];
+	len = p[7];
+	flags = p[1] ? IORESOURCE_IO_16BIT_ADDR : 0;
+	pnp_register_port_resource(dev, option, min, max, align, len, flags);
 }
 
 static __init void pnpbios_parse_fixed_port_option(struct pnp_dev *dev,
 						   unsigned char *p, int size,
 						   struct pnp_option *option)
 {
-	struct pnp_port *port;
+	resource_size_t base, len;
 
-	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!port)
-		return;
-	port->min = port->max = (p[2] << 8) | p[1];
-	port->size = p[3];
-	port->align = 0;
-	port->flags = IORESOURCE_IO_FIXED;
-	pnp_register_port_resource(dev, option, port);
+	base = (p[2] << 8) | p[1];
+	len = p[3];
+	pnp_register_port_resource(dev, option, base, base, 0, len,
+				   IORESOURCE_IO_FIXED);
 }
 
 static __init unsigned char *
Index: work14/drivers/pnp/resource.c
===================================================================
--- work14.orig/drivers/pnp/resource.c	2008-06-17 15:52:22.000000000 -0600
+++ work14/drivers/pnp/resource.c	2008-06-17 15:52:27.000000000 -0600
@@ -78,13 +78,20 @@ struct pnp_option *pnp_register_dependen
 }
 
 int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_irq *data)
+			      pnp_irq_mask_t *map, unsigned char flags)
 {
-	struct pnp_irq *ptr;
+	struct pnp_irq *data, *ptr;
 #ifdef DEBUG
 	char buf[PNP_IRQ_NR];   /* hex-encoded, so this is overkill but safe */
 #endif
 
+	data = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->map = *map;
+	data->flags = flags;
+
 	ptr = option->irq;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
@@ -112,9 +119,16 @@ int pnp_register_irq_resource(struct pnp
 }
 
 int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_dma *data)
+			      unsigned char map, unsigned char flags)
 {
-	struct pnp_dma *ptr;
+	struct pnp_dma *data, *ptr;
+
+	data = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->map = map;
+	data->flags = flags;
 
 	ptr = option->dma;
 	while (ptr && ptr->next)
@@ -130,9 +144,21 @@ int pnp_register_dma_resource(struct pnp
 }
 
 int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option,
-			       struct pnp_port *data)
-{
-	struct pnp_port *ptr;
+			       resource_size_t min, resource_size_t max,
+			       resource_size_t align, resource_size_t size,
+			       unsigned char flags)
+{
+	struct pnp_port *data, *ptr;
+
+	data = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->min = min;
+	data->max = max;
+	data->align = align;
+	data->size = size;
+	data->flags = flags;
 
 	ptr = option->port;
 	while (ptr && ptr->next)
@@ -152,9 +178,21 @@ int pnp_register_port_resource(struct pn
 }
 
 int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_mem *data)
-{
-	struct pnp_mem *ptr;
+			      resource_size_t min, resource_size_t max,
+			      resource_size_t align, resource_size_t size,
+			      unsigned char flags)
+{
+	struct pnp_mem *data, *ptr;
+
+	data = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->min = min;
+	data->max = max;
+	data->align = align;
+	data->size = size;
+	data->flags = flags;
 
 	ptr = option->mem;
 	while (ptr && ptr->next)

-- 
