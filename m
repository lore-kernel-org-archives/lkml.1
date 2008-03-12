Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYCLPPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYCLPPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbYCLPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:15:09 -0400
Received: from testure.choralone.org ([194.9.77.134]:47315 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYCLPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:15:08 -0400
Date: Wed, 12 Mar 2008 11:14:52 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PNP: increase the maximum number of resources
Message-ID: <20080312151452.GA4523@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Zhao Yakui <yakui.zhao@intel.com>,
	Li Shaohua <shaohua.li@intel.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit a7839e960675b549f06209d18283d5cee2ce9261 the number of PNP resources
was increased.  In testing, we've found that the 'exceeded' warnings still get
hit with quite high frequency. See https://bugzilla.redhat.com/show_bug.cgi?id=436589
for examples.

I added the debug patch below, which yielded an interesting output.

pnpacpi: exceeded the max number of mem resources. Max:12 Found:12

off by one somewhere ?

	Dave

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 6aa231e..0c22e41 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -86,7 +86,7 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
 		i++;
 	if (i >= PNP_MAX_IRQ && !warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
-				"resources: %d \n", PNP_MAX_IRQ);
+				"resources. Max:%d Found:%d\n", PNP_MAX_IRQ, i);
 		warned = 1;
 		return;
 	}
@@ -188,7 +188,7 @@ static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
 		res->dma_resource[i].end = dma;
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
-				"resources: %d \n", PNP_MAX_DMA);
+				"resources. Max:%d Found:%d\n", PNP_MAX_DMA, i);
 		warned = 1;
 	}
 }
@@ -214,7 +214,7 @@ static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
 		res->port_resource[i].end = io + len - 1;
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
-				"resources: %d \n", PNP_MAX_PORT);
+				"resources. Max:%d Found:%d\n", PNP_MAX_PORT, i);
 		warned = 1;
 	}
 }
@@ -242,7 +242,7 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
 		res->mem_resource[i].end = mem + len - 1;
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
-				"resources: %d\n", PNP_MAX_MEM);
+				"resources. Max:%d Found:%d\n", PNP_MAX_MEM, i);
 		warned = 1;
 	}
 }
-- 
http://www.codemonkey.org.uk
