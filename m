Return-Path: <linux-kernel-owner+w=401wt.eu-S935823AbZLHGUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935823AbZLHGUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbZLHGUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:20:46 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:48419 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbZLHGUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:20:45 -0500
Message-ID: <4B1DF030.2070100@hillier.de>
Date: Tue, 08 Dec 2009 07:20:32 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <matthias@urlichs.de>
CC: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Mobilcom Debitel USB UMTS Surf-Stick
 to option driver
References: <4B08F18C.3040904@hillier.de>	 <200911220920.16717.oliver@neukum.org> <4B0C1F41.2060101@hillier.de>	 <200911241919.10895.oliver@neukum.org>  <4B0FCAD3.9000801@hillier.de> <1259328254.27675.524.camel@kiste>
In-Reply-To: <1259328254.27675.524.camel@kiste>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Urlichs wrote:
> On Fri, 2009-11-27 at 13:49 +0100, Gernot Hillier wrote:
>> +       /* 4G Systems W14 simply ignores this message on interface 0 & 1 
>> +          and would cause long timeouts when calling usb_control_msg()  */
>> +       if (serial->dev->descriptor.idVendor == FOUR_G_SYSTEMS_VENDOR_ID &&
>> +               serial->dev->descriptor.idProduct == FOUR_G_SYSTEMS_PRODUCT_W14 &&
>> +               (ifNum == 0 || ifNum == 1) )
>> +               return -EIO;
>>
> I'd appreciate if you'd implement this generically.
> 
> I.e., use the driver_info field of struct usb_device for an appropriate
> blacklist flag. (It's not going to be the only one.)
> 

Ok, so here's my first shot at it. Code was mostly stolen from drivers/usb/
serial/sierra.c. 

Additionally, I needed to add some pieces because blacklist info is needed
in option_send_setup() where I don't have easy access to struct usb_
device_id. So far, I had no better idea than remembering the info in our
private structure.

I also prepared things to include the D-Link DWM 652 exceptions from
option_probe() (that's the intention of OPTION_BLACKLIST_RESERVED_IF).
 
Could you please confirm if this is what you wanted - if yes, I can
probably repost the patch in three parts (blacklisting infrastructure, add
4G W14 blacklist info, port D-Link DWM 652 blacklist info) with
appropriate summaries.

--- drivers/usb/serial/option.c.orig	2009-12-08 05:52:13.000000000 +0100
+++ drivers/usb/serial/option.c	2009-12-08 06:53:43.000000000 +0100
@@ -340,6 +340,28 @@ static int  option_resume(struct usb_ser
 #define FOUR_G_SYSTEMS_VENDOR_ID		0x1c9e
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
 
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
+static const u8 four_g_w14_no_sendsetup[] = { 0, 1 };
+static const struct option_blacklist_info four_g_w14_blacklist = {
+	.infolen = ARRAY_SIZE(four_g_w14_no_sendsetup),
+	.ifaceinfo = four_g_w14_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
+
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -604,7 +626,9 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
-	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
+ 	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
+ 	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
+ 	},
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
@@ -668,6 +692,7 @@ struct option_intf_private {
 	spinlock_t susp_lock;
 	unsigned int suspended:1;
 	int in_flight;
+	struct option_blacklist_info *blacklist_info;	
 };
 
 struct option_port_private {
@@ -737,9 +762,27 @@ static int option_probe(struct usb_seria
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
@@ -1170,11 +1213,18 @@ static void option_setup_urbs(struct usb
 static int option_send_setup(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
+	struct option_intf_private *intfdata = (struct option_intf_private *) serial->private;
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
