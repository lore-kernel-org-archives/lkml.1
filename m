Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbYCZXLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbYCZXLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYCZXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:11:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15523 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbYCZXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:11:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [patch 28/37] PNP: add pnp_get_resource() interface
Date: Wed, 26 Mar 2008 17:15:03 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080326171058.099442579@ldl.fc.hp.com> <20080326171228.962706020@ldl.fc.hp.com>
In-Reply-To: <20080326171228.962706020@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261715.05328.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PNP: add pnp_get_resource() interface

This adds a pnp_get_resource() that works the same way as
platform_get_resource().  This will enable us to consolidate
many pnp_resource_table references in one place, which will
make it easier to make the table dynamic.

I used EXPORT_SYMBOL, not EXPORT_SYMBOL_GPL, because it doesn't
seem right to break existing non-GPL PNP drivers.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/resource.c |   27 +++++++++++++++++++++++++++
 include/linux/pnp.h    |    1 +
 2 files changed, 28 insertions(+)

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-26 11:10:22.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-26 16:50:05.000000000 -0600
@@ -25,6 +25,7 @@
 /*
  * Resource Management
  */
+struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
 
 /* Use these instead of directly reading pnp_dev to get resource information */
 #define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-26 11:10:29.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-26 16:50:42.000000000 -0600
@@ -560,6 +560,33 @@
 	return 0;
 }
 
+struct resource *pnp_get_resource(struct pnp_dev *dev,
+				  unsigned int type, unsigned int num)
+{
+	struct pnp_resource_table *res = &dev->res;
+
+	switch (type) {
+	case IORESOURCE_IO:
+		if (num >= PNP_MAX_PORT)
+			return NULL;
+		return &res->port_resource[num];
+	case IORESOURCE_MEM:
+		if (num >= PNP_MAX_MEM)
+			return NULL;
+		return &res->mem_resource[num];
+	case IORESOURCE_IRQ:
+		if (num >= PNP_MAX_IRQ)
+			return NULL;
+		return &res->irq_resource[num];
+	case IORESOURCE_DMA:
+		if (num >= PNP_MAX_DMA)
+			return NULL;
+		return &res->dma_resource[num];
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(pnp_get_resource);
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
