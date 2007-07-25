Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbXGYRTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbXGYRTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763334AbXGYRS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:18:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56672 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762203AbXGYRS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:18:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 25 Jul 2007 19:18:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: dma_free_coherent needs IRQs enabled
To: linux1394-devel@lists.sourceforge.net
cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, David Miller <davem@davemloft.net>
In-Reply-To: <46A729FC.50407@s5r6.in-berlin.de>
Message-ID: <tkrat.200213f9c462cc8e@s5r6.in-berlin.de>
References: <200707241429.05615.david-b@pacbell.net>
 <46A729FC.50407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -907,6 +907,8 @@ static void bus_reset_tasklet(unsigned l
 	int self_id_count, i, j, reg;
 	int generation, new_generation;
 	unsigned long flags;
+	void *free_rom = NULL;
+	dma_addr_t free_rom_bus = 0;
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
 	if (!(reg & OHCI1394_NodeID_idValid)) {
@@ -970,10 +972,10 @@ static void bus_reset_tasklet(unsigned l
 	 */
 
 	if (ohci->next_config_rom != NULL) {
-		if (ohci->next_config_rom != ohci->config_rom)
-			dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-					  ohci->config_rom,
-					  ohci->config_rom_bus);
+		if (ohci->next_config_rom != ohci->config_rom) {
+			free_rom      = ohci->config_rom;
+			free_rom_bus  = ohci->config_rom_bus;
+		}
 		ohci->config_rom      = ohci->next_config_rom;
 		ohci->config_rom_bus  = ohci->next_config_rom_bus;
 		ohci->next_config_rom = NULL;
@@ -992,6 +994,10 @@ static void bus_reset_tasklet(unsigned l
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
+	if (free_rom)
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  free_rom, free_rom_bus);
+
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer);
 }
@@ -1199,7 +1205,7 @@ ohci_set_config_rom(struct fw_card *card
 {
 	struct fw_ohci *ohci;
 	unsigned long flags;
-	int retval = 0;
+	int retval = -EBUSY;
 	__be32 *next_config_rom;
 	dma_addr_t next_config_rom_bus;
 
@@ -1253,10 +1259,7 @@ ohci_set_config_rom(struct fw_card *card
 
 		reg_write(ohci, OHCI1394_ConfigROMmap,
 			  ohci->next_config_rom_bus);
-	} else {
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  next_config_rom, next_config_rom_bus);
-		retval = -EBUSY;
+		retval = 0;
 	}
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
@@ -1270,6 +1273,9 @@ ohci_set_config_rom(struct fw_card *card
 	 */
 	if (retval == 0)
 		fw_core_initiate_bus_reset(&ohci->card, 1);
+	else
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  next_config_rom, next_config_rom_bus);
 
 	return retval;
 }

-- 
Stefan Richter
-=====-=-=== -=== ==--=
http://arcgraph.de/sr/

