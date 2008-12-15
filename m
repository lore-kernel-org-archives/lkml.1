Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbYLONAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYLONAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYLOM74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:59:56 -0500
Received: from mail09.svc.cra.dublin.eircom.net ([159.134.118.25]:47774 "HELO
	mail09.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750802AbYLOM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:59:55 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 3/4] lguest: do not statically allocate root device
Date: Mon, 15 Dec 2008 12:58:28 +0000
Message-Id: <1229345909-27229-3-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1229345909-27229-2-git-send-email-markmc@redhat.com>
References: <20081212190730.GB2950@kroah.com>
 <1229345909-27229-1-git-send-email-markmc@redhat.com>
 <1229345909-27229-2-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't be statically allocating the root device object,
so dynamically allocate it using root_device_register()
instead.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/lguest/lguest_device.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 915da6b..b4d44e5 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -321,10 +321,7 @@ static struct virtio_config_ops lguest_config_ops = {
 
 /* The root device for the lguest virtio devices.  This makes them appear as
  * /sys/devices/lguest/0,1,2 not /sys/devices/0,1,2. */
-static struct device lguest_root = {
-	.parent = NULL,
-	.bus_id = "lguest",
-};
+static struct device *lguest_root;
 
 /*D:120 This is the core of the lguest bus: actually adding a new device.
  * It's a separate function because it's neater that way, and because an
@@ -351,7 +348,7 @@ static void add_lguest_device(struct lguest_device_desc *d,
 	}
 
 	/* This devices' parent is the lguest/ dir. */
-	ldev->vdev.dev.parent = &lguest_root;
+	ldev->vdev.dev.parent = lguest_root;
 	/* We have a unique device index thanks to the dev_index counter. */
 	ldev->vdev.id.device = d->type;
 	/* We have a simple set of routines for querying the device's
@@ -407,7 +404,8 @@ static int __init lguest_devices_init(void)
 	if (strcmp(pv_info.name, "lguest") != 0)
 		return 0;
 
-	if (device_register(&lguest_root) != 0)
+	lguest_root = root_device_register("lguest");
+	if (IS_ERR(lguest_root))
 		panic("Could not register lguest root");
 
 	/* Devices are in a single page above top of "normal" mem */
-- 
1.5.4.3

