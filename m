Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYJ3At3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYJ3At3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYJ3AtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:49:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:54543 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYJ3AtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:49:19 -0400
Subject: ieee1394: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:49:20 +0100
Message-Id: <1225327760.5970.41.camel@nga.site>
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
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Subject: ieee1394: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/ieee1394/hosts.c b/drivers/ieee1394/hosts.c
index 8dd09d8..237d0c9 100644
--- a/drivers/ieee1394/hosts.c
+++ b/drivers/ieee1394/hosts.c
@@ -155,11 +155,11 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 	memcpy(&h->device, &nodemgr_dev_template_host, sizeof(h->device));
 	h->device.parent = dev;
 	set_dev_node(&h->device, dev_to_node(dev));
-	snprintf(h->device.bus_id, BUS_ID_SIZE, "fw-host%d", h->id);
+	dev_set_name(&h->device, "fw-host%d", h->id);
 
 	h->host_dev.parent = &h->device;
 	h->host_dev.class = &hpsb_host_class;
-	snprintf(h->host_dev.bus_id, BUS_ID_SIZE, "fw-host%d", h->id);
+	dev_set_name(&h->host_dev, "fw-host%d", h->id);
 
 	if (device_register(&h->device))
 		goto fail;
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 2376b72..9e39f73 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -826,13 +826,11 @@ static struct node_entry *nodemgr_create_node(octlet_t guid,
 	memcpy(&ne->device, &nodemgr_dev_template_ne,
 	       sizeof(ne->device));
 	ne->device.parent = &host->device;
-	snprintf(ne->device.bus_id, BUS_ID_SIZE, "%016Lx",
-		 (unsigned long long)(ne->guid));
+	dev_set_name(&ne->device, "%016Lx", (unsigned long long)(ne->guid));
 
 	ne->node_dev.parent = &ne->device;
 	ne->node_dev.class = &nodemgr_ne_class;
-	snprintf(ne->node_dev.bus_id, BUS_ID_SIZE, "%016Lx",
-		(unsigned long long)(ne->guid));
+	dev_set_name(&ne->node_dev, "%016Lx", (unsigned long long)(ne->guid));
 
 	if (device_register(&ne->device))
 		goto fail_devreg;
@@ -932,13 +930,11 @@ static void nodemgr_register_device(struct node_entry *ne,
 
 	ud->device.parent = parent;
 
-	snprintf(ud->device.bus_id, BUS_ID_SIZE, "%s-%u",
-		 ne->device.bus_id, ud->id);
+	dev_set_name(&ud->device, "%s-%u", dev_name(&ne->device), ud->id);
 
 	ud->unit_dev.parent = &ud->device;
 	ud->unit_dev.class = &nodemgr_ud_class;
-	snprintf(ud->unit_dev.bus_id, BUS_ID_SIZE, "%s-%u",
-		 ne->device.bus_id, ud->id);
+	dev_set_name(&ud->unit_dev, "%s-%u", dev_name(&ne->device), ud->id);
 
 	if (device_register(&ud->device))
 		goto fail_devreg;
@@ -953,7 +949,7 @@ static void nodemgr_register_device(struct node_entry *ne,
 fail_classdevreg:
 	device_unregister(&ud->device);
 fail_devreg:
-	HPSB_ERR("Failed to create unit %s", ud->device.bus_id);
+	HPSB_ERR("Failed to create unit %s", dev_name(&ud->device));
 }	
 
 

