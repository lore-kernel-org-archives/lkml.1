Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZEVVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZEVVRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZEVVRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:17:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36015 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZEVVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:17:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 22 May 2009 23:17:02 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: core: add sysfs attribute for easier udev rules
To: linux1394-devel@lists.sourceforge.net
cc: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <tkrat.7b837daea0cfa5b2@s5r6.in-berlin.de>
Message-ID: <tkrat.acafb37c21e20784@s5r6.in-berlin.de>
References: <tkrat.d86e749d664670a9@s5r6.in-berlin.de>
 <ac3eb2510905211001m77eda9e4gb73001d504fd5376@mail.gmail.com> 
 <4A159899.20506@s5r6.in-berlin.de> <4A165CED.8030601@s5r6.in-berlin.de>
 <ac3eb2510905220423h23e7aca1u3bc7c204db551eb0@mail.gmail.com>
 <tkrat.7b837daea0cfa5b2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the attribute /sys/bus/firewire/devices/fw[0-9]+/units.  It
can be used in udev rules like the following ones:

# IIDC devices: industrial cameras and some webcams
SUBSYSTEM=="firewire", ATTR{units}=="*0x00a02d:0x00010?*", GROUP="video"

# AV/C devices: camcorders, set-top boxes, TV sets, audio devices, ...
SUBSYSTEM=="firewire", ATTR{units}=="*0x00a02d:0x010001*", GROUP="video"

Background:

firewire-core manages two device types:
  - fw_device is a FireWire node.  A character device file is associated
    with it.
  - fw_unit is a unit directory on a node.  Each fw_device may have 0..n
    children of type fw_unit.  The units tell us what kinds of protocols
    a node implements.

We want to set ownership or ACLs or permissions of the character device
file of an fw_device, or/and create symlinks to it, based on available
protocols.  Until now udev rules had to look at the fw_unit devices and
then modify their parent's character device file accordingly.  This is
problematic for two reasons:  1) It happens sometime after the creation
of the fw_device, 2) an access policy may require that information from
all children is evaluated before a decision about the parent is made.

Problem 1) can ultimately not be avoided since this is the nature of
FireWire nodes:  They may add or remove unit directories at any point in
time.

However, we can still help userland a lot by providing the protocol type
information of all units in a summary sysfs attribute directly at the
fw_device.  This way,
   - the information is immediately available at the affected device
     when userspace goes about to handle an ADD or CHANGE event of the
     fw_device,
   - with most policies, it won't be necessary anymore to dig through
     child attributes.

The new attribute is called "units".  It contains space-separated tuples
of specifier_id and version of each present unit.  The delimiter within
tuples is a colon.  Specifier_id and version are printed as 0x%06x.

Here is an example of a node which implements an IPv4 unit and an IPv6
unit:  $ cat /sys/bus/firewire/devices/fw2/units
0x00005e:0x000001 0x00005e:0x000002

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 drivers/firewire/fw-device.h |    2 -
 2 files changed, 50 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -355,9 +355,55 @@ static ssize_t guid_show(struct device *
 	return ret;
 }
 
+static int units_sprintf(char *buf, u32 *directory)
+{
+	struct fw_csr_iterator ci;
+	int key, value;
+	int specifier_id = 0;
+	int version = 0;
+
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		switch (key) {
+		case CSR_SPECIFIER_ID:
+			specifier_id = value;
+			break;
+		case CSR_VERSION:
+			version = value;
+			break;
+		}
+	}
+
+	return sprintf(buf, "0x%06x:0x%06x ", specifier_id, version);
+}
+
+static ssize_t units_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct fw_device *device = fw_device(dev);
+	struct fw_csr_iterator ci;
+	int key, value, i = 0;
+
+	down_read(&fw_device_rwsem);
+	fw_csr_iterator_init(&ci, &device->config_rom[5]);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		if (key != (CSR_UNIT | CSR_DIRECTORY))
+			continue;
+		i += units_sprintf(&buf[i], ci.p + value - 1);
+		if (i >= PAGE_SIZE - (8 + 1 + 8 + 1))
+			break;
+	}
+	up_read(&fw_device_rwsem);
+
+	sprintf(&buf[i ? i - 1 : 0], "\n");
+
+	return i;
+}
+
 static struct device_attribute fw_device_attributes[] = {
 	__ATTR_RO(config_rom),
 	__ATTR_RO(guid),
+	__ATTR_RO(units),
 	__ATTR_NULL,
 };
 
@@ -1000,6 +1046,9 @@ static void fw_device_refresh(struct wor
 
 	create_units(device);
 
+	/* Userspace may want to re-read attributes. */
+	kobject_uevent(&device->device.kobj, KOBJ_CHANGE);
+
 	if (atomic_cmpxchg(&device->state,
 			   FW_DEVICE_INITIALIZING,
 			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE)
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -42,7 +42,7 @@ enum fw_device_state {
 struct fw_attribute_group {
 	struct attribute_group *groups[2];
 	struct attribute_group group;
-	struct attribute *attrs[11];
+	struct attribute *attrs[12];
 };
 
 struct fw_node;

-- 
Stefan Richter
-=====-==--= -=-= =-==-
http://arcgraph.de/sr/

