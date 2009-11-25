Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbZKYLjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbZKYLjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbZKYLjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:39:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49270 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZKYLjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <200911251021.44295.rusty@rustcorp.com.au>
References: <200911222201.59471.linux@rainbow-software.org> 
	<200911240821.40563.rusty@rustcorp.com.au> <ac3eb2510911240053n593317b0qe60043988d89810f@mail.gmail.com> 
	<200911251021.44295.rusty@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 25 Nov 2009 12:39:43 +0100
Message-ID: <ac3eb2510911250339q6101f06an27b40d1c59709b9@mail.gmail.com>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Takashi Iwai <tiwai@suse.de>, Ondrej Zary <linux@rainbow-software.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 00:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 24 Nov 2009 07:23:51 pm Kay Sievers wrote:
>> On Mon, Nov 23, 2009 at 22:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > On Mon, 23 Nov 2009 07:10:22 pm Takashi Iwai wrote:
>> >> At Mon, 23 Nov 2009 13:59:53 +1030, Rusty Russell wrote:
>> >> > Two things are required:
>> >> > 1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
>> >> > 2) Expose the isapnp devices in sysfs where udev will match them up
>> >> >    (/sys/bus/isa/devices/<dev>/modalias I guess?)
>> >>
>> >> There is non-pnp ISA bus, so I'm afraid "isa" may conflict.
>> >> I suppose "isapnp" would be a safer choice.
>> >
>> > Without pnp, I don't think you can enumerate the ISA bus. Hence I chose
>> > "isa:" in the hope that udev would "just work" if isapnp created the
>> > modalias under /sys/bus/isa...
>> >
>> > But Kay says there's a pnp bus (who knew?).  I don't know what he means
>> > by unfixable aliases tho, since it's all in the kernel source so we can
>> > change it at any time?
>>
>> Here's a bit of the background:
>>
>> The aliases in the modules can only match a single value, but PNP
>> devices often have vendor specific IDs and usual IDs describing the
>> function.
>
> I'm confused.  You can have multiple aliases in a module.  Many do.

Sure, but we have only a single modalias string to match against. The
aliases need to be in a form where they can match the modalias string
containing more than a single entry. The current ones can't do that,
but they were known to be used by some systems with hacky shell
scripts or custom modprobe configs to load pnp device modules.

>> Like here, where the interesting ID is only the second one of the two
>> for a single device:
>>   $ grep . /sys/bus/pnp/devices/*/id
>>   /sys/bus/pnp/devices/00:09/id:LEN0006
>>   /sys/bus/pnp/devices/00:09/id:PNP0f13
>>
>> So the kernel device would need to compose a "modalias" string with
>> all IDs in a single line. But the in-module aliases can unfortunately
>> match only on a single value, like:
>>   alias pnp:dPNP0700* floppy
>>
>> For that reason, a while ago udev switched to acpi aliases entirely,
>> and dropped all pnp: usage. The acpi aliases can handle multi-values
>> just fine with single strings like:
>>   $ cat /sys/bus/acpi/devices/LEN0006:00/modalias
>>   acpi:LEN0006:PNP0F13:
>>
>>   alias acpi*:PNP0700:* floppy
>
> Then why didn't you change the pnp modalias format to be more like the ACPI
> one?

I'm all for doing that, but the current ones are used in old shell
script hacks and custom modprobe configs. Not sure, if that is still
something we need to care about. As mentioned, for that reason,
upstream udev dropped all that a while ago and supports only acpi
aliases today. At the moment we decide not to care about the possible
old users anymore, we could change the pnp aliases to a sane format.

> (I know nothing about ACPI or PNP, so maybe I'm missing something fundamental).

I think you don't miss anything, it's just a bit hard sometimes to get
rid of old users, even when they use the stuff in a wrong way. :)

Thanks,
Kay
