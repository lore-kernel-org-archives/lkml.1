Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbYJRUdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbYJRUdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYJRUc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:32:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:61720 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYJRUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dy2JV+Um7RZySm0Trq54JEyxoAhLccRVUEtnw0wFxKehAd6uM07mAwt/WbqQl4xiHo
         N4gWYbg5Wsk0eKhN/15Po+lBRjNnjoYNB2VXtpZnBb8Lm+HMR93eMbdL3y1CYjtRM/AQ
         tVSYpJ97+/A7p5g7SLSYgCmlqYj5vPppYOx8M=
Message-ID: <dd18b0c30810181332h709377bcjef180ba26abc8fb6@mail.gmail.com>
Date: Sat, 18 Oct 2008 13:32:56 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: appletouch regression
Cc: "Steven Noonan" <steven@uplinklabs.net>, "Jiri Kosina" <jkosina@suse.cz>,
       "Sven Anders" <anders@anduras.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1224359819-15152-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0810181134h24ed5da8lc12e62816436bb5@mail.gmail.com>
	 <1224359819-15152-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 12:56 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Steven Noonan wrote:
>> On Sat, Oct 18, 2008 at 10:29 AM, Justin Mattock
>> <justinmattock@gmail.com> wrote:
>>> On Sat, Oct 18, 2008 at 9:44 AM, Steven Noonan <steven@uplinklabs.net> wrote:
>>>> 2008/10/18 Sven Anders <anders@anduras.de>:
>>>>> Steven Noonan schrieb:
>>>>>> It seems that the appletouch driver is (sporadically) not detecting my
>>>>>> Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
>>>>>> When it is misbehaving, it doesn't have any /dev/input/event* entry
>>>>>> that corresponds to the input from appletouch, and dmesg -should- show
>>>>>> the following, as 2.6.27.1 does, but does not:
>>>>>>
>>>>>> appletouch: Geyser mode initialized.
>>>>>> input: appletouch as /class/input/input4
>>>>>> usbcore: registered new interface driver appletouch
>>>>>> appletouch: 17" model detected
>>>>>>
>>>>>> On the current tree, occasionally all I get is:
>>>>>>
>>>>>> usbcore: registered new interface driver appletouch
> [...]
>> Any ideas, gentlemen?
>
> Yeah, I see the problem. The device is grabbed by the hid bus and not
> released even if apple driver says ENODEV (this is expected behaviour
> and noted in the driver).
>
> Could you try this patch? (Not ready for merge, it needs to be cleaned
> up.)
>
> ---
>  drivers/hid/hid-core.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8a7d9db..94cf1db 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1539,6 +1539,34 @@ static const struct hid_device_id hid_ignore_list[] = {
>        { }
>  };
>
> +static const struct hid_device_id hid_mouse_ignore_list[] = {
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
> +       { }
> +};
> +
> +#include <linux/usb.h>
> +
>  static bool hid_ignore(struct hid_device *hdev)
>  {
>        switch (hdev->vendor) {
> @@ -1555,6 +1583,12 @@ static bool hid_ignore(struct hid_device *hdev)
>                break;
>        }
>
> +       if (hdev->bus == BUS_USB && to_usb_interface(hdev->dev.parent)->
> +                       cur_altsetting->desc.bInterfaceProtocol ==
> +                       USB_INTERFACE_PROTOCOL_MOUSE &&
> +                       hid_match_id(hdev, hid_mouse_ignore_list))
> +               return true;
> +
>        return !!hid_match_id(hdev, hid_ignore_list);
>  }
>
> --
> 1.6.0.2
>
>

Applied and can confirm
my appletouchpad is alive and reacting,
Thanks a lot man.

regards;

-- 
Justin P. Mattock
