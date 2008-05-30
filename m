Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYE3Wyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYE3Wyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYE3WuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:50:04 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47721 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbYE3Wto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:49:44 -0400
Message-Id: <20080530224934.156287156@ldl.fc.hp.com>
References: <20080530224853.976744229@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 16:49:07 -0600
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
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 14/15] PNP: support optional IRQ resources
Content-Disposition: inline; filename=pnp-optional-irqs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an IORESOURCE_IRQ_OPTIONAL flag for use when
assigning resources to a device.  If the flag is set and we are
unable to assign an IRQ to the device, we can leave the IRQ
disabled but allow the overall resource allocation to succeed.

Some devices request an IRQ, but can run without an IRQ
(possibly with degraded performance).  This flag lets us run
the device without the IRQ instead of just leaving the
device disabled.

This is a reimplementation of this previous change by Rene
Herman <rene.herman@gmail.com>:
    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3b73a223661ed137c5d3d2635f954382e94f5a43

I reimplemented this for two reasons:
    - to prepare for converting all resource options into a single linked
      list, as opposed to the per-resource-type lists we have now, and
    - to preserve the order and number of resource options.

In PNPBIOS and ACPI, we configure a device by giving firmware a
list of resource assignments.  It is important that this list
has exactly the same number of resources, in the same order,
as the "template" list we got from the firmware in the first
place.

The problem of a sound card being left disabled for want of an
IRQ was reported by Uwe Bugla <uwe.bugla@gmx.de>.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/include/linux/ioport.h
===================================================================
--- work10.orig/include/linux/ioport.h	2008-05-20 13:34:58.000000000 -0600
+++ work10/include/linux/ioport.h	2008-05-20 13:39:21.000000000 -0600
@@ -59,6 +59,7 @@ struct resource_list {
 #define IORESOURCE_IRQ_HIGHLEVEL	(1<<2)
 #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
 #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
+#define IORESOURCE_IRQ_OPTIONAL		(1<<5)
 
 /* ISA PnP DMA specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-05-20 13:39:21.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-05-20 13:39:25.000000000 -0600
@@ -153,6 +153,15 @@ static int pnp_assign_irq(struct pnp_dev
 				goto __add;
 		}
 	}
+
+	if (rule->flags & IORESOURCE_IRQ_OPTIONAL) {
+		res->start = -1;
+		res->end = -1;
+		res->flags |= IORESOURCE_DISABLED;
+		dev_dbg(&dev->dev, "  irq %d disabled (optional)\n", idx);
+		goto __add;
+	}
+
 	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
 	return -EBUSY;
 
Index: work10/drivers/pnp/quirks.c
===================================================================
--- work10.orig/drivers/pnp/quirks.c	2008-05-20 13:39:36.000000000 -0600
+++ work10/drivers/pnp/quirks.c	2008-05-20 14:01:42.000000000 -0600
@@ -118,34 +118,46 @@ static struct pnp_option *quirk_isapnp_m
 	struct pnp_option *res;
 
 	/*
-	 * Build a functional IRQ-less variant of each MPU option.
+	 * Build a functional IRQ-optional variant of each MPU option.
 	 */
 
 	for (res = dev->dependent; res; res = res->next) {
 		struct pnp_option *curr;
 		struct pnp_port *port;
-		struct pnp_port *copy;
+		struct pnp_port *copy_port;
+		struct pnp_irq *irq;
+		struct pnp_irq *copy_irq;
 
 		port = res->port;
-		if (!port || !res->irq)
+		irq = res->irq;
+		if (!port || !irq)
 			continue;
 
-		copy = pnp_alloc(sizeof *copy);
-		if (!copy)
+		copy_port = pnp_alloc(sizeof *copy_port);
+		if (!copy_port)
 			break;
 
-		copy->min = port->min;
-		copy->max = port->max;
-		copy->align = port->align;
-		copy->size = port->size;
-		copy->flags = port->flags;
+		copy_irq = pnp_alloc(sizeof *copy_irq);
+		if (!copy_irq) {
+			kfree(copy_port);
+			break;
+		}
+
+		*copy_port = *port;
+		copy_port->next = NULL;
+
+		*copy_irq = *irq;
+		copy_irq->flags |= IORESOURCE_IRQ_OPTIONAL;
+		copy_irq->next = NULL;
 
 		curr = pnp_build_option(PNP_RES_PRIORITY_FUNCTIONAL);
 		if (!curr) {
-			kfree(copy);
+			kfree(copy_port);
+			kfree(copy_irq);
 			break;
 		}
-		curr->port = copy;
+		curr->port = copy_port;
+		curr->irq = copy_irq;
 
 		if (prev)
 			prev->next = curr;
@@ -154,7 +166,7 @@ static struct pnp_option *quirk_isapnp_m
 		prev = curr;
 	}
 	if (head)
-		dev_info(&dev->dev, "adding IRQ-less MPU options\n");
+		dev_info(&dev->dev, "adding IRQ-optional MPU options\n");
 
 	return head;
 }
@@ -164,10 +176,6 @@ static void quirk_ad1815_mpu_resources(s
 	struct pnp_option *res;
 	struct pnp_irq *irq;
 
-	/*
-	 * Distribute the independent IRQ over the dependent options
-	 */
-
 	res = dev->independent;
 	if (!res)
 		return;
@@ -176,33 +184,10 @@ static void quirk_ad1815_mpu_resources(s
 	if (!irq || irq->next)
 		return;
 
-	res = dev->dependent;
-	if (!res)
-		return;
-
-	while (1) {
-		struct pnp_irq *copy;
-
-		copy = pnp_alloc(sizeof *copy);
-		if (!copy)
-			break;
-
-		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
-		copy->flags = irq->flags;
-
-		copy->next = res->irq; /* Yes, this is NULL */
-		res->irq = copy;
-
-		if (!res->next)
-			break;
-		res = res->next;
-	}
-	kfree(irq);
+	irq->flags |= IORESOURCE_IRQ_OPTIONAL;
+	dev_info(&dev->dev, "made independent IRQ optional\n");
 
 	res->next = quirk_isapnp_mpu_options(dev);
-
-	res = dev->independent;
-	res->irq = NULL;
 }
 
 static void quirk_isapnp_mpu_resources(struct pnp_dev *dev)

-- 
