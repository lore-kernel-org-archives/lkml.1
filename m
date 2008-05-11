Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbYEKXQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbYEKXQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 19:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbYEKXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 19:15:54 -0400
Received: from senator.holtmann.net ([87.106.208.187]:57110 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbYEKXPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 19:15:54 -0400
Subject: Re: [PATCH 8/9] HID: move apple quirks
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jslaby@suse.cz>
In-Reply-To: <1210536043-19812-8-git-send-email-jirislaby@gmail.com>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-3-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-4-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-5-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-6-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-7-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-8-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 01:15:59 +0200
Message-Id: <1210547759.16390.34.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Move them from core code to separate driver.

<snip>

> +#if defined(CONFIG_BT_HIDP) || defined(CONFIG_BT_HIDP_MODULE)
> +	/* Apple wireless Mighty Mouse */
> +	{ HID_BT_DEVICE(USB_VENDOR_ID_APPLE, 0x030c),
> +		.driver_data = APPLE_MIGHTYMOUSE | APPLE_INVERT_HWHEEL },
> +#endif

why do we have to have this within #ifdefs. The HID_BLUETOOTH_DEVICE
should work even without Bluetooth compiled. It depends only on having
the BUS_BLUETOOTH present. In theory we could have a different Bluetooth
stack providing BUS_BLUETOOTH devices (like through uinput).

<snip>

> +static const struct hid_device_id hid_bt_blacklist[] = {
> +	{ HID_BT_DEVICE(USB_VENDOR_ID_APPLE, 0x030c) },
>  	{ }
>  };
>  
>  static const struct hid_device_id *hid_blacklist[] = {
>  	[BUS_USB] = hid_usb_blacklist,
> -	[BUS_BLUETOOTH] = NULL,
> +	[BUS_BLUETOOTH] = hid_bt_blacklist,
>  };

no shortcut please. Use hid_bluetooth_blacklist. And why do we need two
separate blacklists anyway. We use HID_USB_DEVICE and
HID_BLUETOOTH_DEVICE. Both carry the bus information with them.

<snip>

> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index e85ff38..1e9b0d1 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -677,27 +677,6 @@ static void hidp_close(struct hid_device *hid)
>  {
>  }
>  
> -static const struct {
> -	__u16 idVendor;
> -	__u16 idProduct;
> -	unsigned quirks;
> -} hidp_blacklist[] = {
> -	/* Apple wireless Mighty Mouse */
> -	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
> -
> -	{ }	/* Terminating entry */
> -};
> -
> -static void hidp_setup_quirks(struct hid_device *hid)
> -{
> -	unsigned int n;
> -
> -	for (n = 0; hidp_blacklist[n].idVendor; n++)
> -		if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
> -				hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
> -			hid->quirks = hidp_blacklist[n].quirks;
> -}
> -
>  static int hidp_parse(struct hid_device *hid)
>  {
>  	struct hidp_session *session = hid->driver_data;
> @@ -723,7 +702,6 @@ static int hidp_parse(struct hid_device *hid)
>  
>  	session->req = NULL;
>  
> -	hidp_setup_quirks(hid);
>  	return 0;
>  }

I really like to see this go away :)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


