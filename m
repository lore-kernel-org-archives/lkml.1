Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbZAQVqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbZAQVqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZAQVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:46:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44629 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZAQVqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:46:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jan 2009 22:46:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firewire: keep highlevel drivers attached during brief
 connection loss
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
Message-ID: <tkrat.3c3374cc4b880a88@s5r6.in-berlin.de>
References: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: keep highlevel drivers attached during brief connection loss

There are situations when nodes vanish from the bus and come back in
quickly thereafter:
  - When certain bus-powered hubs are plugged in,
  - when certain devices are plugged into 6-port hubs,
  - when certain disk enclosures are switched from self-power to bus
    power or vice versa and break the daisy chain during the transition,
  - when the user plugs a cable out and quickly plugs it back in, e.g.
    to reorder a daisy chain (works on Mac OS X if done quickly enough),
  - when certain hubs temporarily malfunction during high bus traffic.

Until now, firewire-core reported affected nodes as lost to the
highlevel drivers (firewire-sbp2 and userspace drivers).  We now delay
the destruction of device representations until after at least two
seconds after the last bus reset.  If a "new" device is detected in this
period whose bus information block and root directory header match that
of a device which is pending for deletion, we resurrect that device and
send update calls to highlevel drivers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |  121 ++++++++++++++++++++++++++++-------
 drivers/firewire/fw-device.h |    1 
 2 files changed, 100 insertions(+), 22 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -25,6 +25,7 @@
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
+#include <linux/jiffies.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
@@ -632,12 +633,38 @@ struct fw_device *fw_device_get_by_devt(
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
 
+	if (time_is_after_jiffies(device->card->reset_jiffies + SHUTDOWN_DELAY)) {
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
@@ -645,6 +672,7 @@ static void fw_device_shutdown(struct wo
 	down_write(&fw_device_rwsem);
 	idr_remove(&fw_device_idr, minor);
 	up_write(&fw_device_rwsem);
+
 	fw_device_put(device);
 }
 
@@ -652,25 +680,63 @@ static struct device_type fw_device_type
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
 
-#define MAX_RETRIES	10
-#define RETRY_DELAY	(3 * HZ)
-#define INITIAL_DELAY	(HZ / 2)
+		old->max_speed = new->max_speed;
+		old->node_id = current_node->node_id;
+		smp_wmb();  /* update node_id before generation */
+		old->generation = card->generation;
+		old->config_rom_retries = 0;
+		fw_notify("rediscovered device %s\n", dev_name(dev));
+
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
@@ -694,6 +760,15 @@ static void fw_device_init(struct work_s
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
@@ -732,9 +807,10 @@ static void fw_device_init(struct work_s
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
@@ -845,8 +921,8 @@ static void fw_device_refresh(struct wor
 
 	case REREAD_BIB_UNCHANGED:
 		if (atomic_cmpxchg(&device->state,
-			    FW_DEVICE_INITIALIZING,
-			    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+				   FW_DEVICE_INITIALIZING,
+				   FW_DEVICE_RUNNING) == FW_DEVICE_GONE)
 			goto gone;
 
 		fw_device_update(work);
@@ -877,8 +953,8 @@ static void fw_device_refresh(struct wor
 	create_units(device);
 
 	if (atomic_cmpxchg(&device->state,
-		    FW_DEVICE_INITIALIZING,
-		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+			   FW_DEVICE_INITIALIZING,
+			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE)
 		goto gone;
 
 	fw_notify("refreshed device %s\n", dev_name(&device->device));
@@ -888,8 +964,9 @@ static void fw_device_refresh(struct wor
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
@@ -994,9 +1071,9 @@ void fw_node_event(struct fw_card *card,
 		 */
 		device = node->data;
 		if (atomic_xchg(&device->state,
-				FW_DEVICE_SHUTDOWN) == FW_DEVICE_RUNNING) {
+				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
-			schedule_delayed_work(&device->work, 0);
+			schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
 		}
 		break;
 	}
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -29,6 +29,7 @@
 enum fw_device_state {
 	FW_DEVICE_INITIALIZING,
 	FW_DEVICE_RUNNING,
+	FW_DEVICE_GONE,
 	FW_DEVICE_SHUTDOWN,
 };
 

-- 
Stefan Richter
-=====-==--= ---= =---=
http://arcgraph.de/sr/

