Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbXIXQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbXIXQct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbXIXQ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47453 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760312AbXIXQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:14 -0400
Date: Mon, 24 Sep 2007 09:21:11 -0700
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
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, matthew@wil.cx,
       alex@nibbles.it, dac@conglom-o.org, polynomial-c@gmx.de
Subject: [22/50] Fix DAC960 driver on machines which dont support 64-bit DMA
Message-ID: <20070924162111.GW13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-dac960-driver-on-machines-which-don-t-support-64-bit-dma.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Matthew Wilcox <matthew@wil.cx>

commit 868047fcbb85dbb44ddd98c336fef83236a2c06a in mainline.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=8942

Use PCI_DMA_* constants instead of own private definitions Fall back to
32-bit DMA mask if a 64-bit one fails

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Acked-by: Jeff Garzik <jeff@garzik.org>
Tested-by: Lars <polynomial-c@gmx.de>
Cc: Alessandro Polverini <alex@nibbles.it>
Cc: <dac@conglom-o.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/DAC960.c |   17 ++++++++++-------
 drivers/block/DAC960.h |    7 -------
 2 files changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -17,8 +17,8 @@
 */
 
 
-#define DAC960_DriverVersion			"2.5.48"
-#define DAC960_DriverDate			"14 May 2006"
+#define DAC960_DriverVersion			"2.5.49"
+#define DAC960_DriverDate			"21 Aug 2007"
 
 
 #include <linux/module.h>
@@ -1165,9 +1165,9 @@ static bool DAC960_V1_EnableMemoryMailbo
   int i;
 
   
-  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V1_PciDmaMask))
+  if (pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
 	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DAC690_V1_PciDmaMask;
+  Controller->BounceBufferLimit = DMA_32BIT_MASK;
 
   if ((hw_type == DAC960_PD_Controller) || (hw_type == DAC960_P_Controller)) {
     CommandMailboxesSize =  0;
@@ -1368,9 +1368,12 @@ static bool DAC960_V2_EnableMemoryMailbo
   dma_addr_t	CommandMailboxDMA;
   DAC960_V2_CommandStatus_T CommandStatus;
 
-  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V2_PciDmaMask))
-	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DAC690_V2_PciDmaMask;
+	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_64BIT_MASK))
+		Controller->BounceBufferLimit = DMA_64BIT_MASK;
+	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
+		Controller->BounceBufferLimit = DMA_32BIT_MASK;
+	else
+		return DAC960_Failure(Controller, "DMA mask out of range");
 
   /* This is a temporary dma mapping, used only in the scope of this function */
   CommandMailbox = pci_alloc_consistent(PCI_Device,
--- a/drivers/block/DAC960.h
+++ b/drivers/block/DAC960.h
@@ -61,13 +61,6 @@
 #define DAC960_V2_MaxPhysicalDevices		272
 
 /*
-  Define the pci dma mask supported by DAC960 V1 and V2 Firmware Controlers
- */
-
-#define DAC690_V1_PciDmaMask	0xffffffff
-#define DAC690_V2_PciDmaMask	0xffffffffffffffffULL
-
-/*
   Define a 32/64 bit I/O Address data type.
 */
 

-- 
