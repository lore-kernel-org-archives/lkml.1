Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXJaSZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXJaSZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXJaSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:25:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45802 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXJaSZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:25:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 31 Oct 2007 19:24:41 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.01de46b79bba064a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following FireWire/ IEEE 1394 subsystem updates.
The bigger portion of this has been in -mm for a long time, held up by
another now fixed bug.

 drivers/firewire/fw-ohci.c               |   37 +++++++++++++++-------
 drivers/ieee1394/ieee1394_transactions.c |    2 -
 2 files changed, 25 insertions(+), 14 deletions(-)

Adrian Bunk (1):
      ieee1394: ieee1394_transactions.c: remove dead code

Kristian Høgsberg (1):
      firewire: Fix pci resume to not pass in a __be32 config rom.


Full log and diff:

commit 2ed45b07c957e37db88d7d3696b63eb79b0ef5ef
Author: Adrian Bunk <bunk@kernel.org>
Date:   Sun Oct 28 16:51:32 2007 +0100

    ieee1394: ieee1394_transactions.c: remove dead code
    
    This patch removes dead code spotted by the Intel C Compiler.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
index c39c70a..6779893 100644
--- a/drivers/ieee1394/ieee1394_transactions.c
+++ b/drivers/ieee1394/ieee1394_transactions.c
@@ -235,7 +235,6 @@ int hpsb_packet_success(struct hpsb_packet *packet)
 				 packet->node_id);
 			return -EAGAIN;
 		}
-		BUG();
 
 	case ACK_BUSY_X:
 	case ACK_BUSY_A:
@@ -282,7 +281,6 @@ int hpsb_packet_success(struct hpsb_packet *packet)
 			 packet->ack_code, packet->node_id, packet->tcode);
 		return -EAGAIN;
 	}
-	BUG();
 }
 
 struct hpsb_packet *hpsb_make_readpacket(struct hpsb_host *host, nodeid_t node,

commit 0bd243c4d93583cd8e1786c0bd6982f6f9f94ab6
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Tue Jun 5 19:27:05 2007 -0400

    firewire: Fix pci resume to not pass in a __be32 config rom.
    
    The ohci_enable() function shared between pci_probe and pci_resume
    takes a host endian config rom, but ohci->config_rom is __be32.  This
    sets up the config rom in the wrong endian on little endian machine,
    specifically, BusOptions will be initialized to a 0 max receive size.
    
    This patch changes the way we reuse the config rom so that we avoid
    this problem.
    
    Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 6758832..c9b9081 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -984,8 +984,10 @@ static void bus_reset_tasklet(unsigned long data)
 	 */
 
 	if (ohci->next_config_rom != NULL) {
-		free_rom     = ohci->config_rom;
-		free_rom_bus = ohci->config_rom_bus;
+		if (ohci->next_config_rom != ohci->config_rom) {
+			free_rom      = ohci->config_rom;
+			free_rom_bus  = ohci->config_rom_bus;
+		}
 		ohci->config_rom      = ohci->next_config_rom;
 		ohci->config_rom_bus  = ohci->next_config_rom_bus;
 		ohci->next_config_rom = NULL;
@@ -1161,19 +1163,30 @@ static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 	 * the right values in the bus reset tasklet.
 	 */
 
-	ohci->next_config_rom =
-		dma_alloc_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				   &ohci->next_config_rom_bus, GFP_KERNEL);
-	if (ohci->next_config_rom == NULL)
-		return -ENOMEM;
+	if (config_rom) {
+		ohci->next_config_rom =
+			dma_alloc_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+					   &ohci->next_config_rom_bus,
+					   GFP_KERNEL);
+		if (ohci->next_config_rom == NULL)
+			return -ENOMEM;
 
-	memset(ohci->next_config_rom, 0, CONFIG_ROM_SIZE);
-	fw_memcpy_to_be32(ohci->next_config_rom, config_rom, length * 4);
+		memset(ohci->next_config_rom, 0, CONFIG_ROM_SIZE);
+		fw_memcpy_to_be32(ohci->next_config_rom, config_rom, length * 4);
+	} else {
+		/*
+		 * In the suspend case, config_rom is NULL, which
+		 * means that we just reuse the old config rom.
+		 */
+		ohci->next_config_rom = ohci->config_rom;
+		ohci->next_config_rom_bus = ohci->config_rom_bus;
+	}
 
-	ohci->next_header = config_rom[0];
+	ohci->next_header = be32_to_cpu(ohci->next_config_rom[0]);
 	ohci->next_config_rom[0] = 0;
 	reg_write(ohci, OHCI1394_ConfigROMhdr, 0);
-	reg_write(ohci, OHCI1394_BusOptions, config_rom[2]);
+	reg_write(ohci, OHCI1394_BusOptions,
+		  be32_to_cpu(ohci->next_config_rom[2]));
 	reg_write(ohci, OHCI1394_ConfigROMmap, ohci->next_config_rom_bus);
 
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
@@ -1984,7 +1997,7 @@ static int pci_resume(struct pci_dev *pdev)
 		return err;
 	}
 
-	return ohci_enable(&ohci->card, ohci->config_rom, CONFIG_ROM_SIZE);
+	return ohci_enable(&ohci->card, NULL, 0);
 }
 #endif
 

-- 
Stefan Richter
-=====-=-=== =-=- =====
http://arcgraph.de/sr/

