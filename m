Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYGVFcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYGVFcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYGVFXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128AbYGVFXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 32/79] Driver Core: add ability for class_find_device to start in middle of list
Date: Mon, 21 Jul 2008 22:18:56 -0700
Message-Id: <1216703983-21448-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mirrors the functionality that driver_find_device has as well.

We add a start variable, and all callers of the function are fixed up at
the same time.

The block layer will be using this new functionality in a follow-on
patch.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c                |   22 +++++++++++++---------
 drivers/base/core.c                 |    2 +-
 drivers/ieee1394/nodemgr.c          |    9 ++++++---
 drivers/rtc/interface.c             |    2 +-
 drivers/scsi/hosts.c                |    3 ++-
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 drivers/spi/spi.c                   |    2 +-
 include/linux/device.h              |    3 ++-
 8 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 2eb7048..3918d0e 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -302,6 +302,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device);
 /**
  * class_find_device - device iterator for locating a particular device
  * @class: the class we're iterating
+ * @start: Device to begin with
  * @data: data for the match function
  * @match: function to check device
  *
@@ -319,8 +320,9 @@ EXPORT_SYMBOL_GPL(class_for_each_device);
  * re-acquired in @match, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
-struct device *class_find_device(struct class *class, void *data,
-				   int (*match)(struct device *, void *))
+struct device *class_find_device(struct class *class, struct device *start,
+				 void *data,
+				 int (*match)(struct device *, void *))
 {
 	struct device *dev;
 	int found = 0;
@@ -330,15 +332,17 @@ struct device *class_find_device(struct class *class, void *data,
 
 	down(&class->sem);
 	list_for_each_entry(dev, &class->devices, node) {
+		if (start) {
+			if (start == dev)
+				start = NULL;
+			continue;
+		}
 		dev = get_device(dev);
-		if (dev) {
-			if (match(dev, data)) {
-				found = 1;
-				break;
-			} else
-				put_device(dev);
-		} else
+		if (match(dev, data)) {
+			found = 1;
 			break;
+		} else
+			put_device(dev);
 	}
 	up(&class->sem);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9ae28aa..9f05de6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1289,7 +1289,7 @@ void device_destroy(struct class *class, dev_t devt)
 {
 	struct device *dev;
 
-	dev = class_find_device(class, &devt, __match_devt);
+	dev = class_find_device(class, NULL, &devt, __match_devt);
 	if (dev) {
 		put_device(dev);
 		device_unregister(dev);
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 47c0d85..994a21e 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -754,7 +754,8 @@ static void nodemgr_remove_uds(struct node_entry *ne)
 	 */
 	mutex_lock(&nodemgr_serialize_remove_uds);
 	for (;;) {
-		dev = class_find_device(&nodemgr_ud_class, ne, __match_ne);
+		dev = class_find_device(&nodemgr_ud_class, NULL, ne,
+					__match_ne);
 		if (!dev)
 			break;
 		ud = container_of(dev, struct unit_directory, unit_dev);
@@ -901,7 +902,8 @@ static struct node_entry *find_entry_by_guid(u64 guid)
 	struct device *dev;
 	struct node_entry *ne;
 
-	dev = class_find_device(&nodemgr_ne_class, &guid, __match_ne_guid);
+	dev = class_find_device(&nodemgr_ne_class, NULL, &guid,
+				__match_ne_guid);
 	if (!dev)
 		return NULL;
 	ne = container_of(dev, struct node_entry, node_dev);
@@ -940,7 +942,8 @@ static struct node_entry *find_entry_by_nodeid(struct hpsb_host *host,
 	param.host = host;
 	param.nodeid = nodeid;
 
-	dev = class_find_device(&nodemgr_ne_class, &param, __match_ne_nodeid);
+	dev = class_find_device(&nodemgr_ne_class, NULL, &param,
+				__match_ne_nodeid);
 	if (!dev)
 		return NULL;
 	ne = container_of(dev, struct node_entry, node_dev);
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 58b7336..d397fa5 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -345,7 +345,7 @@ struct rtc_device *rtc_class_open(char *name)
 	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
-	dev = class_find_device(rtc_class, name, __rtc_match);
+	dev = class_find_device(rtc_class, NULL, name, __rtc_match);
 	if (dev)
 		rtc = to_rtc_device(dev);
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 35cd892..78dad28 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -466,7 +466,8 @@ struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 	struct device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
-	cdev = class_find_device(&shost_class, &hostnum, __scsi_host_match);
+	cdev = class_find_device(&shost_class, NULL, &hostnum,
+				 __scsi_host_match);
 	if (cdev) {
 		shost = scsi_host_get(class_to_shost(cdev));
 		put_device(cdev);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3af7cbc..06748f3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -170,7 +170,7 @@ iscsi_create_endpoint(int dd_size)
 	int err;
 
 	for (id = 1; id < ISCSI_MAX_EPID; id++) {
-		dev = class_find_device(&iscsi_endpoint_class, &id,
+		dev = class_find_device(&iscsi_endpoint_class, NULL, &id,
 					iscsi_match_epid);
 		if (!dev)
 			break;
@@ -222,7 +222,7 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 	struct iscsi_endpoint *ep;
 	struct device *dev;
 
-	dev = class_find_device(&iscsi_endpoint_class, &handle,
+	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
 				iscsi_match_epid);
 	if (!dev)
 		return NULL;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1ad12af..1771b24 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -502,7 +502,7 @@ struct spi_master *spi_busnum_to_master(u16 bus_num)
 	struct device		*dev;
 	struct spi_master	*master = NULL;
 
-	dev = class_find_device(&spi_master_class, &bus_num,
+	dev = class_find_device(&spi_master_class, NULL, &bus_num,
 				__spi_master_match);
 	if (dev)
 		master = container_of(dev, struct spi_master, dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index 6d5b351..c1f7298 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -213,7 +213,8 @@ extern void class_unregister(struct class *class);
 extern int class_for_each_device(struct class *class, struct device *start,
 				 void *data,
 				 int (*fn)(struct device *dev, void *data));
-extern struct device *class_find_device(struct class *class, void *data,
+extern struct device *class_find_device(struct class *class,
+					struct device *start, void *data,
 					int (*match)(struct device *, void *));
 
 struct class_attribute {
-- 
1.5.6.3

