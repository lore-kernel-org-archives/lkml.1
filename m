Return-Path: <linux-kernel-owner+w=401wt.eu-S934858AbZKYRSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbZKYRSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbZKYRR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:17:56 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35219 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933568AbZKYRRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:17:54 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Wed, 25 Nov 2009 18:17:45 +0100
User-Agent: KMail/1.9.10
Cc: Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200911240821.40563.rusty@rustcorp.com.au> <ac3eb2510911240053n593317b0qe60043988d89810f@mail.gmail.com>
In-Reply-To: <ac3eb2510911240053n593317b0qe60043988d89810f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911251817.48965.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009 09:53:51 Kay Sievers wrote:
> On Mon, Nov 23, 2009 at 22:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Mon, 23 Nov 2009 07:10:22 pm Takashi Iwai wrote:
> >> At Mon, 23 Nov 2009 13:59:53 +1030, Rusty Russell wrote:
> >> > Two things are required:
> >> > 1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
> >> > 2) Expose the isapnp devices in sysfs where udev will match them up
> >> >    (/sys/bus/isa/devices/<dev>/modalias I guess?)
> >>
> >> There is non-pnp ISA bus, so I'm afraid "isa" may conflict.
> >> I suppose "isapnp" would be a safer choice.
> >
> > Without pnp, I don't think you can enumerate the ISA bus. Hence I chose
> > "isa:" in the hope that udev would "just work" if isapnp created the
> > modalias under /sys/bus/isa...
> >
> > But Kay says there's a pnp bus (who knew?).  I don't know what he means
> > by unfixable aliases tho, since it's all in the kernel source so we can
> > change it at any time?
>
> Here's a bit of the background:
>
> The aliases in the modules can only match a single value, but PNP
> devices often have vendor specific IDs and usual IDs describing the
> function.
>
> Like here, where the interesting ID is only the second one of the two
> for a single device:
>   $ grep . /sys/bus/pnp/devices/*/id
>   /sys/bus/pnp/devices/00:09/id:LEN0006
>   /sys/bus/pnp/devices/00:09/id:PNP0f13

It's the same for my RTL8019 card:
$ grep . /sys/bus/pnp/devices/*/id
/sys/bus/pnp/devices/01:01.00/id:RTL8019
/sys/bus/pnp/devices/01:01.00/id:PNP80d6

and it works with this (which could be easily generated from the current ne 
module, I think):
alias pnp:dPNP80d6* ne

This works fine too:
alias pnp:dRTL8019* ne
alias pnp:dPNP80d6* ne

> So the kernel device would need to compose a "modalias" string with
> all IDs in a single line. But the in-module aliases can unfortunately
> match only on a single value, like:
>   alias pnp:dPNP0700* floppy
>
> For that reason, a while ago udev switched to acpi aliases entirely,
> and dropped all pnp: usage. The acpi aliases can handle multi-values
> just fine with single strings like:
>   $ cat /sys/bus/acpi/devices/LEN0006:00/modalias
>   acpi:LEN0006:PNP0F13:
>
>   alias acpi*:PNP0700:* floppy
>
> Udev does not use any pnp: or /sys/bus/pnp/ values since a while. But
> there might be still distros who use the (broken) pnp: aliases and
> ship the (also broken) shell scripts to iterate over the sysfs devices
> and call modprobe for all they find.
>
> Thanks,
> Kay



-- 
Ondrej Zary
