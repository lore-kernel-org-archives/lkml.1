Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbZKXIyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbZKXIyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:54:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254AbZKXIyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:54:01 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:38048 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbZKXIyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:54:00 -0500
MIME-Version: 1.0
In-Reply-To: <200911240821.40563.rusty@rustcorp.com.au>
References: <200911222201.59471.linux@rainbow-software.org> 
	<200911231359.54544.rusty@rustcorp.com.au> <s5h8wdxab2h.wl%tiwai@suse.de> 
	<200911240821.40563.rusty@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 24 Nov 2009 09:53:51 +0100
Message-ID: <ac3eb2510911240053n593317b0qe60043988d89810f@mail.gmail.com>
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

On Mon, Nov 23, 2009 at 22:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 23 Nov 2009 07:10:22 pm Takashi Iwai wrote:
>> At Mon, 23 Nov 2009 13:59:53 +1030, Rusty Russell wrote:
>> > Two things are required:
>> > 1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
>> > 2) Expose the isapnp devices in sysfs where udev will match them up
>> >    (/sys/bus/isa/devices/<dev>/modalias I guess?)
>>
>> There is non-pnp ISA bus, so I'm afraid "isa" may conflict.
>> I suppose "isapnp" would be a safer choice.
>
> Without pnp, I don't think you can enumerate the ISA bus. Hence I chose
> "isa:" in the hope that udev would "just work" if isapnp created the
> modalias under /sys/bus/isa...
>
> But Kay says there's a pnp bus (who knew?).  I don't know what he means
> by unfixable aliases tho, since it's all in the kernel source so we can
> change it at any time?

Here's a bit of the background:

The aliases in the modules can only match a single value, but PNP
devices often have vendor specific IDs and usual IDs describing the
function.

Like here, where the interesting ID is only the second one of the two
for a single device:
  $ grep . /sys/bus/pnp/devices/*/id
  /sys/bus/pnp/devices/00:09/id:LEN0006
  /sys/bus/pnp/devices/00:09/id:PNP0f13

So the kernel device would need to compose a "modalias" string with
all IDs in a single line. But the in-module aliases can unfortunately
match only on a single value, like:
  alias pnp:dPNP0700* floppy

For that reason, a while ago udev switched to acpi aliases entirely,
and dropped all pnp: usage. The acpi aliases can handle multi-values
just fine with single strings like:
  $ cat /sys/bus/acpi/devices/LEN0006:00/modalias
  acpi:LEN0006:PNP0F13:

  alias acpi*:PNP0700:* floppy

Udev does not use any pnp: or /sys/bus/pnp/ values since a while. But
there might be still distros who use the (broken) pnp: aliases and
ship the (also broken) shell scripts to iterate over the sysfs devices
and call modprobe for all they find.

Thanks,
Kay
