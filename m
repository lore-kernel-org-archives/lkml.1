Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZK1M6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZK1M6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZK1M6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:58:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36937 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZK1M6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xF6luTbtOyM1WGwPHMVuTV1eCSJX6wWflUCycfoJ0TJIw0oeaA9JzPmx+rMIT0gL5+
         UW5A2jzpXOjlqJ4Agx7AR4LUgVo3qa/HDo6BZME8o43Sv9GdpMdpeZ1daVbUiouLYUZZ
         m1q92Exaxd55hVItYJg0jK5D/nZnbk20C7P10=
MIME-Version: 1.0
In-Reply-To: <20091128122229.GB17894@khazad-dum.debian.net>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
	 <b170af450911280230g4a2f7f8ao64b46ce7e88ec929@mail.gmail.com>
	 <20091128122229.GB17894@khazad-dum.debian.net>
Date: Sat, 28 Nov 2009 13:58:23 +0100
Message-ID: <b170af450911280458v66c3741dy2a1d9c5297c8faf5@mail.gmail.com>
Subject: Re: Backlight device class redesign
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/28 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> Backlight maintainer added to CC.

Thanks, I should have done that.

> On Sat, 28 Nov 2009, Rafa?? Mi??ecki wrote:
>> W dniu 28 listopada 2009 01:30 u??ytkownik Rafa?? Mi??ecki
>> <zajec5@gmail.com> napisa??:
>> > Currently we keep all registered controllers in /sys/class/backlgiht/
>> > without any grouping per display or per anything. We can not use
>> > grouping per GPU (as somewhere proposed) because one GPU can control
>> > (for example) two PANELS and TV - 3 displays needing backlight
>> > management. The most obvious and stable solution seems to be grouping
>> > per display.
>>
>> Just in case I was not clear enough. We should make ACPI, platform and
>> GPU drivers register same panel backlight control under same name like
>> "panel-0". Backlight class device would create
>> /sys/class/backlight/panel-0 only. When touching files in this
>> backlight/panel-0/, blacklight class would call functions from the
>> most proper (ACPI > platform > GPU) driver.
>>
>
> I once suggested some sort of multiplexer backlight device that would do
> exactly that.  Various drivers (platform, ACPI, display) would register
> backends and specify some sort of dynamic preference so that the kernel
> would have a good bet on the default one, and userspace could switch the
> active backend later if it wanted.
>
> In this case, we'd have to specify properties or some other way to group the
> backends properly and to easily let userspace find the backlight device it
> needs to drive a specific device.

I described my idea of solution at end (cat/echo method).


>> I thought if we could use card number for anything. I recalled that
>> notebooks with hybrid gpu, where system should switch between weaker
>> and more powerful GPU watching load. In case of that notebooks PANEL
>> can be controlled by both: card0 and card1.
>
> That would require backends to be able to runtime register and unregister
> themselves with the main backlight device, and that they hook somehow on the
> hotplug stuff, to know when to bind/unbind along with the GPU.

Don't see anything problematic here. First of course we would have to
support GPU switching, but backlight should not be any issue. When
switching from ATI do Intel just unregister backlight device in ATI
and register backlight device in Intel. Both drivers should register
under the same name like "panel0" or sth.


>> So finally I think we should just register panel0 by default
>> everywhere. And in future we could add some quirks in drivers (ACPI,
>> platform, GPU) that would register panel1, panel2... for such devices.
>
> If you're going to design something, do it properly from day one.  Address
> all the main issues: multiple backends for each device, auto-selection of
> the default backend based on data reported by the backend drivers (e.g. a
> platform driver usually knows very well if it should be preferred over ACPI
> and GPU or not...), *and* multiple devices with hotplug.
>
> These are not, after all, overengineering for the future.  It is a problem
> we have _now_ with real world devices that are shipping.

I wasn't clear, sorry. I want to address all current and future
combinations. I tried to make that clear in my mails. I just mean we
should modify all panel backlight devices to register for "panel0"
display as we currently don't know/support notebooks with two PANELs.
In future if someone put hands on notebook with two PANELs he can
modify module to register both backlight devices: panel0 and panel1
(2, 3, ...).

I didn't know we should prefer platform over ACPI. But maybe you're
right, really, don't know. Eventually we can even add enum { LOWEST,
GPU, PLATFORM_LOW, ACPI, PLATFORM_HIGH } or sth.


> There are other ways to solve this issue, of course, and they're easier:
> publish MORE information on sysfs to properly bind backlight devices to the
> real device they control, as well as more data to help userspace decide
> which one it should use.   It is a cop-out, as we are only solving half the
> problem space in-kernel.  But it works, and it is not a hack, so it is also
> a viable solution.
>
> I prefer the full kernel solution where we export just one backlight
> interface, but when I propesed it, the others made it clear they'd prefer
> the less complex "userspace chooses which backlight backend to drive"
> currently employed.

I think we can stay with proposed kernel solution with eventual
choosing backlight controller for display (overwriting kernel's
choice). For example
$ cat /sys/class/backlight/panel0/method
acpi
platform
$ echo "platform" > /sys/class/backlight/panel0/method


> Meanwhile, I'd like a LOT to know how I could parent the backlight device I
> export in a platform driver to the correct PCI or ACPI device for the main
> GPU...

Is actually "parent" used for something? I can see it used in many
modules, but not sure where we use that pointer (if we do).

-- 
Rafał
