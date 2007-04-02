Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXDBBsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXDBBsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 21:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXDBBsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 21:48:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:19469 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXDBBsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 21:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LLw4JD1b+763aCW2FUIYXCKXdRdPntBDbmccTnjl7NCvPcbnDlScEfuilgBr7xppI3bmZHqcr2LIxYLsbI6zqEVNIkdxCjeeJf611Zb7lieG3KaBBpyzuCDDKWXpDMHf+zeNr/LOFoVHTSKpXLbUkEXC5Lg5vYEEa5b+5A3nf7Y=
Message-ID: <4610609C.9030101@gmail.com>
Date: Mon, 02 Apr 2007 09:47:08 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dtor@insightbb.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> <460C7EB4.9080009@gmail.com> <200703300033.22059.dtor@insightbb.com> <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 30 Mar 2007, Dmitry Torokhov wrote:
>
>   
>> There should be one device and your driver should simply do:
>> static void my_driver_hid_event(struct hid_device *hid, struct hid_field *field,
>> 				struct hid_usage *usage, __s32 value)
>> {
>> 	if (special_processing_needed(usage)) {
>> 		do_special_processing(...);
>> 		input_event(field->hidinput->input, XXX, YYY, ZZZ);
>> 		...
>>
>> 	} else
>> 		hidinput_hid_event(hid, field, usage, value);
>> }
>>     
>
> Hi,
>
> in fact I am not entirely sure that the specialized drivers hooked to the 
> HID bus should be passed individual fields/usages by the generic HID 
> driver. That would imply that generic HID layer would have to parse the 
> received report using information retrieved from the report descriptor of 
> the device. But this is in some way in contrary to one of the features 
> this effort should be heading to, isn't it? We want to provide means how 
> to bypass possible errors in HID descriptor of the device (or do any other 
> possible quirky handling) - we want to be able to allow for completely 
> different interpretation of fields than the generic HID parser would do, 
> right?
>
> So I guess the above should rather be
>
> static void my_driver_hid_report(struct hid_device *hid, u8 *data, 
> 				 int size)
> {
>       if (special_processing_needed(data)) {
>               do_special_processing(...);
>               input_event(field->hidinput->input, XXX, YYY, ZZZ);
>               ...
>       } else
>               hid_input_report(hid, data, size);
> }
>
>
> Such driver will register itself onto a HID bus. Both USB and BT 
> transports could provide VID and PID which could then be easily matched 
> against by the bus code to easily check whether processing by specialized 
> driver is needed or handling by (existing) generic HID layer is enough.
>
> As an added value, hooking the hidraw code to this architecture would then 
> be rather a trivial task.
>
> Thanks,
>
>   
Let me explain the internal of my current HID bus implementation. I
think that selecting one user scene as example is good idea.

Well, the user A plug a USB joystick into computer. The work processing
of HID subsystem for this joystick is same with our mind: The USB/base
driver works for it. However, the world is not faultless. This joystick
is buggy, its some keys need specific handling, our good friend udev
discover that there is also have another driver can handle it, so it
insert that kernel module, then our sweet leading role specific/shadow
HID driver appear on scene. Registering shadow driver let HID core clone
a hid_device first, and start new usage configuration processing for new
cloned hid_device (if we like, even I think we can reread reports from
physical device), the shadow driver can join with HID core to
custom/hook in this recofiguration processing. If this shadow driver is
input-able, the HID core will unregister working input device come from
USB/base hid_device, and register new input device for this shadow
hid_device. So we have not two input_dev for one HID device at same time.

When user A remove this shadow driver, the USB/base driver should resume
work for this joystick, IOW, it should register back its input device again.

There have another type driver: the sticky driver, they will attach each
working device without clone or create new hid_device or input_dev. the
example is hiddev and hidraw.

Yes, this model imply there need more uevents: add, remove. Is this
model suitable? I think the essence of our discussion is how to handle
unknown abnormal device.

I had already ported this to 2.6.21-rc5-mm2, and spent almost two days
to find out one concurrency problem. I lucky known where have bug, but
not fixed it.

Good luck.

- Li Yu
