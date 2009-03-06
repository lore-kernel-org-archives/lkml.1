Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZCFVGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZCFVGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZCFVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:05:56 -0500
Received: from ag-out-0708.google.com ([72.14.246.251]:54865 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZCFVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:05:55 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC] Warn driver authors about adding device attributes
To: linux-kernel@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org
Date: Fri, 06 Mar 2009 14:05:39 -0700
Message-ID: <20090306210258.24123.50321.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Add a blurb to the driver-model documentation about how (not) to add
extra attributes to a struct device at driver probe time.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

---

Kay, Greg;

Is this an accurate description of how device drivers should approach adding
additional device attributes?

Thanks,
g.

 Documentation/driver-model/device.txt |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)


diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.txt
index a05ec50..d181d15 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -160,3 +160,35 @@ device_remove_file(dev,&dev_attr_power);
 
 The file name will be 'power' with a mode of 0644 (-rw-r--r--).
 
+Word of warning:  While the kernel allows device_create_file() and
+device_remove_file() to be called on a device at any time, userspace has
+strict expectations on when attributes get created.  When a new device is
+registered in the kernel, a uevent is generated to notify userspace (like
+udev) that a new device is available.  If attributes are added after the
+device is registered, then userspace won't get notified and userspace will
+not know about the new attributes.
+
+This is important for device driver that need to publish additional
+attributes for a device at driver probe time.  If the device driver simply
+calls device_create_file() on the device structure passed to it, then
+userspace will never be notified of the new attributes.  Instead, it should
+probably use class_create() and class->dev_attrs to set up a list of
+desired attributes in the modules_init function, and then in the .probe()
+hook, and then use device_create() to create a new device as a child
+of the probed device.  The new device will generate a new uevent and
+properly advertise the new attributes to userspace.
+
+For example, if a driver wanted to add the following attributes:
+struct device_attribute mydriver_attribs[] = {
+	__ATTR(port_count, 0444, port_count_show),
+	__ATTR(serial_number, 0444, serial_number_show),
+	NULL
+};
+
+Then in the module init function is would do:
+	mydriver_class = class_create(THIS_MODULE, "my_attrs");
+	mydriver_class.dev_attr = mydriver_attribs;
+
+And assuming 'dev' is the struct device passed into the probe hook, the driver
+probe function would do something like:
+	create_device(&mydriver_class, dev, chrdev, &private_data, "my_name");

