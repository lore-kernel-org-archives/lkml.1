Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXDQKDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXDQKDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 06:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXDQKDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 06:03:16 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:3406 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753255AbXDQKDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 06:03:14 -0400
Date: Tue, 17 Apr 2007 12:03:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070417120309.38a57579@hyperion.delvare>
In-Reply-To: <20070416211411.GA16150@dreamland.darkstar.lan>
References: <45D5EA88.7090300@redhat.com>
	<200704151431.41503.bjorn.helgaas@hp.com>
	<68676e00704151359g18bf6935wcb2144bcbcf4edd2@mail.gmail.com>
	<200704151857.03115.bjorn.helgaas@hp.com>
	<20070416211411.GA16150@dreamland.darkstar.lan>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn, Luca,

On Mon, 16 Apr 2007 23:14:11 +0200, Luca Tettamanti wrote:
> Il Sun, Apr 15, 2007 at 06:57:02PM -0600, Bjorn Helgaas ha scritto: 
> > In the case of k8temp, the driver claims PCI devices with a certain
> > vendor and device ID.  PCI devices are mostly outside the scope of
> > ACPI.  There's a standard enumeration protocol, and a driver should
> > be able to claim any device it recognizes without fear of conflict.
> >
> > I claim that an AML method that accesses a PCI device is
> > defective because the AML can't know whether a native driver
> > has claimed the device.
> 
> k8temp seems a special case tough.

Yes, it is, and the latest news are that there were no problems with
the k8temp driver, it was a false alert.

> > Sometimes the firmware can hide PCI devices so the OS
> > enumeration doesn't find them.  In that case, AML might
> > be able to safely use the PCI device, but the native
> > driver wouldn't be able to claim the device, so there
> > would be no conflict.  (Linux sometimes uses quirks to
> > "unhide" things like this, which could lead to a conflict
> > of our own making.)

True, and we are stepping back on this. See:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9208ee8286ea2c0136a4bc58638b0295bad791c8

However, it's not so easy, as I have been explaining to Pavel lately.
Some machines have the ACPI vs. lm-sensors conflict while the SMBus
wasn't hidden. On others, the SMBus was hidden and there was no
conflict. So we are not going to just stop unhiding the SMBus and fix
all the problems that way. It's neither necessary, nor sufficient. The
decision must be taken independently for every motherboard / laptop.

> > I suspect that other sensor drivers may just probe for devices
> > at "known" addresses hard-coded in the driver.
> 
> Usually sensors are attached to SMBUS or available in ISA IO space.
> AFAIK they're not enumerated anywhere (at least I2C devices are not, you
> poke at various addresses and see if something responds - not sure about
> ISA).

Legacy ISA hardware monitoring chips (W83781D, W83782D, LM78, LM79)
were indeed probed at an arbitrary address (0x290). I pretty much doubt
that these old chips are found on systems with (working) ACPI though.

More recent "ISA" hardware monitoring chips are embedded in Super-I/O
chips, they are in fact LPC devices, not ISA. The base I/O address is
read from the Super-I/O configuration space, (0x2e/0x2f or 0x4e/0x4f),
just like serial ports, parallel ports, floppy disk controllers, IR,
etc. So these devices _are_ enumerated. Sometimes they are also listed
as PNP devices.

As for I2C/SMBus devices, they are indeed not enumerated. But I fail to
see why non-enumerated devices would be the sole properly of ACPI.

> > This is a
> > problem because the ACPI model is that the OS learns about
> > all built-in devices via the ACPI namespace.  If it isn't
> > in the namespace, it shouldn't exist as far as the OS is
> > concerned.
> >
> > So we could easily have the situation where ACPI uses a
> > sensor and does not expose it to the OS in the namespace.
> > In that case, the firmware expectation is that the OS
> > won't touch the device.  If the OS pokes around at the
> > magic addresses and happens to trip over the device, we
> > just made ourselves a problem.

Interesting theory, but how does it fly in practice? Not much, I guess.
I doubt you could do any useful with an ACPI-enabled system today
without any non-ACPI driver.

> > > > Is this extra functionality available
> > > > on Windows?  If so, do we know whether Windows uses non-ACPI drivers
> > > > or whether they have some smarter way to use ACPI?
> > > 
> > > Usually ACPI exposes 1 or 2 temperature readings (CPU and
> > > motherboard), while the hw driver can also provide fans and voltages
> > > measurements.

And fan speed control.

> > > Vendors usually provides a monitoring utility for Win that also
> > > exposes these information. It's not known whether there's a way to
> > > avoid conflicting accesses between ACPI and the raw driver; it's
> > > possible that it's vendor-specific and not documented.
> > 
> > I'd be surprised if Windows provided interfaces to coordinate
> > between two drivers.  My impression is that they really want
> > to have a single owner for a piece of hardware.  It would be
> > interesting to figure out how these monitoring utilities work.
> > Maybe the monitor and the AML both go through an embedded
> > controller driver and coordinate that way?
> 
> Hum, the utility I have here (Asus PC Probe) seems to use ACPI:
> 
> Pro2.dll:
> [Ordinal/Name Pointer] Table
>         [  11] OCAPI_ACPI_OC_PresetList
>         [  12] OCAPI_ACPI_OC__MB_GetBoardName
>         [  23] OCAPI_CheckAiGear
>         [   0] OCAPI_CheckIntelPowerSaving
>         [   6] OCAPI_CheckWorkable
>         [   2] OCAPI_Close
>         [   9] OCAPI_EnableQFan
>         [  16] OCAPI_GENERAL_GetList
>         [  14] OCAPI_GetCpuVoltRange
>         [  13] OCAPI_GetCurrentCpuFrequency
>         [  15] OCAPI_GetFanStartTemp
>         [   3] OCAPI_GetHealthData
>         [   4] OCAPI_GetHwSensorData
>         [  22] OCAPI_GetMBIF
>         [   8] OCAPI_GetQFanInfo
>         [   5] OCAPI_HW_EnumerateOption
>         [   7] OCAPI_HideQFan
>         [   1] OCAPI_Initialization
>         [  19] OCAPI_NQFAN_GetData
>         [  21] OCAPI_NQFAN_GetList
>         [  20] OCAPI_NQFAN_SetData
>         [  17] OCAPI_QFAN_GetData
>         [  18] OCAPI_QFAN_SetData
>         [  10] OCAPI_SetQFanTarget
>         [  24] ___CPPdebugHook
> 
> ASiO.dll:
> [Ordinal/Name Pointer] Table
>         [   1] ASIO_Close
>         [   9] ASIO_GetCpuID
>         [   3] ASIO_InPortB
>         [   5] ASIO_InPortD
>         [   7] ASIO_MapMem
>         [   0] ASIO_Open
>         [   4] ASIO_OutPortB
>         [   6] ASIO_OutPortD
>         [  10] ASIO_ReadMSR
>         [   8] ASIO_UnmapMem
>         [  11] ASIO_WriteMSR
>         [   2] OC_GetCurrentCpuFrequency
> 
> It seems that Asus exposes monitorining data using "ATK0110" (enumerated
> in DSDT); I see it both on my P5B-E motherboard and on my notebook (L3D)
> (they have different methods though). Another motherboard with the same
> device may actually call it "FOOBAR123" or "WTFISTHIS".
> 
> Problem is that ACPI methods are not documented at all (how am I
> supposed to know that "G6T6" is the reading of the 12V rail?) while the
> datasheet of hw monitoring chips (w83627ehf in my case) are public (more
> or less). Furthermore, sensor driver exposes all the reading of the chip
> (e.g. in the DSDT I can't find the VSB or battery voltage).

Asus does things like this, yeah, but I don't remember any other vendor
having such ACPI methods. It would make sense to write a driver for
this Asus stuff. One of the problem we have in hardware monitoring
drivers is that we usually don't know how the chip is wired on a given
motherboard. The ACPI data might help.

For the other vendors, my assumption is the same as yours: they either
ignore the conflict, or have proprietary, undocumented ways to get
around it. After all, there must be a reason why there is no native
sensors support in Windows and every vendor provides it's own tool.

-- 
Jean Delvare
