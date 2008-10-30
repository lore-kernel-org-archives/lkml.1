Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYJ3A5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYJ3A5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbYJ3A5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:57:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:16834 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbYJ3A5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:57:07 -0400
Subject: s390: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:57:07 +0100
Message-Id: <1225328227.5970.51.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: s390: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 921443b..feceb89 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -23,6 +23,7 @@
 
 /* This is ugly... */
 #define PRINTK_HEADER "dasd_devmap:"
+#define DASD_BUS_ID_SIZE 20
 
 #include "dasd_int.h"
 
@@ -41,7 +42,7 @@ EXPORT_SYMBOL_GPL(dasd_page_cache);
  */
 struct dasd_devmap {
 	struct list_head list;
-	char bus_id[BUS_ID_SIZE];
+	char bus_id[DASD_BUS_ID_SIZE];
         unsigned int devindex;
         unsigned short features;
 	struct dasd_device *device;
@@ -94,7 +95,7 @@ dasd_hash_busid(const char *bus_id)
 	int hash, i;
 
 	hash = 0;
-	for (i = 0; (i < BUS_ID_SIZE) && *bus_id; i++, bus_id++)
+	for (i = 0; (i < DASD_BUS_ID_SIZE) && *bus_id; i++, bus_id++)
 		hash += *bus_id;
 	return hash & 0xff;
 }
@@ -301,7 +302,7 @@ dasd_parse_range( char *parsestring ) {
 	int from, from_id0, from_id1;
 	int to, to_id0, to_id1;
 	int features, rc;
-	char bus_id[BUS_ID_SIZE+1], *str;
+	char bus_id[DASD_BUS_ID_SIZE+1], *str;
 
 	str = parsestring;
 	rc = dasd_busid(&str, &from_id0, &from_id1, &from);
@@ -407,14 +408,14 @@ dasd_add_busid(const char *bus_id, int features)
 	devmap = NULL;
 	hash = dasd_hash_busid(bus_id);
 	list_for_each_entry(tmp, &dasd_hashlists[hash], list)
-		if (strncmp(tmp->bus_id, bus_id, BUS_ID_SIZE) == 0) {
+		if (strncmp(tmp->bus_id, bus_id, DASD_BUS_ID_SIZE) == 0) {
 			devmap = tmp;
 			break;
 		}
 	if (!devmap) {
 		/* This bus_id is new. */
 		new->devindex = dasd_max_devindex++;
-		strncpy(new->bus_id, bus_id, BUS_ID_SIZE);
+		strncpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);
 		new->features = features;
 		new->device = NULL;
 		list_add(&new->list, &dasd_hashlists[hash]);
@@ -439,7 +440,7 @@ dasd_find_busid(const char *bus_id)
 	devmap = ERR_PTR(-ENODEV);
 	hash = dasd_hash_busid(bus_id);
 	list_for_each_entry(tmp, &dasd_hashlists[hash], list) {
-		if (strncmp(tmp->bus_id, bus_id, BUS_ID_SIZE) == 0) {
+		if (strncmp(tmp->bus_id, bus_id, DASD_BUS_ID_SIZE) == 0) {
 			devmap = tmp;
 			break;
 		}
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 63f26a1..b1b204c 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -21,6 +21,7 @@
 #define DCSSBLK_NAME "dcssblk"
 #define DCSSBLK_MINORS_PER_DISK 1
 #define DCSSBLK_PARM_LEN 400
+#define DCSS_BUS_ID_SIZE 20
 
 #ifdef DCSSBLK_DEBUG
 #define PRINT_DEBUG(x...) printk(KERN_DEBUG DCSSBLK_NAME " debug: " x)
@@ -50,7 +51,7 @@ static struct block_device_operations dcssblk_devops = {
 struct dcssblk_dev_info {
 	struct list_head lh;
 	struct device dev;
-	char segment_name[BUS_ID_SIZE];
+	char segment_name[DCSS_BUS_ID_SIZE];
 	atomic_t use_count;
 	struct gendisk *gd;
 	unsigned long start;
@@ -65,7 +66,7 @@ struct dcssblk_dev_info {
 
 struct segment_info {
 	struct list_head lh;
-	char segment_name[BUS_ID_SIZE];
+	char segment_name[DCSS_BUS_ID_SIZE];
 	unsigned long start;
 	unsigned long end;
 	int segment_type;
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 3ac2c20..17fa009 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -19,6 +19,8 @@
 #include <asm/ccwdev.h>
 #include <asm/ccwgroup.h>
 
+#define CCW_BUS_ID_SIZE		20
+
 /* In Linux 2.4, we had a channel device layer called "chandev"
  * that did all sorts of obscure stuff for networking devices.
  * This is another driver that serves as a replacement for just
@@ -172,7 +174,7 @@ static int __get_next_bus_id(const char **buf, char *bus_id)
 		len = end - start + 1;
 		end++;
 	}
-	if (len < BUS_ID_SIZE) {
+	if (len < CCW_BUS_ID_SIZE) {
 		strlcpy(bus_id, start, len);
 		rc = 0;
 	} else
@@ -181,7 +183,7 @@ static int __get_next_bus_id(const char **buf, char *bus_id)
 	return rc;
 }
 
-static int __is_valid_bus_id(char bus_id[BUS_ID_SIZE])
+static int __is_valid_bus_id(char bus_id[CCW_BUS_ID_SIZE])
 {
 	int cssid, ssid, devno;
 
@@ -213,7 +215,7 @@ int ccwgroup_create_from_string(struct device *root, unsigned int creator_id,
 {
 	struct ccwgroup_device *gdev;
 	int rc, i;
-	char tmp_bus_id[BUS_ID_SIZE];
+	char tmp_bus_id[CCW_BUS_ID_SIZE];
 	const char *curr_buf;
 
 	gdev = kzalloc(sizeof(*gdev) + num_devices * sizeof(gdev->cdev[0]),
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 4e78c82..8aca8e0 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1719,7 +1719,7 @@ __ccwdev_check_busid(struct device *dev, void *id)
 
 	bus_id = id;
 
-	return (strncmp(bus_id, dev_name(dev), BUS_ID_SIZE) == 0);
+	return (strcmp(bus_id, dev_name(dev)) == 0);
 }
 
 
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 3b56220..82cc618 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -28,6 +28,8 @@
 #include <linux/miscdevice.h>
 #include "zfcp_ext.h"
 
+#define ZFCP_BUS_ID_SIZE	20
+
 static char *device;
 
 MODULE_AUTHOR("IBM Deutschland Entwicklung GmbH - linux390@de.ibm.com");
@@ -83,9 +85,9 @@ static int __init zfcp_device_setup(char *devstr)
 	strcpy(str, devstr);
 
 	token = strsep(&str, ",");
-	if (!token || strlen(token) >= BUS_ID_SIZE)
+	if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
 		goto err_out;
-	strncpy(zfcp_data.init_busid, token, BUS_ID_SIZE);
+	strncpy(zfcp_data.init_busid, token, ZFCP_BUS_ID_SIZE);
 
 	token = strsep(&str, ",");
 	if (!token || strict_strtoull(token, 0,

