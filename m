Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYHPLhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYHPLhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 07:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYHPLhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 07:37:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45775 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYHPLhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 07:37:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Aug 2008 13:36:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 1/3] ieee1394: regression in 2.6.25: updates should happen
 before probes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, damien_benoist@yahoo.com,
       Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <48A6BA6F.2030000@s5r6.in-berlin.de>
Message-ID: <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression since commit 73cf60232ef16e1f8a64defa97214a1722db1e6c,
"ieee1394: use class iteration api":  The two loops for (1.) driver
updates and (2.) driver probes were replaced by a single loop with
bogus needs_probe checks.  Hence updates and probes were now intermixed,
and especially sbp2 updates (reconnects) held up longer than necessary.

While we fix it, change the needs_probe flag to bool type for clarity.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

I will make sure that this goes into -stable too.

Dave, I won't Cc you on patch 2/3 and 3/3 of this series because they
are not related to the loop regression.

 drivers/ieee1394/nodemgr.c |   14 ++++++++------
 drivers/ieee1394/nodemgr.h |    2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -843,7 +843,7 @@ static struct node_entry *nodemgr_create
 	ne->host = host;
 	ne->nodeid = nodeid;
 	ne->generation = generation;
-	ne->needs_probe = 1;
+	ne->needs_probe = true;
 
 	ne->guid = guid;
 	ne->guid_vendor_id = (guid >> 40) & 0xffffff;
@@ -1141,7 +1141,7 @@ static void nodemgr_process_root_directo
 	struct csr1212_keyval *kv, *vendor_name_kv = NULL;
 	u8 last_key_id = 0;
 
-	ne->needs_probe = 0;
+	ne->needs_probe = false;
 
 	csr1212_for_each_dir_entry(ne->csr, kv, ne->csr->root_kv, dentry) {
 		switch (kv->key.id) {
@@ -1292,7 +1292,7 @@ static void nodemgr_update_node(struct n
 		nodemgr_update_bus_options(ne);
 
 		/* Mark the node as new, so it gets re-probed */
-		ne->needs_probe = 1;
+		ne->needs_probe = true;
 	} else {
 		/* old cache is valid, so update its generation */
 		struct nodemgr_csr_info *ci = ne->csr->private;
@@ -1560,6 +1560,7 @@ static void nodemgr_probe_ne(struct host
 struct probe_param {
 	struct host_info *hi;
 	int generation;
+	bool probe_now;
 };
 
 static int __nodemgr_node_probe(struct device *dev, void *data)
@@ -1568,9 +1569,7 @@ static int __nodemgr_node_probe(struct d
 	struct node_entry *ne;
 
 	ne = container_of(dev, struct node_entry, node_dev);
-	if (!ne->needs_probe)
-		nodemgr_probe_ne(param->hi, ne, param->generation);
-	if (ne->needs_probe)
+	if (ne->needs_probe == param->probe_now)
 		nodemgr_probe_ne(param->hi, ne, param->generation);
 	return 0;
 }
@@ -1591,6 +1590,9 @@ static void nodemgr_node_probe(struct ho
 	 * while probes are time-consuming. (Well, those probes need some
 	 * improvement...) */
 
+	param.probe_now = false;
+	class_for_each_device(&nodemgr_ne_class, &param, __nodemgr_node_probe);
+	param.probe_now = true;
 	class_for_each_device(&nodemgr_ne_class, &param, __nodemgr_node_probe);
 
 	/* If we had a bus reset while we were scanning the bus, it is
Index: linux/drivers/ieee1394/nodemgr.h
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.h
+++ linux/drivers/ieee1394/nodemgr.h
@@ -97,7 +97,7 @@ struct node_entry {
 	struct hpsb_host *host;		/* Host this node is attached to */
 	nodeid_t nodeid;		/* NodeID */
 	struct bus_options busopt;	/* Bus Options */
-	int needs_probe;
+	bool needs_probe;
 	unsigned int generation;	/* Synced with hpsb generation */
 
 	/* The following is read from the config rom */

-- 
Stefan Richter
-=====-==--- =--- =----
http://arcgraph.de/sr/

