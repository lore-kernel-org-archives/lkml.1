Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYFZVMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYFZVMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYFZVL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:11:59 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:42802 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753071AbYFZVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:11:58 -0400
Message-ID: <48640656.9010802@bluewatersys.com>
Date: Fri, 27 Jun 2008 09:12:54 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de>	<485031D5.3020606@bluewatersys.com>	<20080611141852.3ccd89ea@hyperion.delvare>	<200806111327.09298.david-b@pacbell.net>	<20080611225416.169574a0@hyperion.delvare>	<485042A6.3030705@bluewatersys.com> <20080624183945.367c88cf@hyperion.delvare>
In-Reply-To: <20080624183945.367c88cf@hyperion.delvare>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Ryan,
> 
> Sorry for the late answer.
> 
> On Thu, 12 Jun 2008 09:24:54 +1200, Ryan Mallon wrote:
>> Jean Delvare wrote:
>>> On Wed, 11 Jun 2008 13:27:09 -0700, David Brownell wrote:
>>>> There's no rule saying that subsystem initialization may not include
>>>> the essential drivers -- in this case, i2c_adapter drivers.  PCI hubs
>>>> and bridges are certainly initialized very early, before module_init
>>>> code runs...
>>> Care to point me to actual code to backup this "certainly"?
>> ryan@okiwi:pci$ grep initcall * -R
>> pci-acpi.c:arch_initcall(acpi_pci_init);
>> pci.c:device_initcall(pci_init);
>> pci-driver.c:postcore_initcall(pci_driver_init);
>> pcie/aspm.c:fs_initcall(pcie_aspm_init);
>> pci-sysfs.c:late_initcall(pci_sysfs_init);
>> probe.c:postcore_initcall(pcibus_class_init);
>> proc.c:__initcall(pci_proc_init);
>>
>> At a quick glance (I don't know much about the PCI subsystem) at least
>> the bus and class are registered early on.
> 
> Ah, my bad. I had been grepping for subsys_initcall, instead of just
> _initcall. It's clearer now.
> 
>>> I think it makes a lot of sense to initialize the core of a subsystem
>>> early, so that all devices and drivers can be registered. This doesn't
>>> imply registering the hardware bus drivers too, even though in some
>>> cases it is also needed. I doubt that whoever designed subsys_initcall
>>> meant it to be used for all bus drivers, otherwise he/she would have
>>> named it, say, busdrv_initcall.
>> At least in the case of i2c on many embedded devices we want the bus
>> driver early, but many other i2c bus drivers don't need this. There
>> seem to be two main options:
>>
>> 1) Use subsys_initcall on the ones that may need to be early (current
>> approach).
>> 2) Split the bus drivers into two directories, say drivers/i2c-early and
>> drivers/i2c, and put the former earlier in the link order.
> 
> I don't like option 2 at all. drivers/i2c/early could be, but not
> drivers/i2c-early.

I don't think its a good idea either. The point was that in order to
have two sets of i2c drivers with different link order (with regard to
the rest of the driver subsystems) you would need two top level
directories in drivers/. The other way of course, is to use one
directory, or subdirectories under drivers/i2c/ and use subsys_initcall.

> 
>> Maybe a decent compromise approach is to move the drivers which are used
>> on embedded systems to a new directory such as drivers/i2c/embedded or
>> drivers/i2c/soc and then only use subsys_initcall on bus drivers in that
>> directory?
> 
> If we are going to keep using subsys_initcall in bus drivers, then
> moving the bus drivers using it to a separate directory is not needed.
> Which doesn't mean we don't want to split the i2c bus drivers into
> subdirectories for other reasons, but I want to see this as a separate
> issue. BTW, I started categorizing the different types of i2c bus
> drivers:
> http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/i2c-group-bus-drivers.patch
> If you want to help with embedded stuff or SOC or whatever makes sense
> to group together, please do! For now, everything I am not familiar
> with is in group "Others".

I don't know all of the embedded systems, but at a glance the following
busses from your others section are used on embedded ARM processors:

i2c-at91
i2c-davinci
i2c-ixp2000
i2c-omap
i2c-pxa
i2c-s3c2410
i2c-versatile

I'm sure someone else can point out any I missed, and any embedded i2c
controllers from other architectures. i2c-gpio should probably also go
under an embedded section as I assume that it is mostly used on embedded
systems where there is no SoC i2c controller.

>> If all of the i2c drivers then go in the right place, ie drivers/gpio
>> instead of drivers/i2c/chips, then only the bus drivers, not the device
>> drivers, should ever need to use subsys_initcall right?
> 
> If drivers/gpio and everything else which may be needed early are moved
> early in the linking order, yes. Otherwise they will need to use
> subsys_initcall too, but I seem to understand that it might not be
> sufficient, if other drivers depend on them and they are also using
> subsys_initcall.

I think this is a problem in general for the Linux kernel driver model.
There is no real way to say that two otherwise unrelated drivers are
dependent on each other, and that one must precede the other in the link
order. I think this happens more in the embedded space where you get
things like an i2c io expander being used as gpios to control power to
other peripherals, etc.

~Ryan
