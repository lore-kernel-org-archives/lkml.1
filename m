Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175Ab0ASTUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0ASTUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454Ab0ASTUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:20:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:61971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0ASTUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:20:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=uZEvNpsin6hNjK1uGhncEtoHs0+78UIy5UbazvPRSRGDaOt8dNJCmGhlKH0XngbEaG
         rUdhEbN58ftG0wNR/Df3KnLcOfPs2P69z4yNbOXLfQrGQ9C3wLx8K9NitPmlp9G0eDEf
         azq4/NYM2lcQGzUUf0XCW08oqzXJBMX48pELQ=
MIME-Version: 1.0
From: David Holm <dholmster@gmail.com>
Date: Tue, 19 Jan 2010 20:19:40 +0100
Message-ID: <3194316b1001191119h6c15dd2bvbf32bf93a2d1730e@mail.gmail.com>
Subject: [PATCH] Backport of Sierra Wireless USB serial driver from 2.6 to 
	kernel 2.4.37
To: greg@kroah.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@sierrawireless.com,
       klloyd@sierrawireless.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a backport of the Sierra Wireless USB modem from
linux/kernel/git/torvalds/linux-2.6.git to kernel 2.4. We are actively
using this driver on our embedded systems running uClinux 2.4.26 on an
ARM7TDMI but the patch has been produced against 2.4.37. I did not
have time to prepare and run the entire 2.4.37 on our platform but I
did backport usbserial.c just to make sure that there woudln't be any
obvious problems. Hence, if anyone owns a Sierra Wireless modem and is
running 2.4.37 please help me double check that there are no hidden
surprises.
The driver has been run extensively with usbserial and sierra
debugging turned on. I've also done some tests with debugging enabled
in the USB subsystem but this was the first time ever that I had to
code a driver for a USB device so those message were usually of
limited help to me.

I've tried to retain formatting of the 2.6 code as much as possible to
make it easier to diff against newer revisions. This also means that I
intentionally did not fix code guideline errors in that code. The
portions that I have written myself should follow the guidelines
though.

The power management code was removed completely due to lack of
support in 2.4. Other than that I believe I was able to retain all of
the remaining functionality. We only have access to the Sierra
Wireless Compass 889 at work so that is the only hardware I've been
running it against but the only hardware that seems to need special
handling are the "direct IP modems" and that code should still be in
there untouched.

I'm pretty sure "sierra_intf_private" as well as the variable "opened"
in the "sierra_port_private" struct can be removed completely but I
left them in for now.

Even though I've worked on a couple of Linux projects before this is
my first submission so please be gentle. Any feedback will be greatly
appreciated.

Note: I'm not subscribed to any of the LKMLs so please CC any replies
directly to me, thank you.

Sincerely,
David Holm


diff --git a/Documentation/Configure.help b/Documentation/Configure.help
index 6d51d63..9ee7570 100644
--- a/Documentation/Configure.help
+++ b/Documentation/Configure.help
@@ -15620,6 +15620,14 @@ CONFIG_USB_SERIAL_KOBIL_SCT
   The module will be called kobil_sct.o. If you want to compile it as
   a module, say M here and read <file:Documentation/modules.txt>.

+USB Sierra Wireless Modem
+CONFIG_USB_SERIAL_SIERRA
+  Say Y here if you want to use a Sierra Wireless USB connected modem.
+
+  Note that if you have a TRU-Install modem you will need to use
+  USB_ModeSwitch (http://www.draisberghof.de/usb_modeswitch/) to enable
+  Sierra mode and disable the (read-only) USB storage partition.
+
 USB REINER SCT cyberJack pinpad/e-com chipcard reader
 CONFIG_USB_SERIAL_CYBERJACK
   Say Y here if you want to use a cyberJack pinpad/e-com USB chipcard
diff --git a/drivers/usb/serial/Config.in b/drivers/usb/serial/Config.in
index 5272c66..434c24b 100644
--- a/drivers/usb/serial/Config.in
+++ b/drivers/usb/serial/Config.in
@@ -41,6 +41,7 @@ if [ "$CONFIG_USB_SERIAL" != "n" ]; then
    dep_tristate '  USB REINER SCT cyberJack pinpad/e-com chipcard
reader (EXPERIMENTAL)' CONFIG_USB_SERIAL_CYBERJACK $CONFIG_USB_SERIAL
$CONFIG_EXPERIMENTAL
    dep_tristate '  USB Xircom / Entregra Single Port Serial Driver
(EXPERIMENTAL)' CONFIG_USB_SERIAL_XIRCOM $CONFIG_USB_SERIAL
$CONFIG_EXPERIMENTAL
    dep_tristate '  USB ZyXEL omni.net LCD Plus Driver (EXPERIMENTAL)'
CONFIG_USB_SERIAL_OMNINET $CONFIG_USB_SERIAL $CONFIG_EXPERIMENTAL
+   dep_tristate '  USB Sierra Wireless Driver (EXPERIMENTAL)'
CONFIG_USB_SERIAL_SIERRA $CONFIG_USB_SERIAL $CONFIG_EXPERIMENTAL
 fi

 endmenu
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index ce4c856..0a8d9e3 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_USB_SERIAL_CYBERJACK)		+= cyberjack.o
 obj-$(CONFIG_USB_SERIAL_IR)			+= ir-usb.o
 obj-$(CONFIG_USB_SERIAL_KLSI)			+= kl5kusb105.o
 obj-$(CONFIG_USB_SERIAL_KOBIL_SCT)		+= kobil_sct.o
+obj-$(CONFIG_USB_SERIAL_SIERRA)			+= sierra.o

 # Objects that export symbols.
 export-objs	:= usbserial.o
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
new file mode 100644
index 0000000..c7b0e23
--- /dev/null
+++ b/drivers/usb/serial/sierra.c
@@ -0,0 +1,1115 @@
+/*
+  USB Driver for Sierra Wireless
+
+  Copyright (C) 2006, 2007, 2008  Kevin Lloyd <klloyd@sierrawireless.com>,
+
+  Copyright (C) 2008, 2009  Elina Pasheva, Matthew Safar, Rory Filer
+			<linux@sierrawireless.com>
+
+  IMPORTANT DISCLAIMER: This driver is not commercially supported by
+  Sierra Wireless. Use at your own risk.
+
+  This driver is free software; you can redistribute it and/or modify
+  it under the terms of Version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  Portions based on the option driver by Matthias Urlichs
<smurf@smurf.noris.de>
+  Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
+
+  13-Jan-2010 David Holm <david dot holm at zetadisplay dot com>
+   - Backported to kernel 2.4 from driver for 2.6 from git
+     linux/kernel/git/torvalds/linux-2.6.git (latest commit
+     24bc7347da73a9ed3383056c3d0f28c0e361621e).
+     Some code was borrowed from Sierra Wireless (broken) driver for kernel 2.4
+     available at http://www.sierrawireless.com/support/customer_help.aspx.
+     If your modem is using TRU-Install use USB_ModeSwitch to disable it,
+     available at http://www.draisberghof.de/usb_modeswitch/.
+*/
+/* Uncomment to log function calls */
+/* #define DEBUG */
+#define DRIVER_VERSION "v.1.7.16"
+#define DRIVER_AUTHOR "Kevin Lloyd, Elina Pasheva, Matthew Safar, Rory Filer"
+#define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/slab.h>
+#include <asm/uaccess.h>
+
+#ifdef CONFIG_USB_SERIAL_DEBUG
+	static int debug = 1;
+#else
+	static int debug;
+#endif
+
+#include "usb-serial.h"
+
+#define SWIMS_USB_REQUEST_SetPower	0x00
+#define SWIMS_USB_REQUEST_SetNmea	0x07
+
+#define N_IN_URB_HM	8
+#define N_OUT_URB_HM	64
+#define N_IN_URB	4
+#define N_OUT_URB	4
+#define IN_BUFLEN	4096
+
+#define MAX_TRANSFER		(PAGE_SIZE - 512)
+/* MAX_TRANSFER is chosen so that the VM is not stressed by
+   allocations > PAGE_SIZE and the number of packets in a page
+   is an integer 512 is the largest possible packet on EHCI */
+
+#ifndef USB_CTRL_SET_TIMEOUT
+#define USB_CTRL_SET_TIMEOUT    5000
+#endif
+
+/* This symbol is exported from drivers/usb/serial/usb-serial.c in 2.6 */
+#define usb_serial_port_softint(port) \
+	if (!port_paranoia_check(port, __func__) && port->tqueue.routine) \
+		port->tqueue.routine(port);
+
+static int nmea;
+
+/* Used in interface blacklisting */
+struct sierra_iface_info {
+	const u32 infolen;	/* number of interface numbers on blacklist */
+	const u8  *ifaceinfo;	/* pointer to the array holding the numbers */
+};
+
+struct sierra_intf_private {
+	spinlock_t susp_lock;
+	unsigned int suspended:1;
+	int in_flight;
+};
+
+static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
+{
+	int result;
+	dbg("%s", __func__);
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			SWIMS_USB_REQUEST_SetPower,	/* __u8 request      */
+			USB_TYPE_VENDOR,		/* __u8 request type */
+			swiState,			/* __u16 value       */
+			0,				/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout 	     */
+	return result;
+}
+
+static int sierra_vsc_set_nmea(struct usb_device *udev, __u16 enable)
+{
+	int result;
+	dbg("%s\n", __func__);
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			SWIMS_USB_REQUEST_SetNmea,	/* __u8 request      */
+			USB_TYPE_VENDOR,		/* __u8 request type */
+			enable,				/* __u16 value       */
+			0x0000,				/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout       */
+	return result;
+}
+
+static int sierra_calc_num_ports(struct usb_serial *serial)
+{
+	int num_ports = 0;
+	u8 ifnum, numendpoints;
+
+	dbg("%s", __func__);
+
+	ifnum = serial->interface->altsetting[serial->interface->act_altsetting].bInterfaceNumber;
+	numendpoints =
serial->interface->altsetting[serial->interface->act_altsetting].bNumEndpoints;
+
+	/* Dummy interface present on some SKUs should be ignored */
+	if (ifnum == 0x99)
+		num_ports = 0;
+	else if (numendpoints <= 3)
+		num_ports = 1;
+	else
+		num_ports = (numendpoints-1)/2;
+	return num_ports;
+}
+
+static int is_blacklisted(const u8 ifnum,
+				const struct sierra_iface_info *blacklist)
+{
+	const u8  *info;
+	int i;
+
+	if (blacklist) {
+		info = blacklist->ifaceinfo;
+
+		for (i = 0; i < blacklist->infolen; i++) {
+			if (info[i] == ifnum)
+				return 1;
+		}
+	}
+	return 0;
+}
+
+static int is_himemory(const u8 ifnum,
+				const struct sierra_iface_info *himemorylist)
+{
+	const u8  *info;
+	int i;
+
+	if (himemorylist) {
+		info = himemorylist->ifaceinfo;
+
+		for (i=0; i < himemorylist->infolen; i++) {
+			if (info[i] == ifnum)
+				return 1;
+		}
+	}
+	return 0;
+}
+
+static int sierra_calc_interface(struct usb_serial *serial)
+{
+	int interface;
+	struct usb_interface *p_interface;
+	struct usb_interface_descriptor *p_interface_desc;
+	dbg("%s", __func__);
+
+	/* Get the interface structure pointer from the serial struct */
+	p_interface = serial->interface;
+
+	/* Get a pointer to the host interface structure */
+	p_interface_desc = &p_interface->altsetting[p_interface->act_altsetting];
+
+	/* read the interface descriptor for this active altsetting
+	 * to find out the interface number we are on
+	*/
+	interface = p_interface_desc->iInterface;
+
+	return interface;
+}
+
+static int sierra_probe(struct usb_serial *serial)
+{
+	int result = 0;
+	struct usb_device *udev;
+	struct sierra_intf_private *data;
+	const struct usb_device_id *id = NULL;
+	u8 ifnum;
+
+	udev = serial->dev;
+	dbg("%s", __func__);
+
+	ifnum = sierra_calc_interface(serial);
+	/*
+	 * If this interface supports more than 1 alternate
+	 * select the 2nd one
+	 */
+	if (serial->interface->num_altsetting == 2) {
+		dbg("Selecting alt setting for interface %d",
+			ifnum);
+		/* We know the alternate setting is 1 for the MC8785 */
+		usb_set_interface(udev, ifnum, 1);
+	}
+
+	/* ifnum could have changed - by calling usb_set_interface */
+	ifnum = sierra_calc_interface(serial);
+
+	id = usb_match_id(serial->dev, serial->interface, serial->type->id_table);
+	if (id == NULL) {
+		err("USB device not found in ID table");
+		return -ENODEV;
+	}
+
+	if (is_blacklisted(ifnum,
+				(struct sierra_iface_info *)id->driver_info)) {
+		dbg("Ignoring blacklisted interface #%d\n", ifnum);
+		return -ENODEV;
+	}
+
+	data = serial->private = kmalloc(sizeof(struct sierra_intf_private),
GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	memset(data, 0UL, sizeof(struct sierra_intf_private));
+	spin_lock_init(&data->susp_lock);
+
+	return result;
+}
+
+/* interfaces with higher memory requirements */
+static const u8 hi_memory_typeA_ifaces[] = { 0, 2 };
+static const struct sierra_iface_info typeA_interface_list = {
+	.infolen = ARRAY_SIZE(hi_memory_typeA_ifaces),
+	.ifaceinfo = hi_memory_typeA_ifaces,
+};
+
+static const u8 hi_memory_typeB_ifaces[] = { 3, 4, 5, 6 };
+static const struct sierra_iface_info typeB_interface_list = {
+	.infolen = ARRAY_SIZE(hi_memory_typeB_ifaces),
+	.ifaceinfo = hi_memory_typeB_ifaces,
+};
+
+/* 'blacklist' of interfaces not served by this driver */
+static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9, 10, 11 };
+static const struct sierra_iface_info direct_ip_interface_blacklist = {
+	.infolen = ARRAY_SIZE(direct_ip_non_serial_ifaces),
+	.ifaceinfo = direct_ip_non_serial_ifaces,
+};
+
+/* USB_DEVICE_AND_INTERFACE_INFO was copied from include/linux/usb.h in 2.6 */
+/**
+ * USB_DEVICE_AND_INTERFACE_INFO - describe a specific usb device
with a class of usb interfaces
+ * @vend: the 16 bit USB Vendor ID
+ * @prod: the 16 bit USB Product ID
+ * @cl: bInterfaceClass value
+ * @sc: bInterfaceSubClass value
+ * @pr: bInterfaceProtocol value
+ *
+ * This macro is used to create a struct usb_device_id that matches a
+ * specific device with a specific class of interfaces.
+ *
+ * This is especially useful when explicitly matching devices that have
+ * vendor specific bDeviceClass values, but standards-compliant interfaces.
+ */
+#ifndef USB_DEVICE_AND_INTERFACE_INFO
+#define USB_DEVICE_AND_INTERFACE_INFO(vend, prod, cl, sc, pr) \
+        .match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
+                | USB_DEVICE_ID_MATCH_DEVICE, \
+        .idVendor = (vend), \
+        .idProduct = (prod), \
+        .bInterfaceClass = (cl), \
+        .bInterfaceSubClass = (sc), \
+        .bInterfaceProtocol = (pr)
+#endif
+
+static struct usb_device_id id_table [] = {
+	{ USB_DEVICE(0X0F3D, 0X0112) }, /* AIRPRIME/SIERRA PC 5220 */
+	{ USB_DEVICE(0X03F0, 0X1B1D) },	/* HP EV2200 A.K.A MC5720 */
+	{ USB_DEVICE(0X03F0, 0X1E1D) },	/* HP HS2300 A.K.A MC8775 */
+
+	{ USB_DEVICE(0X1199, 0X0017) },	/* SIERRA WIRELESS EM5625 */
+	{ USB_DEVICE(0X1199, 0X0018) },	/* SIERRA WIRELESS MC5720 */
+	{ USB_DEVICE(0X1199, 0X0218) },	/* SIERRA WIRELESS MC5720 */
+	{ USB_DEVICE(0X1199, 0X0020) },	/* SIERRA WIRELESS MC5725 */
+	{ USB_DEVICE(0X1199, 0X0220) },	/* SIERRA WIRELESS MC5725 */
+	{ USB_DEVICE(0X1199, 0X0022) },	/* SIERRA WIRELESS EM5725 */
+	{ USB_DEVICE(0X1199, 0X0024) },	/* SIERRA WIRELESS MC5727 */
+	{ USB_DEVICE(0X1199, 0X0224) },	/* SIERRA WIRELESS MC5727 */
+	{ USB_DEVICE(0X1199, 0X0019) },	/* SIERRA WIRELESS AIRCARD 595 */
+	{ USB_DEVICE(0X1199, 0X0021) },	/* SIERRA WIRELESS AIRCARD 597E */
+	{ USB_DEVICE(0X1199, 0X0112) }, /* SIERRA WIRELESS AIRCARD 580 */
+	{ USB_DEVICE(0X1199, 0X0120) },	/* SIERRA WIRELESS USB DONGLE 595U */
+	/* SIERRA WIRELESS C597 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0X1199, 0X0023, 0XFF, 0XFF, 0XFF) },
+	/* SIERRA WIRELESS T598 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0X1199, 0X0025, 0xFF, 0xFF, 0xFF) },
+	{ USB_DEVICE(0X1199, 0X0026) }, /* SIERRA WIRELESS T11 */
+	{ USB_DEVICE(0X1199, 0X0027) }, /* SIERRA WIRELESS AC402 */
+	{ USB_DEVICE(0X1199, 0X0028) }, /* SIERRA WIRELESS MC5728 */
+	{ USB_DEVICE(0X1199, 0X0029) }, /* SIERRA WIRELESS DEVICE */
+
+	{ USB_DEVICE(0X1199, 0X6802) },	/* SIERRA WIRELESS MC8755 */
+	{ USB_DEVICE(0X1199, 0X6803) },	/* SIERRA WIRELESS MC8765 */
+	{ USB_DEVICE(0X1199, 0X6804) },	/* SIERRA WIRELESS MC8755 */
+	{ USB_DEVICE(0x1199, 0x6805) },	/* Sierra Wireless MC8765 */
+	{ USB_DEVICE(0x1199, 0x6808) },	/* Sierra Wireless MC8755 */
+	{ USB_DEVICE(0x1199, 0x6809) },	/* Sierra Wireless MC8765 */
+	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
+	{ USB_DEVICE(0x1199, 0x6813) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6815) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6816) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
+	{ USB_DEVICE(0x1199, 0x6821) },	/* Sierra Wireless AirCard 875U */
+	{ USB_DEVICE(0x1199, 0x6822) },	/* Sierra Wireless AirCard 875E */
+	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780 */
+	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781 */
+	{ USB_DEVICE(0x1199, 0x6834) },	/* Sierra Wireless MC8780 */
+	{ USB_DEVICE(0x1199, 0x6835) },	/* Sierra Wireless MC8781 */
+	{ USB_DEVICE(0x1199, 0x6838) },	/* Sierra Wireless MC8780 */
+	{ USB_DEVICE(0x1199, 0x6839) },	/* Sierra Wireless MC8781 */
+	{ USB_DEVICE(0x1199, 0x683A) },	/* Sierra Wireless MC8785 */
+	{ USB_DEVICE(0x1199, 0x683B) },	/* Sierra Wireless MC8785 Composite */
+	/* Sierra Wireless MC8790, MC8791, MC8792 Composite */
+	{ USB_DEVICE(0x1199, 0x683C) },
+	{ USB_DEVICE(0x1199, 0x683D) },	/* Sierra Wireless MC8791 Composite */
+	/* Sierra Wireless MC8790, MC8791, MC8792 */
+	{ USB_DEVICE(0x1199, 0x683E) },
+	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
+	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
+	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
+	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U */
+	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
+	{ USB_DEVICE(0x1199, 0x6859) },	/* Sierra Wireless AirCard 885 E */
+	{ USB_DEVICE(0x1199, 0x685A) },	/* Sierra Wireless AirCard 885 E */
+	/* Sierra Wireless C885 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6880, 0xFF, 0xFF, 0xFF) },
+	/* Sierra Wireless C888, Air Card 501, USB 303, USB 304 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6890, 0xFF, 0xFF, 0xFF) },
+	/* Sierra Wireless C22/C33 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6891, 0xFF, 0xFF, 0xFF) },
+	/* Sierra Wireless HSPA Non-Composite Device */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6892, 0xFF, 0xFF, 0xFF) },
+	{ USB_DEVICE(0x1199, 0x6893) },	/* Sierra Wireless Device */
+	{ USB_DEVICE(0x1199, 0x68A3),	/* Sierra Wireless Direct IP modems */
+	  driver_info: (unsigned long) &direct_ip_interface_blacklist
+	},
+
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, id_table);
+
+struct sierra_port_private {
+	spinlock_t lock;	/* lock the structure */
+	int outstanding_urbs;	/* number of out urbs in flight */
+
+	int num_out_urbs;
+	int num_in_urbs;
+	/* Input endpoints and buffers for this port */
+	struct urb *in_urbs[N_IN_URB_HM];
+
+	/* Settings for the port */
+	int rts_state;	/* Handshaking pins (outputs) */
+	int dtr_state;
+	int cts_state;	/* Handshaking pins (inputs) */
+	int dsr_state;
+	int dcd_state;
+	int ri_state;
+	unsigned int opened:1;
+};
+
+static int sierra_send_setup(struct usb_serial_port *port)
+{
+	struct usb_serial *serial = port->serial;
+	struct sierra_port_private *portdata;
+	__u16 interface = 0;
+	int val = 0;
+	int do_send = 0;
+	int retval;
+
+	dbg("%s", __func__);
+
+	portdata = usb_get_serial_port_data(port);
+
+	if (portdata->dtr_state)
+		val |= 0x01;
+	if (portdata->rts_state)
+		val |= 0x02;
+
+	/* If composite device then properly report interface */
+	if (serial->num_ports == 1) {
+		interface = sierra_calc_interface(serial);
+		/* Control message is sent only to interfaces with
+		 * interrupt_in endpoints
+		 */
+		if (port->interrupt_in_urb) {
+			/* send control message */
+			do_send = 1;
+		}
+	}
+
+	/* Otherwise the need to do non-composite mapping */
+	else {
+		if (port->bulk_out_endpointAddress == 2)
+			interface = 0;
+		else if (port->bulk_out_endpointAddress == 4)
+			interface = 1;
+		else if (port->bulk_out_endpointAddress == 5)
+			interface = 2;
+
+		do_send = 1;
+	}
+	if (!do_send)
+		return 0;
+
+	retval = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+		0x22, 0x21, val, interface, NULL, 0, USB_CTRL_SET_TIMEOUT);
+
+	return retval;
+}
+
+static void sierra_set_termios(struct usb_serial_port *port,
+				struct termios *old)
+{
+	dbg("%s - port %d", __func__, port->number);
+	sierra_send_setup(port);
+}
+
+static int sierra_tiocmget(struct usb_serial_port *port, struct file *file)
+{
+	unsigned int value;
+	struct sierra_port_private *portdata;
+
+	dbg("%s", __func__);
+	portdata = usb_get_serial_port_data(port);
+
+	value = ((portdata->rts_state) ? TIOCM_RTS : 0) |
+		((portdata->dtr_state) ? TIOCM_DTR : 0) |
+		((portdata->cts_state) ? TIOCM_CTS : 0) |
+		((portdata->dsr_state) ? TIOCM_DSR : 0) |
+		((portdata->dcd_state) ? TIOCM_CAR : 0) |
+		((portdata->ri_state) ? TIOCM_RNG : 0);
+
+	return value;
+}
+
+static int sierra_tiocmset(struct usb_serial_port *port, unsigned int
cmd, unsigned int *value)
+{
+	struct sierra_port_private *portdata;
+	unsigned int arg;
+
+	dbg("%s", __func__);
+	portdata = usb_get_serial_port_data(port);
+
+	if (copy_from_user(&arg, value, sizeof(int)))
+		return -EFAULT;
+
+	switch (cmd) {
+		case TIOCMBIS:
+			if (arg & TIOCM_RTS)
+				portdata->rts_state = 1;
+			if (arg & TIOCM_DTR)
+				portdata->dtr_state = 1;
+			break;
+
+		case TIOCMBIC:
+			if (arg & TIOCM_RTS)
+				portdata->rts_state = 0;
+			if (arg & TIOCM_DTR)
+				portdata->dtr_state = 0;
+			break;
+
+		case TIOCMSET:
+			portdata->rts_state = ((arg & TIOCM_RTS) ? 1 : 0);
+			portdata->dtr_state = ((arg & TIOCM_DTR) ? 1 : 0);
+			break;
+	}
+
+	return sierra_send_setup(port);
+}
+
+static int sierra_ioctl(struct usb_serial_port *port, struct file
*file, unsigned int cmd, unsigned long arg)
+{
+	unsigned int value;
+	dbg("%s (%d) cmd = 0x%04x", __func__, port->number, cmd);
+
+	switch (cmd) {
+		case TIOCMGET:
+			dbg("%s (%d) TIOCMGET", __func__, port->number);
+			value = sierra_tiocmget(port, file);
+			if (copy_to_user((unsigned int *) arg, &value, sizeof(unsigned int)))
+				return -EFAULT;
+			return 0;
+
+		case TIOCMBIS:
+		case TIOCMBIC:
+		case TIOCMSET:
+			dbg("%s (%d) TIOCMSET/TIOCMBIC/TIOCMSET", __func__,  port->number);
+			if (copy_from_user(&value, (unsigned int *) arg, sizeof(unsigned int)))
+				return -EFAULT;
+			return sierra_tiocmset(port, cmd, &value);
+
+		default:
+			dbg("%s not supported = 0x%04x", __func__, cmd);
+			break;
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static void sierra_release_urb(struct urb *urb)
+{
+	struct usb_serial_port *port;
+	if (urb) {
+		port = urb->context;
+		dbg("%s: %p", __func__, urb);
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+	}
+}
+
+static void sierra_outdat_callback(struct urb *urb)
+{
+	struct usb_serial_port *port = urb->context;
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+	struct sierra_intf_private *intfdata;
+	int status = urb->status;
+
+	if (port_paranoia_check(port, __func__)) {
+		err("%s: usb serial port no longer available", __func__);
+		return;
+	}
+
+	dbg("%s - port %d", __func__, port->number);
+	intfdata = port->serial->private;
+
+	sierra_release_urb(urb);
+	if (status)
+		dbg("%s - nonzero write bulk status "
+		    "received: %d", __func__, status);
+
+	spin_lock(&portdata->lock);
+	--portdata->outstanding_urbs;
+	spin_unlock(&portdata->lock);
+	spin_lock(&intfdata->susp_lock);
+	--intfdata->in_flight;
+	spin_unlock(&intfdata->susp_lock);
+
+	usb_serial_port_softint(port);
+}
+
+/* Write */
+static int sierra_write(struct usb_serial_port *port, int from_user,
+					const unsigned char *buf, int count)
+{
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+	struct sierra_intf_private *intfdata;
+	struct usb_serial *serial = port->serial;
+	unsigned long flags;
+	unsigned char *buffer;
+	struct urb *urb;
+	size_t writesize = min((size_t)count, (size_t)MAX_TRANSFER);
+	int retval = 0;
+
+	/* verify that we actually have some data to write */
+	if (count == 0)
+		return 0;
+
+	portdata = usb_get_serial_port_data(port);
+	intfdata = serial->private;
+
+	dbg("%s: write (%d bytes)", __func__, writesize);
+	spin_lock_irqsave(&portdata->lock, flags);
+	dbg("%s - outstanding_urbs: %d", __func__,
+		portdata->outstanding_urbs);
+	if (portdata->outstanding_urbs > portdata->num_out_urbs) {
+		spin_unlock_irqrestore(&portdata->lock, flags);
+		dbg("%s - write limit hit", __func__);
+		return 0;
+	}
+	portdata->outstanding_urbs++;
+	dbg("%s - 1, outstanding_urbs: %d", __func__,
+		portdata->outstanding_urbs);
+	spin_unlock_irqrestore(&portdata->lock, flags);
+
+	buffer = kmalloc(writesize, GFP_ATOMIC);
+	if (!buffer) {
+		err("%s: out of memory", __func__);
+		retval = -ENOMEM;
+		goto error_no_buffer;
+	}
+
+	urb = usb_alloc_urb(0);
+	if (!urb) {
+		err("%s: no more free urbs", __func__);
+		retval = -ENOMEM;
+		goto error_no_urb;
+	}
+
+	if (from_user) {
+		if (copy_from_user(buffer, buf, writesize))
+			return -EFAULT;
+	} else {
+		memcpy(buffer, buf, writesize);
+	}
+
+	usb_serial_debug_data(__FILE__, __func__, writesize, buffer);
+
+	usb_fill_bulk_urb(urb, serial->dev,
+			  usb_sndbulkpipe(serial->dev,
+					  port->bulk_out_endpointAddress),
+			  buffer, writesize, sierra_outdat_callback, port);
+
+	/* Handle the need to send a zero length packet */
+	urb->transfer_flags |= USB_ZERO_PACKET;
+
+	spin_lock_irqsave(&intfdata->susp_lock, flags);
+
+	/* send it down the pipe */
+	retval = usb_submit_urb(urb);
+	if (retval) {
+		spin_unlock_irqrestore(&intfdata->susp_lock, flags);
+		err("%s - usb_submit_urb(write bulk) failed "
+			"with status = %d", __func__, retval);
+		goto error;
+	} else {
+		intfdata->in_flight++;
+		spin_unlock_irqrestore(&intfdata->susp_lock, flags);
+	}
+
+	return writesize;
+error:
+	usb_free_urb(urb);
+error_no_urb:
+	kfree(buffer);
+error_no_buffer:
+	spin_lock_irqsave(&portdata->lock, flags);
+	--portdata->outstanding_urbs;
+	dbg("%s - 2. outstanding_urbs: %d", __func__,
+		portdata->outstanding_urbs);
+	spin_unlock_irqrestore(&portdata->lock, flags);
+	return retval;
+}
+
+static void sierra_indat_callback(struct urb *urb)
+{
+	int err;
+	int endpoint;
+	struct usb_serial_port *port;
+	struct tty_struct *tty;
+	unsigned char *data = urb->transfer_buffer;
+	int status = urb->status;
+
+	endpoint = usb_pipeendpoint(urb->pipe);
+	port = urb->context;
+	if (port_paranoia_check(port,__FUNCTION__)) {
+		/* device unplugged? */
+		sierra_release_urb(urb);
+		return;
+	}
+
+	dbg("%s: %p", __func__, urb);
+
+	tty = port->tty;
+	if (status) {
+		dbg("%s: nonzero status: %d on"
+			" endpoint %02x", __func__, status, endpoint);
+	} else if (!tty) {
+		err("%s: no tty attached to port", __func__);
+		sierra_release_urb(urb);
+		return;
+	} else {
+		if (urb->actual_length) {
+			int i;
+
+			for (i = 0; i < urb->actual_length; ++i) {
+				if(tty->flip.count >= TTY_FLIPBUF_SIZE) {
+					tty_flip_buffer_push(tty);
+				}
+				tty_insert_flip_char(tty, data[i], TTY_NORMAL);
+			}
+			tty_flip_buffer_push(tty);
+
+			usb_serial_debug_data(__FILE__, __func__,
+				urb->actual_length, data);
+		} else {
+			dbg("%s: empty read urb"
+				" received\n", __func__);
+		}
+	}
+
+	/* Resubmit urb so we continue receiving */
+	if (port->open_count && status != -ESHUTDOWN && status != -EPERM) {
+		urb->dev = port->serial->dev;
+		err = usb_submit_urb(urb);
+		if (err)
+			err("resubmit read urb failed."
+				"(%d)\n", err);
+	}
+}
+
+static void sierra_instat_callback(struct urb *urb)
+{
+	int status = urb->status;
+	struct usb_serial_port *port = urb->context;
+	struct sierra_port_private *portdata;
+	struct usb_serial *serial;
+
+	if (port_paranoia_check(port, __func__)) {
+		err("%s: usb serial port unavailable", __func__);
+		sierra_release_urb(urb);
+		return;
+	}
+	portdata = usb_get_serial_port_data(port);
+	serial = port->serial;
+	dbg("%s: urb %p port %p has data %p", __func__,
+		urb, port, portdata);
+
+	if (status == 0) {
+		struct usb_ctrlrequest *req_pkt =
+				(struct usb_ctrlrequest *)urb->transfer_buffer;
+
+		usb_serial_debug_data (__FILE__, __FUNCTION__,
+				       urb->actual_length,
+				       urb->transfer_buffer);
+
+		if (!req_pkt) {
+			dbg("%s: NULL req_pkt",
+				__func__);
+			return;
+		}
+		if ((req_pkt->bRequestType == 0xA1) &&
+				(req_pkt->bRequest == 0x20)) {
+			int old_dcd_state;
+			unsigned char signals = *((unsigned char *)
+					urb->transfer_buffer +
+					sizeof(struct usb_ctrlrequest));
+			struct tty_struct *tty;
+
+			dbg("%s: signal x%x", __func__,
+				signals);
+
+			old_dcd_state = portdata->dcd_state;
+			portdata->cts_state = 1;
+			portdata->dcd_state = ((signals & 0x01) ? 1 : 0);
+			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
+			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
+
+			tty = port->tty;
+			if (tty && !C_CLOCAL(tty) &&
+					old_dcd_state && !portdata->dcd_state)
+				tty_hangup(tty);
+		} else {
+			dbg("%s: type %x req %x",
+				__func__, req_pkt->bRequestType,
+				req_pkt->bRequest);
+		}
+	} else
+		dbg("%s: error %d", __func__, status);
+
+	/* Interrupt URBs should not be resubmitted in 2.4 */
+}
+
+static int sierra_write_room(struct usb_serial_port *port)
+{
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+	unsigned long flags;
+
+	dbg("%s - port %d", __func__, port->number);
+
+	/* try to give a good number back based on if we have any free urbs at
+	 * this point in time */
+	spin_lock_irqsave(&portdata->lock, flags);
+	if (portdata->outstanding_urbs > (portdata->num_out_urbs * 2) / 3) {
+		spin_unlock_irqrestore(&portdata->lock, flags);
+		dbg("%s - write limit hit", __func__);
+		return 0;
+	}
+	spin_unlock_irqrestore(&portdata->lock, flags);
+
+	return 2048;
+}
+
+static void sierra_stop_rx_urbs(struct usb_serial_port *port)
+{
+	int i;
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+
+	for (i = 0; i < portdata->num_in_urbs; i++)
+		usb_unlink_urb(portdata->in_urbs[i]);
+
+	usb_unlink_urb(port->interrupt_in_urb);
+}
+
+static int sierra_submit_rx_urbs(struct usb_serial_port *port)
+{
+	int ok_cnt;
+	int err = -EINVAL;
+	int i;
+	struct urb *urb;
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
+
+	ok_cnt = 0;
+	for (i = 0; i < portdata->num_in_urbs; i++) {
+		urb = portdata->in_urbs[i];
+		if (!urb)
+			continue;
+		err = usb_submit_urb(urb);
+		if (err) {
+			err("%s: submit urb failed on port %d: %d",
+				__func__, port->number, err);
+		} else {
+			ok_cnt++;
+		}
+	}
+
+	if (ok_cnt && port->interrupt_in_urb) {
+		port->interrupt_in_urb->dev = port->serial->dev;
+		err = usb_submit_urb(port->interrupt_in_urb);
+		if (err) {
+			err("%s: submit intr urb failed on port %d: %d",
+				__func__, port->number, err);
+		}
+	}
+
+	if (ok_cnt > 0) /* at least one rx urb submitted */
+		return 0;
+	else
+		return err;
+}
+
+static struct urb *sierra_setup_urb(struct usb_serial *serial, int endpoint,
+					int dir, void *ctx, int len,
+					int mem_flags,
+					usb_complete_t callback)
+{
+	struct urb	*urb;
+	u8		*buf;
+
+	if (endpoint == -1)
+		return NULL;
+
+	urb = usb_alloc_urb(0);
+	if (urb == NULL) {
+		dbg("%s: alloc for endpoint %d failed",
+			__func__, endpoint);
+		return NULL;
+	}
+
+	buf = kmalloc(len, mem_flags);
+	if (buf) {
+		/* Fill URB using supplied data */
+		usb_fill_bulk_urb(urb, serial->dev,
+			usb_sndbulkpipe(serial->dev, endpoint) | dir,
+			buf, len, callback, ctx);
+
+		/* debug */
+		dbg("%s %c u: %p d:%p", __func__,
+				dir == USB_DIR_IN ? 'i' : 'o', urb, buf);
+	} else {
+		dbg("%s %c u:%p d:%p", __func__,
+				dir == USB_DIR_IN ? 'i' : 'o', urb, buf);
+
+		sierra_release_urb(urb);
+		urb = NULL;
+	}
+
+	return urb;
+}
+
+static void sierra_close(struct usb_serial_port *port, struct file *filp)
+{
+	int i;
+	struct usb_serial *serial;
+	struct sierra_port_private *portdata;
+	struct sierra_intf_private *intfdata;
+
+
+	dbg("%s", __func__);
+
+	if (port_paranoia_check(port, __func__))
+		return;
+	serial = get_usb_serial(port, __func__);
+	if (!serial)
+		return;
+	portdata = usb_get_serial_port_data(port);
+	intfdata = serial->private;
+
+	portdata->rts_state = 0;
+	portdata->dtr_state = 0;
+
+	if (serial->dev) {
+		sierra_send_setup(port);
+		spin_lock_irq(&intfdata->susp_lock);
+		portdata->opened = 0;
+		spin_unlock_irq(&intfdata->susp_lock);
+
+
+		/* Stop reading urbs */
+		sierra_stop_rx_urbs(port);
+		/* .. and release them */
+		for (i = 0; i < portdata->num_in_urbs; i++) {
+			sierra_release_urb(portdata->in_urbs[i]);
+			portdata->in_urbs[i] = NULL;
+		}
+	}
+}
+
+static int sierra_open(struct usb_serial_port *port, struct file *filp)
+{
+	struct sierra_port_private *portdata;
+	struct usb_serial *serial = port->serial;
+	struct sierra_intf_private *intfdata = serial->private;
+	int i;
+	int err;
+	int endpoint;
+	struct urb *urb;
+
+	portdata = usb_get_serial_port_data(port);
+
+	dbg("%s", __func__);
+
+	if (port->tty)
+		port->tty->low_latency = 1;
+
+	/* Set some sane defaults */
+	portdata->rts_state = 1;
+	portdata->dtr_state = 1;
+
+
+	endpoint = port->bulk_in_endpointAddress;
+	for (i = 0; i < portdata->num_in_urbs; i++) {
+		urb = sierra_setup_urb(serial, endpoint, USB_DIR_IN, port,
+					IN_BUFLEN, GFP_KERNEL,
+					sierra_indat_callback);
+		portdata->in_urbs[i] = urb;
+	}
+
+	/* If the interval is lower than 1 << 3 the USB subsystem will reject it */
+	if (port->interrupt_in_urb && port->interrupt_in_urb->interval < 9)
+		port->interrupt_in_urb->interval = 9; /* 32ms */
+
+	/* clear halt condition */
+	usb_clear_halt(serial->dev,
+			usb_sndbulkpipe(serial->dev, endpoint) | USB_DIR_IN);
+
+	err = sierra_submit_rx_urbs(port);
+	if (err) {
+		err("%s: failed to submit rx urbs (%d)", __func__, err);
+		/* get rid of everything as in close */
+		sierra_close(port, NULL);
+		return err;
+	}
+	sierra_send_setup(port);
+
+	spin_lock_irq(&intfdata->susp_lock);
+	portdata->opened = 1;
+	spin_unlock_irq(&intfdata->susp_lock);
+
+	return 0;
+}
+
+
+static int sierra_startup(struct usb_serial *serial)
+{
+	struct usb_serial_port *port;
+	struct sierra_port_private *portdata;
+	struct sierra_iface_info *himemoryp = NULL;
+	int i;
+	int result;
+	u8 ifnum;
+
+	dbg("%s", __func__);
+
+	result = sierra_probe(serial);
+	if (result != 0)
+		return result;
+
+	serial->type->num_ports = sierra_calc_num_ports(serial);
+
+	/* Set Device mode to D0 */
+	sierra_set_power_state(serial->dev, 0x0000);
+
+	/* Check NMEA and set */
+	if (nmea)
+		sierra_vsc_set_nmea(serial->dev, 1);
+
+	/* Now setup per port private data */
+	for (i = 0; i < serial->num_ports; i++) {
+		port = &serial->port[i];
+		portdata = kmalloc(sizeof(*portdata), GFP_KERNEL);
+		if (!portdata) {
+			dbg("%s: kmalloc for "
+				"sierra_port_private (%d) failed!",
+				__func__, i);
+			return -ENOMEM;
+		}
+		memset(portdata, 0UL, sizeof(*portdata));
+		spin_lock_init(&portdata->lock);
+		ifnum = i;
+		/* Assume low memory requirements */
+		portdata->num_out_urbs = N_OUT_URB;
+		portdata->num_in_urbs  = N_IN_URB;
+
+		/* Determine actual memory requirements */
+		if (serial->num_ports == 1) {
+			/* Get interface number for composite device */
+			ifnum = sierra_calc_interface(serial);
+			himemoryp =
+			    (struct sierra_iface_info *)&typeB_interface_list;
+			if (is_himemory(ifnum, himemoryp)) {
+				portdata->num_out_urbs = N_OUT_URB_HM;
+				portdata->num_in_urbs  = N_IN_URB_HM;
+			}
+		}
+		else {
+			himemoryp =
+			    (struct sierra_iface_info *)&typeA_interface_list;
+			if (is_himemory(i, himemoryp)) {
+				portdata->num_out_urbs = N_OUT_URB_HM;
+				portdata->num_in_urbs  = N_IN_URB_HM;
+			}
+		}
+		dbg("Memory usage (urbs) interface #%d, in=%d, out=%d",
+			ifnum,portdata->num_in_urbs, portdata->num_out_urbs );
+		/* Set the port private data pointer */
+		usb_set_serial_port_data(port, portdata);
+	}
+
+	return 0;
+}
+
+static void sierra_release(struct usb_serial *serial)
+{
+	int i;
+	struct usb_serial_port *port;
+	struct sierra_port_private *portdata;
+
+	dbg("%s", __func__);
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = &serial->port[i];
+		if (!port)
+			continue;
+		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
+		kfree(portdata);
+	}
+}
+
+static struct usb_serial_device_type sierra_device = {
+	.owner             = THIS_MODULE,
+	.name              = "sierra",
+	.id_table          = id_table,
+	.num_interrupt_in  = NUM_DONT_CARE,
+	.num_bulk_in       = 1,
+	.num_bulk_out      = 1,
+	.num_ports         = 1,
+	.open              = sierra_open,
+	.close             = sierra_close,
+	.write             = sierra_write,
+	.write_room        = sierra_write_room,
+	.ioctl             = sierra_ioctl,
+	.set_termios       = sierra_set_termios,
+	.startup           = sierra_startup,
+	.shutdown          = sierra_release,
+	.read_int_callback = sierra_instat_callback,
+};
+
+/* Functions used by new usb-serial code. */
+static int __init sierra_init(void)
+{
+	int retval;
+	retval = usb_serial_register(&sierra_device);
+	if (retval)
+		goto failed_device_register;
+
+	printk(KERN_INFO "sierra: " DRIVER_VERSION ":"
+	       DRIVER_DESC "\n");
+
+	return 0;
+
+failed_device_register:
+	return retval;
+}
+
+static void __exit sierra_exit(void)
+{
+	usb_serial_deregister(&sierra_device);
+}
+
+module_init(sierra_init);
+module_exit(sierra_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+
+MODULE_PARM(nmea, "i");
+MODULE_PARM_DESC(nmea, "NMEA streaming");
+
+MODULE_PARM(debug, "i");
+MODULE_PARM_DESC(debug, "Debug messages");
