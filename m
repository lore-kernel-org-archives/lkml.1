Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYGPOIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYGPOIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYGPOIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:08:14 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:53906 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755430AbYGPOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:08:12 -0400
Date: Wed, 16 Jul 2008 10:08:10 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Justin Mattock <justinmattock@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080716140810.GA2861@bromo.msbb.uc.edu>
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com> <20080715231118.GA26807@bromo.msbb.uc.edu> <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com> <20080716012427.GA27398@bromo.msbb.uc.edu> <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com> <20080716035830.GA27935@bromo.msbb.uc.edu> <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com> <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com> <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com> <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunghai,
   I had partial success with your proposed patch. The MacPro2
identifier doesn't appear to be correct for a second generation
MacBook Pro so I had to comment out the line...

                     DMI_MATCH(DMI_PRODUCT_NAME, "MacPro2"),

With that change, a patched 2.6.26-git2 kernel now uses MMCONFIG.
However I still see the same hang. The boot messages I see on
screen are...

ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS_OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: drivers started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000.00)
pci 0000:00:1f.00 : quirk region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000.00:1f:00 : quirk region 0500-053f claimed by ICH6 GPIO

...at which the boot hangs. On the positive side, I was able to fully
boot if I passed 'pci=noacpi' to the kernel options (which never worked
before with 2.6.26). I can post the dmesg from a noacpi boot of the
patched kernel to my bugzilla report tonight if it would help debug the
issues we are still seeing with ACPI.
   One thing I notice with the patched kernel (without noacpi) is that I
only see buses 0 - 63. A normal boot of 2.6.25.10 on this machine (or
2.6.26 reportedly on a MacMini) always shows buses 0 - 255. Could this
be related to the ACPI breakage? Let me know if I can do anything
else to debug the ACPI issues under MMCONFIG.
                     Jack


On Wed, Jul 16, 2008 at 01:36:21AM -0700, Yinghai Lu wrote:
> On Wed, Jul 16, 2008 at 12:50 AM, Justin Mattock
> <justinmattock@gmail.com> wrote:
> > On Wed, Jul 16, 2008 at 7:44 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> I looked at your dmesg from 2.6.25.10
> >>
> >> it tried to use mmconfig, and later fall back to conf1, because
> >> 1. your MCFG said it support bus [0,255], and range will be
> >> [0xf0000000, 0xffffffff]
> >> 2. firmware only reserve [0xf0000000, 0xf4000000)
> >>
> >> and 2.5.25 will not check acp reserved range.
> >>
> >> from 2.6.26, it will check if the [0xf0000000, 0xffffffff] is reserved
> >> via acpi dsdt _crs?
> >> it will fail too.
> >>
> >> So MCFG table is broken.
> >>
> >> You need to get firmware update from your vendor.
> >>
> >> or we need to put that system on DMI check to change end_bus_number
> >> from 0xff to 0x3f
> >>
> >> ps: mem=2g will not work, it will can not change mcfg table etc... you
> >> need take out 1G ram out.
> >>
> >> YH
> >>
> >
> > Well shit man, that sucks...
> > how hard is it to do a DMI check?
> > regards;
> 
> please check attached patch... not sure the
> DMI_MATCH(DMI_PRODUCT_NAME, "MacPro2"),  is right or not.
> 
> YH

> [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
> 
> change the mconf bus range from [0,0xff] to to [0, 0x3f]
> to match range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/pci/mmconfig-shared.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> @@ -374,6 +374,40 @@ reject:
>  
>  static int __initdata known_bridge;
>  
> +static int __devinit check_mmconf(const struct dmi_system_id *d)
> +{
> +	typeof(pci_mmcfg_config[0]) *cfg;
> +
> +	if ((pci_mmcfg_config_num != 1) ||
> +	    (pci_mmcfg_config == NULL) ||
> +	    (pci_mmcfg_config[0].address == 0))
> +		return 1;
> +
> +	cfg = &pci_mmcfg_config[0];
> +
> +	if (cfg->start_bus_number == 0 && cfg->end_bus_number > 0x3f)
> +		cfg->end_bus_number = 0x3f;
> +
> +	return 0;
> +}
> +
> +static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
> +        {
> +                .callback = check_mmconf,
> +                .ident = "Apple",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Apple"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacPro2"),
> +                },
> +        },
> +        {}
> +};
> +
> +void __init check_mmconf_dmi(void)
> +{
> +        dmi_check_system(mmconf_dmi_table);
> +}
> +
>  static void __init __pci_mmcfg_init(int early)
>  {
>  	/* MMCONFIG disabled */
> @@ -395,6 +429,7 @@ static void __init __pci_mmcfg_init(int
>  
>  	if (!known_bridge) {
>  		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
> +		check_mmconf_dmi();
>  		pci_mmcfg_reject_broken(early);
>  	}
>  

