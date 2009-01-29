Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZA2Pcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZA2Pcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZA2PcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:32:21 -0500
Received: from mail05.svc.cra.dublin.eircom.net ([159.134.118.21]:38990 "HELO
	mail05.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752149AbZA2PcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:32:20 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] virtio-pci: do not oops on config change if driver not loaded
Date: Thu, 29 Jan 2009 15:32:16 +0000
Message-Id: <1233243136-8028-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host really shouldn't be notifying us of config changes
before the device status is VIRTIO_CONFIG_S_DRIVER or
VIRTIO_CONFIG_S_DRIVER_OK.

However, if we do happen to be interrupted while we're not
attached to a driver, we really shouldn't oops. Prevent
this simply by checking that device->driver is non-NULL
before trying to notify the driver of config changes.

Problem observed by doing a "set_link virtio.0 down" with
QEMU before the net driver had been loaded.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/virtio/virtio_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index bef6b45..330aacb 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -192,7 +192,7 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 		drv = container_of(vp_dev->vdev.dev.driver,
 				   struct virtio_driver, driver);
 
-		if (drv->config_changed)
+		if (drv && drv->config_changed)
 			drv->config_changed(&vp_dev->vdev);
 	}
 
-- 
1.6.0.6

