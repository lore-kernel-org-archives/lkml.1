Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZA2Ux6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZA2Ux6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZA2Uxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:53:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35295 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZA2Uxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:53:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Jan 2009 21:52:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.bc8887b6ddf84990@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.
This is a bundle of fixes of old problems, especially:

The new driver stack:
  - firewire-core did dangerous and incorrect bus topology comparisons
    if there were more bus reset events than self ID complete events.
  - firewire-core was too quick to report a device as unplugged to upper
    layers.

Both driver stacks:
  - Asynchronous IO with some camcorders was unsuccessful especially in
    newer kernels.  Fixed by configuring the controller for more request
    retries.

Old driver stack:
  - There was an unnecessary limitation to 800 Mb/s in the core driver
    even though the rest of the stack was already fundamentally capable
    to deal with 3200 Mb/s hardware.

...and more, as the shortlog tells.

Stefan Richter (16):
      firewire: insist on successive self ID complete events
      firewire: unnecessary BM delay after generation rollover
      firewire: keep highlevel drivers attached during brief connection loss
      firewire: ohci: change "context_stop: still active" log message
      firewire: ohci: increase AT req. retries, fix ack_busy_X from Panasonic camcorders and others
      ieee1394: ohci1394: increase AT req. retries, fix ack_busy_X from Panasonic camcorders and others
      firewire: core: optimize card shutdown
      ieee1394: support for speeds greater than S800
      ieee1394: sbp2: update a help string
      ieee1394: sbp2: fix payload limit at S1600 and S3200
      ieee1394: sbp2: don't assume zero model_id or firmware_revision if there is none
      firewire: sbp2: fix payload limit at S1600 and S3200
      firewire: sbp2: define some magic numbers as macros
      firewire: sbp2: fix DMA mapping leak on the failure path
      firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
      ieee1394: sbp2: add workarounds for 2nd and 3rd generation iPods

 drivers/firewire/fw-card.c        |    4 +-
 drivers/firewire/fw-device.c      |  123 +++++++++++++++++++++++-----
 drivers/firewire/fw-device.h      |    1 +
 drivers/firewire/fw-ohci.c        |    6 +-
 drivers/firewire/fw-sbp2.c        |   89 ++++++++++++---------
 drivers/firewire/fw-topology.c    |   12 +++
 drivers/firewire/fw-transaction.h |    9 ++
 drivers/ieee1394/ieee1394.h       |    4 +-
 drivers/ieee1394/ieee1394_core.c  |   16 ++--
 drivers/ieee1394/ohci1394.h       |    2 +-
 drivers/ieee1394/sbp2.c           |   54 ++++++++-----
 11 files changed, 221 insertions(+), 99 deletions(-)


diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 6bd91a1..7be2cf3 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -232,7 +232,7 @@ fw_card_bm_work(struct work_struct *work)
 	root_id = root_node->node_id;
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 
-	if (card->bm_generation + 1 == generation ||
+	if (is_next_generation(generation, card->bm_generation) ||
 	    (card->bm_generation != generation && grace)) {
 		/*
 		 * This first step is to figure out who is IRM and
@@ -512,7 +512,7 @@ fw_core_remove_card(struct fw_card *card)
 	fw_core_initiate_bus_reset(card, 1);
 
 	mutex_lock(&card_mutex);
-	list_del(&card->link);
+	list_del_init(&card->link);
 	mutex_unlock(&card_mutex);
 
 	/* Set up the dummy driver. */
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 2af5a8d..bf53acb 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -25,6 +25,7 @@
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
+#include <linux/jiffies.h>
 #include <linux/string.h>
 #include <linux/rwsem.h>
 #include <linux/semaphore.h>
@@ -634,12 +635,39 @@ struct fw_device *fw_device_get_by_devt(dev_t devt)
 	return device;
 }
 
+/*
+ * These defines control the retry behavior for reading the config
+ * rom.  It shouldn't be necessary to tweak these; if the device
+ * doesn't respond to a config rom read within 10 seconds, it's not
+ * going to respond at all.  As for the initial delay, a lot of
+ * devices will be able to respond within half a second after bus
+ * reset.  On the other hand, it's not really worth being more
+ * aggressive than that, since it scales pretty well; if 10 devices
+ * are plugged in, they're all getting read within one second.
+ */
+
+#define MAX_RETRIES	10
+#define RETRY_DELAY	(3 * HZ)
+#define INITIAL_DELAY	(HZ / 2)
+#define SHUTDOWN_DELAY	(2 * HZ)
+
 static void fw_device_shutdown(struct work_struct *work)
 {
 	struct fw_device *device =
 		container_of(work, struct fw_device, work.work);
 	int minor = MINOR(device->device.devt);
 
+	if (time_is_after_jiffies(device->card->reset_jiffies + SHUTDOWN_DELAY)
+	    && !list_empty(&device->card->link)) {
+		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
+		return;
+	}
+
+	if (atomic_cmpxchg(&device->state,
+			   FW_DEVICE_GONE,
+			   FW_DEVICE_SHUTDOWN) != FW_DEVICE_GONE)
+		return;
+
 	fw_device_cdev_remove(device);
 	device_for_each_child(&device->device, NULL, shutdown_unit);
 	device_unregister(&device->device);
@@ -647,6 +675,7 @@ static void fw_device_shutdown(struct work_struct *work)
 	down_write(&fw_device_rwsem);
 	idr_remove(&fw_device_idr, minor);
 	up_write(&fw_device_rwsem);
+
 	fw_device_put(device);
 }
 
@@ -654,25 +683,63 @@ static struct device_type fw_device_type = {
 	.release	= fw_device_release,
 };
 
+static void fw_device_update(struct work_struct *work);
+
 /*
- * These defines control the retry behavior for reading the config
- * rom.  It shouldn't be necessary to tweak these; if the device
- * doesn't respond to a config rom read within 10 seconds, it's not
- * going to respond at all.  As for the initial delay, a lot of
- * devices will be able to respond within half a second after bus
- * reset.  On the other hand, it's not really worth being more
- * aggressive than that, since it scales pretty well; if 10 devices
- * are plugged in, they're all getting read within one second.
+ * If a device was pending for deletion because its node went away but its
+ * bus info block and root directory header matches that of a newly discovered
+ * device, revive the existing fw_device.
+ * The newly allocated fw_device becomes obsolete instead.
  */
+static int lookup_existing_device(struct device *dev, void *data)
+{
+	struct fw_device *old = fw_device(dev);
+	struct fw_device *new = data;
+	struct fw_card *card = new->card;
+	int match = 0;
+
+	down_read(&fw_device_rwsem); /* serialize config_rom access */
+	spin_lock_irq(&card->lock);  /* serialize node access */
+
+	if (memcmp(old->config_rom, new->config_rom, 6 * 4) == 0 &&
+	    atomic_cmpxchg(&old->state,
+			   FW_DEVICE_GONE,
+			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
+		struct fw_node *current_node = new->node;
+		struct fw_node *obsolete_node = old->node;
+
+		new->node = obsolete_node;
+		new->node->data = new;
+		old->node = current_node;
+		old->node->data = old;
+
+		old->max_speed = new->max_speed;
+		old->node_id = current_node->node_id;
+		smp_wmb();  /* update node_id before generation */
+		old->generation = card->generation;
+		old->config_rom_retries = 0;
+		fw_notify("rediscovered device %s\n", dev_name(dev));
 
-#define MAX_RETRIES	10
-#define RETRY_DELAY	(3 * HZ)
-#define INITIAL_DELAY	(HZ / 2)
+		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
+		schedule_delayed_work(&old->work, 0);
+
+		if (current_node == card->root_node)
+			fw_schedule_bm_work(card, 0);
+
+		match = 1;
+	}
+
+	spin_unlock_irq(&card->lock);
+	up_read(&fw_device_rwsem);
+
+	return match;
+}
 
 static void fw_device_init(struct work_struct *work)
 {
 	struct fw_device *device =
 		container_of(work, struct fw_device, work.work);
+	struct device *revived_dev;
 	int minor, err;
 
 	/*
@@ -696,6 +763,15 @@ static void fw_device_init(struct work_struct *work)
 		return;
 	}
 
+	revived_dev = device_find_child(device->card->device,
+					device, lookup_existing_device);
+	if (revived_dev) {
+		put_device(revived_dev);
+		fw_device_release(&device->device);
+
+		return;
+	}
+
 	device_initialize(&device->device);
 
 	fw_device_get(device);
@@ -734,9 +810,10 @@ static void fw_device_init(struct work_struct *work)
 	 * fw_node_event().
 	 */
 	if (atomic_cmpxchg(&device->state,
-		    FW_DEVICE_INITIALIZING,
-		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN) {
-		fw_device_shutdown(work);
+			   FW_DEVICE_INITIALIZING,
+			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
+		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+		schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
 	} else {
 		if (device->config_rom_retries)
 			fw_notify("created device %s: GUID %08x%08x, S%d00, "
@@ -847,8 +924,8 @@ static void fw_device_refresh(struct work_struct *work)
 
 	case REREAD_BIB_UNCHANGED:
 		if (atomic_cmpxchg(&device->state,
-			    FW_DEVICE_INITIALIZING,
-			    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+				   FW_DEVICE_INITIALIZING,
+				   FW_DEVICE_RUNNING) == FW_DEVICE_GONE)
 			goto gone;
 
 		fw_device_update(work);
@@ -879,8 +956,8 @@ static void fw_device_refresh(struct work_struct *work)
 	create_units(device);
 
 	if (atomic_cmpxchg(&device->state,
-		    FW_DEVICE_INITIALIZING,
-		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+			   FW_DEVICE_INITIALIZING,
+			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE)
 		goto gone;
 
 	fw_notify("refreshed device %s\n", dev_name(&device->device));
@@ -890,8 +967,9 @@ static void fw_device_refresh(struct work_struct *work)
  give_up:
 	fw_notify("giving up on refresh of device %s\n", dev_name(&device->device));
  gone:
-	atomic_set(&device->state, FW_DEVICE_SHUTDOWN);
-	fw_device_shutdown(work);
+	atomic_set(&device->state, FW_DEVICE_GONE);
+	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+	schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
  out:
 	if (node_id == card->root_node->node_id)
 		fw_schedule_bm_work(card, 0);
@@ -995,9 +1073,10 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		 */
 		device = node->data;
 		if (atomic_xchg(&device->state,
-				FW_DEVICE_SHUTDOWN) == FW_DEVICE_RUNNING) {
+				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-			schedule_delayed_work(&device->work, 0);
+			schedule_delayed_work(&device->work,
+				list_empty(&card->link) ? 0 : SHUTDOWN_DELAY);
 		}
 		break;
 	}
diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
index df51732..8ef6ec2 100644
--- a/drivers/firewire/fw-device.h
+++ b/drivers/firewire/fw-device.h
@@ -28,6 +28,7 @@
 enum fw_device_state {
 	FW_DEVICE_INITIALIZING,
 	FW_DEVICE_RUNNING,
+	FW_DEVICE_GONE,
 	FW_DEVICE_SHUTDOWN,
 };
 
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index ab9c01e..6d19828 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -226,7 +226,7 @@ static inline struct fw_ohci *fw_ohci(struct fw_card *card)
 #define CONTEXT_DEAD	0x0800
 #define CONTEXT_ACTIVE	0x0400
 
-#define OHCI1394_MAX_AT_REQ_RETRIES	0x2
+#define OHCI1394_MAX_AT_REQ_RETRIES	0xf
 #define OHCI1394_MAX_AT_RESP_RETRIES	0x2
 #define OHCI1394_MAX_PHYS_RESP_RETRIES	0x8
 
@@ -896,11 +896,11 @@ static void context_stop(struct context *ctx)
 	for (i = 0; i < 10; i++) {
 		reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
 		if ((reg & CONTEXT_ACTIVE) == 0)
-			break;
+			return;
 
-		fw_notify("context_stop: still active (0x%08x)\n", reg);
 		mdelay(1);
 	}
+	fw_error("Error: DMA context still active (0x%08x)\n", reg);
 }
 
 struct driver_data {
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index e88d506..c71c441 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -168,6 +168,7 @@ struct sbp2_target {
 	int address_high;
 	unsigned int workarounds;
 	unsigned int mgt_orb_timeout;
+	unsigned int max_payload;
 
 	int dont_block;	/* counter for each logical unit */
 	int blocked;	/* ditto */
@@ -310,14 +311,16 @@ struct sbp2_command_orb {
 	dma_addr_t page_table_bus;
 };
 
+#define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
+#define SBP2_ROM_VALUE_MISSING  0xff000000 /* not present in the unit dir. */
+
 /*
  * List of devices with known bugs.
  *
  * The firmware_revision field, masked with 0xffff00, is the best
  * indicator for the type of bridge chip of a device.  It yields a few
  * false positives but this did not break correctly behaving devices
- * so far.  We use ~0 as a wildcard, since the 24 bit values we get
- * from the config rom can never match that.
+ * so far.
  */
 static const struct {
 	u32 firmware_revision;
@@ -339,33 +342,35 @@ static const struct {
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36,
 	},
 	/* PL-3507 bridge with Prolific firmware */ {
 		.firmware_revision	= 0x012800,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Symbios bridge */ {
 		.firmware_revision	= 0xa0b800,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
 	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
 		.firmware_revision	= 0x002600,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
-
 	/*
-	 * There are iPods (2nd gen, 3rd gen) with model_id == 0, but
-	 * these iPods do not feature the read_capacity bug according
-	 * to one report.  Read_capacity behaviour as well as model_id
-	 * could change due to Apple-supplied firmware updates though.
+	 * iPod 2nd generation: needs 128k max transfer size workaround
+	 * iPod 3rd generation: needs fix capacity workaround
 	 */
-
-	/* iPod 4th generation. */ {
+	{
+		.firmware_revision	= 0x0a2700,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
+	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model			= 0x000021,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
@@ -1092,7 +1097,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 			continue;
 
 		if (sbp2_workarounds_table[i].model != model &&
-		    sbp2_workarounds_table[i].model != ~0)
+		    sbp2_workarounds_table[i].model != SBP2_ROM_VALUE_WILDCARD)
 			continue;
 
 		w |= sbp2_workarounds_table[i].workarounds;
@@ -1142,20 +1147,28 @@ static int sbp2_probe(struct device *dev)
 	fw_device_get(device);
 	fw_unit_get(unit);
 
-	/* Initialize to values that won't match anything in our table. */
-	firmware_revision = 0xff000000;
-	model = 0xff000000;
-
 	/* implicit directory ID */
 	tgt->directory_id = ((unit->directory - device->config_rom) * 4
 			     + CSR_CONFIG_ROM) & 0xffffff;
 
+	firmware_revision = SBP2_ROM_VALUE_MISSING;
+	model		  = SBP2_ROM_VALUE_MISSING;
+
 	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
 			       &firmware_revision) < 0)
 		goto fail_tgt_put;
 
 	sbp2_init_workarounds(tgt, model, firmware_revision);
 
+	/*
+	 * At S100 we can do 512 bytes per packet, at S200 1024 bytes,
+	 * and so on up to 4096 bytes.  The SBP-2 max_payload field
+	 * specifies the max payload size as 2 ^ (max_payload + 2), so
+	 * if we set this to max_speed + 7, we get the right value.
+	 */
+	tgt->max_payload = min(device->max_speed + 7, 10U);
+	tgt->max_payload = min(tgt->max_payload, device->card->max_receive - 1);
+
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
@@ -1273,6 +1286,19 @@ static struct fw_driver sbp2_driver = {
 	.id_table = sbp2_id_table,
 };
 
+static void sbp2_unmap_scatterlist(struct device *card_device,
+				   struct sbp2_command_orb *orb)
+{
+	if (scsi_sg_count(orb->cmd))
+		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
+			     scsi_sg_count(orb->cmd),
+			     orb->cmd->sc_data_direction);
+
+	if (orb->request.misc & cpu_to_be32(COMMAND_ORB_PAGE_TABLE_PRESENT))
+		dma_unmap_single(card_device, orb->page_table_bus,
+				 sizeof(orb->page_table), DMA_TO_DEVICE);
+}
+
 static unsigned int
 sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
 {
@@ -1352,15 +1378,7 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,
 			 sizeof(orb->request), DMA_TO_DEVICE);
-
-	if (scsi_sg_count(orb->cmd) > 0)
-		dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
-			     scsi_sg_count(orb->cmd),
-			     orb->cmd->sc_data_direction);
-
-	if (orb->page_table_bus != 0)
-		dma_unmap_single(device->card->device, orb->page_table_bus,
-				 sizeof(orb->page_table), DMA_TO_DEVICE);
+	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
 	orb->done(orb->cmd);
@@ -1434,7 +1452,6 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
-	unsigned int max_payload;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
 	/*
@@ -1462,17 +1479,9 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	orb->done = done;
 	orb->cmd  = cmd;
 
-	orb->request.next.high   = cpu_to_be32(SBP2_ORB_NULL);
-	/*
-	 * At speed 100 we can do 512 bytes per packet, at speed 200,
-	 * 1024 bytes per packet etc.  The SBP-2 max_payload field
-	 * specifies the max payload size as 2 ^ (max_payload + 2), so
-	 * if we set this to max_speed + 7, we get the right value.
-	 */
-	max_payload = min(device->max_speed + 7,
-			  device->card->max_receive - 1);
+	orb->request.next.high = cpu_to_be32(SBP2_ORB_NULL);
 	orb->request.misc = cpu_to_be32(
-		COMMAND_ORB_MAX_PAYLOAD(max_payload) |
+		COMMAND_ORB_MAX_PAYLOAD(lu->tgt->max_payload) |
 		COMMAND_ORB_SPEED(device->max_speed) |
 		COMMAND_ORB_NOTIFY);
 
@@ -1491,8 +1500,10 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(device->card->device, orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus)) {
+		sbp2_unmap_scatterlist(device->card->device, orb);
 		goto out;
+	}
 
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
 		      lu->command_block_agent_address + SBP2_ORB_POINTER);
diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index c9be6e6..8dd6703 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -518,6 +518,18 @@ fw_core_handle_bus_reset(struct fw_card *card,
 	struct fw_node *local_node;
 	unsigned long flags;
 
+	/*
+	 * If the selfID buffer is not the immediate successor of the
+	 * previously processed one, we cannot reliably compare the
+	 * old and new topologies.
+	 */
+	if (!is_next_generation(generation, card->generation) &&
+	    card->local_node != NULL) {
+		fw_notify("skipped bus generations, destroying all nodes\n");
+		fw_destroy_nodes(card);
+		card->bm_retries = 0;
+	}
+
 	spin_lock_irqsave(&card->lock, flags);
 
 	card->node_id = node_id;
diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
index c9ab12a..1d78e9c 100644
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -276,6 +276,15 @@ static inline void fw_card_put(struct fw_card *card)
 extern void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
 /*
+ * Check whether new_generation is the immediate successor of old_generation.
+ * Take counter roll-over at 255 (as per to OHCI) into account.
+ */
+static inline bool is_next_generation(int new_generation, int old_generation)
+{
+	return (new_generation & 0xff) == ((old_generation + 1) & 0xff);
+}
+
+/*
  * The iso packet format allows for an immediate header/payload part
  * stored in 'header' immediately after the packet info plus an
  * indirect payload part that is pointer to by the 'payload' field.
diff --git a/drivers/ieee1394/ieee1394.h b/drivers/ieee1394/ieee1394.h
index e0ae0d3..af320e2 100644
--- a/drivers/ieee1394/ieee1394.h
+++ b/drivers/ieee1394/ieee1394.h
@@ -54,9 +54,7 @@
 #define IEEE1394_SPEED_800	0x03
 #define IEEE1394_SPEED_1600	0x04
 #define IEEE1394_SPEED_3200	0x05
-
-/* The current highest tested speed supported by the subsystem */
-#define IEEE1394_SPEED_MAX	IEEE1394_SPEED_800
+#define IEEE1394_SPEED_MAX	IEEE1394_SPEED_3200
 
 /* Maps speed values above to a string representation */
 extern const char *hpsb_speedto_str[];
diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index dcdb71a..2beb8d9 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -338,6 +338,7 @@ static void build_speed_map(struct hpsb_host *host, int nodecount)
 	u8 cldcnt[nodecount];
 	u8 *map = host->speed_map;
 	u8 *speedcap = host->speed;
+	u8 local_link_speed = host->csr.lnk_spd;
 	struct selfid *sid;
 	struct ext_selfid *esid;
 	int i, j, n;
@@ -373,8 +374,8 @@ static void build_speed_map(struct hpsb_host *host, int nodecount)
 			if (sid->port2 == SELFID_PORT_CHILD) cldcnt[n]++;
 
 			speedcap[n] = sid->speed;
-			if (speedcap[n] > host->csr.lnk_spd)
-				speedcap[n] = host->csr.lnk_spd;
+			if (speedcap[n] > local_link_speed)
+				speedcap[n] = local_link_speed;
 			n--;
 		}
 	}
@@ -407,12 +408,11 @@ static void build_speed_map(struct hpsb_host *host, int nodecount)
 		}
 	}
 
-#if SELFID_SPEED_UNKNOWN != IEEE1394_SPEED_MAX
-	/* assume maximum speed for 1394b PHYs, nodemgr will correct it */
-	for (n = 0; n < nodecount; n++)
-		if (speedcap[n] == SELFID_SPEED_UNKNOWN)
-			speedcap[n] = IEEE1394_SPEED_MAX;
-#endif
+	/* assume a maximum speed for 1394b PHYs, nodemgr will correct it */
+	if (local_link_speed > SELFID_SPEED_UNKNOWN)
+		for (i = 0; i < nodecount; i++)
+			if (speedcap[i] == SELFID_SPEED_UNKNOWN)
+				speedcap[i] = local_link_speed;
 }
 
 
diff --git a/drivers/ieee1394/ohci1394.h b/drivers/ieee1394/ohci1394.h
index 4320bf0..7fb8ab9 100644
--- a/drivers/ieee1394/ohci1394.h
+++ b/drivers/ieee1394/ohci1394.h
@@ -26,7 +26,7 @@
 
 #define OHCI1394_DRIVER_NAME      "ohci1394"
 
-#define OHCI1394_MAX_AT_REQ_RETRIES	0x2
+#define OHCI1394_MAX_AT_REQ_RETRIES	0xf
 #define OHCI1394_MAX_AT_RESP_RETRIES	0x2
 #define OHCI1394_MAX_PHYS_RESP_RETRIES	0x8
 #define OHCI1394_MAX_SELF_ID_ERRORS	16
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index ab1034c..f3fd865 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -115,8 +115,8 @@
  */
 static int sbp2_max_speed = IEEE1394_SPEED_MAX;
 module_param_named(max_speed, sbp2_max_speed, int, 0644);
-MODULE_PARM_DESC(max_speed, "Force max speed "
-		 "(3 = 800Mb/s, 2 = 400Mb/s, 1 = 200Mb/s, 0 = 100Mb/s)");
+MODULE_PARM_DESC(max_speed, "Limit data transfer speed (5 <= 3200, "
+		 "4 <= 1600, 3 <= 800, 2 <= 400, 1 <= 200, 0 = 100 Mb/s)");
 
 /*
  * Set serialize_io to 0 or N to use dynamically appended lists of command ORBs.
@@ -256,7 +256,7 @@ static int sbp2_set_busy_timeout(struct sbp2_lu *);
 static int sbp2_max_speed_and_size(struct sbp2_lu *);
 
 
-static const u8 sbp2_speedto_max_payload[] = { 0x7, 0x8, 0x9, 0xA, 0xB, 0xC };
+static const u8 sbp2_speedto_max_payload[] = { 0x7, 0x8, 0x9, 0xa, 0xa, 0xa };
 
 static DEFINE_RWLOCK(sbp2_hi_logical_units_lock);
 
@@ -347,8 +347,8 @@ static struct scsi_host_template sbp2_shost_template = {
 	.sdev_attrs		 = sbp2_sysfs_sdev_attrs,
 };
 
-/* for match-all entries in sbp2_workarounds_table */
-#define SBP2_ROM_VALUE_WILDCARD 0x1000000
+#define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
+#define SBP2_ROM_VALUE_MISSING  0xff000000 /* not present in the unit dir. */
 
 /*
  * List of devices with known bugs.
@@ -359,60 +359,70 @@ static struct scsi_host_template sbp2_shost_template = {
  */
 static const struct {
 	u32 firmware_revision;
-	u32 model_id;
+	u32 model;
 	unsigned workarounds;
 } sbp2_workarounds_table[] = {
 	/* DViCO Momobay CX-1 with TSB42AA9 bridge */ {
 		.firmware_revision	= 0x002800,
-		.model_id		= 0x001010,
+		.model			= 0x001010,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
 					  SBP2_WORKAROUND_MODE_SENSE_8 |
 					  SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
 		.firmware_revision	= 0x002800,
-		.model_id		= 0x000000,
+		.model			= 0x000000,
 		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY |
 					  SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36,
 	},
 	/* PL-3507 bridge with Prolific firmware */ {
 		.firmware_revision	= 0x012800,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Symbios bridge */ {
 		.firmware_revision	= 0xa0b800,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
 	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
 		.firmware_revision	= 0x002600,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/*
+	 * iPod 2nd generation: needs 128k max transfer size workaround
+	 * iPod 3rd generation: needs fix capacity workaround
+	 */
+	{
+		.firmware_revision	= 0x0a2700,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS |
+					  SBP2_WORKAROUND_FIX_CAPACITY,
+	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x000021,
+		.model			= 0x000021,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x000022,
+		.model			= 0x000022,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x000023,
+		.model			= 0x000023,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod Photo */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x00007e,
+		.model			= 0x00007e,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	}
 };
@@ -1341,13 +1351,15 @@ static void sbp2_parse_unit_directory(struct sbp2_lu *lu,
 	struct csr1212_keyval *kv;
 	struct csr1212_dentry *dentry;
 	u64 management_agent_addr;
-	u32 unit_characteristics, firmware_revision;
+	u32 unit_characteristics, firmware_revision, model;
 	unsigned workarounds;
 	int i;
 
 	management_agent_addr = 0;
 	unit_characteristics = 0;
-	firmware_revision = 0;
+	firmware_revision = SBP2_ROM_VALUE_MISSING;
+	model = ud->flags & UNIT_DIRECTORY_MODEL_ID ?
+				ud->model_id : SBP2_ROM_VALUE_MISSING;
 
 	csr1212_for_each_dir_entry(ud->ne->csr, kv, ud->ud_kv, dentry) {
 		switch (kv->key.id) {
@@ -1388,9 +1400,9 @@ static void sbp2_parse_unit_directory(struct sbp2_lu *lu,
 			    sbp2_workarounds_table[i].firmware_revision !=
 			    (firmware_revision & 0xffff00))
 				continue;
-			if (sbp2_workarounds_table[i].model_id !=
+			if (sbp2_workarounds_table[i].model !=
 			    SBP2_ROM_VALUE_WILDCARD &&
-			    sbp2_workarounds_table[i].model_id != ud->model_id)
+			    sbp2_workarounds_table[i].model != model)
 				continue;
 			workarounds |= sbp2_workarounds_table[i].workarounds;
 			break;
@@ -1403,7 +1415,7 @@ static void sbp2_parse_unit_directory(struct sbp2_lu *lu,
 			  NODE_BUS_ARGS(ud->ne->host, ud->ne->nodeid),
 			  workarounds, firmware_revision,
 			  ud->vendor_id ? ud->vendor_id : ud->ne->vendor_id,
-			  ud->model_id);
+			  model);
 
 	/* We would need one SCSI host template for each target to adjust
 	 * max_sectors on the fly, therefore warn only. */


Thanks,
-- 
Stefan Richter
-=====-==--= ---= ===-=
http://arcgraph.de/sr/

