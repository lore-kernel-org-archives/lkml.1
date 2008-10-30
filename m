Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYJ3BZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYJ3BZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYJ3BZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:25:28 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:59165 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYJ3BZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:25:26 -0400
Subject: infiniband: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Roland Dreier <rolandd@cisco.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:25:27 +0100
Message-Id: <1225329927.5970.80.camel@nga.site>
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
Subject: infiniband: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Roland Dreier <rolandd@cisco.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 4d10421..6167649 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -786,7 +786,7 @@ int ib_device_register_sysfs(struct ib_device *device)
 	class_dev->class      = &ib_class;
 	class_dev->driver_data = device;
 	class_dev->parent     = device->dma_device;
-	strlcpy(class_dev->bus_id, device->name, BUS_ID_SIZE);
+	dev_set_name(class_dev, device->name);
 
 	INIT_LIST_HEAD(&device->port_list);
 
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index e603736..51bd966 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1266,8 +1266,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 	ucm_dev->dev.parent = device->dma_device;
 	ucm_dev->dev.devt = ucm_dev->cdev.dev;
 	ucm_dev->dev.release = ib_ucm_release_dev;
-	snprintf(ucm_dev->dev.bus_id, BUS_ID_SIZE, "ucm%d",
-		 ucm_dev->devnum);
+	dev_set_name(&ucm_dev->dev, "ucm%d", ucm_dev->devnum);
 	if (device_register(&ucm_dev->dev))
 		goto err_cdev;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5b8b533..e5ebcbe 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1972,8 +1972,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 
 	host->dev.class = &srp_class;
 	host->dev.parent = device->dev->dma_device;
-	snprintf(host->dev.bus_id, BUS_ID_SIZE, "srp-%s-%d",
-		 device->dev->name, port);
+	dev_set_name(&host->dev, "srp-%s-%d", device->dev->name, port);
 
 	if (device_register(&host->dev))
 		goto free_host;


