Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYFKVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYFKVYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYFKVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:24:15 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:47531 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114AbYFKVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:24:14 -0400
Message-ID: <485042A6.3030705@bluewatersys.com>
Date: Thu, 12 Jun 2008 09:24:54 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de>	<485031D5.3020606@bluewatersys.com>	<20080611141852.3ccd89ea@hyperion.delvare>	<200806111327.09298.david-b@pacbell.net> <20080611225416.169574a0@hyperion.delvare>
In-Reply-To: <20080611225416.169574a0@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Wed, 11 Jun 2008 13:27:09 -0700, David Brownell wrote:
>> On Wednesday 11 June 2008, Jean Delvare wrote:
>>> On Thu, 12 Jun 2008 08:13:09 +1200, Ryan Mallon wrote:
>>>>                               As David suggested, if i2c is needed early
>>>> in enough cases, why not just move it early in the link order? My patch
>>>> was just an alternative approach which mimics the current behaviour, but
>>>> makes it possible to get any i2c driver early. Why not just mark all of
>>>> the drivers/busses that get used on embedded devices as subsys_initcall,
>>>> just in case somebody needs them early?
>>> Because this is an abuse of subsys_initcall? I guess that was
>>> acceptable when only a couple drivers were doing that, but making it
>>> official sounds bad.
>> How would it be an abuse?  On those systems, I2C is a "system bus"
>> and needs to be initialized early for the same reasons PCI gets set
>> up very early on PC hardware.
> 
> But the pci subsystem doesn't make use of subsys_initcall(). Instead,
> it is simply placed early in the link order.
> 
> That being said, I'm not sure if the comparison with the PCI subsystem
> holds... I am under the impression that PCI bus handling doesn't
> require dedicated drivers? At least I can't see any under drivers/pci.
> 
>> There's no rule saying that subsystem initialization may not include
>> the essential drivers -- in this case, i2c_adapter drivers.  PCI hubs
>> and bridges are certainly initialized very early, before module_init
>> code runs...
> 
> Care to point me to actual code to backup this "certainly"?

ryan@okiwi:pci$ grep initcall * -R
pci-acpi.c:arch_initcall(acpi_pci_init);
pci.c:device_initcall(pci_init);
pci-driver.c:postcore_initcall(pci_driver_init);
pcie/aspm.c:fs_initcall(pcie_aspm_init);
pci-sysfs.c:late_initcall(pci_sysfs_init);
probe.c:postcore_initcall(pcibus_class_init);
proc.c:__initcall(pci_proc_init);

At a quick glance (I don't know much about the PCI subsystem) at least
the bus and class are registered early on.

>> And in fact it seems a bit odd to think that initializing any bus
>> subsystem shouldn't be allowed to include its bus adapters.  It's
>> not as if the subsystem has completed initializiation until those
>> adapters are usable!!
> 
> I think it makes a lot of sense to initialize the core of a subsystem
> early, so that all devices and drivers can be registered. This doesn't
> imply registering the hardware bus drivers too, even though in some
> cases it is also needed. I doubt that whoever designed subsys_initcall
> meant it to be used for all bus drivers, otherwise he/she would have
> named it, say, busdrv_initcall.

At least in the case of i2c on many embedded devices we want the bus
driver early, but many other i2c bus drivers don't need this. There
seem to be two main options:

1) Use subsys_initcall on the ones that may need to be early (current
approach).
2) Split the bus drivers into two directories, say drivers/i2c-early and
drivers/i2c, and put the former earlier in the link order.

Maybe a decent compromise approach is to move the drivers which are used
on embedded systems to a new directory such as drivers/i2c/embedded or
drivers/i2c/soc and then only use subsys_initcall on bus drivers in that
directory?

If all of the i2c drivers then go in the right place, ie drivers/gpio
instead of drivers/i2c/chips, then only the bus drivers, not the device
drivers, should ever need to use subsys_initcall right?

> But don't get me wrong: if subsys_initcall is the way to go, that's
> alright with me, that's way less work than having to move drivers to
> different directories and fixing the link order.

I don't think multiple directories for i2c at the drivers/ level is the
right way to go, that just going to get confusing. I think moving the
i2c bus drivers which may be needed early to a new sub directory under
drivers/i2c and then tidying up the Kconfig to categorise the bus
drivers as embedded (soc), pc, external, etc.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
