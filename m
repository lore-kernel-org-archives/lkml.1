Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYB2J0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYB2J0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYB2JZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:25:44 -0500
Received: from parabel.levigo.net ([62.206.214.16]:46083 "EHLO
	parabel.matrix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYB2JZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:25:39 -0500
X-Greylist: delayed 1381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 04:25:38 EST
Message-ID: <47C7CA1A.3080001@gdsys.de>
Date: Fri, 29 Feb 2008 10:02:18 +0100
From: Dirk Eibach <eibach@gdsys.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: [PATCH] usb: add sysfs configuration interface for CP2101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.6.0.67; VDF: 7.0.2.210; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Eibach <eibach@gdsys.de>

The usb configuration data for the Silabs CP2101 usb to uart bridge 
controller can be customized:
- Vendor ID
- Product ID
- Power Descriptor
- Release Number
- Serial Number
- Product Description String

Silabs provides a windows-only tool to do that.
Since we use linux-only machines in our production-environment, we have no 
proper way to customize the chips for our purpose.
So I added sysfs configuration support to the linux driver.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
diff -purN linux-2.6.24/drivers/usb/serial/cp2101.c linux-2.6.24-diff/drivers/usb/serial/cp2101.c
--- linux-2.6.24/drivers/usb/serial/cp2101.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-diff/drivers/usb/serial/cp2101.c	2008-02-29 09:38:30.847817025 +0100
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
diff -purN linux-2.6.24/drivers/usb/serial/cp2101.c.orig linux-2.6.24-diff/drivers/usb/serial/cp2101.c.orig
--- linux-2.6.24/drivers/usb/serial/cp2101.c.orig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-diff/drivers/usb/serial/cp2101.c.orig	2008-01-24 23:58:37.000000000 +0100
@@ -0,0 +1,760 @@
+/*
+ * Silicon Laboratories CP2101/CP2102 USB to RS232 serial adaptor driver
+ *
+ * Copyright (C) 2005 Craig Shelley (craig@microtron.org.uk)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ * Support to set flow control line levels using TIOCMGET and TIOCMSET
+ * thanks to Karl Hiramoto karl@hiramoto.org. RTSCTS hardware flow
+ * control thanks to Munir Nassar nassarmu@real-time.com
+ *
+ * Outstanding Issues:
+ *  Buffers are not flushed when the port is opened.
+ *  Multiple calls to write() may fail with "Resource temporarily unavailable"
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/usb.h>
+#include <asm/uaccess.h>
+#include <linux/usb/serial.h>
+
+/*
+ * Version Information
+ */
+#define DRIVER_VERSION "v0.07"
+#define DRIVER_DESC "Silicon Labs CP2101/CP2102 RS232 serial adaptor driver"
+
+/*
+ * Function Prototypes
+ */
+static int cp2101_open(struct usb_serial_port*, struct file*);
+static void cp2101_cleanup(struct usb_serial_port*);
+static void cp2101_close(struct usb_serial_port*, struct file*);
+static void cp2101_get_termios(struct usb_serial_port*);
+static void cp2101_set_termios(struct usb_serial_port*, struct ktermios*);
+static int cp2101_tiocmget (struct usb_serial_port *, struct file *);
+static int cp2101_tiocmset (struct usb_serial_port *, struct file *,
+		unsigned int, unsigned int);
+static void cp2101_break_ctl(struct usb_serial_port*, int);
+static int cp2101_startup (struct usb_serial *);
+static void cp2101_shutdown(struct usb_serial*);
+
+
+static int debug;
+
+static struct usb_device_id id_table [] = {
+	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
+	{ USB_DEVICE(0x0FCF, 0x1003) }, /* Dynastream ANT development board */
+	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
+	{ USB_DEVICE(0x10A6, 0xAA26) }, /* Knock-off DCU-11 cable */
+	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
+	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */
+	{ USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
+	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
+	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
+	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
+	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
+	{ USB_DEVICE(0x10C4, 0x80DD) }, /* Tracient RFID */
+	{ USB_DEVICE(0x10C4, 0x80F6) }, /* Suunto sports instrument */
+	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
+	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
+	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
+	{ USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie Elektronik GmbH, Baby-JTAG */
+	{ USB_DEVICE(0x10C4, 0x81E2) }, /* Lipowsky Industrie Elektronik GmbH, Baby-LIN */
+	{ USB_DEVICE(0x10C4, 0x81E7) }, /* Aerocomm Radio */
+	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
+	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C5, 0xEA61) }, /* Silicon Labs MobiData GPRS USB Modem */
+	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
+	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
+	{ } /* Terminating Entry */
+};
+
+MODULE_DEVICE_TABLE (usb, id_table);
+
+static struct usb_driver cp2101_driver = {
+	.name		= "cp2101",
+	.probe		= usb_serial_probe,
+	.disconnect	= usb_serial_disconnect,
+	.id_table	= id_table,
+	.no_dynamic_id	= 	1,
+};
+
+static struct usb_serial_driver cp2101_device = {
+	.driver = {
+		.owner =	THIS_MODULE,
+		.name = 	"cp2101",
+	},
+	.usb_driver		= &cp2101_driver,
+	.id_table		= id_table,
+	.num_interrupt_in	= 0,
+	.num_bulk_in		= NUM_DONT_CARE,
+	.num_bulk_out		= NUM_DONT_CARE,
+	.num_ports		= 1,
+	.open			= cp2101_open,
+	.close			= cp2101_close,
+	.break_ctl		= cp2101_break_ctl,
+	.set_termios		= cp2101_set_termios,
+	.tiocmget 		= cp2101_tiocmget,
+	.tiocmset		= cp2101_tiocmset,
+	.attach			= cp2101_startup,
+	.shutdown		= cp2101_shutdown,
+};
+
+/* Config request types */
+#define REQTYPE_HOST_TO_DEVICE	0x41
+#define REQTYPE_DEVICE_TO_HOST	0xc1
+
+/* Config SET requests. To GET, add 1 to the request number */
+#define CP2101_UART 		0x00	/* Enable / Disable */
+#define CP2101_BAUDRATE		0x01	/* (BAUD_RATE_GEN_FREQ / baudrate) */
+#define CP2101_BITS		0x03	/* 0x(0)(databits)(parity)(stopbits) */
+#define CP2101_BREAK		0x05	/* On / Off */
+#define CP2101_CONTROL		0x07	/* Flow control line states */
+#define CP2101_MODEMCTL		0x13	/* Modem controls */
+#define CP2101_CONFIG_6		0x19	/* 6 bytes of config data ??? */
+
+/* CP2101_UART */
+#define UART_ENABLE		0x0001
+#define UART_DISABLE		0x0000
+
+/* CP2101_BAUDRATE */
+#define BAUD_RATE_GEN_FREQ	0x384000
+
+/* CP2101_BITS */
+#define BITS_DATA_MASK		0X0f00
+#define BITS_DATA_5		0X0500
+#define BITS_DATA_6		0X0600
+#define BITS_DATA_7		0X0700
+#define BITS_DATA_8		0X0800
+#define BITS_DATA_9		0X0900
+
+#define BITS_PARITY_MASK	0x00f0
+#define BITS_PARITY_NONE	0x0000
+#define BITS_PARITY_ODD		0x0010
+#define BITS_PARITY_EVEN	0x0020
+#define BITS_PARITY_MARK	0x0030
+#define BITS_PARITY_SPACE	0x0040
+
+#define BITS_STOP_MASK		0x000f
+#define BITS_STOP_1		0x0000
+#define BITS_STOP_1_5		0x0001
+#define BITS_STOP_2		0x0002
+
+/* CP2101_BREAK */
+#define BREAK_ON		0x0000
+#define BREAK_OFF		0x0001
+
+/* CP2101_CONTROL */
+#define CONTROL_DTR		0x0001
+#define CONTROL_RTS		0x0002
+#define CONTROL_CTS		0x0010
+#define CONTROL_DSR		0x0020
+#define CONTROL_RING		0x0040
+#define CONTROL_DCD		0x0080
+#define CONTROL_WRITE_DTR	0x0100
+#define CONTROL_WRITE_RTS	0x0200
+
+/*
+ * cp2101_get_config
+ * Reads from the CP2101 configuration registers
+ * 'size' is specified in bytes.
+ * 'data' is a pointer to a pre-allocated array of integers large
+ * enough to hold 'size' bytes (with 4 bytes to each integer)
+ */
+static int cp2101_get_config(struct usb_serial_port* port, u8 request,
+		unsigned int *data, int size)
+{
+	struct usb_serial *serial = port->serial;
+	__le32 *buf;
+	int result, i, length;
+
+	/* Number of integers required to contain the array */
+	length = (((size - 1) | 3) + 1)/4;
+
+	buf = kcalloc(length, sizeof(__le32), GFP_KERNEL);
+	if (!buf) {
+		dev_err(&port->dev, "%s - out of memory.\n", __FUNCTION__);
+		return -ENOMEM;
+	}
+
+	/* For get requests, the request number must be incremented */
+	request++;
+
+	/* Issue the request, attempting to read 'size' bytes */
+	result = usb_control_msg (serial->dev,usb_rcvctrlpipe (serial->dev, 0),
+				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
+				0, buf, size, 300);
+
+	/* Convert data into an array of integers */
+	for (i=0; i<length; i++)
+		data[i] = le32_to_cpu(buf[i]);
+
+	kfree(buf);
+
+	if (result != size) {
+		dev_err(&port->dev, "%s - Unable to send config request, "
+				"request=0x%x size=%d result=%d\n",
+				__FUNCTION__, request, size, result);
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
+/*
+ * cp2101_set_config
+ * Writes to the CP2101 configuration registers
+ * Values less than 16 bits wide are sent directly
+ * 'size' is specified in bytes.
+ */
+static int cp2101_set_config(struct usb_serial_port* port, u8 request,
+		unsigned int *data, int size)
+{
+	struct usb_serial *serial = port->serial;
+	__le32 *buf;
+	int result, i, length;
+
+	/* Number of integers required to contain the array */
+	length = (((size - 1) | 3) + 1)/4;
+
+	buf = kmalloc(length * sizeof(__le32), GFP_KERNEL);
+	if (!buf) {
+		dev_err(&port->dev, "%s - out of memory.\n",
+				__FUNCTION__);
+		return -ENOMEM;
+	}
+
+	/* Array of integers into bytes */
+	for (i = 0; i < length; i++)
+		buf[i] = cpu_to_le32(data[i]);
+
+	if (size > 2) {
+		result = usb_control_msg (serial->dev,
+				usb_sndctrlpipe(serial->dev, 0),
+				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
+				0, buf, size, 300);
+	} else {
+		result = usb_control_msg (serial->dev,
+				usb_sndctrlpipe(serial->dev, 0),
+				request, REQTYPE_HOST_TO_DEVICE, data[0],
+				0, NULL, 0, 300);
+	}
+
+	kfree(buf);
+
+	if ((size > 2 && result != size) || result < 0) {
+		dev_err(&port->dev, "%s - Unable to send request, "
+				"request=0x%x size=%d result=%d\n",
+				__FUNCTION__, request, size, result);
+		return -EPROTO;
+	}
+
+	/* Single data value */
+	result = usb_control_msg (serial->dev,
+			usb_sndctrlpipe(serial->dev, 0),
+			request, REQTYPE_HOST_TO_DEVICE, data[0],
+			0, NULL, 0, 300);
+	return 0;
+}
+
+/*
+ * cp2101_set_config_single
+ * Convenience function for calling cp2101_set_config on single data values
+ * without requiring an integer pointer
+ */
+static inline int cp2101_set_config_single(struct usb_serial_port* port,
+		u8 request, unsigned int data)
+{
+	return cp2101_set_config(port, request, &data, 2);
+}
+
+static int cp2101_open (struct usb_serial_port *port, struct file *filp)
+{
+	struct usb_serial *serial = port->serial;
+	int result;
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	if (cp2101_set_config_single(port, CP2101_UART, UART_ENABLE)) {
+		dev_err(&port->dev, "%s - Unable to enable UART\n",
+				__FUNCTION__);
+		return -EPROTO;
+	}
+
+	/* Start reading from the device */
+	usb_fill_bulk_urb (port->read_urb, serial->dev,
+			usb_rcvbulkpipe(serial->dev,
+			port->bulk_in_endpointAddress),
+			port->read_urb->transfer_buffer,
+			port->read_urb->transfer_buffer_length,
+			serial->type->read_bulk_callback,
+			port);
+	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
+	if (result) {
+		dev_err(&port->dev, "%s - failed resubmitting read urb, "
+				"error %d\n", __FUNCTION__, result);
+		return result;
+	}
+
+	/* Configure the termios structure */
+	cp2101_get_termios(port);
+
+	/* Set the DTR and RTS pins low */
+	cp2101_tiocmset(port, NULL, TIOCM_DTR | TIOCM_RTS, 0);
+
+	return 0;
+}
+
+static void cp2101_cleanup (struct usb_serial_port *port)
+{
+	struct usb_serial *serial = port->serial;
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	if (serial->dev) {
+		/* shutdown any bulk reads that might be going on */
+		if (serial->num_bulk_out)
+			usb_kill_urb(port->write_urb);
+		if (serial->num_bulk_in)
+			usb_kill_urb(port->read_urb);
+	}
+}
+
+static void cp2101_close (struct usb_serial_port *port, struct file * filp)
+{
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	/* shutdown our urbs */
+	dbg("%s - shutting down urbs", __FUNCTION__);
+	usb_kill_urb(port->write_urb);
+	usb_kill_urb(port->read_urb);
+
+	cp2101_set_config_single(port, CP2101_UART, UART_DISABLE);
+}
+
+/*
+ * cp2101_get_termios
+ * Reads the baud rate, data bits, parity, stop bits and flow control mode
+ * from the device, corrects any unsupported values, and configures the
+ * termios structure to reflect the state of the device
+ */
+static void cp2101_get_termios (struct usb_serial_port *port)
+{
+	unsigned int cflag, modem_ctl[4];
+	int baud;
+	int bits;
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	if (!port->tty || !port->tty->termios) {
+		dbg("%s - no tty structures", __FUNCTION__);
+		return;
+	}
+
+	cp2101_get_config(port, CP2101_BAUDRATE, &baud, 2);
+	/* Convert to baudrate */
+	if (baud)
+		baud = BAUD_RATE_GEN_FREQ / baud;
+
+	dbg("%s - baud rate = %d", __FUNCTION__, baud);
+
+	tty_encode_baud_rate(port->tty, baud, baud);
+	cflag = port->tty->termios->c_cflag;
+
+	cp2101_get_config(port, CP2101_BITS, &bits, 2);
+	cflag &= ~CSIZE;
+	switch(bits & BITS_DATA_MASK) {
+		case BITS_DATA_5:
+			dbg("%s - data bits = 5", __FUNCTION__);
+			cflag |= CS5;
+			break;
+		case BITS_DATA_6:
+			dbg("%s - data bits = 6", __FUNCTION__);
+			cflag |= CS6;
+			break;
+		case BITS_DATA_7:
+			dbg("%s - data bits = 7", __FUNCTION__);
+			cflag |= CS7;
+			break;
+		case BITS_DATA_8:
+			dbg("%s - data bits = 8", __FUNCTION__);
+			cflag |= CS8;
+			break;
+		case BITS_DATA_9:
+			dbg("%s - data bits = 9 (not supported, "
+					"using 8 data bits)", __FUNCTION__);
+			cflag |= CS8;
+			bits &= ~BITS_DATA_MASK;
+			bits |= BITS_DATA_8;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+		default:
+			dbg("%s - Unknown number of data bits, "
+					"using 8", __FUNCTION__);
+			cflag |= CS8;
+			bits &= ~BITS_DATA_MASK;
+			bits |= BITS_DATA_8;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+	}
+
+	switch(bits & BITS_PARITY_MASK) {
+		case BITS_PARITY_NONE:
+			dbg("%s - parity = NONE", __FUNCTION__);
+			cflag &= ~PARENB;
+			break;
+		case BITS_PARITY_ODD:
+			dbg("%s - parity = ODD", __FUNCTION__);
+			cflag |= (PARENB|PARODD);
+			break;
+		case BITS_PARITY_EVEN:
+			dbg("%s - parity = EVEN", __FUNCTION__);
+			cflag &= ~PARODD;
+			cflag |= PARENB;
+			break;
+		case BITS_PARITY_MARK:
+			dbg("%s - parity = MARK (not supported, "
+					"disabling parity)", __FUNCTION__);
+			cflag &= ~PARENB;
+			bits &= ~BITS_PARITY_MASK;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+		case BITS_PARITY_SPACE:
+			dbg("%s - parity = SPACE (not supported, "
+					"disabling parity)", __FUNCTION__);
+			cflag &= ~PARENB;
+			bits &= ~BITS_PARITY_MASK;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+		default:
+			dbg("%s - Unknown parity mode, "
+					"disabling parity", __FUNCTION__);
+			cflag &= ~PARENB;
+			bits &= ~BITS_PARITY_MASK;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+	}
+
+	cflag &= ~CSTOPB;
+	switch(bits & BITS_STOP_MASK) {
+		case BITS_STOP_1:
+			dbg("%s - stop bits = 1", __FUNCTION__);
+			break;
+		case BITS_STOP_1_5:
+			dbg("%s - stop bits = 1.5 (not supported, "
+					"using 1 stop bit)", __FUNCTION__);
+			bits &= ~BITS_STOP_MASK;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+		case BITS_STOP_2:
+			dbg("%s - stop bits = 2", __FUNCTION__);
+			cflag |= CSTOPB;
+			break;
+		default:
+			dbg("%s - Unknown number of stop bits, "
+					"using 1 stop bit", __FUNCTION__);
+			bits &= ~BITS_STOP_MASK;
+			cp2101_set_config(port, CP2101_BITS, &bits, 2);
+			break;
+	}
+
+	cp2101_get_config(port, CP2101_MODEMCTL, modem_ctl, 16);
+	if (modem_ctl[0] & 0x0008) {
+		dbg("%s - flow control = CRTSCTS", __FUNCTION__);
+		cflag |= CRTSCTS;
+	} else {
+		dbg("%s - flow control = NONE", __FUNCTION__);
+		cflag &= ~CRTSCTS;
+	}
+
+	port->tty->termios->c_cflag = cflag;
+}
+
+static void cp2101_set_termios (struct usb_serial_port *port,
+		struct ktermios *old_termios)
+{
+	unsigned int cflag, old_cflag;
+	int baud=0, bits;
+	unsigned int modem_ctl[4];
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	if (!port->tty || !port->tty->termios) {
+		dbg("%s - no tty structures", __FUNCTION__);
+		return;
+	}
+	port->tty->termios->c_cflag &= ~CMSPAR;
+
+	cflag = port->tty->termios->c_cflag;
+	old_cflag = old_termios->c_cflag;
+	baud = tty_get_baud_rate(port->tty);
+
+	/* If the baud rate is to be updated*/
+	if (baud != tty_termios_baud_rate(old_termios)) {
+		switch (baud) {
+			case 0:
+			case 600:
+			case 1200:
+			case 1800:
+			case 2400:
+			case 4800:
+			case 7200:
+			case 9600:
+			case 14400:
+			case 19200:
+			case 28800:
+			case 38400:
+			case 55854:
+			case 57600:
+			case 115200:
+			case 127117:
+			case 230400:
+			case 460800:
+			case 921600:
+			case 3686400:
+				break;
+			default:
+				baud = 9600;
+				break;
+		}
+
+		if (baud) {
+			dbg("%s - Setting baud rate to %d baud", __FUNCTION__,
+					baud);
+			if (cp2101_set_config_single(port, CP2101_BAUDRATE,
+						(BAUD_RATE_GEN_FREQ / baud))) {
+				dev_err(&port->dev, "Baud rate requested not "
+						"supported by device\n");
+				baud = tty_termios_baud_rate(old_termios);
+			}
+		}
+	}
+	/* Report back the resulting baud rate */
+	tty_encode_baud_rate(port->tty, baud, baud);
+
+	/* If the number of data bits is to be updated */
+	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {
+		cp2101_get_config(port, CP2101_BITS, &bits, 2);
+		bits &= ~BITS_DATA_MASK;
+		switch (cflag & CSIZE) {
+			case CS5:
+				bits |= BITS_DATA_5;
+				dbg("%s - data bits = 5", __FUNCTION__);
+				break;
+			case CS6:
+				bits |= BITS_DATA_6;
+				dbg("%s - data bits = 6", __FUNCTION__);
+				break;
+			case CS7:
+				bits |= BITS_DATA_7;
+				dbg("%s - data bits = 7", __FUNCTION__);
+				break;
+			case CS8:
+				bits |= BITS_DATA_8;
+				dbg("%s - data bits = 8", __FUNCTION__);
+				break;
+			/*case CS9:
+			 	bits |= BITS_DATA_9;
+				dbg("%s - data bits = 9", __FUNCTION__);
+				break;*/
+			default:
+				dev_err(&port->dev, "cp2101 driver does not "
+					"support the number of bits requested,"
+					" using 8 bit mode\n");
+				bits |= BITS_DATA_8;
+				break;
+		}
+		if (cp2101_set_config(port, CP2101_BITS, &bits, 2))
+			dev_err(&port->dev, "Number of data bits requested "
+					"not supported by device\n");
+	}
+
+	if ((cflag & (PARENB|PARODD)) != (old_cflag & (PARENB|PARODD))) {
+		cp2101_get_config(port, CP2101_BITS, &bits, 2);
+		bits &= ~BITS_PARITY_MASK;
+		if (cflag & PARENB) {
+			if (cflag & PARODD) {
+				bits |= BITS_PARITY_ODD;
+				dbg("%s - parity = ODD", __FUNCTION__);
+			} else {
+				bits |= BITS_PARITY_EVEN;
+				dbg("%s - parity = EVEN", __FUNCTION__);
+			}
+		}
+		if (cp2101_set_config(port, CP2101_BITS, &bits, 2))
+			dev_err(&port->dev, "Parity mode not supported "
+					"by device\n");
+	}
+
+	if ((cflag & CSTOPB) != (old_cflag & CSTOPB)) {
+		cp2101_get_config(port, CP2101_BITS, &bits, 2);
+		bits &= ~BITS_STOP_MASK;
+		if (cflag & CSTOPB) {
+			bits |= BITS_STOP_2;
+			dbg("%s - stop bits = 2", __FUNCTION__);
+		} else {
+			bits |= BITS_STOP_1;
+			dbg("%s - stop bits = 1", __FUNCTION__);
+		}
+		if (cp2101_set_config(port, CP2101_BITS, &bits, 2))
+			dev_err(&port->dev, "Number of stop bits requested "
+					"not supported by device\n");
+	}
+
+	if ((cflag & CRTSCTS) != (old_cflag & CRTSCTS)) {
+		cp2101_get_config(port, CP2101_MODEMCTL, modem_ctl, 16);
+		dbg("%s - read modem controls = 0x%.4x 0x%.4x 0x%.4x 0x%.4x",
+				__FUNCTION__, modem_ctl[0], modem_ctl[1],
+				modem_ctl[2], modem_ctl[3]);
+
+		if (cflag & CRTSCTS) {
+			modem_ctl[0] &= ~0x7B;
+			modem_ctl[0] |= 0x09;
+			modem_ctl[1] = 0x80;
+			dbg("%s - flow control = CRTSCTS", __FUNCTION__);
+		} else {
+			modem_ctl[0] &= ~0x7B;
+			modem_ctl[0] |= 0x01;
+			modem_ctl[1] |= 0x40;
+			dbg("%s - flow control = NONE", __FUNCTION__);
+		}
+
+		dbg("%s - write modem controls = 0x%.4x 0x%.4x 0x%.4x 0x%.4x",
+				__FUNCTION__, modem_ctl[0], modem_ctl[1],
+				modem_ctl[2], modem_ctl[3]);
+		cp2101_set_config(port, CP2101_MODEMCTL, modem_ctl, 16);
+	}
+
+}
+
+static int cp2101_tiocmset (struct usb_serial_port *port, struct file *file,
+		unsigned int set, unsigned int clear)
+{
+	int control = 0;
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	if (set & TIOCM_RTS) {
+		control |= CONTROL_RTS;
+		control |= CONTROL_WRITE_RTS;
+	}
+	if (set & TIOCM_DTR) {
+		control |= CONTROL_DTR;
+		control |= CONTROL_WRITE_DTR;
+	}
+	if (clear & TIOCM_RTS) {
+		control &= ~CONTROL_RTS;
+		control |= CONTROL_WRITE_RTS;
+	}
+	if (clear & TIOCM_DTR) {
+		control &= ~CONTROL_DTR;
+		control |= CONTROL_WRITE_DTR;
+	}
+
+	dbg("%s - control = 0x%.4x", __FUNCTION__, control);
+
+	return cp2101_set_config(port, CP2101_CONTROL, &control, 2);
+
+}
+
+static int cp2101_tiocmget (struct usb_serial_port *port, struct file *file)
+{
+	int control, result;
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+
+	cp2101_get_config(port, CP2101_CONTROL, &control, 1);
+
+	result = ((control & CONTROL_DTR) ? TIOCM_DTR : 0)
+		|((control & CONTROL_RTS) ? TIOCM_RTS : 0)
+		|((control & CONTROL_CTS) ? TIOCM_CTS : 0)
+		|((control & CONTROL_DSR) ? TIOCM_DSR : 0)
+		|((control & CONTROL_RING)? TIOCM_RI  : 0)
+		|((control & CONTROL_DCD) ? TIOCM_CD  : 0);
+
+	dbg("%s - control = 0x%.2x", __FUNCTION__, control);
+
+	return result;
+}
+
+static void cp2101_break_ctl (struct usb_serial_port *port, int break_state)
+{
+	int state;
+
+	dbg("%s - port %d", __FUNCTION__, port->number);
+	if (break_state == 0)
+		state = BREAK_OFF;
+	else
+		state = BREAK_ON;
+	dbg("%s - turning break %s", __FUNCTION__,
+			state==BREAK_OFF ? "off" : "on");
+	cp2101_set_config(port, CP2101_BREAK, &state, 2);
+}
+
+static int cp2101_startup (struct usb_serial *serial)
+{
+	/* CP2101 buffers behave strangely unless device is reset */
+	usb_reset_device(serial->dev);
+	return 0;
+}
+
+static void cp2101_shutdown (struct usb_serial *serial)
+{
+	int i;
+
+	dbg("%s", __FUNCTION__);
+
+	/* Stop reads and writes on all ports */
+	for (i=0; i < serial->num_ports; ++i) {
+		cp2101_cleanup(serial->port[i]);
+	}
+}
+
+static int __init cp2101_init (void)
+{
+	int retval;
+
+	retval = usb_serial_register(&cp2101_device);
+	if (retval)
+		return retval; /* Failed to register */
+
+	retval = usb_register(&cp2101_driver);
+	if (retval) {
+		/* Failed to register */
+		usb_serial_deregister(&cp2101_device);
+		return retval;
+	}
+
+	/* Success */
+	info(DRIVER_DESC " " DRIVER_VERSION);
+	return 0;
+}
+
+static void __exit cp2101_exit (void)
+{
+	usb_deregister (&cp2101_driver);
+	usb_serial_deregister (&cp2101_device);
+}
+
+module_init(cp2101_init);
+module_exit(cp2101_exit);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL");
+
+module_param(debug, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Enable verbose debugging messages");



