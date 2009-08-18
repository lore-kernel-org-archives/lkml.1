Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbZHROwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbZHROwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZHROwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:52:19 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64681 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZHROwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=szONhcnLxyelDRL3WqAXq0Pv4r1pClfK8QKa+h0Af6l0hJ2W9+PIP9zgIk885R+Ahj
         7eza5GhBr4xElXLmXhavOCJ+t5MlqCOxWAb0h4nI4T8lErspbkObzWjY8RJJurSNjM8P
         Xm03c2bsDIMoeD5J9oBj2hkH0fKcoA1n+IMik=
MIME-Version: 1.0
In-Reply-To: <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
Date: Tue, 18 Aug 2009 15:52:18 +0100
Message-ID: <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Mario Limonciello <mario_limonciello@dell.com>,
       cezary.jackiewicz@gmail.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/09, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
> On 8/18/09, Marcel Holtmann <marcel@holtmann.org> wrote:
>> Hi Mario,
>
> ...
>
>>> +static int setup_rfkill(void)
>>> +{
>>> +       int ret;
>>> +
>>> +       wifi_rfkill = rfkill_alloc("compal-wifi", NULL,
>>> RFKILL_TYPE_WLAN,
>>> +                                       &compal_rfkill_ops, (void *)
>>> WLAN_MASK);
>>> +       if (!wifi_rfkill) {
>>> +               ret = -ENOMEM;
>>> +               goto err_wifi;
>>> +       }
>>> +       ret = rfkill_register(wifi_rfkill);
>>> +       if (ret)
>>> +               goto err_wifi;
>>> +
>>> +       bluetooth_rfkill = rfkill_alloc("compal-bluetooth", NULL,
>>> RFKILL_TYPE_BLUETOOTH,
>>> +                                       &compal_rfkill_ops, (void *)
>>> BT_MASK);
>>> +       if (!bluetooth_rfkill) {
>>> +               ret = -ENOMEM;
>>> +               goto err_bt;
>>> +       }
>>> +       ret = rfkill_register(bluetooth_rfkill);
>>> +       if (ret)
>>> +               goto err_bt;
>>> +
>>> +       return 0;
>>> +err_bt:
>>> +       rfkill_destroy(bluetooth_rfkill);
>>> +       if (bluetooth_rfkill)
>>> +               rfkill_unregister(bluetooth_rfkill);
>>> +err_wifi:
>>> +       rfkill_destroy(wifi_rfkill);
>>> +       if (wifi_rfkill)
>>> +               rfkill_unregister(wifi_rfkill);
>>
>> I don't understand how this is not a potential NULL pointer dereference.
>> There might some good luck that the pointer is still valid at that time,
>> but I highly doubt it. So please unregister before destory.
>
> Wrong as well :-).
>
> If you fail to register wifi_rfkill, you should *only* call
> rfkill_destroy().  So I think it should look like this:
>
> +       if (wifi_rfkill)
> +               rfkill_unregister(wifi_rfkill);
> +err_wifi:
> +       rfkill_destroy(wifi_rfkill);
>
> ...
>
>>> @@ -420,6 +518,10 @@
>>>         platform_device_unregister(compal_device);
>>>         platform_driver_unregister(&compal_driver);
>>>         backlight_device_unregister(compalbl_device);
>>> +       if (wifi_rfkill)
>>> +               rfkill_unregister(wifi_rfkill);
>>> +       if (bluetooth_rfkill)
>>> +               rfkill_unregister(bluetooth_rfkill);
>>
>> Same here. It should never ever succeeded in the first place. You can
>> call it conditionally.
>
> They're already called conditionally.  I assume you mean unconditionally
> here.

Also, you're missing the calls to rfkill_destroy() here.

Whew, I think that's everything.  I hope you find the feedback useful,
despite it being a little fragmented.

Regards
Alan
