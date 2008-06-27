Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbYF0XEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbYF0XEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764504AbYF0W7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:05 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:22945 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764116AbYF0W6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:54 -0400
Message-Id: <20080627225800.109781714@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:00 -0600
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
Subject: [patch 09/28] PNP: dont sort by type in /sys/.../resources
Content-Disposition: inline; filename=pnp-unsort-sysfs-resources
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than stepping through all IO resources, then stepping through
all MMIO resources, etc., we can just iterate over the resource list
once directly.

This can change the order in /sys, e.g.,

    # cat /sys/devices/pnp0/00:07/resources     # OLD
    state = active
    io 0x3f8-0x3ff
    irq 4

    # cat /sys/devices/pnp0/00:07/resources     # NEW
    state = active
    irq 4
    io 0x3f8-0x3ff

The old code artificially sorted resources by type; the new code
just lists them in the order we read them from the ISAPNP hardware
or the BIOS.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-05-05 11:54:26.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-05-05 11:59:53.000000000 -0600
@@ -248,8 +248,9 @@ static ssize_t pnp_show_current_resource
 					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int i, ret;
+	int ret;
 	pnp_info_buffer_t *buffer;
 
 	if (!dev)
@@ -262,46 +263,33 @@ static ssize_t pnp_show_current_resource
 	buffer->buffer = buf;
 	buffer->curr = buffer->buffer;
 
-	pnp_printf(buffer, "state = ");
-	if (dev->active)
-		pnp_printf(buffer, "active\n");
-	else
-		pnp_printf(buffer, "disabled\n");
-
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
-		pnp_printf(buffer, "io");
-		if (res->flags & IORESOURCE_DISABLED)
-			pnp_printf(buffer, " disabled\n");
-		else
-			pnp_printf(buffer, " 0x%llx-0x%llx\n",
-				   (unsigned long long) res->start,
-				   (unsigned long long) res->end);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		pnp_printf(buffer, "mem");
-		if (res->flags & IORESOURCE_DISABLED)
+	pnp_printf(buffer, "state = %s\n", dev->active ? "active" : "disabled");
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+
+		pnp_printf(buffer, pnp_resource_type_name(res));
+
+		if (res->flags & IORESOURCE_DISABLED) {
 			pnp_printf(buffer, " disabled\n");
-		else
-			pnp_printf(buffer, " 0x%llx-0x%llx\n",
+			continue;
+		}
+
+		switch (pnp_resource_type(res)) {
+		case IORESOURCE_IO:
+		case IORESOURCE_MEM:
+			pnp_printf(buffer, " %#llx-%#llx\n",
 				   (unsigned long long) res->start,
 				   (unsigned long long) res->end);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
-		pnp_printf(buffer, "irq");
-		if (res->flags & IORESOURCE_DISABLED)
-			pnp_printf(buffer, " disabled\n");
-		else
-			pnp_printf(buffer, " %lld\n",
-				   (unsigned long long) res->start);
-	}
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
-		pnp_printf(buffer, "dma");
-		if (res->flags & IORESOURCE_DISABLED)
-			pnp_printf(buffer, " disabled\n");
-		else
+			break;
+		case IORESOURCE_IRQ:
+		case IORESOURCE_DMA:
 			pnp_printf(buffer, " %lld\n",
 				   (unsigned long long) res->start);
+			break;
+		}
 	}
+
 	ret = (buffer->curr - buf);
 	kfree(buffer);
 	return ret;

-- 
