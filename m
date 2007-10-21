Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbXJUHwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbXJUHwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXJUHwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58881 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXJUHwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:11 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: acme@ghostprotocols.net, chas@cmf.nrl.navy.mil,
       linux-serial@vger.kernel.org
Subject: [PATCH 1/17] various irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075210.04E1919041A@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:10 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit a33c4b813fea228053f6e6747bc9786f3e3db58d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 15:10:54 2007 -0400

    [IRQ ARG CLEANUP] more driver cleanups

 drivers/atm/ambassador.c     |    7 ++++---
 drivers/char/cyclades.c      |   17 +----------------
 drivers/char/mwave/tp3780i.c |   14 ++++++++++----
 drivers/serial/8250.c        |    1 +
 5 files changed, 17 insertions(+), 25 deletions(-)

a33c4b813fea228053f6e6747bc9786f3e3db58d
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index c2b9464..da0895e 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -862,8 +862,9 @@ static inline void interrupts_off (amb_dev * dev) {
 
 /********** interrupt handling **********/
 
-static irqreturn_t interrupt_handler(int irq, void *dev_id) {
-  amb_dev * dev = dev_id;
+static irqreturn_t interrupt_handler(int irq, void *dev_id)
+{
+  amb_dev *dev = dev_id;
   
   PRINTD (DBG_IRQ|DBG_FLOW, "interrupt_handler: %p", dev_id);
   
@@ -872,7 +873,7 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id) {
   
     // for us or someone else sharing the same interrupt
     if (!interrupt) {
-      PRINTD (DBG_IRQ, "irq not for me");
+      PRINTD (DBG_IRQ, "no irq events pending");
       return IRQ_NONE;
     }
     
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index d1bd0f0..b1b5799 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1318,13 +1318,6 @@ static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 	unsigned int chip, too_many, had_work;
 	int index;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyy_interrupt: spurious interrupt %d\n",irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
@@ -1730,17 +1723,9 @@ static irqreturn_t cyz_interrupt(int irq, void *dev_id)
 {
 	struct cyclades_card *cinfo = dev_id;
 
-	if (unlikely(cinfo == NULL)) {
-#ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: spurious interrupt %d\n",irq);
-#endif
-		return IRQ_NONE;	/* spurious interrupt */
-	}
-
 	if (unlikely(!ISZLOADED(*cinfo))) {
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded "
-				"(IRQ%d).\n", irq);
+		printk(KERN_DEBUG "cyz_interrupt: board not yet loaded\n");
 #endif
 		return IRQ_NONE;
 	}
diff --git a/drivers/char/mwave/tp3780i.c b/drivers/char/mwave/tp3780i.c
index f282976..37fe80d 100644
--- a/drivers/char/mwave/tp3780i.c
+++ b/drivers/char/mwave/tp3780i.c
@@ -97,20 +97,24 @@ static void EnableSRAM(THINKPAD_BD_DATA * pBDData)
 
 static irqreturn_t UartInterrupt(int irq, void *dev_id)
 {
+	int irqno = (int)(unsigned long) dev_id;
+
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irq, dev_id);
+		"tp3780i::UartInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t DspInterrupt(int irq, void *dev_id)
 {
+	int irqno = (int)(unsigned long) dev_id;
+
 	pMWAVE_DEVICE_DATA pDrvData = &mwave_s_mdd;
 	DSP_3780I_CONFIG_SETTINGS *pSettings = &pDrvData->rBDData.rDspSettings;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	unsigned short usIPCSource = 0, usIsolationMask, usPCNum;
 
 	PRINTK_3(TRACE_TP3780I,
-		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irq, dev_id);
+		"tp3780i::DspInterrupt entry irq %x dev_id %p\n", irqno, dev_id);
 
 	if (dsp3780I_GetIPCSource(usDspBaseIO, &usIPCSource) == 0) {
 		PRINTK_2(TRACE_TP3780I,
@@ -361,14 +365,16 @@ int tp3780I_EnableDSP(THINKPAD_BD_DATA * pBDData)
 	pSettings->bPllBypass = TP_CFG_PllBypass;
 	pSettings->usChipletEnable = TP_CFG_ChipletEnable;
 
-	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart", NULL)) {
+	if (request_irq(pSettings->usUartIrq, &UartInterrupt, 0, "mwave_uart",
+			(void *)(unsigned long) pSettings->usUartIrq)) {
 		PRINTK_ERROR(KERN_ERR_MWAVE "tp3780i::tp3780I_EnableDSP: Error: Could not get UART IRQ %x\n", pSettings->usUartIrq);
 		goto exit_cleanup;
 	} else {		/* no conflict just release */
 		free_irq(pSettings->usUartIrq, NULL);
 	}
 
-	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i", NULL)) {
+	if (request_irq(pSettings->usDspIrq, &DspInterrupt, 0, "mwave_3780i",
+			(void *)(unsigned long) pSettings->usDspIrq)) {
 		PRINTK_ERROR("tp3780i::tp3780I_EnableDSP: Error: Could not get 3780i IRQ %x\n", pSettings->usDspIrq);
 		goto exit_cleanup;
 	} else {
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..0d661ba 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -40,6 +40,7 @@
 #include <linux/serial_8250.h>
 #include <linux/nmi.h>
 #include <linux/mutex.h>
+#include <linux/interrupt.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
