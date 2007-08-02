Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXHBSwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXHBSwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbXHBSwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:52:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43022 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbXHBSwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:52:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 2 Aug 2007 20:52:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.cb34c8f8786b3097@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following fixes for the new and old 1394 subsystems:

Stefan Richter (5):
      ieee1394: revert "sbp2: enforce 32bit DMA mapping"
      ieee1394: sbp2: more correct Kconfig dependencies
      firewire: fw-sbp2: set correct maximum payload (fixes CardBus adapters)
      firewire: fw-ohci: dma_free_coherent needs IRQs enabled
      firewire: fw-core: make two variables static


Stat, log, and combined diff:

 drivers/firewire/fw-ohci.c        |   20 +++++++++++++-------
 drivers/firewire/fw-sbp2.c        |    5 ++++-
 drivers/firewire/fw-transaction.c |    4 ++--
 drivers/firewire/fw-transaction.h |    2 +-
 drivers/ieee1394/Kconfig          |    2 +-
 drivers/ieee1394/sbp2.c           |    5 -----
 6 files changed, 21 insertions(+), 17 deletions(-)


commit ae57988f68acdc9fbee649765148f15eb7a1b991
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Aug 2 20:34:17 2007 +0200

    firewire: fw-core: make two variables static
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 4eaff7d63052d781732de9eff4d2287c8e00348f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Jul 25 19:18:08 2007 +0200

    firewire: fw-ohci: dma_free_coherent needs IRQs enabled
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 25659f7183376c6b37661da6141d5eaa21479061
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jul 21 22:43:05 2007 +0200

    firewire: fw-sbp2: set correct maximum payload (fixes CardBus adapters)
    
    As far as I know, all CardBus FireWire 400 adapters have a maximum
    payload of 1024 bytes which is less than the speed-dependent limit of
    2048 bytes.  Fw-sbp2 has to take the host adapter's limit into account.
    
    This apparently fixes Juju's incompatibility with my CardBus cards, a
    NEC based card and a VIA based card.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Acked-by: Kristian Høgsberg <krh@redhat.com>

commit e4f8cac5e07528f7e0bc21d3682c16c9de993ecb
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jul 21 17:51:22 2007 +0200

    ieee1394: sbp2: more correct Kconfig dependencies
    
    Make the option SBP2_PHYS_DMA available on all architectures where it
    compiles.  This includes x86-64 where I runtime-tested it successfully.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit a9c2f18800753c82c45fc13b27bdc148849bdbb2
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Aug 1 20:30:36 2007 +0200

    ieee1394: revert "sbp2: enforce 32bit DMA mapping"
    
    Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
    The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
    http://lkml.org/lkml/2007/8/1/344
    
    Should there ever occur a DMA mapping beyond the physical DMA range, a
    proper SBP-2 firmware will report transport errors.  So let's leave it
    at that.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Tested-by: Olaf Hering <olh@suse.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index db70375..7e427b4 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -907,6 +907,8 @@ static void bus_reset_tasklet(unsigned long data)
 	int self_id_count, i, j, reg;
 	int generation, new_generation;
 	unsigned long flags;
+	void *free_rom = NULL;
+	dma_addr_t free_rom_bus = 0;
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
 	if (!(reg & OHCI1394_NodeID_idValid)) {
@@ -970,8 +972,8 @@ static void bus_reset_tasklet(unsigned long data)
 	 */
 
 	if (ohci->next_config_rom != NULL) {
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  ohci->config_rom, ohci->config_rom_bus);
+		free_rom     = ohci->config_rom;
+		free_rom_bus = ohci->config_rom_bus;
 		ohci->config_rom      = ohci->next_config_rom;
 		ohci->config_rom_bus  = ohci->next_config_rom_bus;
 		ohci->next_config_rom = NULL;
@@ -990,6 +992,10 @@ static void bus_reset_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
+	if (free_rom)
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  free_rom, free_rom_bus);
+
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer);
 }
@@ -1186,7 +1192,7 @@ ohci_set_config_rom(struct fw_card *card, u32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci;
 	unsigned long flags;
-	int retval = 0;
+	int retval = -EBUSY;
 	__be32 *next_config_rom;
 	dma_addr_t next_config_rom_bus;
 
@@ -1240,10 +1246,7 @@ ohci_set_config_rom(struct fw_card *card, u32 *config_rom, size_t length)
 
 		reg_write(ohci, OHCI1394_ConfigROMmap,
 			  ohci->next_config_rom_bus);
-	} else {
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  next_config_rom, next_config_rom_bus);
-		retval = -EBUSY;
+		retval = 0;
 	}
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
@@ -1257,6 +1260,9 @@ ohci_set_config_rom(struct fw_card *card, u32 *config_rom, size_t length)
 	 */
 	if (retval == 0)
 		fw_core_initiate_bus_reset(&ohci->card, 1);
+	else
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  next_config_rom, next_config_rom_bus);
 
 	return retval;
 }
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 3e4a369..ba816ef 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -984,6 +984,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_command_orb *orb;
+	unsigned max_payload;
 
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
@@ -1017,8 +1018,10 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	 * specifies the max payload size as 2 ^ (max_payload + 2), so
 	 * if we set this to max_speed + 7, we get the right value.
 	 */
+	max_payload = min(device->max_speed + 7,
+			  device->card->max_receive - 1);
 	orb->request.misc =
-		COMMAND_ORB_MAX_PAYLOAD(device->max_speed + 7) |
+		COMMAND_ORB_MAX_PAYLOAD(max_payload) |
 		COMMAND_ORB_SPEED(device->max_speed) |
 		COMMAND_ORB_NOTIFY;
 
diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 3ce8e2f..3e1cb12 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -734,7 +734,7 @@ fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 }
 EXPORT_SYMBOL(fw_core_handle_response);
 
-const struct fw_address_region topology_map_region =
+static const struct fw_address_region topology_map_region =
 	{ .start = 0xfffff0001000ull, .end = 0xfffff0001400ull, };
 
 static void
@@ -772,7 +772,7 @@ static struct fw_address_handler topology_map = {
 	.address_callback	= handle_topology_map,
 };
 
-const struct fw_address_region registers_region =
+static const struct fw_address_region registers_region =
 	{ .start = 0xfffff0000000ull, .end = 0xfffff0000400ull, };
 
 static void
diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
index 5ceaccd..fa7967b 100644
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -231,7 +231,7 @@ struct fw_card {
 	unsigned long reset_jiffies;
 
 	unsigned long long guid;
-	int max_receive;
+	unsigned max_receive;
 	int link_speed;
 	int config_rom_generation;
 
diff --git a/drivers/ieee1394/Kconfig b/drivers/ieee1394/Kconfig
index 8012b3b..545663e 100644
--- a/drivers/ieee1394/Kconfig
+++ b/drivers/ieee1394/Kconfig
@@ -97,7 +97,7 @@ config IEEE1394_SBP2
 
 config IEEE1394_SBP2_PHYS_DMA
 	bool "Enable replacement for physical DMA in SBP2"
-	depends on IEEE1394 && IEEE1394_SBP2 && EXPERIMENTAL && (X86_32 || PPC_32)
+	depends on IEEE1394_SBP2 && VIRT_TO_BUS && EXPERIMENTAL
 	help
 	  This builds sbp2 for use with non-OHCI host adapters which do not
 	  support physical DMA or for when ohci1394 is run with phys_dma=0.
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index e882cb9..47dbe8f 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -773,11 +773,6 @@ static struct sbp2_lu *sbp2_alloc_device(struct unit_directory *ud)
 			SBP2_ERR("failed to register lower 4GB address range");
 			goto failed_alloc;
 		}
-#else
-		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
-			SBP2_ERR("failed to set 4GB DMA mask");
-			goto failed_alloc;
-		}
 #endif
 	}
 


-- 
Stefan Richter
-=====-=-=== =--- ---=-
http://arcgraph.de/sr/

