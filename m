Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYEXOuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYEXOuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYEXOu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:50:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48354 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbYEXOu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:50:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 May 2008 16:50:22 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: clean up fw_card reference counting
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Message-ID: <tkrat.a7fee7c1c657154f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a functionally equivalent replacement of the current reference
counting of struct fw_card instances.  It only converts it to common
idioms as suggested by Kristian Høgsberg:
  - struct kref replaces atomic_t as the counter.
  - wait_for_completion is used to wait for all card users to complete.

BTW, it may make sense to count card->flush_timer and card->work as
card users too.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Applies after patch "firewire: clean up some includes".

 drivers/firewire/fw-card.c        |   30 ++++++++++++++++++++----------
 drivers/firewire/fw-device.c      |    5 ++---
 drivers/firewire/fw-transaction.h |   20 ++++++++++++++++++--
 3 files changed, 40 insertions(+), 15 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -16,12 +16,15 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/module.h>
-#include <linux/errno.h>
+#include <linux/completion.h>
+#include <linux/crc-itu-t.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/kref.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/crc-itu-t.h>
+
 #include "fw-transaction.h"
 #include "fw-topology.h"
 #include "fw-device.h"
@@ -396,7 +399,6 @@ fw_card_initialize(struct fw_card *card,
 {
 	static atomic_t index = ATOMIC_INIT(-1);
 
-	atomic_set(&card->device_count, 0);
 	card->index = atomic_inc_return(&index);
 	card->driver = driver;
 	card->device = device;
@@ -405,6 +407,8 @@ fw_card_initialize(struct fw_card *card,
 	card->color = 0;
 	card->broadcast_channel = BROADCAST_CHANNEL_INITIAL;
 
+	kref_init(&card->kref);
+	init_completion(&card->done);
 	INIT_LIST_HEAD(&card->transaction_list);
 	spin_lock_init(&card->lock);
 	setup_timer(&card->flush_timer,
@@ -507,6 +511,14 @@ static struct fw_card_driver dummy_drive
 };
 
 void
+fw_card_release(struct kref *kref)
+{
+	struct fw_card *card = container_of(kref, struct fw_card, kref);
+
+	complete(&card->done);
+}
+
+void
 fw_core_remove_card(struct fw_card *card)
 {
 	card->driver->update_phy_reg(card, 4,
@@ -521,12 +533,10 @@ fw_core_remove_card(struct fw_card *card
 	card->driver = &dummy_driver;
 
 	fw_destroy_nodes(card);
-	/*
-	 * Wait for all device workqueue jobs to finish.  Otherwise the
-	 * firewire-core module could be unloaded before the jobs ran.
-	 */
-	while (atomic_read(&card->device_count) > 0)
-		msleep(100);
+
+	/* Wait for all users, especially device workqueue jobs, to finish. */
+	fw_card_put(card);
+	wait_for_completion(&card->done);
 
 	cancel_delayed_work_sync(&card->work);
 	fw_flush_transactions(card);
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -167,7 +167,7 @@ static void fw_device_release(struct dev
 	fw_node_put(device->node);
 	kfree(device->config_rom);
 	kfree(device);
-	atomic_dec(&card->device_count);
+	fw_card_put(card);
 }
 
 int fw_device_enable_phys_dma(struct fw_device *device)
@@ -945,8 +945,7 @@ void fw_node_event(struct fw_card *card,
 		 */
 		device_initialize(&device->device);
 		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
-		atomic_inc(&card->device_count);
-		device->card = card;
+		device->card = fw_card_get(card);
 		device->node = fw_node_get(node);
 		device->node_id = node->node_id;
 		device->generation = card->generation;
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -19,14 +19,15 @@
 #ifndef __fw_transaction_h
 #define __fw_transaction_h
 
+#include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/firewire-constants.h>
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
 #define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
@@ -219,7 +220,8 @@ extern struct bus_type fw_bus_type;
 struct fw_card {
 	const struct fw_card_driver *driver;
 	struct device *device;
-	atomic_t device_count;
+	struct kref kref;
+	struct completion done;
 
 	int node_id;
 	int generation;
@@ -260,6 +262,20 @@ struct fw_card {
 	int bm_generation;
 };
 
+static inline struct fw_card *fw_card_get(struct fw_card *card)
+{
+	kref_get(&card->kref);
+
+	return card;
+}
+
+void fw_card_release(struct kref *kref);
+
+static inline void fw_card_put(struct fw_card *card)
+{
+	kref_put(&card->kref, fw_card_release);
+}
+
 /*
  * Check whether new_generation is the immediate successor of old_generation.
  * Take counter roll-over at 255 (as per to OHCI) into account.

-- 
Stefan Richter
-=====-==--- -=-= ==---
http://arcgraph.de/sr/

