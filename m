Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZAGN1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZAGN1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZAGN0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:26:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:29422 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZAGN0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FEOld+6sxZYxHhIf1lFjtVTHZqIMztO4Gedo0aOKLJHKhEEFIL4ib2vBLsMKhNgNld
         OhtSa7C9SwZNo4fTqMoZfp6nhpJ9ZHtvi05486C8GqWqweQXhxl/Dp0Y8rYjRUlf1BnM
         xBI2FKsOr1mRUQPmXSsXbulG6K9pK7Bszrer4=
Message-ID: <4964AD64.6040003@googlemail.com>
Date: Wed, 07 Jan 2009 14:25:56 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081122)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Oliver Neukum <oliver@neukum.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID updates for 2.6.29
References: <alpine.LNX.1.10.0901040115060.5377@jikos.suse.cz> <4963EE3C.3070106@googlemail.com> <alpine.LNX.1.10.0901071049400.5377@jikos.suse.cz> <200901071230.45993.oliver@neukum.org> <alpine.LNX.1.10.0901071242160.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901071242160.5377@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:

> On Wed, 7 Jan 2009, Oliver Neukum wrote:
> 
>>> --- a/drivers/hid/usbhid/hiddev.c
>>> +++ b/drivers/hid/usbhid/hiddev.c
>>> @@ -885,6 +885,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
>>>  	} else {
>>>  		hid->minor = usbhid->intf->minor;
>>>  		hiddev_table[usbhid->intf->minor - HIDDEV_MINOR_BASE] = hiddev;
>>> +		hid->hiddev = hiddev;
>> It seems to me that this is still a race condition. What prevents open()
>> from being called before this is set?
> 
> Right, there indeed is a tiny race window. Gabriel, could you please 
> verify with the patch below instead? Thanks.


Your patch fixed the panic for me.

Feel free to add my Tested-by: if needed.

> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] HID: fix hid->hiddev initialization in hiddev_connect()
> 
> Commit 079034073fa ("HID: hiddev cleanup -- handle all error conditions
> properly") by mistake removed proper initialization of hid->hiddev pointer
> in hiddev_connect() in case usb_register_dev() succeeds for the hiddev node.
> Put it properly back in place.
> 
> Reported-by: Gabriel C <nix.or.die@googlemail.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/usbhid/hiddev.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index 6a98f9f..d73eea3 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -874,12 +874,14 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
>  	INIT_LIST_HEAD(&hiddev->list);
>  	spin_lock_init(&hiddev->list_lock);
>  	mutex_init(&hiddev->existancelock);
> +	hid->hiddev = hiddev;
>  	hiddev->hid = hid;
>  	hiddev->exist = 1;
>  
>  	retval = usb_register_dev(usbhid->intf, &hiddev_class);
>  	if (retval) {
>  		err_hid("Not able to get a minor for this device.");
> +		hid->hiddev = NULL;
>  		kfree(hiddev);
>  		return -1;
>  	} else {


Regards,

Gabriel C
