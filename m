Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbXC3GfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbXC3GfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 02:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXC3GfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 02:35:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:31052 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXC3GfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 02:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CpXo1W8KhE5y73xkD0B/N9upKRt+GkElakLaSLIBKz2+EAa3dn5MKl2yL5FwkfrBA9NdPYKRFDndngteR4qwo3xP+5A98vh/N6Gbv7AzgBGt2rNLD/BWP/dDWSR8PfAp89w2T2TB2vo1SUTJHDvaXpS5NdqEnB02/nYrx8fCPmQ=
Message-ID: <460CA201.7030006@gmail.com>
Date: Fri, 30 Mar 2007 13:37:05 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Jiri Kosina <jkosina@suse.cz>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> <460C7EB4.9080009@gmail.com> <200703300033.22059.dtor@insightbb.com>
In-Reply-To: <200703300033.22059.dtor@insightbb.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thursday 29 March 2007 23:06, Li Yu wrote:
>   
>> Dmitry Torokhov wrote:
>>     
>>> On 3/28/07, Jiri Kosina <jkosina@suse.cz> wrote:
>>>       
>>>> The crucial thing here is that all reports but the ones that the driver
>>>> registered to will be processed in a standard way by the generic hid bus
>>>> layer, and those reports that the driver registered to will be
>>>> ignored by
>>>> the layer, and passed for processing to the driver.
>>>>
>>>>         
>>> I don't think it is a good idea to register driver for specific
>>> usages/reports. Quite often you want to adjust processing of a report
>>> for a specific device. What if there are 2 devices that need such
>>> quirks? How will you do hotplug and module loading? Emit new uevent
>>> for every report? Also, what about users and Kconfig? "Driver for
>>> usage 0x000012345. Say Y if your hardware does not wotk correctly with
>>> defautl handler for this usage and require special processing"???
>>>
>>> Just register based on VID/PID and provide standard
>>> hid_default_input_event() to drivers so they would call it for reports
>>> they don't need to do special processing on.
>>>
>>>       
>>     I think the shadow driver can not share inputdev with the related
>> fundamental driver, so here are two input devices for one hid_device,
>> how we should process both? It seem we have three choices:
>>
>> 1. Shadow | Fundamental means
>>
>>     I think this is Jiri said. Fundamental driver handle all common
>> input events, and Shadow driver handle anther specific input events,
>> this imply user space process need monitor both input devices at same
>> time, I do not think this is good idea.
>>
>> 2. Shadow & Fundamental means
>>
>>     Let Fundamental driver and Shadow driver work at same time! but
>> shadow also handle specific input event. So, the user may get twice
>> input events! For example, the keyboard input in console.
>> Also, I do not like this.
>>
>> 3. Shadow ^ Fundamental means
>>
>>     Let Shadow driver handle every thing, and fundamental device silent,
>> even unregister it. I think this is best choice between them, this means
>> have a bit of complex.
>>
>>     
>
>
> There should be one device and your driver should simply do:
>
> static void my_driver_hid_event(struct hid_device *hid, struct hid_field *field,
> 				struct hid_usage *usage, __s32 value)
> {
> 	if (special_processing_needed(usage)) {
> 		do_special_processing(...);
> 		input_event(field->hidinput->input, XXX, YYY, ZZZ);
> 		...
>
> 	} else
> 		hidinput_hid_event(hid, field, usage, value);
> }
>
> That is pretty much it. Your driver is not a shadow driver, it is
> regular driver on HID bus that just happens to use generic hander
> for standard events.
>
>   

I think I can understand your words. but I need confirm:

Before specific driver register this device, the
fundamental/standard/common(select one by your mind:) driver had already
attach on it likely. At this case, we should detach this hid_device from
its working driver, let this hid_device attach with our new specific
driver. then new driver will handle all input event later, so the your
words is same with the third choice in fact, is it right? if so, the
actual behavior is same with former HID simple interface.

Good luck.

- Li Yu

