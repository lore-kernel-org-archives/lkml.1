Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYBCWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYBCWDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYBCWDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:03:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47625 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYBCWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:03:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:03:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/9] firewire: log GUID of new devices
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.4304cda1ec1be99d@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should help to interpret user reports.  E.g. one can look up the
vendor OUI (first three bytes of the GUID) and thus tell what is what.

Also simplifies the math in the GUID sysfs attribute.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -358,12 +358,9 @@ static ssize_t
 guid_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
-	u64 guid;
 
-	guid = ((u64)device->config_rom[3] << 32) | device->config_rom[4];
-
-	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
-			(unsigned long long)guid);
+	return snprintf(buf, PAGE_SIZE, "0x%08x%08x\n",
+			device->config_rom[3], device->config_rom[4]);
 }
 
 static struct device_attribute fw_device_attributes[] = {
@@ -723,13 +720,22 @@ static void fw_device_init(struct work_s
 	 */
 	if (atomic_cmpxchg(&device->state,
 		    FW_DEVICE_INITIALIZING,
-		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN) {
 		fw_device_shutdown(&device->work.work);
-	else
-		fw_notify("created new fw device %s "
-			  "(%d config rom retries, S%d00)\n",
-			  device->device.bus_id, device->config_rom_retries,
-			  1 << device->max_speed);
+	} else {
+		if (device->config_rom_retries)
+			fw_notify("created device %s: GUID %08x%08x, S%d00, "
+				  "%d config ROM retries\n",
+				  device->device.bus_id,
+				  device->config_rom[3], device->config_rom[4],
+				  1 << device->max_speed,
+				  device->config_rom_retries);
+		else
+			fw_notify("created device %s: GUID %08x%08x, S%d00\n",
+				  device->device.bus_id,
+				  device->config_rom[3], device->config_rom[4],
+				  1 << device->max_speed);
+	}
 
 	/*
 	 * Reschedule the IRM work if we just finished reading the

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

