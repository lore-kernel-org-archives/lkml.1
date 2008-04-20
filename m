Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYDTQPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYDTQPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYDTQP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:15:28 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:33436 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbYDTQP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:15:27 -0400
Message-ID: <480B6C16.40806@gmail.com>
Date: Sun, 20 Apr 2008 19:15:18 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       mit-devel@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: HID bus
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1208644696-29129-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Hmm, I must admit, I didn't know how exactly autoloading works. On suse,
> at least, module aliases are used. So autoloading works for me after this
> patch and slight modifications of the previous patches. The pro of this
> is that it's in-kernel modification of modpost phase.

Indeed in current systems udev uses module aliases for autoloading.

> --
> 
> Generate aliases for usb hid device modules to support autoloading.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
[...]
> +/* Looks like: usb */

Looks like: "usb:vNpNd*dc*dsc*dp*ic3isc*ip*"

> +static int do_hid_usb_entry(const char *filename,
> +			     struct hid_device_id *id, char *alias)
> +{
> +	__u16 v = TO_NATIVE((__u16)id->vendor);
> +	__u16 p = TO_NATIVE((__u16)id->product);
> +
> +	strcpy(alias, "usb:");
> +	ADD(alias, "v", id->vendor != HID_ANY_ID, v);
> +	ADD(alias, "p", id->product != HID_ANY_ID, p);
> +
> +	sprintf(alias + strlen(alias), "d*dc*dsc*dp*ic%02Xisc*ip*",
> +			USB_INTERFACE_CLASS_HID);
> +
> +	return 1;
> +}

Oh, so we create a normal usb modalias entry anyway, not a custom
'usbhid:' one.

Why not just do something like

#define HID_DEVICE(vend, dev) \
	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
		       USB_DEVICE_ID_MATCH_INT_CLASS, \
	.idVendor = (vend), \
	.idProduct = (prod), \
	.bInterfaceClass = USB_INTERFACE_CLASS_HID
(see linux/usb.h)

and use USB hotplugging?

Or do we plan to match against something else as well, such as hid
reports or something?

-- 
Anssi Hannula
