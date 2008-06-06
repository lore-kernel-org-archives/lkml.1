Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbYFFUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbYFFUpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYFFUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:45:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:37445 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYFFUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=jIRgiay/wyXlUW5rf02DXtKEfBcU54MtxfPSlyfvAfrEZsryKVV/hGS72nnVO5mk7Y
         0gBm7+Soc7bhuForr0uVykv3O9ncJC8c0zdAufWc5Vg90zmoKDvrFbRiOpXA5+Ragp/T
         PsrYjV16cYuT2Js2JHt2gulEjpiiK6hcs5B1g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.25 -> 2.6.26-rc1: pcmcia flash card changed name from hda to hdc
Date: Fri, 6 Jun 2008 22:45:55 +0200
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org
References: <20080515132313.GA1558@elf.ucw.cz> <200805162140.49501.bzolnier@gmail.com> <20080605102146.GA1552@elf.ucw.cz>
In-Reply-To: <20080605102146.GA1552@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806062245.55973.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 05 June 2008, Pavel Machek wrote:
> Hi!
> 
> > > After update to 2.6.26-rc1, CF card (in pcmcia slot) moved from hda to
> > > hdc on thinkpad x60 (and broke my scripts).
> > > 
> > > Is that intentional?
> > 
> > Please send dmesgs for 2.6.25 and 2.6.26-rc1 so we can tell more.
> 
> Sorry it took me so long...
> 								Pavel

No problem, lets see what is going on:

> 2.6.26-rc5: flash card is at /dev/hdc.

[...]

> Uniform Multi-Platform E-IDE driver
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
> ICH7: not 100% native mode: will probe irqs later
> ICH7: IDE port disabled
>     ide0: BM-DMA at 0x1810-0x1817

ide0 interface is claimed by piix host driver...

> Probing IDE interface ide0...
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

...but there are no devices attached to it.

[...]

> pcmcia: registering new device pcmcia0.0
> Probing IDE interface ide1...
> hdc: SunDisk SDP3B-20, CFA DISK drive
> hdd: SunDisk SDP3B-20, CFA DISK drive
> ide-probe: ignoring undecoded slave
> ide1 at 0x9100-0x9107,0x910e on irq 16

PCMCIA IDE controller is inserted and ide-cs claims the next free
interface (ide1) and then detects device on it.

[...]

Now in 2.6.25 it was is like this:

> 2.6.25 : flash card is on /dev/hda

[...]

> Uniform Multi-Platform E-IDE driver
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
> ICH7: not 100% native mode: will probe irqs later
> ICH7: IDE port disabled
>     ide0: BM-DMA at 0x1810-0x1817, BIOS settings: hda:PIO, hdb:PIO
> Probing IDE interface ide0...

Same as in 2.6.26-rc1.

[...]

> pcmcia: registering new device pcmcia0.0
> Probing IDE interface ide0...
> hda: SunDisk SDP3B-20, CFA DISK drive
> hdb: SunDisk SDP3B-20, CFA DISK drive
> ide-probe: ignoring undecoded slave
> ide0 at 0x9100-0x9107,0x910e on irq 16

However ide0 (already claimed by piix host driver) is re-used by ide-cs
host driver.

[...]

I now see the source cause of the hda -> hdc name change - we've fixed
bast-ide (for arm/bast and arm/vr1000) palm_bk3710 (arm/davinci), ide-cs
and delkin_cb to use ide_find_port() instead of ide_deprecated_find_port()
in the commit 4f0eee4d877e3b617b6a22d209d52b3dfca2b2a7.

This was needed because re-using interfaces already claimed by other host
drivers was buggy (i.e. if ide-cs was used along with some other host driver
that can be unloaded, unloading the other driver would result in attempt to
un-register ide-cs interface => havoc), also the change was necessary for
proper IDE warm-plug support (devices can be added/removed to ide0).

We may try to bring the old behavior back with some (major) hackery but:

- the old behavior was buggy (it could result in _real_ bugs under certain
  circumstances)

- the issue will come back again if allow module unloading for IDE PCI host
  drivers or remove static ide_hwifs[] table

- there shouldn't be many systems affected by it since you need to use both
  bast-ide/palm_bk3710/ide-cs/delkin_cb and some other host driver (for host
  which has _all_ IDE interfaces empty)

- we've never claimed to have stable device naming (we try very hard to keep
  it unchanged and avoid unnecessary changes but sometimes it isn't feasible)
  and there are more reliable means for achieving it (udev / UUIDs)

so I guess that is fair to say that ide-cs name change is an inconvenient
side-effect of moving things forward? [ and I'm _really_ sorry about it! ]

Thanks,
Bart
