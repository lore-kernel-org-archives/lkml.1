Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZABKsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZABKsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZABKmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:42:10 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:36252 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbZABKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org
Subject: [PATCH] m68k: scsi - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:24 +0100
Message-Id: <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/a2091.c |   18 ++++++++++++------
 drivers/scsi/gvp11.c |    8 ++++++--
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 07d572f..37dd471 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -169,10 +169,8 @@ int __init a2091_detect(struct scsi_host_template *tpnt)
 	    continue;
 
 	instance = scsi_register (tpnt, sizeof (struct WD33C93_hostdata));
-	if (instance == NULL) {
-	    release_mem_region(address, 256);
-	    continue;
-	}
+	if (instance == NULL)
+	    goto release;
 	instance->base = ZTWO_VADDR(address);
 	instance->irq = IRQ_AMIGA_PORTS;
 	instance->unique_id = z->slotaddr;
@@ -183,10 +181,18 @@ int __init a2091_detect(struct scsi_host_template *tpnt)
 	HDATA(instance)->fast = 0;
 	HDATA(instance)->dma_mode = CTRL_DMA;
 	wd33c93_init(instance, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
-	request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED, "A2091 SCSI",
-		    instance);
+	if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED, "A2091 SCSI",
+			instance))
+	    goto unregister;
 	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
 	num_a2091++;
+	continue;
+
+unregister:
+	scsi_unregister(instance);
+	wd33c93_release();
+release:
+	release_mem_region(address, 256);
     }
 
     return num_a2091;
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index ca73637..5d1bf7e 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -329,12 +329,16 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
 					     : WD33C93_FS_12_15);
 
-	request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED, "GVP11 SCSI",
-		    instance);
+	if (request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED, "GVP11 SCSI",
+			instance))
+		goto unregister;
 	DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
 	num_gvp11++;
 	continue;
 
+unregister:
+	scsi_unregister(instance);
+	wd33c93_release();
 release:
 	release_mem_region(address, 256);
     }
-- 
1.5.6.5

