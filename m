Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZBCDEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZBCDEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZBCDEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:04:38 -0500
Received: from ozlabs.org ([203.10.76.45]:56474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZBCDEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:04:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] virtio-pci: do not oops on config change if driver not loaded
Date: Tue, 3 Feb 2009 13:33:53 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-9-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031333.54084.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

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
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 
