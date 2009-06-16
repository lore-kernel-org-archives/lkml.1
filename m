Return-Path: <linux-kernel-owner+w=401wt.eu-S934664AbZFPFwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664AbZFPFwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760067AbZFPFuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:55 -0400
Received: from kroah.org ([198.145.64.141]:48300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759069AbZFPFuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/64] driver core: add BUS_NOTIFY_UNBOUND_DRIVER event
Date: Mon, 15 Jun 2009 22:45:55 -0700
Message-Id: <1245131213-24168-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds a new bus notifier event which is emitted _after_ a
device is removed from its driver. This event will be used by the
dma-api debug code to check if a driver has released all dma allocations
for that device.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
index a4a7b10..4410464 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -114,6 +114,8 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 #define BUS_NOTIFY_BOUND_DRIVER		0x00000003 /* driver bound to device */
 #define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
 						      unbound */
+#define BUS_NOTIFY_UNBOUND_DRIVER	0x00000005 /* driver is unbound
+						      from the device */
 
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
-- 
1.6.3.2

