Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbYF0XIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbYF0XIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764315AbYF0W73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:29 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46141 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764550AbYF0W7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:06 -0400
Message-Id: <20080627225801.940528882@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:09 -0600
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
Subject: [patch 18/28] PNP: make resource assignment functions return 0 (success) or -EBUSY (failure)
Content-Disposition: inline; filename=pnp-change-assignment-return-values
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch doesn't change any behavior; it just makes the return
values more conventional.

This changes pnp_assign_dma() from a void function to one that
returns an int, just like the other assignment functions.  For
now, at least, pnp_assign_dma() always returns 0 (success), so
it appears to never fail, just like before.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-05-13 13:27:01.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-05-13 13:29:05.000000000 -0600
@@ -26,7 +26,7 @@ static int pnp_assign_port(struct pnp_de
 		dev_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
-		return 1;
+		return 0;
 	}
 
 	res = &local_res;
@@ -51,13 +51,13 @@ static int pnp_assign_port(struct pnp_de
 				"(min %#llx max %#llx)\n", idx,
 				(unsigned long long) rule->min,
 				(unsigned long long) rule->max);
-			return 0;
+			return -EBUSY;
 		}
 	}
 
 __add:
 	pnp_add_io_resource(dev, res->start, res->end, res->flags);
-	return 1;
+	return 0;
 }
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
@@ -69,7 +69,7 @@ static int pnp_assign_mem(struct pnp_dev
 		dev_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
-		return 1;
+		return 0;
 	}
 
 	res = &local_res;
@@ -103,13 +103,13 @@ static int pnp_assign_mem(struct pnp_dev
 				"(min %#llx max %#llx)\n", idx,
 				(unsigned long long) rule->min,
 				(unsigned long long) rule->max);
-			return 0;
+			return -EBUSY;
 		}
 	}
 
 __add:
 	pnp_add_mem_resource(dev, res->start, res->end, res->flags);
-	return 1;
+	return 0;
 }
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
@@ -126,7 +126,7 @@ static int pnp_assign_irq(struct pnp_dev
 	if (res) {
 		dev_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
-		return 1;
+		return 0;
 	}
 
 	res = &local_res;
@@ -154,14 +154,14 @@ static int pnp_assign_irq(struct pnp_dev
 		}
 	}
 	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
-	return 0;
+	return -EBUSY;
 
 __add:
 	pnp_add_irq_resource(dev, res->start, res->flags);
-	return 1;
+	return 0;
 }
 
-static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
+static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
 	struct resource *res, local_res;
 	int i;
@@ -175,7 +175,7 @@ static void pnp_assign_dma(struct pnp_de
 	if (res) {
 		dev_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
-		return;
+		return 0;
 	}
 
 	res = &local_res;
@@ -198,6 +198,7 @@ static void pnp_assign_dma(struct pnp_de
 
 __add:
 	pnp_add_dma_resource(dev, res->start, res->flags);
+	return 0;
 }
 
 void pnp_init_resources(struct pnp_dev *dev)
@@ -243,25 +244,26 @@ static int pnp_assign_resources(struct p
 		irq = dev->independent->irq;
 		dma = dev->independent->dma;
 		while (port) {
-			if (!pnp_assign_port(dev, port, nport))
+			if (pnp_assign_port(dev, port, nport) < 0)
 				goto fail;
 			nport++;
 			port = port->next;
 		}
 		while (mem) {
-			if (!pnp_assign_mem(dev, mem, nmem))
+			if (pnp_assign_mem(dev, mem, nmem) < 0)
 				goto fail;
 			nmem++;
 			mem = mem->next;
 		}
 		while (irq) {
-			if (!pnp_assign_irq(dev, irq, nirq))
+			if (pnp_assign_irq(dev, irq, nirq) < 0)
 				goto fail;
 			nirq++;
 			irq = irq->next;
 		}
 		while (dma) {
-			pnp_assign_dma(dev, dma, ndma);
+			if (pnp_assign_dma(dev, dma, ndma) < 0)
+				goto fail;
 			ndma++;
 			dma = dma->next;
 		}
@@ -281,25 +283,26 @@ static int pnp_assign_resources(struct p
 		irq = dep->irq;
 		dma = dep->dma;
 		while (port) {
-			if (!pnp_assign_port(dev, port, nport))
+			if (pnp_assign_port(dev, port, nport) < 0)
 				goto fail;
 			nport++;
 			port = port->next;
 		}
 		while (mem) {
-			if (!pnp_assign_mem(dev, mem, nmem))
+			if (pnp_assign_mem(dev, mem, nmem) < 0)
 				goto fail;
 			nmem++;
 			mem = mem->next;
 		}
 		while (irq) {
-			if (!pnp_assign_irq(dev, irq, nirq))
+			if (pnp_assign_irq(dev, irq, nirq) < 0)
 				goto fail;
 			nirq++;
 			irq = irq->next;
 		}
 		while (dma) {
-			pnp_assign_dma(dev, dma, ndma);
+			if (pnp_assign_dma(dev, dma, ndma) < 0)
+				goto fail;
 			ndma++;
 			dma = dma->next;
 		}

-- 
