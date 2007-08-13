Return-Path: <linux-kernel-owner+w=401wt.eu-S1031770AbXHMOWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031770AbXHMOWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXHMLXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:23:55 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:47654
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S944016AbXHMLXt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:23:49 -0400
Message-Id: <46C05BA0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 13 Aug 2007 12:24:48 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <ambx1@neo.rr.com>
Subject: [PATCH] PNP: don't fail device init if no DMA channel
	available
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most drivers for devices supporting ISA DMA can operate without DMA as
well (falling back zo PIO). Thus it seems inappropriate for PNP to fail
device initialization in case none of the possible DMA channels are
available. Instead, it should be left to the driver to decide what to
do if request_dma() fails.

The patch at once adjusts the code to account for the fact that
pnp_assign_dma() now doesn't need to report failure anymore.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Adam Belay <ambx1@neo.rr.com>

 drivers/pnp/manager.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

--- linux-2.6.23-rc3/drivers/pnp/manager.c	2007-08-13 09:00:32.000000000 +0200
+++ 2.6.23-rc3-pnp-no-dma/drivers/pnp/manager.c	2007-08-07 10:40:43.000000000 +0200
@@ -170,7 +170,7 @@ static int pnp_assign_irq(struct pnp_dev
 	return 0;
 }
 
-static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
+static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
@@ -181,19 +181,15 @@ static int pnp_assign_dma(struct pnp_dev
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	if (!dev || !rule)
-		return -EINVAL;
-
 	if (idx >= PNP_MAX_DMA) {
 		pnp_err
 		    ("More than 2 dmas is incompatible with pnp specifications.");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
+		return;
 	}
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
-		return 1;
+		return;
 
 	start = &dev->res.dma_resource[idx].start;
 	end = &dev->res.dma_resource[idx].end;
@@ -203,19 +199,17 @@ static int pnp_assign_dma(struct pnp_dev
 	*flags |= rule->flags | IORESOURCE_DMA;
 	*flags &= ~IORESOURCE_UNSET;
 
-	if (!rule->map) {
-		*flags |= IORESOURCE_DISABLED;
-		return 1;	/* skip disabled resource requests */
-	}
-
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
 			*start = *end = xtab[i];
 			if (pnp_check_dma(dev, idx))
-				return 1;
+				return;
 		}
 	}
-	return 0;
+#ifdef MAX_DMA_CHANNELS
+	*start = *end = MAX_DMA_CHANNELS;
+#endif
+	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
 }
 
 /**
@@ -342,8 +336,7 @@ static int pnp_assign_resources(struct p
 			irq = irq->next;
 		}
 		while (dma) {
-			if (!pnp_assign_dma(dev, dma, ndma))
-				goto fail;
+			pnp_assign_dma(dev, dma, ndma);
 			ndma++;
 			dma = dma->next;
 		}
@@ -379,8 +372,7 @@ static int pnp_assign_resources(struct p
 			irq = irq->next;
 		}
 		while (dma) {
-			if (!pnp_assign_dma(dev, dma, ndma))
-				goto fail;
+			pnp_assign_dma(dev, dma, ndma);
 			ndma++;
 			dma = dma->next;
 		}



