Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYHSTar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYHSTar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYHSTai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:30:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38505 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYHSTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:30:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Aug 2008 21:30:17 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2/2] ieee1394: survive a few seconds connection loss
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, damien_benoist@yahoo.com
In-Reply-To: <tkrat.a7680a3ca1cdeb42@s5r6.in-berlin.de>
Message-ID: <tkrat.51d4828de9d3aee3@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
 <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
 <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
 <tkrat.3829f18186b21759@s5r6.in-berlin.de>
 <tkrat.a7680a3ca1cdeb42@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations when nodes vanish from the bus and come back in
quickly thereafter:
  - When certain bus-powered hubs are plugged in,
  - when certain disk enclosures are switched from self-power to bus
    power or vice versa and break the daisy chain during the transition,
  - when the user plugs a cable out and quickly plugs it back in, e.g.
    to reorder a daisy chain (works on Mac OS X if done quickly enough),
  - when certain hubs temporarily malfunction during high bus traffic.

The ieee1394 driver's nodemgr already contained a function to set
vanished nodes aside into "limbo"; i.e. they wouldn't actually be
deleted right away.  (In fact, only unloading the driver or writing into
an obscure sysfs attribute would delete them eventually.)  If nodes
reappeared later, they would be resurrected out of limbo.

Moving nodes into and out of limbo was accompanied with calling the
.suspend() and .resume() driver methods of the drivers which were bound
to a respective node's unit directories.  Not only is this somewhat
strange due to the primary use of these drivers for power management,
also the sbp2 driver in particular does not implement .suspend() and
.resume().

Hence sbp2 would be disconnected from devices in situations as listed
above.

We now:
  - leave drivers bound when nodes go into limbo,
  - call the drivers' .update() when nodes come out of limbo,
  - automatically delete in-limbo nodes 5 seconds after the last
    bus reset and bus rescan.
  - Because of the automatic removal, the now obsolete bus attribute
    /sys/bus/ieee1394/destroy_node is removed.

This especially lets sbp2 survive brief disconnections.  You can for
example yank a disk's cable and plug it back in while reading the
respective disk with dd, but dd will happily continue as if nothing
happened.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |  146 ++++++++++++-------------------------
 drivers/ieee1394/nodemgr.h |    2 
 2 files changed, 52 insertions(+), 96 deletions(-)

Index: linux-2.6.27-rc3/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.27-rc3.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.27-rc3/drivers/ieee1394/nodemgr.c
@@ -154,7 +154,6 @@ struct host_info {
 
 static int nodemgr_bus_match(struct device * dev, struct device_driver * drv);
 static int nodemgr_uevent(struct device *dev, struct kobj_uevent_env *env);
-static void nodemgr_reactivate_ne(struct node_entry *ne);
 static void nodemgr_remove_ne(struct node_entry *ne);
 static struct node_entry *find_entry_by_guid(u64 guid);
 
@@ -385,27 +384,6 @@ static ssize_t fw_get_ignore_driver(stru
 static DEVICE_ATTR(ignore_driver, S_IWUSR | S_IRUGO, fw_get_ignore_driver, fw_set_ignore_driver);
 
 
-static ssize_t fw_set_destroy_node(struct bus_type *bus, const char *buf, size_t count)
-{
-	struct node_entry *ne;
-	u64 guid = (u64)simple_strtoull(buf, NULL, 16);
-
-	ne = find_entry_by_guid(guid);
-
-	if (ne == NULL || !ne->in_limbo)
-		return -EINVAL;
-
-	nodemgr_remove_ne(ne);
-
-	return count;
-}
-static ssize_t fw_get_destroy_node(struct bus_type *bus, char *buf)
-{
-	return sprintf(buf, "You can destroy in_limbo nodes by writing their GUID to this file\n");
-}
-static BUS_ATTR(destroy_node, S_IWUSR | S_IRUGO, fw_get_destroy_node, fw_set_destroy_node);
-
-
 static ssize_t fw_set_rescan(struct bus_type *bus, const char *buf,
 			     size_t count)
 {
@@ -442,7 +420,6 @@ static BUS_ATTR(ignore_drivers, S_IWUSR 
 
 
 struct bus_attribute *const fw_bus_attrs[] = {
-	&bus_attr_destroy_node,
 	&bus_attr_rescan,
 	&bus_attr_ignore_drivers,
 	NULL
@@ -1300,14 +1277,19 @@ static void nodemgr_update_node(struct n
 		csr1212_destroy_csr(csr);
 	}
 
-	if (ne->in_limbo)
-		nodemgr_reactivate_ne(ne);
-
 	/* Mark the node current */
 	ne->generation = generation;
-}
 
+	if (ne->in_limbo) {
+		device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
+		ne->in_limbo = false;
 
+		HPSB_DEBUG("Node reactivated: "
+			   "ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
+			   NODE_BUS_ARGS(ne->host, ne->nodeid),
+			   (unsigned long long)ne->guid);
+	}
+}
 
 static void nodemgr_node_scan_one(struct hpsb_host *host,
 				  nodeid_t nodeid, int generation)
@@ -1392,75 +1374,14 @@ static void nodemgr_node_scan(struct hps
 	}
 }
 
-static int pause_ne(struct device *dev, void *data)
-{
-	struct unit_directory *ud;
-	struct device_driver *drv;
-	struct node_entry *ne = data;
-	int error;
-
-	ud = container_of(dev, struct unit_directory, unit_dev);
-	if (ud->ne == ne) {
-		drv = get_driver(ud->device.driver);
-		if (drv) {
-			error = 1; /* release if suspend is not implemented */
-			if (drv->suspend) {
-				down(&ud->device.sem);
-				error = drv->suspend(&ud->device, PMSG_SUSPEND);
-				up(&ud->device.sem);
-			}
-			if (error)
-				device_release_driver(&ud->device);
-			put_driver(drv);
-		}
-	}
-
-	return 0;
-}
-
 static void nodemgr_pause_ne(struct node_entry *ne)
 {
-	HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
+	HPSB_DEBUG("Node paused: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
 		   NODE_BUS_ARGS(ne->host, ne->nodeid),
 		   (unsigned long long)ne->guid);
 
-	ne->in_limbo = 1;
+	ne->in_limbo = true;
 	WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
-
-	class_for_each_device(&nodemgr_ud_class, NULL, ne, pause_ne);
-}
-
-static int reactivate_ne(struct device *dev, void *data)
-{
-	struct unit_directory *ud;
-	struct device_driver *drv;
-	struct node_entry *ne = data;
-
-	ud = container_of(dev, struct unit_directory, unit_dev);
-	if (ud->ne == ne) {
-		drv = get_driver(ud->device.driver);
-		if (drv) {
-			if (drv->resume) {
-				down(&ud->device.sem);
-				drv->resume(&ud->device);
-				up(&ud->device.sem);
-			}
-			put_driver(drv);
-		}
-	}
-
-	return 0;
-}
-
-static void nodemgr_reactivate_ne(struct node_entry *ne)
-{
-	ne->in_limbo = 0;
-	device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
-
-	class_for_each_device(&nodemgr_ud_class, NULL, ne, reactivate_ne);
-	HPSB_DEBUG("Node resumed: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
-		   NODE_BUS_ARGS(ne->host, ne->nodeid),
-		   (unsigned long long)ne->guid);
 }
 
 static int update_pdrv(struct device *dev, void *data)
@@ -1497,7 +1418,6 @@ static void nodemgr_update_pdrv(struct n
 	class_for_each_device(&nodemgr_ud_class, NULL, ne, update_pdrv);
 }
 
-
 /* Write the BROADCAST_CHANNEL as per IEEE1394a 8.3.2.3.11 and 8.4.2.3.  This
  * seems like an optional service but in the end it is practically mandatory
  * as a consequence of these clauses.
@@ -1574,7 +1494,7 @@ static int node_probe(struct device *dev
 	return 0;
 }
 
-static void nodemgr_node_probe(struct hpsb_host *host, int generation)
+static int nodemgr_node_probe(struct hpsb_host *host, int generation)
 {
 	struct node_probe_parameter p;
 
@@ -1595,11 +1515,11 @@ static void nodemgr_node_probe(struct hp
 	 */
 	p.probe_now = false;
 	if (class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe) != 0)
-		return;
+		return 0;
 
 	p.probe_now = true;
 	if (class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe) != 0)
-		return;
+		return 0;
 	/*
 	 * Now let's tell the bus to rescan our devices. This may seem
 	 * like overhead, but the driver-model core will only scan a
@@ -1611,6 +1531,27 @@ static void nodemgr_node_probe(struct hp
 	 */
 	if (bus_rescan_devices(&ieee1394_bus_type) != 0)
 		HPSB_DEBUG("bus_rescan_devices had an error");
+
+	return 1;
+}
+
+static int remove_nodes_in_limbo(struct device *dev, void *data)
+{
+	struct node_entry *ne;
+
+	if (dev->bus != &ieee1394_bus_type)
+		return 0;
+
+	ne = container_of(dev, struct node_entry, device);
+	if (ne->in_limbo)
+		nodemgr_remove_ne(ne);
+
+	return 0;
+}
+
+static void nodemgr_remove_nodes_in_limbo(struct hpsb_host *host)
+{
+	device_for_each_child(&host->device, NULL, remove_nodes_in_limbo);
 }
 
 static int nodemgr_send_resume_packet(struct hpsb_host *host)
@@ -1781,10 +1722,25 @@ static int nodemgr_host_thread(void *dat
 
 		/* This actually does the full probe, with sysfs
 		 * registration. */
-		nodemgr_node_probe(host, generation);
+		if (!nodemgr_node_probe(host, generation))
+			continue;
 
 		/* Update some of our sysfs symlinks */
 		nodemgr_update_host_dev_links(host);
+
+		/* Sleep 5 seconds */
+		for (i = 0; i < 5000/100 ; i++) {
+			msleep_interruptible(100);
+			if (kthread_should_stop())
+				goto exit;
+
+			if (generation != get_hpsb_generation(host))
+				break;
+		}
+
+		/* Remove nodes which are gone, unless a bus reset happened */
+		if (i == 5000/100)
+			nodemgr_remove_nodes_in_limbo(host);
 	}
 exit:
 	HPSB_VERBOSE("NodeMgr: Exiting thread");
Index: linux-2.6.27-rc3/drivers/ieee1394/nodemgr.h
===================================================================
--- linux-2.6.27-rc3.orig/drivers/ieee1394/nodemgr.h
+++ linux-2.6.27-rc3/drivers/ieee1394/nodemgr.h
@@ -110,7 +110,7 @@ struct node_entry {
 	struct device node_dev;
 
 	/* Means this node is not attached anymore */
-	int in_limbo;
+	bool in_limbo;
 
 	struct csr1212_csr *csr;
 };

-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/

