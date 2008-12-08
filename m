Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYLHL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYLHL5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYLHLxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:53:13 -0500
Received: from mail25.svc.cra.dublin.eircom.net ([159.134.118.54]:47805 "HELO
	mail25.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756817AbYLHLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:53:09 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       Jiri Slaby <jirislaby@gmail.com>, Greg KH <gregkh@suse.de>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/2] lguest: do not statically allocate root device
Date: Mon,  8 Dec 2008 11:51:45 +0000
Message-Id: <1228737106-20034-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently we shouldn't be statically allocating the root device
object, so dynamically allocate it instead.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/lguest/lguest_device.c |   44 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index b02f6bc..40fa973 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -321,10 +321,42 @@ static struct virtio_config_ops lguest_config_ops = {
 
 /* The root device for the lguest virtio devices.  This makes them appear as
  * /sys/devices/lguest/0,1,2 not /sys/devices/0,1,2. */
-static struct device lguest_root = {
-	.parent = NULL,
-	.bus_id = "lguest",
-};
+static struct device *lguest_root;
+
+static void lguest_release_root(struct device *root)
+{
+	kfree(root);
+}
+
+static int lguest_init_root(void)
+{
+	struct device *root;
+	int err = -ENOMEM;
+
+	root = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (root == NULL)
+		goto out;
+
+	err = dev_set_name(root, "lguest");
+	if (err)
+		goto free_root;
+
+	err = device_register(root);
+	if (err)
+		goto free_root;
+
+	root->parent  = NULL;
+	root->release = lguest_release_root;
+
+	lguest_root = root;
+
+	return 0;
+
+free_root:
+	kfree(root);
+out:
+	return err;
+}
 
 /*D:120 This is the core of the lguest bus: actually adding a new device.
  * It's a separate function because it's neater that way, and because an
@@ -351,7 +383,7 @@ static void add_lguest_device(struct lguest_device_desc *d,
 	}
 
 	/* This devices' parent is the lguest/ dir. */
-	ldev->vdev.dev.parent = &lguest_root;
+	ldev->vdev.dev.parent = lguest_root;
 	/* We have a unique device index thanks to the dev_index counter. */
 	ldev->vdev.id.device = d->type;
 	/* We have a simple set of routines for querying the device's
@@ -407,7 +439,7 @@ static int __init lguest_devices_init(void)
 	if (strcmp(pv_info.name, "lguest") != 0)
 		return 0;
 
-	if (device_register(&lguest_root) != 0)
+	if (lguest_init_root() != 0)
 		panic("Could not register lguest root");
 
 	/* Devices are in a single page above top of "normal" mem */
-- 
1.5.4.3

