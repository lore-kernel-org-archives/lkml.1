Return-Path: <linux-kernel-owner+w=401wt.eu-S1161194AbXDEFaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbXDEFaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXDEFaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:30:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:40876 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161194AbXDEFaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PsdmFq4UWmF9RhDlfR/3RJZzPgsRuZagkBvJvM2qpi7PHHNUOjMmuCEf8PH3E1M1FrX1OsyXrXsfK4LN7CQyDyDBAoH8i5aw/dgXoF3UBy67hwgOLs+zg5QcdKyQEHHV33Qgb6Y6+WDfzd9vLJpJQMpMrX1QD8tKvDJEAO9jAKM=
Message-ID: <4614890E.4030908@gmail.com>
Date: Thu, 05 Apr 2007 13:28:46 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Jiri Kosina <jkosina@suse.cz>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>	<Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>	<46145026.3050305@gmail.com> <200704042309.19344.dtor@insightbb.com>
In-Reply-To: <200704042309.19344.dtor@insightbb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>> +static int hid_bus_match(struct device *dev, struct device_driver
>> *drv) +{
>> +	struct hid_driver *hid_drv;
>> +	struct hid_device *hid_dev;
>> +
>> +	hid_drv = to_hid_driver(drv);
>> +	hid_dev = to_hid_device(dev);
>> +
>> +	if (is_hid_driver_sticky(hid_drv))
>> +		/* the sticky driver match device do not pass here. */
>> +		return 0;
>> +	if (hid_dev->bus != hid_drv->bus)
>> +		return 0;
>>     
>
> How can this happen?
>
>   
Our HID driver just are some logical drivers, they are not attach some
physical devices directly. However, The HID core may include more than
one physical bus devices, I think HID drivers only take care of these
devices at one physical bus. So, compare here can avoid call 
hid_drv->match() across bus.
>> +	if (!hid_drv->match || hid_drv->match(hid_drv, hid_dev)) {
>> +		hid_dev->driver = hid_drv;
>>     
>
> This usually done in bus->probe() function, when we know for sure that
> driver binds to to the device.
>
>   
Yes, this may have a bit of hack, but this make hid_drv->probe() more
easier. And, as you seen, the hid_drv_probe() will check the actual
probe process is whether OK. If not so, the hid_drv_probe() will clean
this member.
>> +static void hid_bus_release(struct device *dev)
>> +{
>> +}
>> +
>> +struct device hid_bus = {
>> +	.bus_id   = "hidbus0",
>> +	.release  = hid_bus_release
>> +};
>> +
>> +static void hid_dev_release(struct device *dev)
>> +{
>> +}
>> +
>>     
>
> That will for sure raise Greg KH's blood pressure ;)
>
>   
Er, if not so, we will get some dump stack information in dmesg when
remove this module ......
>> +	for (i=0; hid_dev->attrs && hid_dev->attrs[i]; ++i) {
>> +		ret = device_create_file(&hid_dev->device, hid_dev->attrs[i]);
>> +		if (ret)
>> +			break;
>> +
>>     
>
> That should be handled via bus's device attributes and not open coded...
>
>   
I agree, this is another TODO.
>> - *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
>> - *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
>> + *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@@suse.cz>
>> + *  Copyright (c) 2005 Michael Haboustak <mike-@@cinci.rr.com> for Concept2, Inc
>>   *  Copyright (c) 2006 Jiri  Kosina
>>     
>
> Any particular reason for mangling addresses?
>
>   
I also want to who changed them! ~_~

>> +	if (interrupt)
>> +		local_irq_save(flags);
>> +	spin_lock(&hid_lock);
>> +	list_for_each_entry(driver, &hid_sticky_drivers, sticky_link) {
>> +		hook = driver->hook;
>> +		if (hook && hook->raw_event) {
>> +			ret = hook->raw_event(hid, type, data, size, interrupt);
>> +			if (!ret)
>> +				break;
>> +		}
>> +	}
>> +	spin_unlock(&hid_lock);
>> +	if (interrupt)
>> +		local_irq_restore(flags);
>> +
>>     
>
> This is scary. spin_lock_irqsave() and be done with it.
>
>   
May be, I really do not want to increase interrupt disabling time in our
action.

>> +int hid_open(struct hid_device *hid)
>> +{
>> +	struct hid_transport *tl;
>> +	int ret;
>> +
>> +	if (hid->driver->open)
>> +		return hid->driver->open(hid);
>> +	ret = 0;
>> +	spin_lock(&hid_lock);
>> +	tl =  hid_transports[hid->bus];
>> +	if (tl->open)
>> +		ret = tl->open(hid);
>> +	spin_unlock(&hid_lock);
>> +	return ret;
>> +}
>>     
>
> Spinlock is not the best choise here, I'd expect most ->open()
> implementation wait on some IO.
>
>   
Yes, I agree! Also, there have another code access hid_transports[]
without spin it!
