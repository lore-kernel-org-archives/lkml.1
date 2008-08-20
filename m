Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYHTWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYHTWqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYHTWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:46:12 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44272 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbYHTWqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:46:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 2/2] fastboot: use a DMI match table to set defaults for port-disable
Date: Wed, 20 Aug 2008 16:46:06 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080811153542.61095e5c@infradead.org> <20080811153730.74599410@infradead.org>
In-Reply-To: <20080811153730.74599410@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201646.07159.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008 04:37:30 pm Arjan van de Ven wrote:
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] libata: use a DMI match table to set defaults for port-disable
> 
> As suggested by Jeff:
> This patch adds a DMI table that is used for setting defaults for
> the new dont-probe-port parameter boot time optimization feature.

Isn't this the sort of thing we theoretically could learn from ACPI?
I know we haven't really taken advantage of what ACPI tells us about
the presence of legacy devices like COM ports and IDE ports, but
maybe we should.

> +static int __init dmi_disable_ports(const struct dmi_system_id *d)
> +{
> +	int value = (unsigned long)d->driver_data;
> +
> +	printk(KERN_INFO "libata: DMI match used to disable probing\n");
> +	libata_disable_ports |= value;
> +	return 0;
> +}
> +
> +#define DMI_PORT_ATA1 (void *)0x1
> +#define DMI_PORT_ATA2 (void *)0x2
> +#define DMI_PORT_ATA3 (void *)0x4
> +#define DMI_PORT_ATA4 (void *)0x8
> +
> +static struct dmi_system_id libata_dmi_table[] __initdata = {
> +	/*
> +	 * The Asus EeePC901 has its devices attached to ATA2 only
> +	 */
> +	{
> +	.callback = dmi_disable_ports,
> +	.driver_data = DMI_PORT_ATA1,
> +	.ident = "Asus EeePC 901",
> +	.matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "901"),
> +		},
> +	},
> +	{}
> +};
> +
> +
>  /**
>   *	ata_force_cbl - force cable type according to libata.force
>   *	@ap: ATA port of interest
> @@ -6126,6 +6158,7 @@ static void __init ata_parse_force_param(void)
>  static int __init ata_init(void)
>  {
>  	ata_parse_force_param();
> +	dmi_check_system(libata_dmi_table);
>  
>  	ata_wq = create_workqueue("ata");
>  	if (!ata_wq)


