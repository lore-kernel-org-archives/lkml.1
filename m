Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZEVVQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZEVVQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZEVVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:16:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36011 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZEVVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:16:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 22 May 2009 23:16:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: core: check for missing struct update at build
 time, not run time
To: linux1394-devel@lists.sourceforge.net
cc: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <ac3eb2510905220423h23e7aca1u3bc7c204db551eb0@mail.gmail.com>
Message-ID: <tkrat.7b837daea0cfa5b2@s5r6.in-berlin.de>
References: <tkrat.d86e749d664670a9@s5r6.in-berlin.de>
 <ac3eb2510905211001m77eda9e4gb73001d504fd5376@mail.gmail.com> 
 <4A159899.20506@s5r6.in-berlin.de> <4A165CED.8030601@s5r6.in-berlin.de>
 <ac3eb2510905220423h23e7aca1u3bc7c204db551eb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct fw_attribute_group.attrs.[] must have enough room for all
attributes.  This can and should be checked at build time.

Our previous check at run time was a little late and not reliable since
most of the time less than the available attributes are populated.

Furthermore, omit an increment of an index at its last usage.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -289,14 +289,13 @@ static void init_fw_attribute_group(stru
 		attr = &config_rom_attributes[i].attr;
 		if (attr->show(dev, attr, NULL) < 0)
 			continue;
 		group->attrs[j++] = &attr->attr;
 	}
 
-	BUG_ON(j >= ARRAY_SIZE(group->attrs));
-	group->attrs[j++] = NULL;
+	group->attrs[j] = NULL;
 	group->groups[0] = &group->group;
 	group->groups[1] = NULL;
 	group->group.attrs = group->attrs;
 	dev->groups = group->groups;
 }
 
@@ -570,9 +569,13 @@ static void create_units(struct fw_devic
 		unit->device.parent = &device->device;
 		dev_set_name(&unit->device, "%s.%d", dev_name(&device->device), i++);
 
+		BUILD_BUG_ON(ARRAY_SIZE(unit->attribute_group.attrs) <
+				ARRAY_SIZE(fw_unit_attributes) +
+				ARRAY_SIZE(config_rom_attributes));
 		init_fw_attribute_group(&unit->device,
 					fw_unit_attributes,
 					&unit->attribute_group);
+
 		if (device_register(&unit->device) < 0)
 			goto skip_unit;
 
@@ -849,9 +852,13 @@ static void fw_device_init(struct work_s
 	device->device.devt = MKDEV(fw_cdev_major, minor);
 	dev_set_name(&device->device, "fw%d", minor);
 
+	BUILD_BUG_ON(ARRAY_SIZE(device->attribute_group.attrs) <
+			ARRAY_SIZE(fw_device_attributes) +
+			ARRAY_SIZE(config_rom_attributes));
 	init_fw_attribute_group(&device->device,
 				fw_device_attributes,
 				&device->attribute_group);
+
 	if (device_add(&device->device)) {
 		fw_error("Failed to add device.\n");
 		goto error_with_cdev;

-- 
Stefan Richter
-=====-==--= -=-= =-==-
http://arcgraph.de/sr/

