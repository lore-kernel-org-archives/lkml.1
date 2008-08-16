Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYHPLii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYHPLii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 07:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYHPLi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 07:38:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45799 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYHPLi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 07:38:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 13:38:11 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2/3] ieee1394: don't drop nodes during bus reset series
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, damien_benoist@yahoo.com
In-Reply-To: <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
Message-ID: <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
 <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nodemgr_node_probe checked for generation increments too late and
therefore prematurely reported nodes as "suspended".

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=11349 for me.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |   42 +++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -1563,11 +1563,14 @@ struct probe_param {
 	bool probe_now;
 };
 
-static int __nodemgr_node_probe(struct device *dev, void *data)
+static int node_probe(struct device *dev, void *data)
 {
 	struct probe_param *param = (struct probe_param *)data;
 	struct node_entry *ne;
 
+	if (param->generation != get_hpsb_generation(param->hi->host))
+		return -EAGAIN;
+
 	ne = container_of(dev, struct node_entry, node_dev);
 	if (ne->needs_probe == param->probe_now)
 		nodemgr_probe_ne(param->hi, ne, param->generation);
@@ -1576,42 +1579,41 @@ static int __nodemgr_node_probe(struct d
 
 static void nodemgr_node_probe(struct host_info *hi, int generation)
 {
-	struct hpsb_host *host = hi->host;
 	struct probe_param param;
 
 	param.hi = hi;
 	param.generation = generation;
-	/* Do some processing of the nodes we've probed. This pulls them
+	/*
+	 * Do some processing of the nodes we've probed. This pulls them
 	 * into the sysfs layer if needed, and can result in processing of
 	 * unit-directories, or just updating the node and it's
 	 * unit-directories.
 	 *
 	 * Run updates before probes. Usually, updates are time-critical
-	 * while probes are time-consuming. (Well, those probes need some
-	 * improvement...) */
-
+	 * while probes are time-consuming.
+	 *
+	 * Meanwhile, another bus reset may have happened. In this case we
+	 * skip everything here and let the next bus scan handle it.
+	 * Otherwise we may prematurely remove nodes which are still there.
+	 */
 	param.probe_now = false;
-	class_for_each_device(&nodemgr_ne_class, &param, __nodemgr_node_probe);
-	param.probe_now = true;
-	class_for_each_device(&nodemgr_ne_class, &param, __nodemgr_node_probe);
+	if (class_for_each_device(&nodemgr_ne_class, &param, node_probe) != 0)
+		return;
 
-	/* If we had a bus reset while we were scanning the bus, it is
-	 * possible that we did not probe all nodes.  In that case, we
-	 * skip the clean up for now, since we could remove nodes that
-	 * were still on the bus.  Another bus scan is pending which will
-	 * do the clean up eventually.
-	 *
+	param.probe_now = true;
+	if (class_for_each_device(&nodemgr_ne_class, &param, node_probe) != 0)
+		return;
+	/*
 	 * Now let's tell the bus to rescan our devices. This may seem
 	 * like overhead, but the driver-model core will only scan a
 	 * device for a driver when either the device is added, or when a
 	 * new driver is added. A bus reset is a good reason to rescan
 	 * devices that were there before.  For example, an sbp2 device
 	 * may become available for login, if the host that held it was
-	 * just removed.  */
-
-	if (generation == get_hpsb_generation(host))
-		if (bus_rescan_devices(&ieee1394_bus_type))
-			HPSB_DEBUG("bus_rescan_devices had an error");
+	 * just removed.
+	 */
+	if (bus_rescan_devices(&ieee1394_bus_type) != 0)
+		HPSB_DEBUG("bus_rescan_devices had an error");
 }
 
 static int nodemgr_send_resume_packet(struct hpsb_host *host)

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

