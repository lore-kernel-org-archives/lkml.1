Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbYFDWNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbYFDWNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbYFDWLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:11:31 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25425 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbYFDWL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:11:26 -0400
Message-Id: <20080604221127.564142220@ldl.fc.hp.com>
References: <20080604220933.168145536@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 16:09:37 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
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
Subject: [patch 04/18] PNP: define PNP-specific IORESOURCE_IO_* flags alongside IRQ, DMA, MEM
Content-Disposition: inline; filename=pnp-io-option-flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PNP previously defined PNP_PORT_FLAG_16BITADDR and PNP_PORT_FLAG_FIXED
in a private header file, but put those flags in struct resource.flags
fields.  Better to make them IORESOURCE_IO_* flags like the existing
IRQ, DMA, and MEM flags.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

---
 include/linux/ioport.h         |   10 +++++++---
 include/linux/pnp.h            |    3 ---
 drivers/pnp/interface.c        |    2 +-
 drivers/pnp/isapnp/core.c      |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |   10 +++++-----
 drivers/pnp/pnpbios/rsparser.c |    4 ++--
 6 files changed, 17 insertions(+), 16 deletions(-)

Index: work10/include/linux/ioport.h
===================================================================
--- work10.orig/include/linux/ioport.h	2008-06-03 14:32:52.000000000 -0600
+++ work10/include/linux/ioport.h	2008-06-03 14:33:22.000000000 -0600
@@ -88,6 +88,10 @@ struct resource_list {
 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
 
+/* PnP I/O specific bits (IORESOURCE_BITS) */
+#define IORESOURCE_IO_16BIT_ADDR	(1<<0)
+#define IORESOURCE_IO_FIXED		(1<<1)
+
 /* PCI ROM control bits (IORESOURCE_BITS) */
 #define IORESOURCE_ROM_ENABLE		(1<<0)	/* ROM is enabled, same as PCI_ROM_ADDRESS_ENABLE */
 #define IORESOURCE_ROM_SHADOW		(1<<1)	/* ROM is copy at C000:0 */
Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-06-03 14:32:38.000000000 -0600
+++ work10/include/linux/pnp.h	2008-06-03 14:33:01.000000000 -0600
@@ -175,9 +175,6 @@ static inline int pnp_dma_valid(struct p
 }
 
 
-#define PNP_PORT_FLAG_16BITADDR	(1<<0)
-#define PNP_PORT_FLAG_FIXED	(1<<1)
-
 struct pnp_port {
 	unsigned short min;	/* min base number */
 	unsigned short max;	/* max base number */
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-06-03 14:32:38.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-06-03 14:33:01.000000000 -0600
@@ -57,7 +57,7 @@ static void pnp_print_port(pnp_info_buff
 		   "%sport 0x%x-0x%x, align 0x%x, size 0x%x, %i-bit address decoding\n",
 		   space, port->min, port->max,
 		   port->align ? (port->align - 1) : 0, port->size,
-		   port->flags & PNP_PORT_FLAG_16BITADDR ? 16 : 10);
+		   port->flags & IORESOURCE_IO_16BIT_ADDR ? 16 : 10);
 }
 
 static void pnp_print_irq(pnp_info_buffer_t * buffer, char *space,
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-06-03 14:32:38.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-06-03 14:33:01.000000000 -0600
@@ -486,7 +486,7 @@ static void __init isapnp_parse_port_res
 	port->max = (tmp[4] << 8) | tmp[3];
 	port->align = tmp[5];
 	port->size = tmp[6];
-	port->flags = tmp[0] ? PNP_PORT_FLAG_16BITADDR : 0;
+	port->flags = tmp[0] ? IORESOURCE_IO_16BIT_ADDR : 0;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -507,7 +507,7 @@ static void __init isapnp_parse_fixed_po
 	port->min = port->max = (tmp[1] << 8) | tmp[0];
 	port->size = tmp[2];
 	port->align = 0;
-	port->flags = PNP_PORT_FLAG_FIXED;
+	port->flags = IORESOURCE_IO_FIXED;
 	pnp_register_port_resource(dev, option, port);
 }
 
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-03 14:32:38.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-06-03 14:33:01.000000000 -0600
@@ -178,7 +178,7 @@ static void pnpacpi_parse_allocated_iore
 	u64 end = start + len - 1;
 
 	if (io_decode == ACPI_DECODE_16)
-		flags |= PNP_PORT_FLAG_16BITADDR;
+		flags |= IORESOURCE_IO_16BIT_ADDR;
 	if (len == 0 || end >= 0x10003)
 		flags |= IORESOURCE_DISABLED;
 
@@ -451,7 +451,7 @@ static __init void pnpacpi_parse_port_op
 	port->align = io->alignment;
 	port->size = io->address_length;
 	port->flags = ACPI_DECODE_16 == io->io_decode ?
-	    PNP_PORT_FLAG_16BITADDR : 0;
+	    IORESOURCE_IO_16BIT_ADDR : 0;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -469,7 +469,7 @@ static __init void pnpacpi_parse_fixed_p
 	port->min = port->max = io->address;
 	port->size = io->address_length;
 	port->align = 0;
-	port->flags = PNP_PORT_FLAG_FIXED;
+	port->flags = IORESOURCE_IO_FIXED;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -575,7 +575,7 @@ static __init void pnpacpi_parse_address
 		port->min = port->max = p->minimum;
 		port->size = p->address_length;
 		port->align = 0;
-		port->flags = PNP_PORT_FLAG_FIXED;
+		port->flags = IORESOURCE_IO_FIXED;
 		pnp_register_port_resource(dev, option, port);
 	}
 }
@@ -890,7 +890,7 @@ static void pnpacpi_encode_io(struct pnp
 	struct acpi_resource_io *io = &resource->data.io;
 
 	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
-	io->io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
+	io->io_decode = (p->flags & IORESOURCE_IO_16BIT_ADDR) ?
 	    ACPI_DECODE_16 : ACPI_DECODE_10;
 	io->minimum = p->start;
 	io->maximum = p->end;
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-06-03 14:32:38.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-06-03 14:33:01.000000000 -0600
@@ -310,7 +310,7 @@ static __init void pnpbios_parse_port_op
 	port->max = (p[5] << 8) | p[4];
 	port->align = p[6];
 	port->size = p[7];
-	port->flags = p[1] ? PNP_PORT_FLAG_16BITADDR : 0;
+	port->flags = p[1] ? IORESOURCE_IO_16BIT_ADDR : 0;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -326,7 +326,7 @@ static __init void pnpbios_parse_fixed_p
 	port->min = port->max = (p[2] << 8) | p[1];
 	port->size = p[3];
 	port->align = 0;
-	port->flags = PNP_PORT_FLAG_FIXED;
+	port->flags = IORESOURCE_IO_FIXED;
 	pnp_register_port_resource(dev, option, port);
 }
 

-- 
