Return-Path: <linux-kernel-owner+w=401wt.eu-S935939AbZFPFvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935939AbZFPFvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZFPFuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:52 -0400
Received: from kroah.org ([198.145.64.141]:48290 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZFPFuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/64] Driver Core: Warn driver authors about adding device attributes
Date: Mon, 15 Jun 2009 22:45:52 -0700
Message-Id: <1245131213-24168-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Add a blurb to the driver-model documentation about how (not) to add
extra attributes to a struct device at driver probe time.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/device.txt |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.txt
index a7cbfff..a124f31 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -162,3 +162,35 @@ device_remove_file(dev,&dev_attr_power);
 
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
-- 
1.6.3.2

