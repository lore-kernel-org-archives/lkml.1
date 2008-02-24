Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbYBXSCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbYBXSCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbYBXSCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:02:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45705 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759878AbYBXSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:02:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Feb 2008 19:01:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/5] firewire: refactor fw_unit reference counting
To: linux1394-devel@lists.sourceforge.net
cc: Kristian Hoegsberg <krh@bitplanet.net>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
Message-ID: <tkrat.5aa4d20dc2c04eed@s5r6.in-berlin.de>
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wrappers for getting and putting a unit.
Remove some line breaks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.h |   27 +++++++++++++++++----------
 drivers/firewire/fw-sbp2.c   |    4 ++--
 2 files changed, 19 insertions(+), 12 deletions(-)

Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -64,28 +64,24 @@ struct fw_device {
 	struct fw_attribute_group attribute_group;
 };
 
-static inline struct fw_device *
-fw_device(struct device *dev)
+static inline struct fw_device *fw_device(struct device *dev)
 {
 	return container_of(dev, struct fw_device, device);
 }
 
-static inline int
-fw_device_is_shutdown(struct fw_device *device)
+static inline int fw_device_is_shutdown(struct fw_device *device)
 {
 	return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
 }
 
-static inline struct fw_device *
-fw_device_get(struct fw_device *device)
+static inline struct fw_device *fw_device_get(struct fw_device *device)
 {
 	get_device(&device->device);
 
 	return device;
 }
 
-static inline void
-fw_device_put(struct fw_device *device)
+static inline void fw_device_put(struct fw_device *device)
 {
 	put_device(&device->device);
 }
@@ -104,12 +100,23 @@ struct fw_unit {
 	struct fw_attribute_group attribute_group;
 };
 
-static inline struct fw_unit *
-fw_unit(struct device *dev)
+static inline struct fw_unit *fw_unit(struct device *dev)
 {
 	return container_of(dev, struct fw_unit, device);
 }
 
+static inline struct fw_unit *fw_unit_get(struct fw_unit *unit)
+{
+	get_device(&unit->device);
+
+	return unit;
+}
+
+static inline void fw_unit_put(struct fw_unit *unit)
+{
+	put_device(&unit->device);
+}
+
 #define CSR_OFFSET	0x40
 #define CSR_LEAF	0x80
 #define CSR_DIRECTORY	0xc0
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -777,7 +777,7 @@ static void sbp2_release_target(struct k
 	scsi_remove_host(shost);
 	fw_notify("released %s\n", tgt->bus_id);
 
-	put_device(&tgt->unit->device);
+	fw_unit_put(tgt->unit);
 	scsi_host_put(shost);
 	fw_device_put(device);
 }
@@ -1083,7 +1083,7 @@ static int sbp2_probe(struct device *dev
 		goto fail_shost_put;
 
 	fw_device_get(device);
-	get_device(&unit->device);
+	fw_unit_get(unit);
 
 	/* Initialize to values that won't match anything in our table. */
 	firmware_revision = 0xff000000;

-- 
Stefan Richter
-=====-==--- --=- ==---
http://arcgraph.de/sr/

