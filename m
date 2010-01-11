Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674Ab0AKIaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab0AKIaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0AKIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:30:16 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:44910 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0AKIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:30:13 -0500
Message-ID: <4B4AE188.5010004@hillier.de>
Date: Mon, 11 Jan 2010 09:30:00 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] option.c: Add blacklisting infrastructure for special
 device handling
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gernot Hillier <gernot@hillier.de>

As suggested by Matthias Urlichs, this patch adds a somehow generic 
mechanism for special handling of devices which don't support all 
bits expected by this driver.

The blacklisting code is heavily stolen from sierra.c, but extended to
support different special cases.

For now, one case is implemented (OPTION_BLACKLIST_SENDSETUP),
targeted at the 4G W14 device: devices which don't understand the 
setting of RTS/DTR in option_send_setup() causing a USB timeout of
5 s in any userspace open() which leads to errors in most userspace
applications.

In addition, I prepared another case for devices with interfaces which 
shall not be accessed by this driver (targeted at the D-Link DWM 652).

However, OPTION_BLACKLIST_RESERVED_IF is not fully implemented yet as 
I have no device to test this. Anyone volunteering to help here?
If not, I'll contact the guys who added D-Link DWM 652 support soon.

Signed-off-by: Gernot Hillier <gernot@hillier.de>

Index: linux-next/drivers/usb/serial/option.c
===================================================================
--- linux-next.orig/drivers/usb/serial/option.c	2010-01-09 10:24:57.000000000 +0100
+++ linux-next/drivers/usb/serial/option.c	2010-01-09 10:25:00.000000000 +0100
@@ -344,6 +344,19 @@ static int  option_resume(struct usb_ser
 #define HAIER_VENDOR_ID				0x201e
 #define HAIER_PRODUCT_CE100			0x2009
 
+/* some devices interfaces need special handling due to a number of reasons */
+typedef enum {
+		OPTION_BLACKLIST_NONE = 0,
+		OPTION_BLACKLIST_SENDSETUP = 1,
+		OPTION_BLACKLIST_RESERVED_IF = 2
+} option_blacklist_reason_t;
+
+struct option_blacklist_info {
+	const u32 infolen;	/* number of interface numbers on blacklist */
+	const u8  *ifaceinfo;	/* pointer to the array holding the numbers */
+	option_blacklist_reason_t reason;
+};
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -709,6 +722,7 @@ struct option_intf_private {
 	spinlock_t susp_lock;
 	unsigned int suspended:1;
 	int in_flight;
+	struct option_blacklist_info *blacklist_info;
 };
 
 struct option_port_private {
@@ -778,9 +792,27 @@ static int option_probe(struct usb_seria
 	if (!data)
 		return -ENOMEM;
 	spin_lock_init(&data->susp_lock);
+	data->blacklist_info = (struct option_blacklist_info*) id->driver_info;
 	return 0;
 }
 
+static option_blacklist_reason_t is_blacklisted(const u8 ifnum,
+				const struct option_blacklist_info *blacklist)
+{
+	const u8  *info;
+	int i;
+
+	if (blacklist) {
+		info = blacklist->ifaceinfo;
+
+		for (i = 0; i < blacklist->infolen; i++) {
+			if (info[i] == ifnum)
+				return blacklist->reason;
+		}
+	}
+	return OPTION_BLACKLIST_NONE;
+}
+
 static void option_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
@@ -1211,11 +1243,19 @@ static void option_setup_urbs(struct usb
 static int option_send_setup(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
+	struct option_intf_private *intfdata =
+		(struct option_intf_private *) serial->private;
 	struct option_port_private *portdata;
 	int ifNum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
 	int val = 0;
 	dbg("%s", __func__);
 
+	if (is_blacklisted(ifNum, intfdata->blacklist_info) ==
+						OPTION_BLACKLIST_SENDSETUP) {
+		dbg("No send_setup on blacklisted interface #%d\n", ifNum);
+		return -EIO;
+	}
+
 	portdata = usb_get_serial_port_data(port);
 
 	if (portdata->dtr_state)
