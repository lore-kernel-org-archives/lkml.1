Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZDXM5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZDXM5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZDXM5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:57:21 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:50944
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756018AbZDXM5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:57:20 -0400
X-BigFish: VPS13(z1857rzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KILVYZ-03-BA4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] driver/base: add BUS_NOTIFY_UNBOUND_DRIVER event
Date: Fri, 24 Apr 2009 14:57:00 +0200
Message-ID: <1240577820-13783-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
X-OriginalArrivalTime: 24 Apr 2009 12:57:00.0237 (UTC) FILETIME=[28289FD0:01C9C4DC]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new bus notifier event which is emitted _after_ a
device is removed from its driver. This event will be used by the
dma-api debug code to check if a driver has released all dma allocations
for that device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/base/dd.c      |    4 ++++
 include/linux/device.h |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 742cbe6..efd00de 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -320,6 +320,10 @@ static void __device_release_driver(struct device *dev)
 		devres_release_all(dev);
 		dev->driver = NULL;
 		klist_remove(&dev->p->knode_driver);
+		if (dev->bus)
+			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+						     BUS_NOTIFY_UNBOUND_DRIVER,
+						     dev);
 	}
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 6a69caa..ac69c22 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -116,6 +116,8 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 #define BUS_NOTIFY_BOUND_DRIVER		0x00000003 /* driver bound to device */
 #define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
 						      unbound */
+#define BUS_NOTIFY_UNBOUND_DRIVER	0x00000005 /* driver is unbound
+						      from the device */
 
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
-- 
1.6.2.3


