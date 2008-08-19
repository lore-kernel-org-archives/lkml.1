Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYHST3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYHST3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYHST3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:29:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38496 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYHST3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:29:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Aug 2008 21:29:23 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 1/2] ieee1394: nodemgr clean up class iterators
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, damien_benoist@yahoo.com
In-Reply-To: <tkrat.3829f18186b21759@s5r6.in-berlin.de>
Message-ID: <tkrat.a7680a3ca1cdeb42@s5r6.in-berlin.de>
References: <994096.81924.qm@web50505.mail.re2.yahoo.com>
 <48A5A80A.90506@s5r6.in-berlin.de> <48A6BA6F.2030000@s5r6.in-berlin.de>
 <tkrat.bdb066b22ec930a0@s5r6.in-berlin.de>
 <tkrat.a3ef08493991acb0@s5r6.in-berlin.de>
 <tkrat.3829f18186b21759@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless pointer type casts.
Remove unnecessary hi->host indirection where only host is used.
Remove an unnecessary WARN_ON.
Change a few names.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |  178 ++++++++++++++++---------------------
 1 file changed, 81 insertions(+), 97 deletions(-)

Index: linux-2.6.27-rc3/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.27-rc3.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.27-rc3/drivers/ieee1394/nodemgr.c
@@ -154,7 +154,7 @@ struct host_info {
 
 static int nodemgr_bus_match(struct device * dev, struct device_driver * drv);
 static int nodemgr_uevent(struct device *dev, struct kobj_uevent_env *env);
-static void nodemgr_resume_ne(struct node_entry *ne);
+static void nodemgr_reactivate_ne(struct node_entry *ne);
 static void nodemgr_remove_ne(struct node_entry *ne);
 static struct node_entry *find_entry_by_guid(u64 guid);
 
@@ -734,10 +734,10 @@ static int nodemgr_bus_match(struct devi
 
 static DEFINE_MUTEX(nodemgr_serialize_remove_uds);
 
-static int __match_ne(struct device *dev, void *data)
+static int match_ne(struct device *dev, void *data)
 {
 	struct unit_directory *ud;
-	struct node_entry *ne = (struct node_entry *)data;
+	struct node_entry *ne = data;
 
 	ud = container_of(dev, struct unit_directory, unit_dev);
 	return ud->ne == ne;
@@ -754,8 +754,7 @@ static void nodemgr_remove_uds(struct no
 	 */
 	mutex_lock(&nodemgr_serialize_remove_uds);
 	for (;;) {
-		dev = class_find_device(&nodemgr_ud_class, NULL, ne,
-					__match_ne);
+		dev = class_find_device(&nodemgr_ud_class, NULL, ne, match_ne);
 		if (!dev)
 			break;
 		ud = container_of(dev, struct unit_directory, unit_dev);
@@ -785,7 +784,7 @@ static void nodemgr_remove_ne(struct nod
 	put_device(dev);
 }
 
-static int __nodemgr_remove_host_dev(struct device *dev, void *data)
+static int remove_host_dev(struct device *dev, void *data)
 {
 	if (dev->bus == &ieee1394_bus_type)
 		nodemgr_remove_ne(container_of(dev, struct node_entry,
@@ -795,7 +794,7 @@ static int __nodemgr_remove_host_dev(str
 
 static void nodemgr_remove_host_dev(struct device *dev)
 {
-	WARN_ON(device_for_each_child(dev, NULL, __nodemgr_remove_host_dev));
+	device_for_each_child(dev, NULL, remove_host_dev);
 	sysfs_remove_link(&dev->kobj, "irm_id");
 	sysfs_remove_link(&dev->kobj, "busmgr_id");
 	sysfs_remove_link(&dev->kobj, "host_id");
@@ -830,11 +829,10 @@ static void nodemgr_update_bus_options(s
 }
 
 
-static struct node_entry *nodemgr_create_node(octlet_t guid, struct csr1212_csr *csr,
-					      struct host_info *hi, nodeid_t nodeid,
-					      unsigned int generation)
+static struct node_entry *nodemgr_create_node(octlet_t guid,
+				struct csr1212_csr *csr, struct hpsb_host *host,
+				nodeid_t nodeid, unsigned int generation)
 {
-	struct hpsb_host *host = hi->host;
 	struct node_entry *ne;
 
 	ne = kzalloc(sizeof(*ne), GFP_KERNEL);
@@ -888,10 +886,10 @@ fail_alloc:
 	return NULL;
 }
 
-static int __match_ne_guid(struct device *dev, void *data)
+static int match_ne_guid(struct device *dev, void *data)
 {
 	struct node_entry *ne;
-	u64 *guid = (u64 *)data;
+	u64 *guid = data;
 
 	ne = container_of(dev, struct node_entry, node_dev);
 	return ne->guid == *guid;
@@ -902,8 +900,7 @@ static struct node_entry *find_entry_by_
 	struct device *dev;
 	struct node_entry *ne;
 
-	dev = class_find_device(&nodemgr_ne_class, NULL, &guid,
-				__match_ne_guid);
+	dev = class_find_device(&nodemgr_ne_class, NULL, &guid, match_ne_guid);
 	if (!dev)
 		return NULL;
 	ne = container_of(dev, struct node_entry, node_dev);
@@ -912,21 +909,21 @@ static struct node_entry *find_entry_by_
 	return ne;
 }
 
-struct match_nodeid_param {
+struct match_nodeid_parameter {
 	struct hpsb_host *host;
 	nodeid_t nodeid;
 };
 
-static int __match_ne_nodeid(struct device *dev, void *data)
+static int match_ne_nodeid(struct device *dev, void *data)
 {
 	int found = 0;
 	struct node_entry *ne;
-	struct match_nodeid_param *param = (struct match_nodeid_param *)data;
+	struct match_nodeid_parameter *p = data;
 
 	if (!dev)
 		goto ret;
 	ne = container_of(dev, struct node_entry, node_dev);
-	if (ne->host == param->host && ne->nodeid == param->nodeid)
+	if (ne->host == p->host && ne->nodeid == p->nodeid)
 		found = 1;
 ret:
 	return found;
@@ -937,13 +934,12 @@ static struct node_entry *find_entry_by_
 {
 	struct device *dev;
 	struct node_entry *ne;
-	struct match_nodeid_param param;
+	struct match_nodeid_parameter p;
 
-	param.host = host;
-	param.nodeid = nodeid;
+	p.host = host;
+	p.nodeid = nodeid;
 
-	dev = class_find_device(&nodemgr_ne_class, NULL, &param,
-				__match_ne_nodeid);
+	dev = class_find_device(&nodemgr_ne_class, NULL, &p, match_ne_nodeid);
 	if (!dev)
 		return NULL;
 	ne = container_of(dev, struct node_entry, node_dev);
@@ -990,7 +986,7 @@ fail_devreg:
  * immediate unit directories looking for software_id and
  * software_version entries, in order to get driver autoloading working. */
 static struct unit_directory *nodemgr_process_unit_directory
-	(struct host_info *hi, struct node_entry *ne, struct csr1212_keyval *ud_kv,
+	(struct node_entry *ne, struct csr1212_keyval *ud_kv,
 	 unsigned int *id, struct unit_directory *parent)
 {
 	struct unit_directory *ud;
@@ -1083,7 +1079,7 @@ static struct unit_directory *nodemgr_pr
 					nodemgr_register_device(ne, ud, &ne->device);
 				
 				/* process the child unit */
-				ud_child = nodemgr_process_unit_directory(hi, ne, kv, id, ud);
+				ud_child = nodemgr_process_unit_directory(ne, kv, id, ud);
 
 				if (ud_child == NULL)
 					break;
@@ -1137,7 +1133,7 @@ unit_directory_error:
 }
 
 
-static void nodemgr_process_root_directory(struct host_info *hi, struct node_entry *ne)
+static void nodemgr_process_root_directory(struct node_entry *ne)
 {
 	unsigned int ud_id = 0;
 	struct csr1212_dentry *dentry;
@@ -1157,7 +1153,7 @@ static void nodemgr_process_root_directo
 			break;
 
 		case CSR1212_KV_ID_UNIT:
-			nodemgr_process_unit_directory(hi, ne, kv, &ud_id, NULL);
+			nodemgr_process_unit_directory(ne, kv, &ud_id, NULL);
 			break;
 
 		case CSR1212_KV_ID_DESCRIPTOR:
@@ -1273,8 +1269,7 @@ void hpsb_unregister_protocol(struct hps
  * the to take whatever actions required.
  */
 static void nodemgr_update_node(struct node_entry *ne, struct csr1212_csr *csr,
-				struct host_info *hi, nodeid_t nodeid,
-				unsigned int generation)
+				nodeid_t nodeid, unsigned int generation)
 {
 	if (ne->nodeid != nodeid) {
 		HPSB_DEBUG("Node changed: " NODE_BUS_FMT " -> " NODE_BUS_FMT,
@@ -1306,7 +1301,7 @@ static void nodemgr_update_node(struct n
 	}
 
 	if (ne->in_limbo)
-		nodemgr_resume_ne(ne);
+		nodemgr_reactivate_ne(ne);
 
 	/* Mark the node current */
 	ne->generation = generation;
@@ -1314,10 +1309,9 @@ static void nodemgr_update_node(struct n
 
 
 
-static void nodemgr_node_scan_one(struct host_info *hi,
+static void nodemgr_node_scan_one(struct hpsb_host *host,
 				  nodeid_t nodeid, int generation)
 {
-	struct hpsb_host *host = hi->host;
 	struct node_entry *ne;
 	octlet_t guid;
 	struct csr1212_csr *csr;
@@ -1373,16 +1367,15 @@ static void nodemgr_node_scan_one(struct
 	}
 
 	if (!ne)
-		nodemgr_create_node(guid, csr, hi, nodeid, generation);
+		nodemgr_create_node(guid, csr, host, nodeid, generation);
 	else
-		nodemgr_update_node(ne, csr, hi, nodeid, generation);
+		nodemgr_update_node(ne, csr, nodeid, generation);
 }
 
 
-static void nodemgr_node_scan(struct host_info *hi, int generation)
+static void nodemgr_node_scan(struct hpsb_host *host, int generation)
 {
 	int count;
-	struct hpsb_host *host = hi->host;
 	struct selfid *sid = (struct selfid *)host->topology_map;
 	nodeid_t nodeid = LOCAL_BUS;
 
@@ -1395,15 +1388,15 @@ static void nodemgr_node_scan(struct hos
 			nodeid++;
 			continue;
 		}
-		nodemgr_node_scan_one(hi, nodeid++, generation);
+		nodemgr_node_scan_one(host, nodeid++, generation);
 	}
 }
 
-static int __nodemgr_driver_suspend(struct device *dev, void *data)
+static int pause_ne(struct device *dev, void *data)
 {
 	struct unit_directory *ud;
 	struct device_driver *drv;
-	struct node_entry *ne = (struct node_entry *)data;
+	struct node_entry *ne = data;
 	int error;
 
 	ud = container_of(dev, struct unit_directory, unit_dev);
@@ -1425,11 +1418,23 @@ static int __nodemgr_driver_suspend(stru
 	return 0;
 }
 
-static int __nodemgr_driver_resume(struct device *dev, void *data)
+static void nodemgr_pause_ne(struct node_entry *ne)
+{
+	HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
+		   NODE_BUS_ARGS(ne->host, ne->nodeid),
+		   (unsigned long long)ne->guid);
+
+	ne->in_limbo = 1;
+	WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
+
+	class_for_each_device(&nodemgr_ud_class, NULL, ne, pause_ne);
+}
+
+static int reactivate_ne(struct device *dev, void *data)
 {
 	struct unit_directory *ud;
 	struct device_driver *drv;
-	struct node_entry *ne = (struct node_entry *)data;
+	struct node_entry *ne = data;
 
 	ud = container_of(dev, struct unit_directory, unit_dev);
 	if (ud->ne == ne) {
@@ -1447,37 +1452,23 @@ static int __nodemgr_driver_resume(struc
 	return 0;
 }
 
-static void nodemgr_suspend_ne(struct node_entry *ne)
-{
-	HPSB_DEBUG("Node suspended: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
-		   NODE_BUS_ARGS(ne->host, ne->nodeid),
-		   (unsigned long long)ne->guid);
-
-	ne->in_limbo = 1;
-	WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
-
-	class_for_each_device(&nodemgr_ud_class, NULL, ne,
-			      __nodemgr_driver_suspend);
-}
-
-
-static void nodemgr_resume_ne(struct node_entry *ne)
+static void nodemgr_reactivate_ne(struct node_entry *ne)
 {
 	ne->in_limbo = 0;
 	device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
 
-	class_for_each_device(&nodemgr_ud_class, NULL, ne,
-			      __nodemgr_driver_resume);
+	class_for_each_device(&nodemgr_ud_class, NULL, ne, reactivate_ne);
 	HPSB_DEBUG("Node resumed: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
-		   NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
+		   NODE_BUS_ARGS(ne->host, ne->nodeid),
+		   (unsigned long long)ne->guid);
 }
 
-static int __nodemgr_update_pdrv(struct device *dev, void *data)
+static int update_pdrv(struct device *dev, void *data)
 {
 	struct unit_directory *ud;
 	struct device_driver *drv;
 	struct hpsb_protocol_driver *pdrv;
-	struct node_entry *ne = (struct node_entry *)data;
+	struct node_entry *ne = data;
 	int error;
 
 	ud = container_of(dev, struct unit_directory, unit_dev);
@@ -1503,8 +1494,7 @@ static int __nodemgr_update_pdrv(struct 
 
 static void nodemgr_update_pdrv(struct node_entry *ne)
 {
-	class_for_each_device(&nodemgr_ud_class, NULL, ne,
-			      __nodemgr_update_pdrv);
+	class_for_each_device(&nodemgr_ud_class, NULL, ne, update_pdrv);
 }
 
 
@@ -1535,11 +1525,12 @@ static void nodemgr_irm_write_bc(struct 
 }
 
 
-static void nodemgr_probe_ne(struct host_info *hi, struct node_entry *ne, int generation)
+static void nodemgr_probe_ne(struct hpsb_host *host, struct node_entry *ne,
+			     int generation)
 {
 	struct device *dev;
 
-	if (ne->host != hi->host || ne->in_limbo)
+	if (ne->host != host || ne->in_limbo)
 		return;
 
 	dev = get_device(&ne->device);
@@ -1554,40 +1545,40 @@ static void nodemgr_probe_ne(struct host
 	 * down to the drivers. Otherwise, this is a dead node and we
 	 * suspend it. */
 	if (ne->needs_probe)
-		nodemgr_process_root_directory(hi, ne);
+		nodemgr_process_root_directory(ne);
 	else if (ne->generation == generation)
 		nodemgr_update_pdrv(ne);
 	else
-		nodemgr_suspend_ne(ne);
+		nodemgr_pause_ne(ne);
 
 	put_device(dev);
 }
 
-struct probe_param {
-	struct host_info *hi;
+struct node_probe_parameter {
+	struct hpsb_host *host;
 	int generation;
 	bool probe_now;
 };
 
 static int node_probe(struct device *dev, void *data)
 {
-	struct probe_param *p = data;
+	struct node_probe_parameter *p = data;
 	struct node_entry *ne;
 
-	if (p->generation != get_hpsb_generation(p->hi->host))
+	if (p->generation != get_hpsb_generation(p->host))
 		return -EAGAIN;
 
 	ne = container_of(dev, struct node_entry, node_dev);
 	if (ne->needs_probe == p->probe_now)
-		nodemgr_probe_ne(p->hi, ne, p->generation);
+		nodemgr_probe_ne(p->host, ne, p->generation);
 	return 0;
 }
 
-static void nodemgr_node_probe(struct host_info *hi, int generation)
+static void nodemgr_node_probe(struct hpsb_host *host, int generation)
 {
-	struct probe_param p;
+	struct node_probe_parameter p;
 
-	p.hi = hi;
+	p.host = host;
 	p.generation = generation;
 	/*
 	 * Do some processing of the nodes we've probed. This pulls them
@@ -1730,10 +1721,9 @@ static int nodemgr_check_irm_capability(
 	return 1;
 }
 
-static int nodemgr_host_thread(void *__hi)
+static int nodemgr_host_thread(void *data)
 {
-	struct host_info *hi = (struct host_info *)__hi;
-	struct hpsb_host *host = hi->host;
+	struct hpsb_host *host = data;
 	unsigned int g, generation = 0;
 	int i, reset_cycles = 0;
 
@@ -1787,11 +1777,11 @@ static int nodemgr_host_thread(void *__h
 		 * entries. This does not do the sysfs stuff, since that
 		 * would trigger uevents and such, which is a bad idea at
 		 * this point. */
-		nodemgr_node_scan(hi, generation);
+		nodemgr_node_scan(host, generation);
 
 		/* This actually does the full probe, with sysfs
 		 * registration. */
-		nodemgr_node_probe(hi, generation);
+		nodemgr_node_probe(host, generation);
 
 		/* Update some of our sysfs symlinks */
 		nodemgr_update_host_dev_links(host);
@@ -1801,22 +1791,20 @@ exit:
 	return 0;
 }
 
-struct host_iter_param {
+struct per_host_parameter {
 	void *data;
 	int (*cb)(struct hpsb_host *, void *);
 };
 
-static int __nodemgr_for_each_host(struct device *dev, void *data)
+static int per_host(struct device *dev, void *data)
 {
 	struct hpsb_host *host;
-	struct host_iter_param *hip = (struct host_iter_param *)data;
-	int error = 0;
+	struct per_host_parameter *p = data;
 
 	host = container_of(dev, struct hpsb_host, host_dev);
-	error = hip->cb(host, hip->data);
-
-	return error;
+	return p->cb(host, p->data);
 }
+
 /**
  * nodemgr_for_each_host - call a function for each IEEE 1394 host
  * @data: an address to supply to the callback
@@ -1831,15 +1819,11 @@ static int __nodemgr_for_each_host(struc
  */
 int nodemgr_for_each_host(void *data, int (*cb)(struct hpsb_host *, void *))
 {
-	struct host_iter_param hip;
-	int error;
+	struct per_host_parameter p;
 
-	hip.cb = cb;
-	hip.data = data;
-	error = class_for_each_device(&hpsb_host_class, NULL, &hip,
-				      __nodemgr_for_each_host);
-
-	return error;
+	p.cb = cb;
+	p.data = data;
+	return class_for_each_device(&hpsb_host_class, NULL, &p, per_host);
 }
 
 /* The following two convenience functions use a struct node_entry
@@ -1893,7 +1877,7 @@ static void nodemgr_add_host(struct hpsb
 		return;
 	}
 	hi->host = host;
-	hi->thread = kthread_run(nodemgr_host_thread, hi, "knodemgrd_%d",
+	hi->thread = kthread_run(nodemgr_host_thread, host, "knodemgrd_%d",
 				 host->id);
 	if (IS_ERR(hi->thread)) {
 		HPSB_ERR("NodeMgr: cannot start thread for host %d", host->id);

-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/

