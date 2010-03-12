Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0CLWHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:07:05 -0500
Received: from lucidpixels.com ([75.144.35.66]:54179 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725Ab0CLWHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:07:03 -0500
Date: Fri, 12 Mar 2010 17:07:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous
 reboots
In-Reply-To: <201003121459.29793.bjorn.helgaas@hp.com>
Message-ID: <alpine.DEB.2.00.1003121700290.6929@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan> <86802c441003121144y24e763e6n16f237928df1f676@mail.gmail.com> <alpine.DEB.2.00.1003121520120.6929@p34.internal.lan> <201003121459.29793.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-800327987-1268431622=:6929"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-800327987-1268431622=:6929
Content-Type: TEXT/PLAIN; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 12 Mar 2010, Bjorn Helgaas wrote:

> On Friday 12 March 2010 01:32:17 pm Justin Piszcz wrote:
>
>>>> Even with all boards removed:
>>>> [ =A0 =A00.133537] pci 0000:00:00.0: address space collision: [mem
>>>> 0xe0000000-0xffffffff 64bit] already in use
>>>>
>>>> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual =
slot
>>>> PCI-e_GFX and HT3 K8 part
>>>
>>> how about current linus' tree with pci=3Dnocrs or pci=3Duse_crs?
>>
>> Hi, I saw your second e-mail, so it sounds like a bad board or something
>> that Linux does not have a quirk for yet, but in any case, per your
>> recommendations:
>>
>> pci=3Dnocrs:
>> http://home.comcast.net/~jpiszcz/20100312/dmesg-pci-nocrs.txt
>>
>> pci=3Duse_crs:
>> http://home.comcast.net/~jpiszcz/20100312/dmesg-use-crs.txt
>>
>> No collision when pci=3Duse_crs is used, BUT the system still crashes.
>>
>> Instead of collision, it says this:
>>
>> [    0.133598] PCI: pci_cache_line_size set to 64 bytes
>> [    0.133603] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffff=
ffff flags 0x120204] (d=3D0, p=3D0)
>> [    0.133606] pci 0000:00:00.0: no compatible bridge window for [mem 0x=
e0000000-0xffffffff 64bit]
>> [    0.133610] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xfffffff=
f 64bit]
>> [    0.133617] pci 0000:00:11.0: BAR 0: reserving [io  0xff00-0xff07 fla=
gs 0x20101] (d=3D0, p=3D0)
>>
>> [    0.133735] Expanded resource reserved due to conflict with PCI Bus 0=
000:00
>
> Let's look at some of these messages:
>
>  pci_root PNP0A03:00: host bridge window [mem 0x40000000-0xfed0ffff]
>
> That looks normal to me.  If you could boot a current upstream kernel,
> e.g., 2.6.34-rc1, I think it might print more information about your
> AMD PCI address space routing.  BTW, it looks like you have four CPUs,
> but your kernel is only compiled to support two.
The latest e-mail shows similar messages (2.6.34-rc1).

>
>  pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
>  pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffff=
ffff 64bit]
>  pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]
>
> These are just telling us that the device BAR 0xe0000000-0xffffffff
> doesn't fit inside the bridge window of 0x40000000-0xfed0ffff.  I don't
> know why the device has that weird-looking BAR, but that by itself
> shouldn't be fatal because we don't have any drivers that try to use
> that BAR.
OK- btw, keep in mind all boards have been removed from the system, also,
the serial port, 1394, some other things, floppy, etc, have been disabled
in the motherboard, to free up IRQs if that was the cause, no difference.
Also tried many pci=3D options, noapic, acpi=3Doff, nothing helps.

>
>  Expanded resource reserved due to conflict with PCI Bus 0000:00
>
> This comes from e820_reserve_resources_late().  I wish it were a
> more useful message and showed the actual conflict and what was
> expanded, but I don't think it's a problem in itself.
Ok..

>
>  pnp 00:0a: disabling [mem 0x000f0000-0x000f3fff] because it overlaps 000=
0:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
>
> We failed to reserve the 0xe0000000-0xffffffff region above, so we just
> cleared out the resource.  It keeps the same size, so it ends up at
> 0x00000000-0x1fffffff, where it appears to conflict with a lot of PNP
> devices.  But this isn't a real conflict; it's just Linux being stupid
> because we don't handle that PCI resource correctly.
Ok..

>
> So the messages *look* alarming, but I don't see anything there that
> should cause a spontaneous reboot.
The system stays up for 5min, 10min, 1-2hrs sometimes and then the box
will reboot, even with various kernel debugging enabled, nothing is capture=
d,
have not setup netconsole for this server yet, but I don't think that would
get anything either due to how this error occurs.  It is a brand new=20
motherboard/memory/etc.  What is interesting is running stress, there are
no issues, but I was able to make it crash by reading all of the drives
on the system and running lilo at the same time, that was the only time I
made it crash on-demand, or "reboot"- as there are no logs/etc of the crash=
=2E
>
> Is this a regression?  Did the system ever work reliably with any
> Linux kernel?  If not, I'd suspect a hardware problem like bad memory.
The memory has been tested, latest memtest from the latest System Rescue
CD, it has 1 stick of memory (1GB), it passed the memory test successfuly,
there were no errors.

>
> Bjorn

Thanks for the response..

Justin.

---1463747160-800327987-1268431622=:6929--
