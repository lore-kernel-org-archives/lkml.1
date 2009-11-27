Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbZK0Mtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbZK0Mtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZK0Mtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:49:32 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:54059 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZK0Mtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:49:31 -0500
Message-ID: <4B0FCAD3.9000801@hillier.de>
Date: Fri, 27 Nov 2009 13:49:23 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick
 to option driver
References: <4B08F18C.3040904@hillier.de> <200911220920.16717.oliver@neukum.org> <4B0C1F41.2060101@hillier.de> <200911241919.10895.oliver@neukum.org>
In-Reply-To: <200911241919.10895.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Dienstag, 24. November 2009 19:00:33 schrieb Gernot Hillier:
>> As you might have expected, I have no detailed spec about the device 
>> which could explain this. I can only say that the device reacts on AT 
>> commands on ttyUSB1 and ttyUSB2 while ttyUSB0 seems to serve other
>>  purposes.
>>
>> What do you think - shall I disable sending the usb control message 
>> depending on bInterfaceNumber? Any better ideas?
> 
> I have no better idea.
> 
> 	Regards
> 		Oliver
> 

Ok, so here comes the update. The patch was tested to apply against 2.6.31
as well as 2.6-git. Please apply if you agree...

----------- SNIP -------------
From: Gernot Hillier <gernot@hillier.de>

This patch adds the vendor and device id for the Mobilcom Debitel UMTS surf
stick (a.k.a. 4G Systems XSStick W14, MobiData MBD-200HU, ...).

To see these ids, you need to switch the stick to modem operation first
with the help of usb_modeswitch. This makes it switch from 1c9e:f000 to
1c9e:9603 and thus be recognized by the option driver.

In addition, this device seems to ignore setting of RTS/DTR by option_send_
setup and doesn't answer the usb_control_msg leading to a 5 s timeout
(USB_CTRL_SET_TIMEOUT) in userspace open() and other operations. As this
confused several impatient userspace applications like Minicom and
ModemManager, I return immediately instead.

Signed-off-by: Gernot Hillier <gernot@hillier.de>

--- linux-source-2.6.31/drivers/usb/serial/option.c.orig	2009-11-24 08:17:31.000000000 +0100
+++ linux-source-2.6.31/drivers/usb/serial/option.c	2009-11-27 12:48:15.000000000 +0100
@@ -337,6 +337,10 @@
 #define AIRPLUS_VENDOR_ID			0x1011
 #define AIRPLUS_PRODUCT_MCD650			0x3198
 
+/* 4G Systems products */
+#define FOUR_G_SYSTEMS_VENDOR_ID		0x1c9e
+#define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -600,6 +604,7 @@
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
@@ -1171,6 +1176,13 @@
 	int val = 0;
 	dbg("%s", __func__);
 
+	/* 4G Systems W14 simply ignores this message on interface 0 & 1 
+	   and would cause long timeouts when calling usb_control_msg()  */
+	if (serial->dev->descriptor.idVendor == FOUR_G_SYSTEMS_VENDOR_ID &&
+		serial->dev->descriptor.idProduct == FOUR_G_SYSTEMS_PRODUCT_W14 &&
+		(ifNum == 0 || ifNum == 1) )
+		return -EIO;
+
 	portdata = usb_get_serial_port_data(port);
 
 	if (portdata->dtr_state)


