Return-Path: <linux-kernel-owner+w=401wt.eu-S1763869AbXLMHIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763869AbXLMHIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762348AbXLMG5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55369 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761844AbXLMG5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:07 -0500
Date: Wed, 12 Dec 2007 22:52:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, trenn@suse.de, yakui.zhao@intel.com,
       shaohua.li@intel.com, bjorn.helgaas@hp.com
Subject: [patch 31/60] PNP: increase the maximum number of resources
Message-ID: <20071213065231.GF6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pnp-increase-the-maximum-number-of-resources.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Zhao Yakui <yakui.zhao@intel.com>

patch a7839e960675b549f06209d18283d5cee2ce9261 in mainline.

On some systems the number of resources(IO,MEM) returnedy by PNP device is
greater than the PNP constant, for example motherboard devices.  It brings
that some resources can't be reserved and resource confilicts.  This will
cause PCI resources are assigned wrongly in some systems, and cause hang. 
This is a regression since we deleted ACPI motherboard driver and use PNP
system driver.

[akpm@linux-foundation.org: fix text and coding-style a bit]
Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pnp/pnpacpi/rsparser.c |   15 +++++++++++++--
 include/linux/pnp.h            |    4 ++--
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -82,9 +82,11 @@ static void pnpacpi_parse_allocated_irqr
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_IRQ)
 		i++;
-	if (i >= PNP_MAX_IRQ)
+	if (i >= PNP_MAX_IRQ) {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
+				"resources: %d \n", PNP_MAX_IRQ);
 		return;
-
+	}
 	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
 	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
@@ -163,6 +165,9 @@ static void pnpacpi_parse_allocated_dmar
 		}
 		res->dma_resource[i].start = dma;
 		res->dma_resource[i].end = dma;
+	} else {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
+				"resources: %d \n", PNP_MAX_DMA);
 	}
 }
 
@@ -184,6 +189,9 @@ static void pnpacpi_parse_allocated_iore
 		}
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
+	} else {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
+				"resources: %d \n", PNP_MAX_PORT);
 	}
 }
 
@@ -207,6 +215,9 @@ static void pnpacpi_parse_allocated_memr
 
 		res->mem_resource[i].start = mem;
 		res->mem_resource[i].end = mem + len - 1;
+	} else {
+		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
+				"resources: %d\n", PNP_MAX_MEM);
 	}
 }
 
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -13,8 +13,8 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		8
-#define PNP_MAX_MEM		4
+#define PNP_MAX_PORT		24
+#define PNP_MAX_MEM		12
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50

-- 
