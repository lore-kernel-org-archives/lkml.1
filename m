Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXCaTaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXCaTaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 15:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXCaTaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 15:30:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:48677 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753285AbXCaTaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 15:30:15 -0400
Date: Sat, 31 Mar 2007 21:35:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuard_hayes@dell.com
Subject: Re: usb hid: reset NumLock
In-Reply-To: <20070330105924.01a16dd6.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Pete Zaitcev wrote:

> @@ -1328,9 +1340,18 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  		return -ENODEV;
>  	}
>  
> -	if ((hid->claimed & HID_CLAIMED_INPUT))
> +	if ((hid->claimed & HID_CLAIMED_INPUT)) {
>  		hid_ff_init(hid);
>  
> +		/*
> +		 * We do this only if input has claimed the device because
> +		 * we can only find fields after they were configured in
> +		 * hidinput_connect.
> +		 */
> +		/* if (hid->quirks & HID_QUIRK_RESET_LEDS) */
> +		usbhid_set_leds(hid, LED_NUML, 0);
> +	}
> +
>  	if (hid->quirks & HID_QUIRK_SONY_PS3_CONTROLLER)
>  		hid_fixup_sony_ps3_controller(interface_to_usbdev(intf),
>  			intf->cur_altsetting->desc.bInterfaceNumber);

Hi Pete,

I think I see an issue here. Imagine that you boot a system initially with 
one keyboard connected (usb, ps/2, doesn't matter), and after some time 
you connect second USB keyboard (the NumLock is 'on' on the first keyboard 
when you connect the second one).

Without your patch, the NumLock led will be OK on the second keyboard 
immediately. With your patch, the NumLock will be forced to 'off' and it 
will be out of sync with the first keyboard. The leds will get in sync 
later when any change occurs. 

> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d26b08f..f592f01 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -267,6 +267,7 @@ struct hid_item {
>  #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00020000
>  #define HID_QUIRK_IGNORE_MOUSE			0x00040000
>  #define HID_QUIRK_SONY_PS3_CONTROLLER		0x00080000
> +#define HID_QUIRK_RESET_LEDS			0x00100000

I think this is not worth a quirk - when we get it working properly, why 
not do it unconditionally for all keyboards?

> URL with details, discussion, rejected patch to read BIOS byte at 0x417:
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228674

"You are not authorized to access bug #228674. To see this bug, you must 
first log in to an account with the appropriate permissions." 

:)

Thanks,

-- 
Jiri Kosina
