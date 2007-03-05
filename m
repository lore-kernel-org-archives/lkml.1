Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbXCECjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbXCECjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXCECjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:39:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44986 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbXCECje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:39:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 5 Mar 2007 03:39:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: ohci1394: add reg_flush, remove bogus barriers
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.d79e708fd3f5b582@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a utility function to flush MMIO writes.
Remove some mb()s which didn't do anything.

There are still a few wmb()s in ohci1394 which look suspicious.
Shouldn't there be dma_sync_*() calls instead?

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

 drivers/ieee1394/ohci1394.c |   47 +++++++++---------------------------
 drivers/ieee1394/ohci1394.h |   14 ++++++----
 2 files changed, 21 insertions(+), 40 deletions(-)


Index: linux/drivers/ieee1394/ohci1394.h
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.h
+++ linux/drivers/ieee1394/ohci1394.h
@@ -248,17 +248,19 @@ static inline int cross_bound(unsigned l
 	return 0;
 }
 
-/*
- * Register read and write helper functions.
- */
+/* Register read and write helper functions */
 static inline void reg_write(const struct ti_ohci *ohci, int offset, u32 data)
 {
-        writel(data, ohci->registers + offset);
+	writel(data, ohci->registers + offset);
 }
-
 static inline u32 reg_read(const struct ti_ohci *ohci, int offset)
 {
-        return readl(ohci->registers + offset);
+	return readl(ohci->registers + offset);
+}
+/* A dummy read to force all PCI writes to be posted immediately */
+static inline void reg_flush(const struct ti_ohci *ohci)
+{
+	readl(ohci->registers);
 }
 
 
Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -1438,12 +1438,8 @@ static void ohci_iso_recv_change_channel
 		reg = listen ? OHCI1394_IRMultiChanMaskHiSet : OHCI1394_IRMultiChanMaskHiClear;
 		i = channel - 32;
 	}
-
 	reg_write(recv->ohci, reg, (1 << i));
-
-	/* issue a dummy read to force all PCI writes to be posted immediately */
-	mb();
-	reg_read(recv->ohci, OHCI1394_IsochronousCycleTimer);
+	reg_flush(recv->ohci);
 }
 
 static void ohci_iso_recv_set_channel_mask(struct hpsb_iso *iso, u64 mask)
@@ -1464,10 +1460,7 @@ static void ohci_iso_recv_set_channel_ma
 				reg_write(recv->ohci, OHCI1394_IRMultiChanMaskHiClear, (1 << (i-32)));
 		}
 	}
-
-	/* issue a dummy read to force all PCI writes to be posted immediately */
-	mb();
-	reg_read(recv->ohci, OHCI1394_IsochronousCycleTimer);
+	reg_flush(recv->ohci);
 }
 
 static int ohci_iso_recv_start(struct hpsb_iso *iso, int cycle, int tag_mask, int sync)
@@ -1477,7 +1470,6 @@ static int ohci_iso_recv_start(struct hp
 	u32 command, contextMatch;
 
 	reg_write(recv->ohci, recv->ContextControlClear, 0xFFFFFFFF);
-	wmb();
 
 	/* always keep ISO headers */
 	command = (1 << 30);
@@ -1521,7 +1513,7 @@ static int ohci_iso_recv_start(struct hp
 
 	if (sync != -1) {
 		/* set sync flag on first DMA descriptor */
-		struct dma_cmd *cmd = &recv->block[recv->block_dma];
+ 		struct dma_cmd *cmd = &recv->block[recv->block_dma];
 		cmd->control |= cpu_to_le32(DMA_CTL_WAIT);
 
 		/* match sync field */
@@ -1545,11 +1537,6 @@ static int ohci_iso_recv_start(struct hp
 	/* run */
 	reg_write(recv->ohci, recv->ContextControlSet, 0x8000);
 
-	/* issue a dummy read of the cycle timer register to force
-	   all PCI writes to be posted immediately */
-	mb();
-	reg_read(recv->ohci, OHCI1394_IsochronousCycleTimer);
-
 	/* check RUN */
 	if (!(reg_read(recv->ohci, recv->ContextControlSet) & 0x8000)) {
 		PRINT(KERN_ERR,
@@ -2116,13 +2103,8 @@ static int ohci_iso_xmit_queue(struct hp
 	wmb();
 
 	/* wake DMA in case it is sleeping */
-	reg_write(xmit->ohci, xmit->ContextControlSet, 1 << 12);
-
-	/* issue a dummy read of the cycle timer to force all PCI
-	   writes to be posted immediately */
-	mb();
-	reg_read(xmit->ohci, OHCI1394_IsochronousCycleTimer);
-
+	reg_write(ohci, xmit->ContextControlSet, 1 << 12);
+	reg_flush(ohci);
 	return 0;
 }
 
@@ -2132,11 +2114,10 @@ static int ohci_iso_xmit_start(struct hp
 	struct ti_ohci *ohci = xmit->ohci;
 
 	/* clear out the control register */
-	reg_write(xmit->ohci, xmit->ContextControlClear, 0xFFFFFFFF);
-	wmb();
+	reg_write(ohci, xmit->ContextControlClear, 0xFFFFFFFF);
 
 	/* address and length of first descriptor block (Z=3) */
-	reg_write(xmit->ohci, xmit->CommandPtr,
+	reg_write(ohci, xmit->CommandPtr,
 		  dma_prog_region_offset_to_bus(&xmit->prog, iso->pkt_dma * sizeof(struct iso_xmit_cmd)) | 3);
 
 	/* cycle match */
@@ -2145,28 +2126,28 @@ static int ohci_iso_xmit_start(struct hp
 
 		/* 'cycle' is only mod 8000, but we also need two 'seconds' bits -
 		   just snarf them from the current time */
-		u32 seconds = reg_read(xmit->ohci, OHCI1394_IsochronousCycleTimer) >> 25;
+		u32 seconds = reg_read(ohci, OHCI1394_IsochronousCycleTimer) >> 25;
 
 		/* advance one second to give some extra time for DMA to start */
 		seconds += 1;
 
 		start |= (seconds & 3) << 13;
 
-		reg_write(xmit->ohci, xmit->ContextControlSet, 0x80000000 | (start << 16));
+		reg_write(ohci, xmit->ContextControlSet, 0x80000000 | (start << 16));
 	}
 
 	/* enable interrupts */
-	reg_write(xmit->ohci, OHCI1394_IsoXmitIntMaskSet, 1 << xmit->task.context);
+	reg_write(ohci, OHCI1394_IsoXmitIntMaskSet, 1 << xmit->task.context);
 
 	/* run */
-	reg_write(xmit->ohci, xmit->ContextControlSet, 0x8000);
-	mb();
+	reg_write(ohci, xmit->ContextControlSet, 0x8000);
+	reg_flush(ohci);
 
 	/* wait 100 usec to give the card time to go active */
 	udelay(100);
 
 	/* check the RUN bit */
-	if (!(reg_read(xmit->ohci, xmit->ContextControlSet) & 0x8000)) {
+	if (!(reg_read(ohci, xmit->ContextControlSet) & 0x8000)) {
 		PRINT(KERN_ERR, "Error starting IT DMA (ContextControl 0x%08x)\n",
 		      reg_read(xmit->ohci, xmit->ContextControlSet));
 		return -1;
@@ -3674,8 +3655,6 @@ int ohci1394_stop_context(struct ti_ohci
 			      "Runaway loop while stopping context: %s...", msg ? msg : "");
 			return 1;
 		}
-
-		mb();
 		udelay(10);
 	}
 	if (msg) PRINT(KERN_ERR, "%s: dma prg stopped", msg);

-- 
Stefan Richter
-=====-=-=== --== --=-=
http://arcgraph.de/sr/

