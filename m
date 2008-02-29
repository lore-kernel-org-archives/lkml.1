Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYB2Jko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYB2Jko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYB2Jke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:40:34 -0500
Received: from parabel.levigo.net ([62.206.214.16]:52410 "EHLO
	parabel.matrix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYB2Jke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:40:34 -0500
Message-ID: <47C7D2F9.5030704@gdsys.de>
Date: Fri, 29 Feb 2008 10:40:09 +0100
From: Dirk Eibach <eibach@gdsys.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
References: <47C7CA1A.3080001@gdsys.de>
In-Reply-To: <47C7CA1A.3080001@gdsys.de>
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.6.0.67; VDF: 7.0.2.210; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eibach@gdsys.de wrote:
> From: Dirk Eibach <eibach@gdsys.de>
> 
> The usb configuration data for the Silabs CP2101 usb to uart bridge 
> controller can be customized:
> - Vendor ID
> - Product ID
> - Power Descriptor
> - Release Number
> - Serial Number
> - Product Description String
> 
> Silabs provides a windows-only tool to do that.
> Since we use linux-only machines in our production-environment, we have no 
> proper way to customize the chips for our purpose.
> So I added sysfs configuration support to the linux driver.
> 
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> ---
Sorry, I have to resubmit the patch, because a backup copy crept in...

diff -purN linux-2.6.24/drivers/usb/serial/cp2101.c linux-2.6.24-diff/drivers/usb/serial/cp2101.c
--- linux-2.6.24/drivers/usb/serial/cp2101.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-diff/drivers/usb/serial/cp2101.c	2008-02-29 10:35:13.300208929 +0100
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
 
+bool enable_config = false;
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
@@ -167,6 +172,17 @@ static struct usb_serial_driver cp2101_d
 #define CONTROL_WRITE_DTR	0x0100
 #define CONTROL_WRITE_RTS	0x0200
 
+/* CP2101 CONFIGURATION EEPROM */
+#define EEPROM_RELOAD		0x0008
+#define EEPROM_VID		0x3701
+#define EEPROM_PID		0x3702
+#define EEPROM_PRODUCTSTRING	0x3703
+#define EEPROM_SERIALNUMBER	0x3704
+#define EEPROM_POWER_ATTRIB	0x3705
+#define EEPROM_MAX_POWER	0x3706
+#define EEPROM_RELEASE_VERSION	0x3707
+#define EEPROM_LOCK		0x370a
+
 /*
  * cp2101_get_config
  * Reads from the CP2101 configuration registers
@@ -704,11 +720,262 @@ static void cp2101_break_ctl (struct usb
 	cp2101_set_config(port, CP2101_BREAK, &state, 2);
 }
 
+static ssize_t write_reload(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	/* writing "0" does not trigger */
+	if (!simple_strtoul(buf, NULL, 0))
+		return count;
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_RELOAD,
+		0, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(reload, S_IWUGO, NULL, write_reload);
+
+static ssize_t write_vid(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long vid = simple_strtoul(buf, NULL, 0);
+
+	if (!vid || vid > 0xffff)
+		return -EINVAL;
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_VID,
+		vid, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(vid, S_IWUGO, NULL, write_vid);
+
+static ssize_t write_pid(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long pid = simple_strtoul(buf, NULL, 0);
+
+	if (!pid || pid > 0xffff)
+		return -EINVAL;
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_PID,
+		pid, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(pid, S_IWUGO, NULL, write_pid);
+
+static ssize_t write_serialnumber(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	int result;
+	unsigned int k;
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+	u8 serial_stringsize = 2 + 2*count;
+	char serial[serial_stringsize];
+
+	if (count > 63)
+		return -EINVAL;
+
+	serial[0] = serial_stringsize;
+	serial[1] = USB_DT_STRING;
+
+	/* convert to utf-16 */
+	for (k = 0; k < count; ++k) {
+		serial[2+2*k] = buf[k];
+		serial[2+2*k+1] = 0;
+	}
+
+	result = usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_SERIALNUMBER,
+		0, serial, sizeof(serial), 300);
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
+	char product[product_stringsize];
+
+	if (count > 126)
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
+			product, sizeof(product), 300);
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
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long self_powered = simple_strtoul(buf, NULL, 0);
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_POWER_ATTRIB,
+		self_powered ? 0x00c0 : 0x0080, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(self_powered, S_IWUGO, NULL, write_self_powered);
+
+static ssize_t write_max_power(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long max_power = simple_strtoul(buf, NULL, 0);
+
+	if (!max_power || max_power > 0xff)
+		return -EINVAL;
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_MAX_POWER,
+		max_power, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(max_power, S_IWUGO, NULL, write_max_power);
+
+static ssize_t write_release_version(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long release_version = simple_strtoul(buf, NULL, 0);
+
+	if (release_version > 0xffff)
+		return -EINVAL;
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_RELEASE_VERSION,
+		release_version, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(release_version, S_IWUGO, NULL, write_release_version);
+
+static ssize_t write_lock_forever(struct device *dev,
+	struct device_attribute *attr,	const char *buf, size_t count)
+{
+	struct usb_device *usbdev = container_of(dev, struct usb_device, dev);
+
+	unsigned long lock = simple_strtoul(buf, NULL, 0);
+
+	/* be really, really sure to know what you are doing here */
+	if (lock != 0xabadbabe)
+		return -EINVAL;
+
+	usb_control_msg(usbdev,
+		usb_sndctrlpipe(usbdev, 0),
+		CP2101_EEPROM, REQTYPE_HOST_TO_DEVICE, EEPROM_LOCK,
+		0x00f0, NULL, 0, 300);
+
+	return count;
+}
+
+static DEVICE_ATTR(lock_forever, S_IWUGO, NULL, write_lock_forever);
+
 static int cp2101_startup (struct usb_serial *serial)
 {
+	int err;
+
 	/* CP2101 buffers behave strangely unless device is reset */
 	usb_reset_device(serial->dev);
+
+	if (!enable_config)
+		return 0;
+
+	err = device_create_file(&serial->dev->dev, &dev_attr_reload);
+	if (err) goto out;
+	err = device_create_file(&serial->dev->dev, &dev_attr_vid);
+	if (err) goto out_reload;
+	err = device_create_file(&serial->dev->dev, &dev_attr_pid);
+	if (err) goto out_vid;
+	err = device_create_file(&serial->dev->dev, &dev_attr_productstring);
+	if (err) goto out_pid;
+	err = device_create_file(&serial->dev->dev, &dev_attr_serialnumber);
+	if (err) goto out_productstring;
+	err = device_create_file(&serial->dev->dev, &dev_attr_self_powered);
+	if (err) goto out_serialnumber;
+	err = device_create_file(&serial->dev->dev, &dev_attr_max_power);
+	if (err) goto out_self_powered;
+	err = device_create_file(&serial->dev->dev, &dev_attr_release_version);
+	if (err) goto out_max_power;
+	err = device_create_file(&serial->dev->dev, &dev_attr_lock_forever);
+	if (err) goto out_release_version;
+
 	return 0;
+
+out_release_version:
+	device_remove_file(&serial->dev->dev, &dev_attr_release_version);
+out_max_power:
+	device_remove_file(&serial->dev->dev, &dev_attr_max_power);
+out_self_powered:
+	device_remove_file(&serial->dev->dev, &dev_attr_self_powered);
+out_serialnumber:
+	device_remove_file(&serial->dev->dev, &dev_attr_serialnumber);
+out_productstring:
+	device_remove_file(&serial->dev->dev, &dev_attr_productstring);
+out_pid:
+	device_remove_file(&serial->dev->dev, &dev_attr_pid);
+out_vid:
+	device_remove_file(&serial->dev->dev, &dev_attr_vid);
+out_reload:
+	device_remove_file(&serial->dev->dev, &dev_attr_reload);
+out:
+	return err;
 }
 
 static void cp2101_shutdown (struct usb_serial *serial)
@@ -721,6 +988,19 @@ static void cp2101_shutdown (struct usb_
 	for (i=0; i < serial->num_ports; ++i) {
 		cp2101_cleanup(serial->port[i]);
 	}
+
+	if (!enable_config)
+		return;
+
+	device_remove_file(&serial->dev->dev, &dev_attr_reload);
+	device_remove_file(&serial->dev->dev, &dev_attr_vid);
+	device_remove_file(&serial->dev->dev, &dev_attr_pid);
+	device_remove_file(&serial->dev->dev, &dev_attr_productstring);
+	device_remove_file(&serial->dev->dev, &dev_attr_serialnumber);
+	device_remove_file(&serial->dev->dev, &dev_attr_self_powered);
+	device_remove_file(&serial->dev->dev, &dev_attr_max_power);
+	device_remove_file(&serial->dev->dev, &dev_attr_release_version);
+	device_remove_file(&serial->dev->dev, &dev_attr_lock_forever);
 }
 
 static int __init cp2101_init (void)
@@ -758,3 +1038,6 @@ MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Enable verbose debugging messages");
+
+module_param(enable_config, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_config, "Enable sysfs access to configuration eeprom.");



