Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYA3W4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYA3W4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYA3W4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:56:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58283 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYA3W42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:56:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 30 Jan 2008 23:55:24 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] FireWire updates post 2.6.24
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
Message-ID: <tkrat.22c9d09dcd8e690e@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches recently added to linux1394-2.6.git/for-linus:

Jarod Wilson (3):
      firewire: replace subtraction with bitwise and
      firewire: fw-sbp2: increase login orb reply timeout, fix "failed to login"
      firewire: fw-sbp2: Use sbp2 device-provided mgt orb timeout for logins

Stefan Richter (6):
      firewire: fw-sbp2: skip unnecessary logout
      firewire: fw-sbp2: try to increase reconnect_hold (speed up reconnection)
      firewire: fw-sbp2: use device generation, not card generation
      firewire: fw-cdev: use device generation, not card generation
      firewire: enforce access order between generation and node ID, fix "giving up on config rom"
      firewire: fw-core: react on bus resets while the config ROM is being fetched

 drivers/firewire/fw-cdev.c        |    3 +-
 drivers/firewire/fw-device.c      |   38 +++++++++++++----
 drivers/firewire/fw-device.h      |   12 +++++
 drivers/firewire/fw-sbp2.c        |   63 +++++++++++++++++++++++------
 drivers/firewire/fw-topology.c    |    6 +++
 drivers/firewire/fw-transaction.c |    2 +-
 6 files changed, 100 insertions(+), 24 deletions(-)



commit 384170da9384b7bb3650c0c9b9d17ba0f7bde4ff
Author: Jarod Wilson <jwilson@redhat.com>
Date:   Fri Jan 25 23:31:12 2008 -0500

    firewire: fw-sbp2: Use sbp2 device-provided mgt orb timeout for logins
    
    To be more compliant with section 7.4.8 of the SBP-2 specification,
    use the mgt_ORB_timeout specified in the SBP-2 device's config rom
    for login ORB attempts (though with some sanity checks). A happy
    side-effect is that certain device and controller combinations that
    sometimes take more than 20 seconds to get synced up (like my laptop
    with just about any SBP-2 device) now function more reliably.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (silenced sparse)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 794bade..19ece9b 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -149,15 +149,17 @@ struct sbp2_target {
 
 	unsigned workarounds;
 	struct list_head lu_list;
+
+	unsigned int mgt_orb_timeout;
 };
 
 /*
  * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
- * provided in the config rom.  A high timeout value really only matters
- * on initial login, where we'll just use 20s rather than hassling with
- * reading the config rom, since it really wouldn't buy us much.
+ * provided in the config rom. Most devices do provide a value, which
+ * we'll use for login management orbs, but with some sane limits.
  */
-#define SBP2_LOGIN_ORB_TIMEOUT		20000	/* Timeout in ms */
+#define SBP2_MIN_LOGIN_ORB_TIMEOUT	5000U	/* Timeout in ms */
+#define SBP2_MAX_LOGIN_ORB_TIMEOUT	40000U	/* Timeout in ms */
 #define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
@@ -166,6 +168,7 @@ struct sbp2_target {
 #define SBP2_DIRECTION_FROM_MEDIA	0x1
 
 /* Unit directory keys */
+#define SBP2_CSR_UNIT_CHARACTERISTICS	0x3a
 #define SBP2_CSR_FIRMWARE_REVISION	0x3c
 #define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
 #define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
@@ -527,7 +530,7 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 		orb->request.misc |=
 			MANAGEMENT_ORB_RECONNECT(2) |
 			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login);
-		timeout = SBP2_LOGIN_ORB_TIMEOUT;
+		timeout = lu->tgt->mgt_orb_timeout;
 	} else {
 		timeout = SBP2_ORB_TIMEOUT;
 	}
@@ -777,6 +780,7 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 {
 	struct fw_csr_iterator ci;
 	int key, value;
+	unsigned int timeout;
 
 	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
@@ -799,6 +803,21 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 			*firmware_revision = value;
 			break;
 
+		case SBP2_CSR_UNIT_CHARACTERISTICS:
+			/* the timeout value is stored in 500ms units */
+			timeout = ((unsigned int) value >> 8 & 0xff) * 500;
+			timeout = max(timeout, SBP2_MIN_LOGIN_ORB_TIMEOUT);
+			tgt->mgt_orb_timeout =
+				  min(timeout, SBP2_MAX_LOGIN_ORB_TIMEOUT);
+
+			if (timeout > tgt->mgt_orb_timeout)
+				fw_notify("%s: config rom contains %ds "
+					  "management ORB timeout, limiting "
+					  "to %ds\n", tgt->unit->device.bus_id,
+					  timeout / 1000,
+					  tgt->mgt_orb_timeout / 1000);
+			break;
+
 		case SBP2_CSR_LOGICAL_UNIT_NUMBER:
 			if (sbp2_add_logical_unit(tgt, value) < 0)
 				return -ENOMEM;



commit a4c379c1979fbc417099cd22ba16735bc3625bbf
Author: Jarod Wilson <jwilson@redhat.com>
Date:   Sat Jan 19 13:15:05 2008 +0100

    firewire: fw-sbp2: increase login orb reply timeout, fix "failed to login"
    
    Increase (and rename) the login orb reply timeout value to 20s
    to match that of the old firewire stack. 2s simply didn't give
    many devices enough time to spin up and reply.
    
    Fixes inability to recognize some devices.
    Failure mode was "orb reply timed out"/"failed to login".
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (style, comments, changelog)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 705a20c..794bade 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -151,9 +151,16 @@ struct sbp2_target {
 	struct list_head lu_list;
 };
 
-#define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
+/*
+ * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
+ * provided in the config rom.  A high timeout value really only matters
+ * on initial login, where we'll just use 20s rather than hassling with
+ * reading the config rom, since it really wouldn't buy us much.
+ */
+#define SBP2_LOGIN_ORB_TIMEOUT		20000	/* Timeout in ms */
 #define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
+#define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 
 #define SBP2_DIRECTION_TO_MEDIA		0x0
 #define SBP2_DIRECTION_FROM_MEDIA	0x1
@@ -488,6 +495,7 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 {
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_management_orb *orb;
+	unsigned int timeout;
 	int retval = -ENOMEM;
 
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
@@ -519,6 +527,9 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 		orb->request.misc |=
 			MANAGEMENT_ORB_RECONNECT(2) |
 			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login);
+		timeout = SBP2_LOGIN_ORB_TIMEOUT;
+	} else {
+		timeout = SBP2_ORB_TIMEOUT;
 	}
 
 	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));
@@ -535,8 +546,7 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	sbp2_send_orb(&orb->base, lu, node_id, generation,
 		      lu->tgt->management_agent_address);
 
-	wait_for_completion_timeout(&orb->done,
-				    msecs_to_jiffies(SBP2_ORB_TIMEOUT));
+	wait_for_completion_timeout(&orb->done, msecs_to_jiffies(timeout));
 
 	retval = -EIO;
 	if (sbp2_cancel_orbs(lu) == 0) {



commit 8f9f963e5d9853dbc5fa5091f15ae64f423d3d89
Author: Jarod Wilson <jwilson@redhat.com>
Date:   Wed Jan 23 16:05:45 2008 -0500

    firewire: replace subtraction with bitwise and
    
    Replace an unnecessary subtraction with a bitwise AND when determining the
    value of ext_tcode in fw_fill_transaction() to save a cpu cycle or two in a
    somewhat critical path.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 8018c3b..7fcc59d 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -153,7 +153,7 @@ fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
 	int ext_tcode;
 
 	if (tcode > 0x10) {
-		ext_tcode = tcode - 0x10;
+		ext_tcode = tcode & ~0x10;
 		tcode = TCODE_LOCK_REQUEST;
 	} else
 		ext_tcode = 0;



commit f8d2dc39389d6ccc0def290dc4b7eb71d68645a2
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Jan 25 17:53:49 2008 +0100

    firewire: fw-core: react on bus resets while the config ROM is being fetched
    
    read_rom() obtained a fresh new fw_device.generation for each read
    transaction.  Hence it was able to continue reading in the middle of the
    ROM even if a bus reset happened.  However the device may have modified
    the ROM during the reset.  We would end up with a corrupt fetched ROM
    image then.
    
    Although all of this is quite unlikely, it is not impossible.
    Therefore we now restart reading the ROM if the bus generation changed.
    
    Note, the memory barrier in read_rom() is still necessary according to
    tests by Jarod Wilson, despite of the ->generation access being moved up
    in the call chain.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    
    This is essentially what I've been beating on locally, and I've yet to hit
    another config rom read failure with it.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 872df22..de9066e 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -390,12 +390,12 @@ complete_transaction(struct fw_card *card, int rcode,
 	complete(&callback_data->done);
 }
 
-static int read_rom(struct fw_device *device, int index, u32 * data)
+static int
+read_rom(struct fw_device *device, int generation, int index, u32 *data)
 {
 	struct read_quadlet_callback_data callback_data;
 	struct fw_transaction t;
 	u64 offset;
-	int generation = device->generation;
 
 	/* device->node_id, accessed below, must not be older than generation */
 	smp_rmb();
@@ -414,7 +414,14 @@ static int read_rom(struct fw_device *device, int index, u32 * data)
 	return callback_data.rcode;
 }
 
-static int read_bus_info_block(struct fw_device *device)
+/*
+ * Read the bus info block, perform a speed probe, and read all of the rest of
+ * the config ROM.  We do all this with a cached bus generation.  If the bus
+ * generation changes under us, read_bus_info_block will fail and get retried.
+ * It's better to start all over in this case because the node from which we
+ * are reading the ROM may have changed the ROM during the reset.
+ */
+static int read_bus_info_block(struct fw_device *device, int generation)
 {
 	static u32 rom[256];
 	u32 stack[16], sp, key;
@@ -424,7 +431,7 @@ static int read_bus_info_block(struct fw_device *device)
 
 	/* First read the bus info block. */
 	for (i = 0; i < 5; i++) {
-		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			return -1;
 		/*
 		 * As per IEEE1212 7.2, during power-up, devices can
@@ -459,7 +466,8 @@ static int read_bus_info_block(struct fw_device *device)
 			device->max_speed = device->card->link_speed;
 
 		while (device->max_speed > SCODE_100) {
-			if (read_rom(device, 0, &dummy) == RCODE_COMPLETE)
+			if (read_rom(device, generation, 0, &dummy) ==
+			    RCODE_COMPLETE)
 				break;
 			device->max_speed--;
 		}
@@ -492,7 +500,7 @@ static int read_bus_info_block(struct fw_device *device)
 			return -1;
 
 		/* Read header quadlet for the block to get the length. */
-		if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			return -1;
 		end = i + (rom[i] >> 16) + 1;
 		i++;
@@ -511,7 +519,8 @@ static int read_bus_info_block(struct fw_device *device)
 		 * it references another block, and push it in that case.
 		 */
 		while (i < end) {
-			if (read_rom(device, i, &rom[i]) != RCODE_COMPLETE)
+			if (read_rom(device, generation, i, &rom[i]) !=
+			    RCODE_COMPLETE)
 				return -1;
 			if ((key >> 30) == 3 && (rom[i] >> 30) > 1 &&
 			    sp < ARRAY_SIZE(stack))
@@ -658,7 +667,7 @@ static void fw_device_init(struct work_struct *work)
 	 * device.
 	 */
 
-	if (read_bus_info_block(device) < 0) {
+	if (read_bus_info_block(device, device->generation) < 0) {
 		if (device->config_rom_retries < MAX_RETRIES) {
 			device->config_rom_retries++;
 			schedule_delayed_work(&device->work, RETRY_DELAY);



commit b5d2a5e04e6a26cb3f77af8cbc31e74c361d706c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Jan 25 18:57:41 2008 +0100

    firewire: enforce access order between generation and node ID, fix "giving up on config rom"
    
    fw_device.node_id and fw_device.generation are accessed without mutexes.
    We have to ensure that all readers will get to see node_id updates
    before generation updates.
    
    Fixes an inability to recognize devices after "giving up on config rom",
    https://bugzilla.redhat.com/show_bug.cgi?id=429950
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    
    Reviewed by Nick Piggin <nickpiggin@yahoo.com.au>.
    
    Verified to fix 'giving up on config rom' issues on multiple system and
    drive combinations that were previously affected.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index cea8a79..7e73cba 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -207,6 +207,7 @@ fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
 	event->generation    = client->device->generation;
+	smp_rmb();           /* node_id must not be older than generation */
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
 	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 56681b3..872df22 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -27,6 +27,7 @@
 #include <linux/idr.h>
 #include <linux/rwsem.h>
 #include <asm/semaphore.h>
+#include <asm/system.h>
 #include <linux/ctype.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -182,9 +183,14 @@ static void fw_device_release(struct device *dev)
 
 int fw_device_enable_phys_dma(struct fw_device *device)
 {
+	int generation = device->generation;
+
+	/* device->node_id, accessed below, must not be older than generation */
+	smp_rmb();
+
 	return device->card->driver->enable_phys_dma(device->card,
 						     device->node_id,
-						     device->generation);
+						     generation);
 }
 EXPORT_SYMBOL(fw_device_enable_phys_dma);
 
@@ -389,12 +395,16 @@ static int read_rom(struct fw_device *device, int index, u32 * data)
 	struct read_quadlet_callback_data callback_data;
 	struct fw_transaction t;
 	u64 offset;
+	int generation = device->generation;
+
+	/* device->node_id, accessed below, must not be older than generation */
+	smp_rmb();
 
 	init_completion(&callback_data.done);
 
 	offset = 0xfffff0000400ULL + index * 4;
 	fw_send_request(device->card, &t, TCODE_READ_QUADLET_REQUEST,
-			device->node_id, device->generation, device->max_speed,
+			device->node_id, generation, device->max_speed,
 			offset, NULL, 4, complete_transaction, &callback_data);
 
 	wait_for_completion(&callback_data.done);
@@ -801,6 +811,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 
 		device = node->data;
 		device->node_id = node->node_id;
+		smp_wmb();  /* update node_id before generation */
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
index 894d4a9..0854fe2 100644
--- a/drivers/firewire/fw-device.h
+++ b/drivers/firewire/fw-device.h
@@ -35,6 +35,18 @@ struct fw_attribute_group {
 	struct attribute *attrs[11];
 };
 
+/*
+ * Note, fw_device.generation always has to be read before fw_device.node_id.
+ * Use SMP memory barriers to ensure this.  Otherwise requests will be sent
+ * to an outdated node_id if the generation was updated in the meantime due
+ * to a bus reset.
+ *
+ * Likewise, fw-core will take care to update .node_id before .generation so
+ * that whenever fw_device.generation is current WRT the actual bus generation,
+ * fw_device.node_id is guaranteed to be current too.
+ *
+ * The same applies to fw_device.card->node_id vs. fw_device.generation.
+ */
 struct fw_device {
 	atomic_t state;
 	struct fw_node *node;
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index d406c34..705a20c 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -40,6 +40,7 @@
 #include <linux/stringify.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -662,6 +663,7 @@ static void sbp2_login(struct work_struct *work)
 	int generation, node_id, local_node_id;
 
 	generation    = device->generation;
+	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
@@ -912,6 +914,7 @@ static void sbp2_reconnect(struct work_struct *work)
 	int generation, node_id, local_node_id;
 
 	generation    = device->generation;
+	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index 0fc9b00..172c186 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
+#include <asm/system.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
 
@@ -518,6 +519,11 @@ fw_core_handle_bus_reset(struct fw_card *card,
 		card->bm_retries = 0;
 
 	card->node_id = node_id;
+	/*
+	 * Update node_id before generation to prevent anybody from using
+	 * a stale node_id together with a current generation.
+	 */
+	smp_wmb();
 	card->generation = generation;
 	card->reset_jiffies = jiffies;
 	schedule_delayed_work(&card->work, 0);



commit cf5a56ac8083dd04ffe8b9b2ec7895e9bcff44bc
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Jan 24 01:53:51 2008 +0100

    firewire: fw-cdev: use device generation, not card generation
    
    We have to use the fw_device.generation here, not the fw_card.generation,
    because the generation must never be newer than the node ID when we emit
    a transaction.  This cannot be guaranteed with fw_card.generation.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    
    Verified in concert with subsequent memory barriers patch to fix 'giving
    up on config rom' issues on multiple system and drive combinations that
    were previously affected.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 60f1a89..cea8a79 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -206,12 +206,12 @@ fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
 
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
+	event->generation    = client->device->generation;
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
 	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
 	event->irm_node_id   = card->irm_node->node_id;
 	event->root_node_id  = card->root_node->node_id;
-	event->generation    = card->generation;
 }
 
 static void



commit 5a8a1bcd15dfb9f177f3605fe6b9ba2bef2bf55a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Jan 24 01:53:19 2008 +0100

    firewire: fw-sbp2: use device generation, not card generation
    
    There was a small window where a login or reconnect job could use an
    already updated card generation with an outdated node ID.  We have to
    use the fw_device.generation here, not the fw_card.generation, because
    the generation must never be newer than the node ID when we emit a
    transaction.  This cannot be guaranteed with fw_card.generation.
    
    Furthermore, the target's and initiator's node IDs can be obtained from
    fw_device and fw_card.  Dereferencing their underlying topology objects
    is not necessary.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    
    Verified in concert with subsequent memory barriers patch to fix 'giving
    up on config rom' issues on multiple system and drive combinations that
    were previously affected.
    
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index d2fbfc6..d406c34 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -661,9 +661,9 @@ static void sbp2_login(struct work_struct *work)
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
-	generation    = device->card->generation;
-	node_id       = device->node->node_id;
-	local_node_id = device->card->local_node->node_id;
+	generation    = device->generation;
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
@@ -911,9 +911,9 @@ static void sbp2_reconnect(struct work_struct *work)
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
-	generation    = device->card->generation;
-	node_id       = device->node->node_id;
-	local_node_id = device->card->local_node->node_id;
+	generation    = device->generation;
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,



commit 14dc992aa782f8759c6d117d4322db62f62600ce
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 20 01:25:31 2008 +0100

    firewire: fw-sbp2: try to increase reconnect_hold (speed up reconnection)
    
    Ask the target to grant 4 seconds instead of the standard and minimum of
    1 second window after bus reset for reconnection.  This accelerates
    reconnection if there are more than one targets on the bus:  If a login
    and inquiry to one target blocks the fw-sbp2 workqueue for more than 1s
    after bus reset, we now still can reconnect to the other target.
    
    Before that, fw-sbp2's reconnect attempts would be rejected with "error
    status: 0:9" (function rejected), and fw-sbp2 would finally re-login.
    All those futile reconnect attemps cost extra time until the target
    which needs re-login is ready for I/O again.
    
    The reconnect timeout field in the login ORB doesn't have to be honored
    by the target though.  I found that we could get up to
      - allegedly 32768s from an old OXFW911 firmware
      - 256s from LSI bridges
      - 4s from OXUF922 and OXFW912 bridges,
      - 2s from TI bridges,
      - only the standard 1s from Initio and Prolific bridges and from
        Apple OpenFirmware in target mode.
    
    We just try to get 4 seconds which already covers the case of a few
    HDDs on the same bus quite nicely.
    
    A minor drawback occurs in the following (rare and impractical) border
    case:
      - two initiators are there, initiator 1 holds an exclusive login to
        a target,
      - initiator 1 goes off the bus,
      - target refuses login attempts from initiator 2 until reconnect_hold
        seconds after bus reset.
    
    An alternative approach to the issue at hand would be to parallelize
    fw-sbp2's reconnect and login work.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Acked-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 661a5b6..d2fbfc6 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -514,9 +514,10 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	orb->request.status_fifo.low  = lu->address_handler.offset;
 
 	if (function == SBP2_LOGIN_REQUEST) {
+		/* Ask for 2^2 == 4 seconds reconnect grace period */
 		orb->request.misc |=
-			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login) |
-			MANAGEMENT_ORB_RECONNECT(0);
+			MANAGEMENT_ORB_RECONNECT(2) |
+			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login);
 	}
 
 	fw_memcpy_to_be32(&orb->request, &orb->request, sizeof(orb->request));



commit 4dccd020d7ca5e673d7804cc4ff80fbf58d8a37e
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 20 01:24:26 2008 +0100

    firewire: fw-sbp2: skip unnecessary logout
    
    Don't attempt to send a logout ORB if the target was already unplugged
    or had its link switched off.  If two targets are attached, this
    enhances the chance to quickly reconnect to the remaining target when
    one target is plugged out.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Acked-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index e5a2571..661a5b6 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -606,13 +606,17 @@ static void sbp2_release_target(struct kref *kref)
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	struct fw_device *device = fw_device(tgt->unit->device.parent);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
 		if (lu->sdev)
 			scsi_remove_device(lu->sdev);
 
-		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
-				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+		if (!fw_device_is_shutdown(device))
+			sbp2_send_management_orb(lu, tgt->node_id,
+					lu->generation, SBP2_LOGOUT_REQUEST,
+					lu->login_id, NULL);
+
 		fw_core_remove_address_handler(&lu->address_handler);
 		list_del(&lu->link);
 		kfree(lu);

-- 
Stefan Richter
-=====-==--- ---= ====-
http://arcgraph.de/sr/

