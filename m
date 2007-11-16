Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbXKPH3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbXKPH3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXKPH3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:29:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:37658 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbXKPH3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:29:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,425,1188802800"; 
   d="scan'208";a="386477128"
Subject: [PATCH]: PNP: Increase the value of PNP constant
From: Zhao Yakui <yakui.zhao@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, shaohua.li@intel.com
Content-Type: text/plain
Date: Fri, 16 Nov 2007 15:39:58 +0800
Message-Id: <1195198798.2460.18.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: PNP: Increase the value of PNP constant
From: Zhao Yakui  <yakui.zhao@intel.com>

On some systems the number of resources(IO,MEM) returnedy by PNP
device is greater than the PNP constant, for example motherboard devices. 
It brings that some resources can't be reserved and resource confilicts.
This will cause PCI resources are assigned wrongly in some systems, and
cause hang. This is a regression since we deleted ACPI motherboard
driver and use PNP system driver.

Andrew, I thought this is an urgent issue and should be fixed ASAP, and
this is a good candidate for -stable tree

Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>

---
 drivers/pnp/pnpacpi/rsparser.c |   18 ++++++++++++++++--
 include/linux/pnp.h            |    4 ++--
 2 files changed, 18 insertions(+), 4 deletions(-)

Index: linux-2.6.24-rc2/include/linux/pnp.h
===================================================================
--- linux-2.6.24-rc2.orig/include/linux/pnp.h
+++ linux-2.6.24-rc2/include/linux/pnp.h
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
Index: linux-2.6.24-rc2/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.24-rc2/drivers/pnp/pnpacpi/rsparser.c
@@ -82,9 +82,11 @@ static void pnpacpi_parse_allocated_irqr
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_IRQ)
 		i++;
-	if (i >= PNP_MAX_IRQ)
+	if (i >= PNP_MAX_IRQ) {
+		printk(KERN_ERR "Exceed the max number of IRQ resource: "
+				"%d \n",PNP_MAX_IRQ);
 		return;
-
+	}
 #ifdef CONFIG_X86
 	if (gsi < 16 && (triggering != ACPI_EDGE_SENSITIVE ||
 				polarity != ACPI_ACTIVE_HIGH)) {
@@ -173,6 +175,10 @@ static void pnpacpi_parse_allocated_dmar
 		}
 		res->dma_resource[i].start = dma;
 		res->dma_resource[i].end = dma;
+	} else {
+		printk(KERN_ERR "Exceed the max number of DMA resource: "
+				"%d \n",PNP_MAX_DMA);
+		return;
 	}
 }
 
@@ -194,6 +200,10 @@ static void pnpacpi_parse_allocated_iore
 		}
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
+	} else {
+		printk(KERN_ERR "Exceed the max number of IO Resource: "
+				"%d \n",PNP_MAX_PORT);
+		return;
 	}
 }
 
@@ -217,6 +227,10 @@ static void pnpacpi_parse_allocated_memr
 
 		res->mem_resource[i].start = mem;
 		res->mem_resource[i].end = mem + len - 1;
+	} else {
+		printk(KERN_ERR "Exceed the max number of Mem Resource: "
+				"%d \n",PNP_MAX_MEM);
+		return;
 	}
 }
 
