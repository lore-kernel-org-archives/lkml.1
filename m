Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbXILXhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbXILXhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXILXhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:37:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53759 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbXILXhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:37:06 -0400
Date: Wed, 12 Sep 2007 16:40:16 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Oliver Neukum <oliver@neukum.org>, Paolo Ornati <ornati@fastwebnet.it>,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage:
	implement autosuspend"
Message-ID: <20070912234016.GA455@kroah.com>
References: <20070814131557.5653d991@localhost> <200708141746.16958.oliver@neukum.org> <20070814183857.28997de1@localhost> <200708142033.23158.oliver@neukum.org> <46E864AC.1020000@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E864AC.1020000@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 06:14:04PM -0400, Mark Lord wrote:
> Oliver Neukum wrote:
>> Am Dienstag 14 August 2007 schrieb Paolo Ornati:
>>> On Tue, 14 Aug 2007 17:46:16 +0200
>>> Oliver Neukum <oliver@neukum.org> wrote:
>>>
>>>> Am Dienstag 14 August 2007 schrieb Paolo Ornati:
>>>>> Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage)  
>>>> Please try this patch.
>>> Tried on -rc3 but it doesn't work, dmesg attached.
>>>
>>> However I've found that if "hald" is running the problems doesn't
>>> happen (I think it's just hidden by the fact that hald do some polling
>>> on it preventing autosuspend to trigger).
>> Exactly. This is not reliable. It needs to be done in kernel. This patch
>> should do it.
>> 	Regards
>> 		Oliver
>> ---
>> --- a/drivers/usb/core/quirks.c	2007-08-14 17:42:22.000000000 +0200
>> +++ b/drivers/usb/core/quirks.c	2007-08-14 20:30:28.000000000 +0200
>> @@ -30,6 +30,8 @@
>>  static const struct usb_device_id usb_quirk_list[] = {
>>  	/* HP 5300/5370C scanner */
>>  	{ USB_DEVICE(0x03f0, 0x0701), .driver_info = USB_QUIRK_STRING_FETCH_255 
>> },
>> +	/* Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage) */
>> +	{ USB_DEVICE(0x03f0, 0x4002), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
>>  	/* Acer Peripherals Inc. (now BenQ Corp.) Prisa 640BU */
>>  	{ USB_DEVICE(0x04a5, 0x207e), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
>>  	/* Benq S2W 3300U */
>> -
>
> I believe the offending commit needs to be reverted.
> It just breaks too much stuff, including my Sandisk USB sticks.
>
>> with "CONFIG_USB_SUSPEND=y", since commit:
>> 8dfe4b14869fd185ca25ee88b02ada58a3005eaf
>>     usb-storage: implement autosuspend
>>         This patch (as930) implements autosuspend for usb-storage.  It is
>>     adapted from a patch by Oliver Neukum.  Autosuspend is allowed except
>>     during LUN scanning, resets, and command execution.
>> my USB photo-camera gets automagically disconnected before I can do
>> anything with it  ;) 
>
> Ditto for several other devices that are being slowly special-cased,
> and many that have yet to be tested.  This commit is (unfortunately)
> a disaster with many regressions.

There are many regressions right now, _ONLY_ if you enable
CONFIG_USB_SUSPEND.  If you disable that, your problems will go away,
right?

This option is a new option, and we have found out the hard way that
a very large class of hardware really does not like working with usb
suspend at all.

Because of this, we have a patch queued up for 2.6.24 that will disable
suspend for devices, and have to be enabled from a white-list that we
will put in userspace based on the history of what other operating
systems have determined are devices that can sleep properly.

I can send this patch in now to Linus, but as it changes functionality
from previous -rc patches, I've been hesitant to do so.  Especially when
a mere config option change will solve your problem.

Oh, and currently no distro will enable this option due to the hardware
problems, so the only people that could get hit by this are those who
build their own kernels, and they can easily disable the option.

Does this help explain things?

thanks,

greg k-h
