Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbYGRQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbYGRQu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYGRQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:50:15 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:58397 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755344AbYGRQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:50:14 -0400
Date: Fri, 18 Jul 2008 12:50:11 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080718165011.GA6296@bromo.msbb.uc.edu>
References: <200807180941.09779.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807180941.09779.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   Just filed a radar bug report with Apple as ID 6086072 entitled
"BIOS in MacBook Pro 1.5.1 update is buggy - reports too many buses".
Pointed them to the thread here and the messages with the patch,
the earlydump and 'lspci --vvxxxx' logs.
                   Jack


On Fri, Jul 18, 2008 at 09:41:09AM -0700, Yinghai Lu wrote:
> 
> change the mconf bus range from [0,0xff] to to [0, 0x3f]
> to match range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>
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
> +	{
> +		.callback = check_mmconf,
> +		.ident = "Apple",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Apple"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2"),
> +		},
> +	},
> +	{}
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
