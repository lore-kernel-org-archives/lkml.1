Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZFBEdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZFBEdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZFBEdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:33:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:58404 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZFBEdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hD1rmgboet8K7FScFEMD7xvXENQwud9IbmaxVkjm2IsAVXsBupALmNRLSe19ygKbWs
         HlcFBVhA/0ZApTuZJYXimcHUOS9i7nSWMoCP42rMpxCsJXOs3aGn+OQ9WKpWkUcYBYjf
         cjPz+OaZLli2Eofp/HrQfGTSfkKjhnWv/CokA=
MIME-Version: 1.0
In-Reply-To: <200906012133.32074.rjw@sisk.pl>
References: <20090601101614.10720.93804.sendpatchset@rx1.opensource.se>
	 <200906012047.59726.rjw@sisk.pl> <200906012133.32074.rjw@sisk.pl>
Date: Tue, 2 Jun 2009 13:33:08 +0900
Message-ID: <aec7e5c30906012133w74d7d843jccad99c564a308ec@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: Add platform device arch data V2
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, paul@pwsan.com, khilman@deeprootsystems.com,
       gregkh@suse.de, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/2 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 01 June 2009, Rafael J. Wysocki wrote:
>> On Monday 01 June 2009, Magnus Damm wrote:
>> > From: Magnus Damm <damm@igel.co.jp>
>> >
>> > Allow architecture specific data in struct platform_device V2.
>> > The structure pdev_archdata is added to struct platform_device,
>> > similar to struct dev_archdata in struct device.
>> >
>> > Useful for architecture code that needs to keep extra data
>> > associated with each platform device. This data shall not
>> > be accessed by platform drivers, only architecture code.
>> >
>> > Needed for platform device runtime PM.
>>
>> What exactly do you need this data for?

I'd like to keep a hardware block id associated with each platform
device on our SoC.
Please have a look at "PATCH [04/04] sh: Runtime platform device PM mockup",
http://patchwork.kernel.org/patch/26421/

> Anyway, I think you can introduce something like:
>
> struct <your arch>_platform_device {
>    struct platform_device dev;
>    <some type> <your arch data>;
>    ...
> };
>
> define your platform devices using the struct above and pass its dev member to
> the functions that need 'struct platform_device' as an argument.
>
> Then you won't need to add arch members to 'struct platform_device' itself.

Thanks for your suggestion. I'm usually a friend of wrapping
structures and using offsetof(), but in this case I don't think it
will work very well.

I'd like to keep a SoC specific hardware block id in this architecture
specific struct. Then let the arch specific functions
platform_device_idle() and platform_device_wakeup() use this hardware
block id to locate which clocks to stop and which power domains to
fiddle with within the SoC. If we only consider this on-SoC case then
wrapping and offsetof() works well.

However, a typical embedded system has a wide range of platform
devices. Some are for the SoC itself and some are for external
devices, like on board ethernet controlllers (not on chip like the SoC
platform devices). And since idle() and wakeup() work with struct
platform device, with a wrapped data structure we need some way to
check if the platform data is actually wrapped and offsetof() is
valid. I guess we could use some platform device specific flag for
this, but that seems overly complicated in my opinion. And modifying
idle() and wakup() to take arch specific structures is not so good
since we want to use the same platform driver on multiple
architectures.

My mockup code that keeps keeps the hardware block id in the platform
device arch specific data works well since the hardware block id with
value zero is a special case. The value zero means "external non-soc
device", so a "regular" board specific struct platform_device that do
not setup arch specific data can just be skipped in idle()/wakeup().

If you guys dislike adding arch specific data to struct platform
device then for SuperH we can just (mis)use the arch specific data in
struct device instead. I'm afraid that solution wastes memory since
the data will only be used for platform devices anyway. So I prefer
adding arch specific data to struct platform_device instead of struct
device if possible.

Maybe there are better ways to solve this? I think arch specific data
in struct platform_device is pretty straight forward though.

Thanks,

/ magnus
