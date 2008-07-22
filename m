Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbYGVFfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbYGVFfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYGVFYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:53908 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920AbYGVFYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH 41/79] infiniband: make cm_device use a struct device and not a kobject.
Date: Mon, 21 Jul 2008 22:19:05 -0700
Message-Id: <1216703983-21448-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This object really should be a struct device, or at least contain a
pointer to a struct device, as it is trying to create a separate device
tree outside of the main device tree.  This patch fixes this problem.

It is needed for the class core rework that is being done in the driver
core.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/cm.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 8dc4429..922d35f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -44,6 +44,7 @@
 #include <linux/spinlock.h>
 #include <linux/sysfs.h>
 #include <linux/workqueue.h>
+#include <linux/kdev_t.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_cm.h>
@@ -163,7 +164,7 @@ struct cm_port {
 struct cm_device {
 	struct list_head list;
 	struct ib_device *ib_device;
-	struct kobject dev_obj;
+	struct device *device;
 	u8 ack_delay;
 	struct cm_port *port[0];
 };
@@ -3618,18 +3619,6 @@ static struct kobj_type cm_port_obj_type = {
 	.release = cm_release_port_obj
 };
 
-static void cm_release_dev_obj(struct kobject *obj)
-{
-	struct cm_device *cm_dev;
-
-	cm_dev = container_of(obj, struct cm_device, dev_obj);
-	kfree(cm_dev);
-}
-
-static struct kobj_type cm_dev_obj_type = {
-	.release = cm_release_dev_obj
-};
-
 struct class cm_class = {
 	.name    = "infiniband_cm",
 };
@@ -3640,7 +3629,7 @@ static int cm_create_port_fs(struct cm_port *port)
 	int i, ret;
 
 	ret = kobject_init_and_add(&port->port_obj, &cm_port_obj_type,
-				   &port->cm_dev->dev_obj,
+				   &port->cm_dev->device->kobj,
 				   "%d", port->port_num);
 	if (ret) {
 		kfree(port);
@@ -3702,10 +3691,10 @@ static void cm_add_one(struct ib_device *ib_device)
 	cm_dev->ib_device = ib_device;
 	cm_get_ack_delay(cm_dev);
 
-	ret = kobject_init_and_add(&cm_dev->dev_obj, &cm_dev_obj_type,
-				   &cm_class.subsys.kobj, "%s",
-				   ib_device->name);
-	if (ret) {
+	cm_dev->device = device_create_drvdata(&cm_class, &ib_device->dev,
+					       MKDEV(0, 0), NULL,
+					       "%s", ib_device->name);
+	if (!cm_dev->device) {
 		kfree(cm_dev);
 		return;
 	}
@@ -3758,7 +3747,7 @@ error1:
 		ib_unregister_mad_agent(port->mad_agent);
 		cm_remove_port_fs(port);
 	}
-	kobject_put(&cm_dev->dev_obj);
+	device_unregister(cm_dev->device);
 }
 
 static void cm_remove_one(struct ib_device *ib_device)
@@ -3786,7 +3775,7 @@ static void cm_remove_one(struct ib_device *ib_device)
 		flush_workqueue(cm.wq);
 		cm_remove_port_fs(port);
 	}
-	kobject_put(&cm_dev->dev_obj);
+	device_unregister(cm_dev->device);
 }
 
 static int __init ib_cm_init(void)
-- 
1.5.6.3

