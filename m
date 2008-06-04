Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbYFDWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbYFDWOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbYFDWLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:11:39 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35627 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222AbYFDWLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:11:34 -0400
Message-Id: <20080604221128.175724997@ldl.fc.hp.com>
References: <20080604220933.168145536@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 16:09:40 -0600
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
Subject: [patch 07/18] PNP: increase I/O port & memory option address sizes
Content-Disposition: inline; filename=pnp-option-resource-size
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI Address Space Descriptors can be up to 64 bits wide.
We should keep track of the whole thing when parsing resource
options, so this patch changes PNP port and mem option
fields from "unsigned short" and "unsigned int" to
"resource_size_t".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/base.h      |   16 ++++++++--------
 drivers/pnp/interface.c |   17 +++++++++++------
 drivers/pnp/resource.c  |   14 ++++++++++----
 3 files changed, 29 insertions(+), 18 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-05-16 16:13:34.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-05-16 16:13:37.000000000 -0600
@@ -20,10 +20,10 @@ int pnp_add_card_device(struct pnp_card 
 void pnp_remove_card_device(struct pnp_dev *dev);
 
 struct pnp_port {
-	unsigned short min;	/* min base number */
-	unsigned short max;	/* max base number */
-	unsigned char align;	/* align boundary */
-	unsigned char size;	/* size of range */
+	resource_size_t min;	/* min base number */
+	resource_size_t max;	/* max base number */
+	resource_size_t align;	/* align boundary */
+	resource_size_t size;	/* size of range */
 	unsigned char flags;	/* port flags */
 	unsigned char pad;	/* pad */
 	struct pnp_port *next;	/* next port */
@@ -46,10 +46,10 @@ struct pnp_dma {
 };
 
 struct pnp_mem {
-	unsigned int min;	/* min base number */
-	unsigned int max;	/* max base number */
-	unsigned int align;	/* align boundary */
-	unsigned int size;	/* size of range */
+	resource_size_t min;	/* min base number */
+	resource_size_t max;	/* max base number */
+	resource_size_t align;	/* align boundary */
+	resource_size_t size;	/* size of range */
 	unsigned char flags;	/* memory flags */
 	unsigned char pad;	/* pad */
 	struct pnp_mem *next;	/* next memory resource */
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-05-16 16:13:34.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-05-16 16:13:37.000000000 -0600
@@ -53,10 +53,12 @@ static int pnp_printf(pnp_info_buffer_t 
 static void pnp_print_port(pnp_info_buffer_t * buffer, char *space,
 			   struct pnp_port *port)
 {
-	pnp_printf(buffer,
-		   "%sport 0x%x-0x%x, align 0x%x, size 0x%x, %i-bit address decoding\n",
-		   space, port->min, port->max,
-		   port->align ? (port->align - 1) : 0, port->size,
+	pnp_printf(buffer, "%sport %#llx-%#llx, align %#llx, size %#llx, "
+		   "%i-bit address decoding\n", space,
+		   (unsigned long long) port->min,
+		   (unsigned long long) port->max,
+		   port->align ? ((unsigned long long) port->align - 1) : 0,
+		   (unsigned long long) port->size,
 		   port->flags & IORESOURCE_IO_16BIT_ADDR ? 16 : 10);
 }
 
@@ -148,8 +150,11 @@ static void pnp_print_mem(pnp_info_buffe
 {
 	char *s;
 
-	pnp_printf(buffer, "%sMemory 0x%x-0x%x, align 0x%x, size 0x%x",
-		   space, mem->min, mem->max, mem->align, mem->size);
+	pnp_printf(buffer, "%sMemory %#llx-%#llx, align %#llx, size %#llx",
+		   space, (unsigned long long) mem->min,
+		   (unsigned long long) mem->max,
+		   (unsigned long long) mem->align,
+		   (unsigned long long) mem->size);
 	if (mem->flags & IORESOURCE_MEM_WRITEABLE)
 		pnp_printf(buffer, ", writeable");
 	if (mem->flags & IORESOURCE_MEM_CACHEABLE)
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-05-16 16:13:34.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-05-16 16:13:37.000000000 -0600
@@ -143,8 +143,11 @@ int pnp_register_port_resource(struct pn
 		option->port = data;
 
 	dev_dbg(&dev->dev, "  io  "
-		"min %#x max %#x align %d size %d flags %#x\n",
-		data->min, data->max, data->align, data->size, data->flags);
+		"min %#llx max %#llx align %lld size %lld flags %#x\n",
+		(unsigned long long) data->min,
+		(unsigned long long) data->max,
+		(unsigned long long) data->align,
+		(unsigned long long) data->size, data->flags);
 	return 0;
 }
 
@@ -162,8 +165,11 @@ int pnp_register_mem_resource(struct pnp
 		option->mem = data;
 
 	dev_dbg(&dev->dev, "  mem "
-		"min %#x max %#x align %d size %d flags %#x\n",
-		data->min, data->max, data->align, data->size, data->flags);
+		"min %#llx max %#llx align %lld size %lld flags %#x\n",
+		(unsigned long long) data->min,
+		(unsigned long long) data->max,
+		(unsigned long long) data->align,
+		(unsigned long long) data->size, data->flags);
 	return 0;
 }
 

-- 
