Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbZFBPge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbZFBPge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbZFBPg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:36:26 -0400
Received: from mail-px0-f114.google.com ([209.85.216.114]:64107 "EHLO
	mail-px0-f114.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbZFBPgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:36:24 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 11:36:24 EDT
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       paul@pwsan.com, gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se>
	<200906012047.59726.rjw@sisk.pl> <200906012133.32074.rjw@sisk.pl>
	<aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 02 Jun 2009 08:30:54 -0700
In-Reply-To: <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com> (Magnus Damm's message of "Tue\, 2 Jun 2009 13\:33\:08 +0900")
Message-ID: <87d49mk5zl.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm <magnus.damm@gmail.com> writes:

> 2009/6/2 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Monday 01 June 2009, Rafael J. Wysocki wrote:
>>> On Monday 01 June 2009, Magnus Damm wrote:
>>> > From: Magnus Damm <damm@igel.co.jp>
>>> >
>>> > Allow architecture specific data in struct platform_device V2.
>>> > The structure pdev_archdata is added to struct platform_device,
>>> > similar to struct dev_archdata in struct device.
>>> >
>>> > Useful for architecture code that needs to keep extra data
>>> > associated with each platform device. This data shall not
>>> > be accessed by platform drivers, only architecture code.
>>> >
>>> > Needed for platform device runtime PM.
>>>
>>> What exactly do you need this data for?
>
> I'd like to keep a hardware block id associated with each platform
> device on our SoC.
> Please have a look at "PATCH [04/04] sh: Runtime platform device PM mockup",
> http://patchwork.kernel.org/patch/26421/

And in OMAP, we will keep a pointer to an SoC-specific struct of
HW specific data to be used in idle/wakeup decision making.

>> Anyway, I think you can introduce something like:
>>
>> struct <your arch>_platform_device {
>>    struct platform_device dev;
>>    <some type> <your arch data>;
>>    ...
>> };
>>
>> define your platform devices using the struct above and pass its dev member to
>> the functions that need 'struct platform_device' as an argument.
>>
>> Then you won't need to add arch members to 'struct platform_device' itself.
>
> Thanks for your suggestion. I'm usually a friend of wrapping
> structures and using offsetof(), but in this case I don't think it
> will work very well.

Neither do I in this case...

> I'd like to keep a SoC specific hardware block id in this architecture
> specific struct. Then let the arch specific functions
> platform_device_idle() and platform_device_wakeup() use this hardware
> block id to locate which clocks to stop and which power domains to
> fiddle with within the SoC. If we only consider this on-SoC case then
> wrapping and offsetof() works well.
>
> However, a typical embedded system has a wide range of platform
> devices. Some are for the SoC itself and some are for external
> devices, like on board ethernet controlllers (not on chip like the SoC
> platform devices). And since idle() and wakeup() work with struct
> platform device, with a wrapped data structure we need some way to
> check if the platform data is actually wrapped and offsetof() is
> valid. I guess we could use some platform device specific flag for
> this, but that seems overly complicated in my opinion. And modifying
> idle() and wakup() to take arch specific structures is not so good
> since we want to use the same platform driver on multiple
> architectures.

Also, there many cases where platform_devices are not declared
statically and using the wrapper method doesn't work well if you are
using platform_device_alloc().  In addition to not being able to use
container_of() etc.  the memory allocated potentially lasts longer than
the existence of the platform_device.

I have a patch lying around that extended platform_device_alloc() to
take an extra size arg for platform-specific extentions (like
netdev_alloc() and some others like it) but I never got ambitious
enough to change all the users of platform_device_alloc().

Kevin


> My mockup code that keeps keeps the hardware block id in the platform
> device arch specific data works well since the hardware block id with
> value zero is a special case. The value zero means "external non-soc
> device", so a "regular" board specific struct platform_device that do
> not setup arch specific data can just be skipped in idle()/wakeup().
>
> If you guys dislike adding arch specific data to struct platform
> device then for SuperH we can just (mis)use the arch specific data in
> struct device instead. I'm afraid that solution wastes memory since
> the data will only be used for platform devices anyway. So I prefer
> adding arch specific data to struct platform_device instead of struct
> device if possible.
>
> Maybe there are better ways to solve this? I think arch specific data
> in struct platform_device is pretty straight forward though.
