Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbZDRVKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbZDRVKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZDRVKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:10:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZDRVKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:10:04 -0400
Message-ID: <49EA4118.2040701@kernel.org>
Date: Sat, 18 Apr 2009 14:07:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
References: <20090416172803.GB16618@elte.hu>	 <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>	 <20090416235452.GE21405@elte.hu>	 <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>	 <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com>	 <49E96731.1000501@kernel.org>	 <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain>	 <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de>	 <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy>
In-Reply-To: <1240086446.2411.9.camel@poy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Sat, 2009-04-18 at 22:00 +0200, Kay Sievers wrote:
>> On Sat, Apr 18, 2009 at 21:23, Greg KH <gregkh@suse.de> wrote:
>>> On Sat, Apr 18, 2009 at 12:19:21PM -0700, Yinghai Lu wrote:
>>>> Linus Torvalds wrote:
>>>>> Can we not make the rule be that the name should just be set before?
>> I guess, that's what they do already, otherwise they could not use dev_name().
>>
>>>> pci_bus_add_device will call device_add.
>>>>
>>>> actually in device_add
>>>>
>>>>         /* first, register with generic layer. */
>>>>         error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
>>>>         if (error)
>>>>                 goto Error;
>>>>
>>>> will get one new name for that kobj, old name is freed.
>>>>
>>>> Will try to make kobject_add more smart to reuse the old one.
>>> I don't understand the problem here, how are you going to change the
>>> kobject core?  Is this just because you aren't getting a name for the
>>> resource?  If so, why would the driver core care about this?
>> Seems a bit odd what we do when registering a device.
>>
>> Usually one sets the name with dev_set_name() which will name the
>> kobject. When one later registers the device, we reallocate the same
>> name, so the pointer changes. I guess the problem here is that the pci
>> code remembers the name pointer after it was set, but it will not be
>> the same after the device is live.
>>
>> We should probably make device_add() pass a NULL as the name, and
>> kobject_add() in that case use the name that is properly set already.
> 
> Only to see if we are on the right track, does that fix the problem? If
> yes, we will fix it properly without the NULL hack deep in the kobject
> call.
> 
> Thanks,
> Kay
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d230ff4..1969b20 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -890,8 +890,8 @@ int device_add(struct device *dev)
>  	if (parent)
>  		set_dev_node(dev, dev_to_node(parent));
>  
> -	/* first, register with generic layer. */
> -	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
> +	/* we require the name to be set before, and pass NULL */
> +	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
>  	if (error)
>  		goto Error;
>  
> diff --git a/lib/kobject.c b/lib/kobject.c
> index a6dec32..48565d6 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -218,6 +218,9 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  	const char *old_name = kobj->name;
>  	char *s;
>  
> +	if (kobj->name && !fmt)
> +		return 0;
> +
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>  	if (!kobj->name)
>  		return -ENOMEM;
> 

it works well. Thanks

YH


