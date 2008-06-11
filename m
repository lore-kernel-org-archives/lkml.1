Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYFKLnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYFKLnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYFKLnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:43:13 -0400
Received: from smtp-01.datacomm.ch ([212.40.2.26]:58955 "EHLO
	smtp-01.datacomm.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYFKLnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:43:11 -0400
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
From: Patrick <ragamuffin@datacomm.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <200806090036.32267.rjw@sisk.pl>
References: <1211717435.6038.53.camel@localhost.localdomain>
	 <200806040033.20736.rjw@sisk.pl> <20080606132011.GA9027@ucw.cz>
	 <200806090036.32267.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Jun 2008 13:43:07 +0200
Message-Id: <1213184587.6376.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Mon, 2008-06-09 at 00:36 +0200, Rafael J. Wysocki wrote:

> > > It's on top of the patch that adds the GART sysdev.

> Updated patch follows.  It has been tested a little on my new 4 GB test box on
> which 2.6.26-rc4 failed miserably with severe consequences.  More testing
> welcome, but please be careful.

No risk no fun! :-)

As the suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch,
where the GART sysdev is added, is now included in 2.6.26-rc5, I was
able to apply this one seamlessly to it (-rc5 tree) and have just
rebooted *, suspended to disk and ram once wiht all filesystems (>400GB)
mounted rw ** and everything is _working fine_.

As usual, a kernel log, the applied patch and a test report are
available at http://zefir.890m.com/kernel-testing/ .

pat@babar:~/tmp/dmesg$ grep -C3 GART dmesg.2.6.26-rc5-gart-suspend.txt
[    0.294419] PCI: Using ACPI for IRQ routing
[    0.314420] PCI-DMA: Disabling AGP.
[    0.314420] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    0.314420] PCI-DMA: using GART IOMMU.
[    0.314420] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.314420] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.314420] hpet0: 4 32-bit timers, 14318180 Hz
--
[  221.770810] CPU1 is down
[  221.770966] PM: Creating hibernation image:
[  221.772014] PM: Need to copy 220260 pages
[  221.772014] PCI-DMA: Resuming GART IOMMU
[  221.772014] Enabling non-boot CPUs ...
[  221.772014] CPU0 attaching NULL sched-domain.
[  221.781073] SMP alternatives: switching to SMP code
--
[  251.756678]   groups: 0
[  251.756984] CPU1 is down
[  251.756984] Back to C!
[  251.756988] PCI-DMA: Resuming GART IOMMU
[  251.757355] Enabling non-boot CPUs ...
[  251.757515] CPU0 attaching NULL sched-domain.
[  251.766920] SMP alternatives: switching to SMP code



﻿* ﻿Rebooted for the first time since i compiled and rebooted -rc4 with
a similar "home-grown" patch on 31. of May, with which I suspended
several times to disk and ram without any problems.

** ﻿and also generally the same setup where suspending has disastrous
effects using kernel < 2.6.26-rc5

> ---
> Add resume handling to GART IOMMU.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/aperture_64.c |    2 +
>  arch/x86/kernel/pci-gart_64.c |   75 +++++++++++++++++++++++++++++++++---------
>  include/asm-x86/gart.h        |    1 
>  3 files changed, 62 insertions(+), 16 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
> +++ linux-2.6/arch/x86/kernel/pci-gart_64.c
> @@ -549,14 +549,70 @@ static __init unsigned read_aperture(str
>  	return aper_base;
>  }
>  
> +static void enable_gart_translations(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_k8_northbridges; i++) {
> +		struct pci_dev *dev;
> +		u32 gatt_reg;
> +		u32 ctl;
> +
> +		dev = k8_northbridges[i];
> +		gatt_reg = __pa(agp_gatt_table) >> 12;
> +		gatt_reg <<= 4;
> +		pci_write_config_dword(dev, 0x98, gatt_reg);
> +		pci_read_config_dword(dev, 0x90, &ctl);
> +
> +		ctl |= 1;
> +		ctl &= ~((1<<4) | (1<<5));
> +
> +		pci_write_config_dword(dev, 0x90, ctl);
> +	}
> +}
> +
> +/*
> + * If fix_up_north_bridges is set, the north bridges have to be fixed up on
> + * resume in the same way as they are handled in gart_iommu_hole_init().
> + */
> +static bool fix_up_north_bridges;
> +static u32 aperture_order;
> +static u32 aperture_alloc;
> +
> +void set_up_gart_resume(u32 aper_order, u32 aper_alloc)
> +{
> +	fix_up_north_bridges = true;
> +	aperture_order = aper_order;
> +	aperture_alloc = aper_alloc;
> +}
> +
>  static int gart_resume(struct sys_device *dev)
>  {
> +	printk(KERN_INFO "PCI-DMA: Resuming GART IOMMU\n");
> +
> +	if (fix_up_north_bridges) {
> +		int i;
> +
> +		for (i = 0; i < num_k8_northbridges; i++) {
> +			struct pci_dev *dev = k8_northbridges[i];
> +
> +			/*
> +			 * Don't enable translations just yet.  That is the next
> +			 * step.  Restore the pre-suspend aperture settings.
> +			 */
> +			pci_write_config_dword(dev, 0x90, aperture_order << 1);
> +			pci_write_config_dword(dev, 0x94, aperture_alloc >> 25);
> +		}
> +	}
> +
> +	enable_gart_translations();
> +
>  	return 0;
>  }
>  
>  static int gart_suspend(struct sys_device *dev, pm_message_t state)
>  {
> -	return -EINVAL;
> +	return 0;
>  }
>  
>  static struct sysdev_class gart_sysdev_class = {
> @@ -614,27 +670,14 @@ static __init int init_k8_gatt(struct ag
>  	memset(gatt, 0, gatt_size);
>  	agp_gatt_table = gatt;
>  
> -	for (i = 0; i < num_k8_northbridges; i++) {
> -		u32 gatt_reg;
> -		u32 ctl;
> -
> -		dev = k8_northbridges[i];
> -		gatt_reg = __pa(gatt) >> 12;
> -		gatt_reg <<= 4;
> -		pci_write_config_dword(dev, 0x98, gatt_reg);
> -		pci_read_config_dword(dev, 0x90, &ctl);
> -
> -		ctl |= 1;
> -		ctl &= ~((1<<4) | (1<<5));
> -
> -		pci_write_config_dword(dev, 0x90, ctl);
> -	}
> +	enable_gart_translations();
>  
>  	error = sysdev_class_register(&gart_sysdev_class);
>  	if (!error)
>  		error = sysdev_register(&device_gart);
>  	if (error)
>  		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
> +
>  	flush_gart();
>  
>  	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
> Index: linux-2.6/arch/x86/kernel/aperture_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/aperture_64.c
> +++ linux-2.6/arch/x86/kernel/aperture_64.c
> @@ -413,4 +413,6 @@ void __init gart_iommu_hole_init(void)
>  		write_pci_config(0, num, 3, 0x90, aper_order<<1);
>  		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
>  	}
> +
> +	set_up_gart_resume(aper_order, aper_alloc);
>  }
> Index: linux-2.6/include/asm-x86/gart.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/gart.h
> +++ linux-2.6/include/asm-x86/gart.h
> @@ -11,6 +11,7 @@ extern void gart_iommu_shutdown(void);
>  extern void __init gart_parse_options(char *);
>  extern void early_gart_iommu_check(void);
>  extern void gart_iommu_hole_init(void);
> +extern void set_up_gart_resume(u32, u32);
>  extern int fallback_aper_order;
>  extern int fallback_aper_force;
>  extern int gart_iommu_aperture;

