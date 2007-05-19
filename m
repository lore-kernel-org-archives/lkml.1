Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbXESIzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbXESIzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXESIzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:55:06 -0400
Received: from neopsis.com ([213.239.204.14]:49688 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754356AbXESIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:55:05 -0400
Message-ID: <464EC0F7.20004@dbservice.com>
Date: Sat, 19 May 2007 11:18:47 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz> <464C708C.6090808@dbservice.com> <464CA34F.8090509@dbservice.com> <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz> <464D4F31.6000100@dbservice.com> <Pine.LNX.4.64.0705182304400.27422@twin.jikos.cz> <464E23CA.8040400@dbservice.com> <Pine.LNX.4.64.0705190111310.27422@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705190111310.27422@twin.jikos.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.333,
	required 5, autolearn=spam, AWL 0.19, BAYES_00 -2.60, TW_XF 0.08,
	UPPERCASE_25_50 0.00)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Sat, 19 May 2007, Tomas Carnecky wrote:
>> I already thought about this option (to whitelist this particular
>> vendor/device ID as an hid-input device), but I first wanted some
>> feedback on the whole situation. As for the patch, I have zero knowledge
>> of the hid subsystem.. but if you give me a go on this, I'll try to dig
>> into the code and make a patch :)
> 
> Adding a HID_QUIRK_HIDINPUT quirk makes maybe a more sense than fixing 
> this particular report descriptor to stop pretending that the device is 
> Telephony/Headset - we might in future discover that there are more 
> devices that have broken report descriptors and that we want to be forced 
> to be handled by hid-input subsystem.
> 
> So, could you please test whether the quick and untested patch below 
> (against 2.6.22-rc1) works as expected with the device?

Applied to -rc1, rebased to -rc2, works as expected. Thanks.

> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7f81789..8696dbe 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -976,7 +976,7 @@ int hidinput_connect(struct hid_device *
>  			if (IS_INPUT_APPLICATION(hid->collection[i].usage))
>  				break;
>  
> -	if (i == hid->maxcollection)
> +	if (i == hid->maxcollection && (hid->quirks & HID_QUIRK_HIDINPUT) == 0)
>  		return -1;
>  
>  	if (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index f6c4145..62a7f1e 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -209,6 +209,9 @@
>  #define USB_DEVICE_ID_MGE_UPS		0xffff
>  #define USB_DEVICE_ID_MGE_UPS1		0x0001
>  
> +#define USB_VENDOR_ID_MICROSOFT		0x045e
> +#define USB_DEVICE_ID_SIDEWINDER_GV	0x003b
> +
>  #define USB_VENDOR_ID_NEC		0x073e
>  #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
>  
> @@ -290,6 +293,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_DINOVO_EDGE, HID_QUIRK_DUPLICATE_USAGES },
>  
>  	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
> +	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV, HID_QUIRK_HIDINPUT },
>  
>  	{ USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_01, HID_QUIRK_IGNORE },
>  	{ USB_VENDOR_ID_AIPTEK, USB_DEVICE_ID_AIPTEK_10, HID_QUIRK_IGNORE },
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 827ee74..6e45d10 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -276,6 +276,7 @@ struct hid_item {
>  #define HID_QUIRK_DUPLICATE_USAGES		0x00200000
>  #define HID_QUIRK_RESET_LEDS			0x00400000
>  #define HID_QUIRK_SWAPPED_MIN_MAX		0x00800000
> +#define HID_QUIRK_HIDINPUT			0x01000000
>  
>  /*
>   * This is the global environment of the parser. This information is
> 
