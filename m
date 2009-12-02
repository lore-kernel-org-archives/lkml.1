Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZLBV3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZLBV3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZLBV3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:29:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36513 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbZLBV3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BdL+3mBq+wWurloyaoh07qbx31F2cFMAJmPO0HkOFK9i+0r5HWXinNcNT8F9KRp441
         eZqM+DUioYKp8IEbNbPb6ca85kP81JYrjLdc+RMRXjAlgQyoeO9Nto7dyBRvmeo2NlH3
         2ke67wSM7x+ojvW0Adwjq1QILs1phI6sdUW6w=
MIME-Version: 1.0
In-Reply-To: <20091202204946.GB25682@nokia.com>
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
	 <20091202173321.GA23738@nokia.com>
	 <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
	 <20091202204946.GB25682@nokia.com>
Date: Wed, 2 Dec 2009 23:29:10 +0200
Message-ID: <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
From: Grazvydas Ignotas <notasas@gmail.com>
To: felipe.balbi@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 10:49 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> Hi,
>
> On Wed, Dec 02, 2009 at 09:34:00PM +0100, ext Grazvydas Ignotas wrote:
>>>>
>>>> +#define BCI_DELAY              100
>>>
>>> 100ms ??? that's too quick for battery monitoring. Imagine that you'll
>>> have
>>> 10 i2c transfers per-second forever with this one. Don't you think you're
>>> waking up omap for nothing ??
>>
>> The work item doesn't queue itself, so this is only used once after
>> every interrupt. The delay itself is needed because charge state
>> machine needs some time to switch states and is not yet in expected
>> state at the time VBUS/AC detect interrupt kicks.
>
> ok got it... not so bad then ;-)
>
>>>> +static struct twl4030_bci_device_info twl4030_bci = {
>>>
>>> this should be allocated on probe() time.
>>
>> I need to access it from twl4030charger_usb_en().. Could only leave
>> delayed_work global and allocate everything else in probe() if you
>> prefer that.
>
> well, you could keep only a global static pointer and after allocating that
> in probe, make the global static pointer, point to it... Anyways, I think
> twl4030charger_usb_en() should change its prototype to something like
>
> twl4030charger_usb_en(struct twl4030_bci *bci, int enable);

This function is called by twl4030-usb, where will it get this bci pointer from?

> you could leave userland to decide whether to start charging, specially in
> usb charging case where we still need to know if we where enumerated with
> 100mA or 500mA configuration.

>From what I saw in other drivers they are setup to start charging
automatically as soon as they see VBUS. Maybe Anton can give more
details here.

> How are you differing between those currently?

Not handled at all at the moment (uses BCI defaults).

>>> I don't like the way you did this. I would expect twl4030-usb to kick the
>>> charger detection based on the VBUS irq. You have to consider the
>>> possibility of boards which won't use BCI module and will have some
>>> bq24xxx
>>> chip dealing with that like RX51. So instead of implementing this here
>>> and
>>> forcing people to have this driver enabled on e.g. RX51, you should
>>> implement the charger_enable_usb() logic in twl4030-usb itself. /me
>>> thinks
>>
>> I don't think charging is twl4030-usb's business, also notifying
>> power_supply core about charge state changes that I do here.
>
> I was talking about the charger detection.

The USB_PRES interrupt belongs to twl4030-usb, so it gets it's
detection as before and does not need this driver, where is the
problem? This driver only registers CHG_PRES, which is AC charger
detect interrupt.

> The start of charge you could leave to userland to handle, no ?

Maybe, I wonder if there is standard way to do that.
Anton?

>
>> What about just returning early from twl4030charger_usb_en() if this
>> driver is not started? TWL4030-core requires twl4030_bci_platform_data
>> to be present to even register this driver, so it won't start on RX51.
>> RX51 can also choose not to compile this driver in, then
>> twl4030charger_usb_en() call won't even be done fom twl4030-usb.
>
> still we need to detect the charger...
>
>>> how about using request_threaded_irq() ?? then you avoid having that
>>> workqueue.
>>
>> I need to do some delayed processing after VBUS/AC detect interrupts
>> kick, delayed_work looked perfect for this. Also note that I can't get
>> USB_PRES interrupt (taken by twl4030-usb), only a callback from
>> twl4030-usb.
>
> or you let userland to handle a bit more of this logic (??)

Still need to autostart AC charging, who would plug AC adapter and
want to fiddle with the GUI to start charging instead it having it go
automatically? Agree about USB userspace switch though..
