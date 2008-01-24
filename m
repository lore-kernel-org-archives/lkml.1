Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYAXAzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYAXAzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYAXAzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:55:03 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45379 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYAXAzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:55:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 Jan 2008 01:54:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firewire: enforce access order between generation and
 node ID
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Jarod Wilson <jwilson@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
Message-ID: <tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <200711011453.35268.nickpiggin@yahoo.com.au>
 <4729A1BF.8010800@s5r6.in-berlin.de>
 <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_device.node_id and fw_device.generation are accessed without mutexes.
We have to ensure that all readers will get to see node_id updates
before generation updates.

An earlier incarnation of this patch fixes an inability to recognize
devices after "giving up on config rom",
https://bugzilla.redhat.com/show_bug.cgi?id=429950

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Rework of patches
    firewire: fw-core: enforce write order when updating fw_device.generation
and parts of
    firewire: fw-core: react on bus resets while the config ROM is being fetched
    firewire: fw-sbp2: enforce read order of device generation and node ID
from November 1 2007.

Update:
  - write site and read sites folded into one patch
  - added fix to fw_device_enable_phys_dma() and fill_bus_reset_event()
  - smp_ barriers are sufficient
  - comments, changelog

 drivers/firewire/fw-cdev.c     |    1 +
 drivers/firewire/fw-device.c   |   13 +++++++++++--
 drivers/firewire/fw-device.h   |   12 ++++++++++++
 drivers/firewire/fw-sbp2.c     |    2 ++
 drivers/firewire/fw-topology.c |    5 +++++
 5 files changed, 31 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -182,9 +182,13 @@ static void fw_device_release(struct dev
 
 int fw_device_enable_phys_dma(struct fw_device *device)
 {
+	int generation = device->generation;
+
+	/* device->node_id, accessed below, must not be older than generation */
+	smp_rmb();
 	return device->card->driver->enable_phys_dma(device->card,
 						     device->node_id,
-						     device->generation);
+						     generation);
 }
 EXPORT_SYMBOL(fw_device_enable_phys_dma);
 
@@ -389,12 +393,16 @@ static int read_rom(struct fw_device *de
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
@@ -801,6 +809,7 @@ void fw_node_event(struct fw_card *card,
 
 		device = node->data;
 		device->node_id = node->node_id;
+		smp_wmb();  /* update node_id before generation */
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -518,6 +518,11 @@ fw_core_handle_bus_reset(struct fw_card 
 		card->bm_retries = 0;
 
 	card->node_id = node_id;
+	/*
+	 * Update node_id before generation to prevent anybody from using
+	 * a stale node_id togeher with a current generation.
+	 */
+	smp_wmb();
 	card->generation = generation;
 	card->reset_jiffies = jiffies;
 	schedule_delayed_work(&card->work, 0);
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -672,6 +672,7 @@ static void sbp2_login(struct work_struc
 	int generation, node_id, local_node_id;
 
 	generation    = device->generation;
+	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
@@ -922,6 +923,7 @@ static void sbp2_reconnect(struct work_s
 	int generation, node_id, local_node_id;
 
 	generation    = device->generation;
+	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
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
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -207,6 +207,7 @@ fill_bus_reset_event(struct fw_cdev_even
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
 	event->generation    = client->device->generation;
+	smp_rmb();           /* node_id must not be older than generation */
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
 	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */

-- 
Stefan Richter
-=====-==--- ---= ==---
http://arcgraph.de/sr/

