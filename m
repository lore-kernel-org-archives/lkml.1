Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYFMMqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYFMMqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYFMMqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:46:45 -0400
Received: from mail08.svc.cra.dublin.eircom.net ([159.134.118.24]:45073 "HELO
	mail08.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755618AbYFMMqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:46:44 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/2] virtio: Use bus_type probe and remove methods
Date: Fri, 13 Jun 2008 13:46:40 +0100
Message-Id: <1213361201-10854-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook up to the probe() and remove() methods in bus_type
rather than device_driver. The latter has been preferred
since 2.6.16.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 0f3c2bb..ab0aca7 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -71,13 +71,6 @@ static int virtio_uevent(struct device *_dv, struct kobj_uevent_env *env)
 			      dev->id.device, dev->id.vendor);
 }
 
-static struct bus_type virtio_bus = {
-	.name  = "virtio",
-	.match = virtio_dev_match,
-	.dev_attrs = virtio_dev_attrs,
-	.uevent = virtio_uevent,
-};
-
 static void add_status(struct virtio_device *dev, unsigned status)
 {
 	dev->config->set_status(dev, dev->config->get_status(dev) | status);
@@ -147,13 +140,20 @@ static int virtio_dev_remove(struct device *_d)
 	return 0;
 }
 
+static struct bus_type virtio_bus = {
+	.name  = "virtio",
+	.match = virtio_dev_match,
+	.dev_attrs = virtio_dev_attrs,
+	.uevent = virtio_uevent,
+	.probe = virtio_dev_probe,
+	.remove = virtio_dev_remove,
+};
+
 int register_virtio_driver(struct virtio_driver *driver)
 {
 	/* Catch this early. */
 	BUG_ON(driver->feature_table_size && !driver->feature_table);
 	driver->driver.bus = &virtio_bus;
-	driver->driver.probe = virtio_dev_probe;
-	driver->driver.remove = virtio_dev_remove;
 	return driver_register(&driver->driver);
 }
 EXPORT_SYMBOL_GPL(register_virtio_driver);
-- 
1.5.4.1

