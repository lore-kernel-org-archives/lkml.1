Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbYFXQkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbYFXQkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759846AbYFXQkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:40:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12656 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759516AbYFXQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:40:16 -0400
Date: Tue, 24 Jun 2008 18:39:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Message-ID: <20080624183945.367c88cf@hyperion.delvare>
In-Reply-To: <485042A6.3030705@bluewatersys.com>
References: <200806091541.43899.u.luckas@road.de>
	<485031D5.3020606@bluewatersys.com>
	<20080611141852.3ccd89ea@hyperion.delvare>
	<200806111327.09298.david-b@pacbell.net>
	<20080611225416.169574a0@hyperion.delvare>
	<485042A6.3030705@bluewatersys.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

Sorry for the late answer.

On Thu, 12 Jun 2008 09:24:54 +1200, Ryan Mallon wrote:
> Jean Delvare wrote:
> > On Wed, 11 Jun 2008 13:27:09 -0700, David Brownell wrote:
> >> There's no rule saying that subsystem initialization may not include
> >> the essential drivers -- in this case, i2c_adapter drivers.  PCI hubs
> >> and bridges are certainly initialized very early, before module_init
> >> code runs...
> > 
> > Care to point me to actual code to backup this "certainly"?
> 
> ryan@okiwi:pci$ grep initcall * -R
> pci-acpi.c:arch_initcall(acpi_pci_init);
> pci.c:device_initcall(pci_init);
> pci-driver.c:postcore_initcall(pci_driver_init);
> pcie/aspm.c:fs_initcall(pcie_aspm_init);
> pci-sysfs.c:late_initcall(pci_sysfs_init);
> probe.c:postcore_initcall(pcibus_class_init);
> proc.c:__initcall(pci_proc_init);
> 
> At a quick glance (I don't know much about the PCI subsystem) at least
> the bus and class are registered early on.

Ah, my bad. I had been grepping for subsys_initcall, instead of just
_initcall. It's clearer now.

> > I think it makes a lot of sense to initialize the core of a subsystem
> > early, so that all devices and drivers can be registered. This doesn't
> > imply registering the hardware bus drivers too, even though in some
> > cases it is also needed. I doubt that whoever designed subsys_initcall
> > meant it to be used for all bus drivers, otherwise he/she would have
> > named it, say, busdrv_initcall.
> 
> At least in the case of i2c on many embedded devices we want the bus
> driver early, but many other i2c bus drivers don't need this. There
> seem to be two main options:
> 
> 1) Use subsys_initcall on the ones that may need to be early (current
> approach).
> 2) Split the bus drivers into two directories, say drivers/i2c-early and
> drivers/i2c, and put the former earlier in the link order.

I don't like option 2 at all. drivers/i2c/early could be, but not
drivers/i2c-early.

> Maybe a decent compromise approach is to move the drivers which are used
> on embedded systems to a new directory such as drivers/i2c/embedded or
> drivers/i2c/soc and then only use subsys_initcall on bus drivers in that
> directory?

If we are going to keep using subsys_initcall in bus drivers, then
moving the bus drivers using it to a separate directory is not needed.
Which doesn't mean we don't want to split the i2c bus drivers into
subdirectories for other reasons, but I want to see this as a separate
issue. BTW, I started categorizing the different types of i2c bus
drivers:
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/i2c-group-bus-drivers.patch
If you want to help with embedded stuff or SOC or whatever makes sense
to group together, please do! For now, everything I am not familiar
with is in group "Others".

> If all of the i2c drivers then go in the right place, ie drivers/gpio
> instead of drivers/i2c/chips, then only the bus drivers, not the device
> drivers, should ever need to use subsys_initcall right?

If drivers/gpio and everything else which may be needed early are moved
early in the linking order, yes. Otherwise they will need to use
subsys_initcall too, but I seem to understand that it might not be
sufficient, if other drivers depend on them and they are also using
subsys_initcall.

> > But don't get me wrong: if subsys_initcall is the way to go, that's
> > alright with me, that's way less work than having to move drivers to
> > different directories and fixing the link order.
> 
> I don't think multiple directories for i2c at the drivers/ level is the
> right way to go, that just going to get confusing. I think moving the
> i2c bus drivers which may be needed early to a new sub directory under
> drivers/i2c and then tidying up the Kconfig to categorise the bus
> drivers as embedded (soc), pc, external, etc.

I agree.

-- 
Jean Delvare
