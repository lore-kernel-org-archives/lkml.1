Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYB2Mbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYB2Mbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbYB2MbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:31:24 -0500
Received: from parabel.levigo.net ([62.206.214.16]:52181 "EHLO
	parabel.matrix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbYB2MbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:31:23 -0500
Message-ID: <47C7FB0F.1060902@gdsys.de>
Date: Fri, 29 Feb 2008 13:31:11 +0100
From: Dirk Eibach <eibach@gdsys.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       Andy Whitcroft <apw@shadowen.org>
References: <20080229020245.61f1f8f4.akpm@linux-foundation.org>
In-Reply-To: <20080229020245.61f1f8f4.akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.6.0.67; VDF: 7.0.2.212; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So here is a new try.

---
diff -purN linux-2.6.24/drivers/usb/serial/cp2101.c linux-2.6.24-diff/drivers/usb/serial/cp2101.c
--- linux-2.6.24/drivers/usb/serial/cp2101.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-diff/drivers/usb/serial/cp2101.c	2008-02-29 13:15:58.168233146 +0100
@@ -18,6 +18,8 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
@@ -52,6 +54,8 @@ static void cp2101_shutdown(struct usb_s
 
 static int debug;
 
+static int enable_config = false;
+
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */
@@ -125,6 +129,7 @@ static struct usb_serial_driver cp2101_d
 #define CP2101_CONTROL		0x07	/* Flow control line states */
 #define CP2101_MODEMCTL		0x13	/* Modem controls */
 #define CP2101_CONFIG_6		0x19	/* 6 bytes of config data ??? */
+#define CP2101_EEPROM		0xFF	/* write configuration eeprom */
 
 /* CP2101_UART */
 #define UART_ENABLE		0x0001
@@ -167,6 +172,20 @@ static struct usb_serial_driver cp2101_d
 #define CONTROL_WRITE_DTR	0x0100
 #define CONTROL_WRITE_RTS	0x0200
 
+/* CP2101 CONFIGURATION EEPROM */
+#define EEPROM_RELOAD		0x0008
+#define EEPROM_VENDOR_ID	0x3701
+#define EEPROM_PRODUCT_ID	0x3702
+#define EEPROM_PRODUCTSTRING	0x3703
+#define EEPROM_SERIALNUMBER	0x3704
+#define EEPROM_POWER_ATTRIB	0x3705
+#define EEPROM_MAX_POWER	0x3706
+#define EEPROM_RELEASE_VERSION	0x3707
+#define EEPROM_LOCK		0x370a
+
+#define SERIALNUMBER_MAX_CHARS	63
+#define PRODUCTSTRING_MAX_CHARS	126
+
 /*
  * cp2101_get_config
  * Reads from the CP2101 configuration registers
@@ -704,11 +723,286 @@ static void cp2101_break_ctl (struct usb
 	cp2101_set_config(port, CP2101_BREAK, &state, 2);
 }
 
+/*
+ * When loaded with module parameter "enable_config=1" the driver offers the
+ * following sysfs attributes to customize USB configuration data:
+ * reload: write "1" to reboot CP210x and activate the new configuration
+ * vendor_id: write 16 bit value to set
+ * product_id: write 16 bit value to set
+ * productstring: write up to 126 characters to set
+ * serialnumber: write up to 63 characters to set
+ * self_powered: write "1" to set, "0" to unset
+ * max_power: write 8 bit value (unit 2 mA) to set
+ * release_version: write 16 bit BCD-value to set (0x1234 => version 12.34)
+ * lock_forever: write 0xabadbabe to lock the settings permanently
+ */
+
+static ssize_t write_reload(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	/* writing "0" does not trigger */
+	if (!strict_strtoul(buf, NULL, 0))
+		return count;
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_RELOAD,
+		0, NULL, 0, 300);
+
+	/* this request is expected to fail because cp210x reboots */
+
+	return count;
+}
+
+static DEVICE_ATTR(reload, S_IWUGO, NULL, write_reload);
+
+static ssize_t write_vendor_id(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long vendor_id = strict_strtoul(buf, NULL, 0);
+
+	if (!vendor_id || vendor_id > 0xffff)
+		return -EINVAL;
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_VENDOR_ID,
+		vendor_id, NULL, 0, 300);
+
+	if (result)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(vendor_id, S_IWUGO, NULL, write_vendor_id);
+
+static ssize_t write_product_id(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long product_id = strict_strtoul(buf, NULL, 0);
+
+	if (!product_id || product_id > 0xffff)
+		return -EINVAL;
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_PRODUCT_ID,
+		product_id, NULL, 0, 300);
+
+	if (result)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(product_id, S_IWUGO, NULL, write_product_id);
+
+static ssize_t write_serialnumber(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int result;
+	unsigned int k;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+	u8 serial_stringsize = 2 + 2*count;
+	char serial[2 + 2*SERIALNUMBER_MAX_CHARS];
+
+	if (count > SERIALNUMBER_MAX_CHARS)
+		return -EINVAL;
+
+	serial[0] = serial_stringsize;
+	serial[1] = USB_DT_STRING;
+
+	/* convert to utf-16 */
+	printk("#Max index: %d\n", serial_stringsize - 1);
+	for (k = 0; k < count; ++k) {
+		printk("Address index %d and %d\n", 2+2*k, 2+2*k+1);
+		serial[2+2*k] = buf[k];
+		serial[2+2*k+1] = 0;
+	}
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_SERIALNUMBER,
+		0, serial, serial_stringsize, 300);
+
+	if (result != serial_stringsize)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(serialnumber, S_IWUGO, NULL, write_serialnumber);
+
+
+static ssize_t write_productstring(struct device *dev,
+	struct device_attribute *attr,	const char *buf, size_t count)
+{
+	int result;
+	unsigned int k;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+	u8 product_stringsize = 2 + 2*count;
+	char product[2 + 2*PRODUCTSTRING_MAX_CHARS];
+
+	if (count > PRODUCTSTRING_MAX_CHARS)
+		return -EINVAL;
+
+	product[0] = product_stringsize;
+	product[1] = USB_DT_STRING;
+
+	/* convert to utf-16 */
+	for (k = 0; k < count; ++k) {
+		product[2+2*k] = buf[k];
+		product[2+2*k+1] = 0;
+	}
+
+	result = usb_control_msg(usbdev,
+			usb_sndctrlpipe(usbdev, 0),
+			CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE,
+			EEPROM_PRODUCTSTRING, 0,
+			product, product_stringsize, 300);
+
+	if (result != product_stringsize)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(productstring, S_IWUGO, NULL, write_productstring);
+
+static ssize_t write_self_powered(struct device *dev,
+	struct device_attribute *attr,	const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long self_powered = strict_strtoul(buf, NULL, 0);
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_POWER_ATTRIB,
+		self_powered ? 0x00c0 : 0x0080, NULL, 0, 300);
+
+	if (result)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(self_powered, S_IWUGO, NULL, write_self_powered);
+
+static ssize_t write_max_power(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long max_power = strict_strtoul(buf, NULL, 0);
+
+	if (!max_power || max_power > 0xff)
+		return -EINVAL;
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_MAX_POWER,
+		max_power, NULL, 0, 300);
+
+	if (result)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(max_power, S_IWUGO, NULL, write_max_power);
+
+static ssize_t write_release_version(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long release_version = strict_strtoul(buf, NULL, 0);
+
+	if (release_version > 0xffff)
+		return -EINVAL;
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_RELEASE_VERSION,
+		release_version, NULL, 0, 300);
+
+	if (result)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(release_version, S_IWUGO, NULL, write_release_version);
+
+static ssize_t write_lock_forever(struct device *dev,
+	struct device_attribute *attr,	const char *buf, size_t count)
+{
+	int result;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long lock = strict_strtoul(buf, NULL, 0);
+
+	/* be really, really sure to know what you are doing here */
+	if (lock != 0xabadbabe)
+		return -EINVAL;
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_LOCK,
+		0x00f0, NULL, 0, 300);
+
+	if (result)
+		return -EIO;
+
+	return count;
+}
+
+static DEVICE_ATTR(lock_forever, S_IWUGO, NULL, write_lock_forever);
+
+static struct attribute *cp2101_attributes[] = {
+	&dev_attr_reload.attr,
+	&dev_attr_vendor_id.attr,
+	&dev_attr_product_id.attr,
+	&dev_attr_productstring.attr,
+	&dev_attr_serialnumber.attr,
+	&dev_attr_self_powered.attr,
+	&dev_attr_max_power.attr,
+	&dev_attr_release_version.attr,
+	&dev_attr_lock_forever.attr,
+	NULL
+};
+
+static const struct attribute_group cp2101_group = {
+	.attrs = cp2101_attributes,
+};
+
 static int cp2101_startup (struct usb_serial *serial)
 {
+	int err;
+
 	/* CP2101 buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
-	return 0;
+
+	if (!enable_config)
+		return 0;
+
+	err = sysfs_create_group(&serial->dev->dev.kobj, &cp2101_group);
+	
+	return err;
 }
 
 static void cp2101_shutdown (struct usb_serial *serial)
@@ -721,6 +1015,11 @@ static void cp2101_shutdown (struct usb_
 	for (i=0; i < serial->num_ports; ++i) {
 		cp2101_cleanup(serial->port[i]);
 	}
+
+	if (!enable_config)
+		return;
+
+	sysfs_remove_group(&serial->dev->dev.kobj, &cp2101_group);
 }
 
 static int __init cp2101_init (void)
@@ -758,3 +1057,6 @@ MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable verbose debugging messages");
+
+module_param(enable_config, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_config, "Enable sysfs access to configuration eeprom.");



