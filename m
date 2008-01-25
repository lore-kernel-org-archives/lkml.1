Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYAYR60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYAYR60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYAYR6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:58:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60126 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYAYR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:58:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 25 Jan 2008 18:57:41 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/4] firewire: enforce access order between generation and
 node ID
To: Jarod Wilson <jwilson@redhat.com>
cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <479A0FD7.5050003@s5r6.in-berlin.de>
Message-ID: <tkrat.7cfb2c72baf87206@s5r6.in-berlin.de>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>
 <200711011453.35268.nickpiggin@yahoo.com.au>
 <4729A1BF.8010800@s5r6.in-berlin.de>
 <tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>
 <tkrat.f1b275fda9e67a3c@s5r6.in-berlin.de> <4798B793.8080909@redhat.com>
 <479A0FD7.5050003@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I'm going to commit it with a whitespace adjustment and a comment typo
> fixed.

Also forgot to #include <asm/system.h> in some of the files.  Here is
the final product, for the record.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: enforce access order between generation and node ID, fix "giving up on config rom"

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
---
 drivers/firewire/fw-cdev.c     |    1 +
 drivers/firewire/fw-device.c   |   15 +++++++++++++--
 drivers/firewire/fw-device.h   |   12 ++++++++++++
 drivers/firewire/fw-sbp2.c     |    3 +++
 drivers/firewire/fw-topology.c |    6 ++++++
 5 files changed, 35 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -27,6 +27,7 @@
 #include <linux/idr.h>
 #include <linux/rwsem.h>
 #include <asm/semaphore.h>
+#include <asm/system.h>
 #include <linux/ctype.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -182,9 +183,14 @@ static void fw_device_release(struct dev
 
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
 
@@ -389,12 +395,16 @@ static int read_rom(struct fw_device *de
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
@@ -801,6 +811,7 @@ void fw_node_event(struct fw_card *card,
 
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
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
+#include <asm/system.h>
 #include "fw-transaction.h"
 #include "fw-topology.h"
 
@@ -518,6 +519,11 @@ fw_core_handle_bus_reset(struct fw_card 
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
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -40,6 +40,7 @@
 #include <linux/stringify.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -662,6 +663,7 @@ static void sbp2_login(struct work_struc
 	int generation, node_id, local_node_id;
 
 	generation    = device->generation;
+	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
@@ -912,6 +914,7 @@ static void sbp2_reconnect(struct work_s
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
-=====-==--- ---= ==--=
http://arcgraph.de/sr/

