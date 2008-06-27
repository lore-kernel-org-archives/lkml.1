Return-Path: <linux-kernel-owner+w=401wt.eu-S1765934AbYF0XGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765934AbYF0XGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762248AbYF0W7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:19 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:39437 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764271AbYF0W6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:55 -0400
Message-Id: <20080627225800.310058020@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:01 -0600
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
Subject: [patch 10/28] PNP: add pnp_possible_config() -- can a device could be configured this way?
Content-Disposition: inline; filename=pnp-new-option-interface-for-serial-pnp
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of a heuristic to identify modem devices, 8250_pnp.c
checks to see whether a device can be configured at any of the
legacy COM port addresses.

This patch moves the code that traverses the PNP "possible resource
options" from 8250_pnp.c to the PNP subsystem.  This encapsulation
is important because a future patch will change the implementation
of those resource options.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/resource.c    |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/serial/8250_pnp.c |   24 +++++-------------
 include/linux/pnp.h       |    3 ++
 3 files changed, 71 insertions(+), 17 deletions(-)

Index: work14/drivers/pnp/resource.c
===================================================================
--- work14.orig/drivers/pnp/resource.c	2008-06-24 17:06:49.000000000 -0600
+++ work14/drivers/pnp/resource.c	2008-06-24 17:06:49.000000000 -0600
@@ -624,6 +624,68 @@ struct pnp_resource *pnp_add_mem_resourc
 	return pnp_res;
 }
 
+static int pnp_possible_option(struct pnp_option *option, int type,
+			       resource_size_t start, resource_size_t size)
+{
+	struct pnp_option *tmp;
+	struct pnp_port *port;
+	struct pnp_mem *mem;
+	struct pnp_irq *irq;
+	struct pnp_dma *dma;
+
+	if (!option)
+		return 0;
+
+	for (tmp = option; tmp; tmp = tmp->next) {
+		switch (type) {
+		case IORESOURCE_IO:
+			for (port = tmp->port; port; port = port->next) {
+				if (port->min == start && port->size == size)
+					return 1;
+			}
+			break;
+		case IORESOURCE_MEM:
+			for (mem = tmp->mem; mem; mem = mem->next) {
+				if (mem->min == start && mem->size == size)
+					return 1;
+			}
+			break;
+		case IORESOURCE_IRQ:
+			for (irq = tmp->irq; irq; irq = irq->next) {
+				if (start < PNP_IRQ_NR &&
+				    test_bit(start, irq->map))
+					return 1;
+			}
+			break;
+		case IORESOURCE_DMA:
+			for (dma = tmp->dma; dma; dma = dma->next) {
+				if (dma->map & (1 << start))
+					return 1;
+			}
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Determine whether the specified resource is a possible configuration
+ * for this device.
+ */
+int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t start,
+			resource_size_t size)
+{
+	if (pnp_possible_option(dev->independent, type, start, size))
+		return 1;
+
+	if (pnp_possible_option(dev->dependent, type, start, size))
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(pnp_possible_config);
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work14/drivers/serial/8250_pnp.c
===================================================================
--- work14.orig/drivers/serial/8250_pnp.c	2008-06-24 16:53:06.000000000 -0600
+++ work14/drivers/serial/8250_pnp.c	2008-06-24 17:06:49.000000000 -0600
@@ -383,21 +383,14 @@ static int __devinit check_name(char *na
 	return 0;
 }
 
-static int __devinit check_resources(struct pnp_option *option)
+static int __devinit check_resources(struct pnp_dev *dev)
 {
-	struct pnp_option *tmp;
-	if (!option)
-		return 0;
+	resource_size_t base[] = {0x2f8, 0x3f8, 0x2e8, 0x3e8};
+	int i;
 
-	for (tmp = option; tmp; tmp = tmp->next) {
-		struct pnp_port *port;
-		for (port = tmp->port; port; port = port->next)
-			if ((port->size == 8) &&
-			    ((port->min == 0x2f8) ||
-			     (port->min == 0x3f8) ||
-			     (port->min == 0x2e8) ||
-			     (port->min == 0x3e8)))
-				return 1;
+	for (i = 0; i < ARRAY_SIZE(base); i++) {
+		if (pnp_possible_config(dev, IORESOURCE_IO, base[i], 8))
+			return 1;
 	}
 
 	return 0;
@@ -420,10 +413,7 @@ static int __devinit serial_pnp_guess_bo
 		(dev->card && check_name(dev->card->name))))
 			return -ENODEV;
 
-	if (check_resources(dev->independent))
-		return 0;
-
-	if (check_resources(dev->dependent))
+	if (check_resources(dev))
 		return 0;
 
 	return -ENODEV;
Index: work14/include/linux/pnp.h
===================================================================
--- work14.orig/include/linux/pnp.h	2008-06-24 16:53:06.000000000 -0600
+++ work14/include/linux/pnp.h	2008-06-24 17:07:27.000000000 -0600
@@ -479,6 +479,8 @@ void pnp_unregister_card_driver(struct p
 extern struct list_head pnp_cards;
 
 /* resource management */
+int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t base,
+			resource_size_t size);
 int pnp_auto_config_dev(struct pnp_dev *dev);
 int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
@@ -506,6 +508,9 @@ static inline int pnp_register_card_driv
 static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv) { }
 
 /* resource management */
+static inline int pnp_possible_config(struct pnp_dev *dev, int type,
+				      resource_size_t base,
+				      resource_size_t size) { return 0; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }

-- 
