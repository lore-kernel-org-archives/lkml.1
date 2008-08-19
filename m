Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYHSRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYHSRLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHSRLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:11:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37259 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYHSRLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:11:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Aug 2008 19:10:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] ieee1394 updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.f9af167e43ba696f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following ieee1394 and firewire subsystem updates.  The
ieee1394 part fixes and enhances SBP-2 reconnection when further devices
are plugged in to a bus or become ready while other devices are in use.

The -stable team will receive a backport of the regression fix.


Stefan Richter (4):
      ieee1394: regression in 2.6.25: updates should happen before probes
      ieee1394: don't drop nodes during bus reset series
      ieee1394: sbp2: let nodemgr retry node updates during bus reset series
      firewire: Kconfig help update

 drivers/firewire/Kconfig   |    4 +-
 drivers/ieee1394/nodemgr.c |   63 +++++++++++++++++++-----------------
 drivers/ieee1394/nodemgr.h |    2 +-
 drivers/ieee1394/sbp2.c    |   25 ++++++++++----
 4 files changed, 54 insertions(+), 40 deletions(-)


commit 30b0aa7c9a5e769a874a456cd56396eebf164b91
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 16 21:52:28 2008 +0200

    firewire: Kconfig help update
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index fa6d6ab..4509024 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -12,8 +12,8 @@ config FIREWIRE
 	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
 	  stack, or the old stack (the ieee1394 driver, ohci1394 etc.) or both.
-	  Please read http://wiki.linux1394.org/JujuMigration before you
-	  enable the new stack.
+	  Please read http://ieee1394.wiki.kernel.org/index.php/Juju_Migration
+	  before you enable the new stack.
 
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.

commit a3384067fb0df9c58e112ac6a5ec9beb7d169482
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 16 13:39:26 2008 +0200

    ieee1394: sbp2: let nodemgr retry node updates during bus reset series
    
    sbp2 was too quick to report .update() to the ieee1394 core as failed.
    (Logged as "Failed to reconnect to sbp2 device!".)  The core would then
    unbind sbp2 from the device.
    
    This is not justified if the .update() failed because another bus reset
    happened.  We check this and tell the ieee1394 that .update() succeeded,
    and the core will call sbp2's .update() for the new bus reset as well.
    
    This improves reconnection/re-login especially on buses with several
    disks as they may issue bus resets in close succession when they come
    online.
    
    Tested by Damien Benoist.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 9cbf315..1d6ad34 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -731,15 +731,26 @@ static int sbp2_update(struct unit_directory *ud)
 {
 	struct sbp2_lu *lu = ud->device.driver_data;
 
-	if (sbp2_reconnect_device(lu)) {
-		/* Reconnect has failed. Perhaps we didn't reconnect fast
-		 * enough. Try a regular login, but first log out just in
-		 * case of any weirdness. */
+	if (sbp2_reconnect_device(lu) != 0) {
+		/*
+		 * Reconnect failed.  If another bus reset happened,
+		 * let nodemgr proceed and call sbp2_update again later
+		 * (or sbp2_remove if this node went away).
+		 */
+		if (!hpsb_node_entry_valid(lu->ne))
+			return 0;
+		/*
+		 * Or the target rejected the reconnect because we weren't
+		 * fast enough.  Try a regular login, but first log out
+		 * just in case of any weirdness.
+		 */
 		sbp2_logout_device(lu);
 
-		if (sbp2_login_device(lu)) {
-			/* Login failed too, just fail, and the backend
-			 * will call our sbp2_remove for us */
+		if (sbp2_login_device(lu) != 0) {
+			if (!hpsb_node_entry_valid(lu->ne))
+				return 0;
+
+			/* Maybe another initiator won the login. */
 			SBP2_ERR("Failed to reconnect to sbp2 device!");
 			return -EBUSY;
 		}

commit c921a9745705ed62a949192ef9128c60d6c63874
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 16 13:38:11 2008 +0200

    ieee1394: don't drop nodes during bus reset series
    
    nodemgr_node_probe checked for generation increments too late and
    therefore prematurely reported nodes as "suspended".
    
    Fixes http://bugzilla.kernel.org/show_bug.cgi?id=11349.  Reported and
    tested by Damien Benoist.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 2ebd09a..16240a7 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1574,6 +1574,9 @@ static int node_probe(struct device *dev, void *data)
 	struct probe_param *p = data;
 	struct node_entry *ne;
 
+	if (p->generation != get_hpsb_generation(p->hi->host))
+		return -EAGAIN;
+
 	ne = container_of(dev, struct node_entry, node_dev);
 	if (ne->needs_probe == p->probe_now)
 		nodemgr_probe_ne(p->hi, ne, p->generation);
@@ -1582,42 +1585,41 @@ static int node_probe(struct device *dev, void *data)
 
 static void nodemgr_node_probe(struct host_info *hi, int generation)
 {
-	struct hpsb_host *host = hi->host;
 	struct probe_param p;
 
 	p.hi = hi;
 	p.generation = generation;
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
 	p.probe_now = false;
-	class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe);
-	p.probe_now = true;
-	class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe);
+	if (class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe) != 0)
+		return;
 
-	/* If we had a bus reset while we were scanning the bus, it is
-	 * possible that we did not probe all nodes.  In that case, we
-	 * skip the clean up for now, since we could remove nodes that
-	 * were still on the bus.  Another bus scan is pending which will
-	 * do the clean up eventually.
-	 *
+	p.probe_now = true;
+	if (class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe) != 0)
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

commit 6848408abf1bc18d9a4d5fed3fcca812745ece05
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 16 13:36:47 2008 +0200

    ieee1394: regression in 2.6.25: updates should happen before probes
    
    Regression since commit 73cf60232ef16e1f8a64defa97214a1722db1e6c,
    "ieee1394: use class iteration api":  The two loops for (1.) driver
    updates and (2.) driver probes were replaced by a single loop with
    bogus needs_probe checks.  Hence updates and probes were now intermixed,
    and especially sbp2 updates (reconnects) held up longer than necessary.
    
    While we fix it, change the needs_probe flag to bool type for clarity.
    
    Tested by Damien Benoist.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 994a21e..2ebd09a 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -844,7 +844,7 @@ static struct node_entry *nodemgr_create_node(octlet_t guid, struct csr1212_csr
 	ne->host = host;
 	ne->nodeid = nodeid;
 	ne->generation = generation;
-	ne->needs_probe = 1;
+	ne->needs_probe = true;
 
 	ne->guid = guid;
 	ne->guid_vendor_id = (guid >> 40) & 0xffffff;
@@ -1144,7 +1144,7 @@ static void nodemgr_process_root_directory(struct host_info *hi, struct node_ent
 	struct csr1212_keyval *kv, *vendor_name_kv = NULL;
 	u8 last_key_id = 0;
 
-	ne->needs_probe = 0;
+	ne->needs_probe = false;
 
 	csr1212_for_each_dir_entry(ne->csr, kv, ne->csr->root_kv, dentry) {
 		switch (kv->key.id) {
@@ -1295,7 +1295,7 @@ static void nodemgr_update_node(struct node_entry *ne, struct csr1212_csr *csr,
 		nodemgr_update_bus_options(ne);
 
 		/* Mark the node as new, so it gets re-probed */
-		ne->needs_probe = 1;
+		ne->needs_probe = true;
 	} else {
 		/* old cache is valid, so update its generation */
 		struct nodemgr_csr_info *ci = ne->csr->private;
@@ -1566,28 +1566,27 @@ static void nodemgr_probe_ne(struct host_info *hi, struct node_entry *ne, int ge
 struct probe_param {
 	struct host_info *hi;
 	int generation;
+	bool probe_now;
 };
 
-static int __nodemgr_node_probe(struct device *dev, void *data)
+static int node_probe(struct device *dev, void *data)
 {
-	struct probe_param *param = (struct probe_param *)data;
+	struct probe_param *p = data;
 	struct node_entry *ne;
 
 	ne = container_of(dev, struct node_entry, node_dev);
-	if (!ne->needs_probe)
-		nodemgr_probe_ne(param->hi, ne, param->generation);
-	if (ne->needs_probe)
-		nodemgr_probe_ne(param->hi, ne, param->generation);
+	if (ne->needs_probe == p->probe_now)
+		nodemgr_probe_ne(p->hi, ne, p->generation);
 	return 0;
 }
 
 static void nodemgr_node_probe(struct host_info *hi, int generation)
 {
 	struct hpsb_host *host = hi->host;
-	struct probe_param param;
+	struct probe_param p;
 
-	param.hi = hi;
-	param.generation = generation;
+	p.hi = hi;
+	p.generation = generation;
 	/* Do some processing of the nodes we've probed. This pulls them
 	 * into the sysfs layer if needed, and can result in processing of
 	 * unit-directories, or just updating the node and it's
@@ -1597,8 +1596,10 @@ static void nodemgr_node_probe(struct host_info *hi, int generation)
 	 * while probes are time-consuming. (Well, those probes need some
 	 * improvement...) */
 
-	class_for_each_device(&nodemgr_ne_class, NULL, &param,
-			      __nodemgr_node_probe);
+	p.probe_now = false;
+	class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe);
+	p.probe_now = true;
+	class_for_each_device(&nodemgr_ne_class, NULL, &p, node_probe);
 
 	/* If we had a bus reset while we were scanning the bus, it is
 	 * possible that we did not probe all nodes.  In that case, we
diff --git a/drivers/ieee1394/nodemgr.h b/drivers/ieee1394/nodemgr.h
index 919e92e..6eb2646 100644
--- a/drivers/ieee1394/nodemgr.h
+++ b/drivers/ieee1394/nodemgr.h
@@ -97,7 +97,7 @@ struct node_entry {
 	struct hpsb_host *host;		/* Host this node is attached to */
 	nodeid_t nodeid;		/* NodeID */
 	struct bus_options busopt;	/* Bus Options */
-	int needs_probe;
+	bool needs_probe;
 	unsigned int generation;	/* Synced with hpsb generation */
 
 	/* The following is read from the config rom */


Thanks,
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/

