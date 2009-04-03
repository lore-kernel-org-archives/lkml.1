Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZDCGqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZDCGqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZDCGqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:46:12 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:47802 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZDCGqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:46:11 -0400
Message-ID: <49D5B0B3.2040405@ladisch.de>
Date: Fri, 03 Apr 2009 08:46:11 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: speed up request_firmware()
References: <20090128180446.GB31107@ovro.caltech.edu> <E1LSFhF-0002OC-00.arvidjaar-mail-ru@mx5.mail.ru> <20090128194534.457d58cd@lxorguk.ukuu.org.uk> <20090128203421.GC31107@ovro.caltech.edu>
In-Reply-To: <20090128203421.GC31107@ovro.caltech.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira Snyder wrote:
> I didn't want to change an existing kernel interface, so I just made
> the easiest change that worked for me.

Well, userspace does know the actual size of the image, so I see no
reason why it shouldn't be able to tell the kernel about it beforehand.

> I'd be happy to test patches anyone comes up with.

=====

This adds a data_size attribute to the firmware loading device so that
userspace can tell us about the firmware image size.  This allows us to
preallocate the buffer with the final size, thus avoiding reallocating
the buffer for every page of data as it comes in.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux-2.6.orig/Documentation/firmware_class/README
+++ linux-2.6/Documentation/firmware_class/README
@@ -21,7 +21,7 @@
  kernel(driver): calls request_firmware(&fw_entry, $FIRMWARE, device)
 
  userspace:
- 	- /sys/class/firmware/xxx/{loading,data} appear.
+ 	- /sys/class/firmware/xxx/{loading,data,data_size} appear.
 	- hotplug gets called with a firmware identifier in $FIRMWARE
 	  and the usual hotplug environment.
 		- hotplug: echo 1 > /sys/class/firmware/xxx/loading
@@ -29,11 +29,13 @@
  kernel: Discard any previous partial load.
 
  userspace:
+		- hotplug: echo ... > /sys/class/firmware/xxx/data_size
 		- hotplug: cat appropriate_firmware_image > \
 					/sys/class/firmware/xxx/data
 
- kernel: grows a buffer in PAGE_SIZE increments to hold the image as it
-	 comes in.
+ kernel: Copies the firmware image into a buffer of the specified size.
+	 If the image is larger, the buffer automatically grows in
+	 PAGE_SIZE increments.
 
  userspace:
 		- hotplug: echo 0 > /sys/class/firmware/xxx/loading
@@ -60,6 +62,9 @@
 
 	HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/
 
+	if [ -e /sys/$DEVPATH/data_size ]; then
+		stat -c %s $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data_size
+	fi
 	echo 1 > /sys/$DEVPATH/loading
 	cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
 	echo 0 > /sys/$DEVPATH/loading
@@ -73,6 +78,9 @@
  - firmware_data_read() and firmware_loading_show() are just provided
    for testing and completeness, they are not called in normal use.
 
+ - /sys/class/firmware/xxx/data_size is optional for compatibility with
+   older kernels.
+
  - There is also /sys/class/firmware/timeout which holds a timeout in
    seconds for the whole load operation.
 
--- linux-2.6.orig/Documentation/firmware_class/hotplug-script
+++ linux-2.6/Documentation/firmware_class/hotplug-script
@@ -6,6 +6,9 @@
 
 HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/
 
+if [ -e /sys/$DEVPATH/data_size ]; then
+	stat -c %s $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data_size
+fi
 echo 1 > /sys/$DEVPATH/loading
 cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
 echo 0 > /sys/$DEVPATH/loading
--- linux-2.6.orig/drivers/base/firmware_class.c
+++ linux-2.6/drivers/base/firmware_class.c
@@ -46,6 +46,7 @@ struct firmware_priv {
 	struct firmware *fw;
 	unsigned long status;
 	int alloc_size;
+	int size_hint;
 	struct timer_list timeout;
 };
 
@@ -114,6 +115,32 @@ static struct class firmware_class = {
 	.dev_release	= fw_dev_release,
 };
 
+static ssize_t firmware_data_size_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", fw_priv->size_hint);
+}
+
+static ssize_t firmware_data_size_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
+	long value;
+	int err;
+
+	err = strict_strtol(buf, 10, &value);
+	if (err)
+		return err;
+	fw_priv->size_hint = value;
+	return count;
+}
+
+static DEVICE_ATTR(data_size, 0644,
+		   firmware_data_size_show, firmware_data_size_store);
+
 static ssize_t firmware_loading_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -207,6 +234,7 @@ fw_realloc_buffer(struct firmware_priv *
 	if (min_size <= fw_priv->alloc_size)
 		return 0;
 
+	min_size = max(min_size, fw_priv->size_hint);
 	new_size = ALIGN(min_size, PAGE_SIZE);
 	new_data = vmalloc(new_size);
 	if (!new_data) {
@@ -359,6 +387,12 @@ static int fw_setup_device(struct firmwa
 		goto error_unreg;
 	}
 
+	retval = device_create_file(f_dev, &dev_attr_data_size);
+	if (retval) {
+		dev_err(device, "%s: device_create_file failed\n", __func__);
+		goto error_unreg;
+	}
+
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
 		dev_err(device, "%s: device_create_file failed\n", __func__);
