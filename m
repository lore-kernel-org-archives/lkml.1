Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbYCXTvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbYCXTvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYCXTuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:50:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51829 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYCXTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:50:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:49:01 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] ieee1394: ohci1394: unroll a macro with return
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.3b27f4ba701fc1ec@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want to hide something like return in a preprocessor macro.
Unroll the macro and use a goto, which also reduces the size of
ohci1394.ko.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.c |   92 +++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 38 deletions(-)

Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -2984,13 +2984,6 @@ static struct hpsb_host_driver ohci1394_
  * PCI Driver Interface functions  *
  ***********************************/
 
-#define FAIL(err, fmt, args...)			\
-do {						\
-	PRINT_G(KERN_ERR, fmt , ## args);	\
-        ohci1394_pci_remove(dev);               \
-	return err;				\
-} while (0)
-
 #ifdef CONFIG_PPC_PMAC
 static void ohci1394_pmac_on(struct pci_dev *dev)
 {
@@ -3026,15 +3019,21 @@ static int __devinit ohci1394_pci_probe(
 	struct hpsb_host *host;
 	struct ti_ohci *ohci;	/* shortcut to currently handled device */
 	resource_size_t ohci_base;
+	int err = -ENOMEM;
 
 	ohci1394_pmac_on(dev);
-        if (pci_enable_device(dev))
-		FAIL(-ENXIO, "Failed to enable OHCI hardware");
+	if (pci_enable_device(dev)) {
+		PRINT_G(KERN_ERR, "Failed to enable OHCI hardware");
+		err = -ENXIO;
+		goto err;
+	}
         pci_set_master(dev);
 
 	host = hpsb_alloc_host(&ohci1394_driver, sizeof(struct ti_ohci), &dev->dev);
-	if (!host) FAIL(-ENOMEM, "Failed to allocate host structure");
-
+	if (!host) {
+		PRINT_G(KERN_ERR, "Failed to allocate host structure");
+		goto err;
+	}
 	ohci = host->hostdata;
 	ohci->dev = dev;
 	ohci->host = host;
@@ -3083,15 +3082,20 @@ static int __devinit ohci1394_pci_probe(
 		      (unsigned long long)pci_resource_len(dev, 0));
 
 	if (!request_mem_region(ohci_base, OHCI1394_REGISTER_SIZE,
-				OHCI1394_DRIVER_NAME))
-		FAIL(-ENOMEM, "MMIO resource (0x%llx - 0x%llx) unavailable",
+				OHCI1394_DRIVER_NAME)) {
+		PRINT_G(KERN_ERR, "MMIO resource (0x%llx - 0x%llx) unavailable",
 			(unsigned long long)ohci_base,
 			(unsigned long long)ohci_base + OHCI1394_REGISTER_SIZE);
+		goto err;
+	}
 	ohci->init_state = OHCI_INIT_HAVE_MEM_REGION;
 
 	ohci->registers = ioremap(ohci_base, OHCI1394_REGISTER_SIZE);
-	if (ohci->registers == NULL)
-		FAIL(-ENXIO, "Failed to remap registers - card not accessible");
+	if (ohci->registers == NULL) {
+		PRINT_G(KERN_ERR, "Failed to remap registers");
+		err = -ENXIO;
+		goto err;
+	}
 	ohci->init_state = OHCI_INIT_HAVE_IOMAPPING;
 	DBGMSG("Remapped memory spaces reg 0x%p", ohci->registers);
 
@@ -3099,16 +3103,20 @@ static int __devinit ohci1394_pci_probe(
 	ohci->csr_config_rom_cpu =
 		pci_alloc_consistent(ohci->dev, OHCI_CONFIG_ROM_LEN,
 				     &ohci->csr_config_rom_bus);
-	if (ohci->csr_config_rom_cpu == NULL)
-		FAIL(-ENOMEM, "Failed to allocate buffer config rom");
+	if (ohci->csr_config_rom_cpu == NULL) {
+		PRINT_G(KERN_ERR, "Failed to allocate buffer config rom");
+		goto err;
+	}
 	ohci->init_state = OHCI_INIT_HAVE_CONFIG_ROM_BUFFER;
 
 	/* self-id dma buffer allocation */
 	ohci->selfid_buf_cpu =
 		pci_alloc_consistent(ohci->dev, OHCI1394_SI_DMA_BUF_SIZE,
                       &ohci->selfid_buf_bus);
-	if (ohci->selfid_buf_cpu == NULL)
-		FAIL(-ENOMEM, "Failed to allocate DMA buffer for self-id packets");
+	if (ohci->selfid_buf_cpu == NULL) {
+		PRINT_G(KERN_ERR, "Failed to allocate self-ID buffer");
+		goto err;
+	}
 	ohci->init_state = OHCI_INIT_HAVE_SELFID_BUFFER;
 
 	if ((unsigned long)ohci->selfid_buf_cpu & 0x1fff)
@@ -3124,28 +3132,32 @@ static int __devinit ohci1394_pci_probe(
 	if (alloc_dma_rcv_ctx(ohci, &ohci->ar_req_context,
 			      DMA_CTX_ASYNC_REQ, 0, AR_REQ_NUM_DESC,
 			      AR_REQ_BUF_SIZE, AR_REQ_SPLIT_BUF_SIZE,
-			      OHCI1394_AsReqRcvContextBase) < 0)
-		FAIL(-ENOMEM, "Failed to allocate AR Req context");
-
+			      OHCI1394_AsReqRcvContextBase) < 0) {
+		PRINT_G(KERN_ERR, "Failed to allocate AR Req context");
+		goto err;
+	}
 	/* AR DMA response context allocation */
 	if (alloc_dma_rcv_ctx(ohci, &ohci->ar_resp_context,
 			      DMA_CTX_ASYNC_RESP, 0, AR_RESP_NUM_DESC,
 			      AR_RESP_BUF_SIZE, AR_RESP_SPLIT_BUF_SIZE,
-			      OHCI1394_AsRspRcvContextBase) < 0)
-		FAIL(-ENOMEM, "Failed to allocate AR Resp context");
-
+			      OHCI1394_AsRspRcvContextBase) < 0) {
+		PRINT_G(KERN_ERR, "Failed to allocate AR Resp context");
+		goto err;
+	}
 	/* AT DMA request context */
 	if (alloc_dma_trm_ctx(ohci, &ohci->at_req_context,
 			      DMA_CTX_ASYNC_REQ, 0, AT_REQ_NUM_DESC,
-			      OHCI1394_AsReqTrContextBase) < 0)
-		FAIL(-ENOMEM, "Failed to allocate AT Req context");
-
+			      OHCI1394_AsReqTrContextBase) < 0) {
+		PRINT_G(KERN_ERR, "Failed to allocate AT Req context");
+		goto err;
+	}
 	/* AT DMA response context */
 	if (alloc_dma_trm_ctx(ohci, &ohci->at_resp_context,
 			      DMA_CTX_ASYNC_RESP, 1, AT_RESP_NUM_DESC,
-			      OHCI1394_AsRspTrContextBase) < 0)
-		FAIL(-ENOMEM, "Failed to allocate AT Resp context");
-
+			      OHCI1394_AsRspTrContextBase) < 0) {
+		PRINT_G(KERN_ERR, "Failed to allocate AT Resp context");
+		goto err;
+	}
 	/* Start off with a soft reset, to clear everything to a sane
 	 * state. */
 	ohci_soft_reset(ohci);
@@ -3188,9 +3200,10 @@ static int __devinit ohci1394_pci_probe(
 	 * by that point.
 	 */
 	if (request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
-			 OHCI1394_DRIVER_NAME, ohci))
-		FAIL(-ENOMEM, "Failed to allocate shared interrupt %d", dev->irq);
-
+			 OHCI1394_DRIVER_NAME, ohci)) {
+		PRINT_G(KERN_ERR, "Failed to allocate interrupt %d", dev->irq);
+		goto err;
+	}
 	ohci->init_state = OHCI_INIT_HAVE_IRQ;
 	ohci_initialize(ohci);
 
@@ -3210,13 +3223,16 @@ static int __devinit ohci1394_pci_probe(
 	host->middle_addr_space = OHCI1394_MIDDLE_ADDRESS_SPACE;
 
 	/* Tell the highlevel this host is ready */
-	if (hpsb_add_host(host))
-		FAIL(-ENOMEM, "Failed to register host with highlevel");
-
+	if (hpsb_add_host(host)) {
+		PRINT_G(KERN_ERR, "Failed to register host with highlevel");
+		goto err;
+	}
 	ohci->init_state = OHCI_INIT_DONE;
 
 	return 0;
-#undef FAIL
+err:
+	ohci1394_pci_remove(dev);
+	return err;
 }
 
 static void ohci1394_pci_remove(struct pci_dev *dev)

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/

