Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZLBUuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZLBUuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZLBUuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:50:15 -0500
Received: from smtp.nokia.com ([192.100.122.230]:61072 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZLBUuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:50:14 -0500
Date: Wed, 2 Dec 2009 22:49:46 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Grazvydas Ignotas <notasas@gmail.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091202204946.GB25682@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
 <20091202173321.GA23738@nokia.com>
 <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Dec 2009 20:50:05.0993 (UTC) FILETIME=[0717C190:01CA7391]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 02, 2009 at 09:34:00PM +0100, ext Grazvydas Ignotas wrote:
>>> +#define BCI_DELAY              100
>>
>> 100ms ??? that's too quick for battery monitoring. Imagine that you'll have
>> 10 i2c transfers per-second forever with this one. Don't you think you're
>> waking up omap for nothing ??
>
>The work item doesn't queue itself, so this is only used once after
>every interrupt. The delay itself is needed because charge state
>machine needs some time to switch states and is not yet in expected
>state at the time VBUS/AC detect interrupt kicks.

ok got it... not so bad then ;-)

>>> +static struct twl4030_bci_device_info twl4030_bci = {
>>
>> this should be allocated on probe() time.
>
>I need to access it from twl4030charger_usb_en().. Could only leave
>delayed_work global and allocate everything else in probe() if you
>prefer that.

well, you could keep only a global static pointer and after allocating 
that in probe, make the global static pointer, point to it... Anyways, 
I think twl4030charger_usb_en() should change its prototype to something 
like

twl4030charger_usb_en(struct twl4030_bci *bci, int enable);

you could leave userland to decide whether to start charging, specially 
in usb charging case where we still need to know if we where enumerated 
with 100mA or 500mA configuration. How are you differing between those 
currently ?

>> I don't like the way you did this. I would expect twl4030-usb to kick the
>> charger detection based on the VBUS irq. You have to consider the
>> possibility of boards which won't use BCI module and will have some bq24xxx
>> chip dealing with that like RX51. So instead of implementing this here and
>> forcing people to have this driver enabled on e.g. RX51, you should
>> implement the charger_enable_usb() logic in twl4030-usb itself. /me thinks
>
>I don't think charging is twl4030-usb's business, also notifying
>power_supply core about charge state changes that I do here.

I was talking about the charger detection. The start of charge you could 
leave to userland to handle, no ?

>What about just returning early from twl4030charger_usb_en() if this
>driver is not started? TWL4030-core requires twl4030_bci_platform_data
>to be present to even register this driver, so it won't start on RX51.
>RX51 can also choose not to compile this driver in, then
>twl4030charger_usb_en() call won't even be done fom twl4030-usb.

still we need to detect the charger...

>> how about using request_threaded_irq() ?? then you avoid having that
>> workqueue.
>
>I need to do some delayed processing after VBUS/AC detect interrupts
>kick, delayed_work looked perfect for this. Also note that I can't get
>USB_PRES interrupt (taken by twl4030-usb), only a callback from
>twl4030-usb.

or you let userland to handle a bit more of this logic (??)

-- 
balbi
