Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbXG0IVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbXG0IVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbXG0IV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:21:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:34294 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbXG0IVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:21:25 -0400
In-Reply-To: <11854393763547-git-send-email-wei.zhang@freescale.com>
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com> <11854393741899-git-send-email-wei.zhang@freescale.com> <11854393753986-git-send-email-wei.zhang@freescale.com> <11854393763547-git-send-email-wei.zhang@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <FFA9FE6D-81C8-429C-A0CD-FE356CF98C69@kernel.crashing.org>
Cc: mporter@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 4/5 v3] Add RapidIO support to powerpc architecture.
Date: Fri, 27 Jul 2007 03:22:11 -0500
To: Zhang Wei <wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26, 2007, at 3:42 AM, Zhang Wei wrote:

> This patch adds the RapidIO support to the powerpc architecture.
> Some files are moved from ppc. OF-tree and OF-device supports are  
> added.
> New silicons such as MPC8548, MPC8641 with serial RapidIO  
> controller are
> all supported.
> Memory driver hardware operations are added.
> Global mport variables are changed to master port private variables.
> Multi master ports are supported.
>
> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> ---
>  arch/powerpc/Kconfig          |    8 +
>  arch/powerpc/kernel/Makefile  |    1 +
>  arch/powerpc/kernel/rio.c     |   64 ++
>  arch/powerpc/sysdev/Makefile  |    1 +
>  arch/powerpc/sysdev/fsl_rio.c | 1455 ++++++++++++++++++++++++++++++ 
> +++++++++++

how much of this moved from ppc85xx_rio.c?

>  arch/powerpc/sysdev/fsl_rio.h |   20 +
>  6 files changed, 1549 insertions(+), 0 deletions(-)
>  create mode 100644 arch/powerpc/kernel/rio.c
>  create mode 100644 arch/powerpc/sysdev/fsl_rio.c
>  create mode 100644 arch/powerpc/sysdev/fsl_rio.h
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 00099ef..45f32f1 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -492,6 +492,14 @@ source "drivers/pci/Kconfig"
>
>  source "drivers/pcmcia/Kconfig"
>
> +config RAPIDIO
> +	bool "RapidIO support" if MPC8540 || MPC8560 || MPC8641 || MPC8548
> +	help
> +	  If you say Y here, the kernel will include drivers and
> +	  infrastructure code to support RapidIO interconnect devices.

why not make this depend on something like HAS_RAPIDIO and let the  
boards select HAS_RAPIDIO if they have it

> +
> +source "drivers/rapidio/Kconfig"
> +
>  source "drivers/pci/hotplug/Kconfig"
>
>  endmenu
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/ 
> Makefile
> index 42c42ec..02d4100 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -70,6 +70,7 @@ pci64-$(CONFIG_PPC64)		+= pci_64.o pci_dn.o isa- 
> bridge.o
>  pci32-$(CONFIG_PPC32)		:= pci_32.o
>  obj-$(CONFIG_PCI)		+= $(pci64-y) $(pci32-y) pci-common.o
>  obj-$(CONFIG_PCI_MSI)		+= msi.o
> +obj-$(CONFIG_RAPIDIO)		+= rio.o

should probably live in sysdev/rio.c

>  kexec-$(CONFIG_PPC64)		:= machine_kexec_64.o
>  kexec-$(CONFIG_PPC32)		:= machine_kexec_32.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o crash.o $(kexec-y)
> diff --git a/arch/powerpc/kernel/rio.c b/arch/powerpc/kernel/rio.c
> new file mode 100644
> index 0000000..8d41e93
> --- /dev/null
> +++ b/arch/powerpc/kernel/rio.c
> @@ -0,0 +1,64 @@
> +/*
> + * RapidIO PowerPC support
> + *
> + * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights  
> reserved.
> + * Zhang Wei <wei.zhang@freescale.com>, Jun 2007
> + *
> + * This program is free software; you can redistribute  it and/or  
> modify it
> + * under  the terms of  the GNU General  Public License as  
> published by the
> + * Free Software Foundation;  either version 2 of the  License, or  
> (at your
> + * option) any later version.
> + *
> + * New RapidIO peer-to-peer network initialize with of-device  
> supoort.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/rio.h>
> +
> +#include <asm/rio.h>
> +#include <asm/of_device.h>
> +#include <asm/of_platform.h>
> +
> +#include <../sysdev/fsl_rio.h>
> +
> +
> +/* The probe function for RapidIO peer-to-peer network.
> + */
> +static int __devinit of_rio_rpn_probe(struct of_device *dev,
> +				     const struct of_device_id *match)
> +{
> +	int rc;
> +	printk(KERN_INFO "Setting up RapidIO peer-to-peer network %s\n",
> +			dev->node->full_name);
> +
> +	rc = fsl_rio_setup(dev);
> +	if (rc)
> +		goto out;
> +
> +	/* Enumerate all registered ports */
> +	rc = rio_init_mports();
> +out:
> +	return rc;
> +};
> +
> +static struct of_device_id of_rio_rpn_ids[] = {
> +	{
> +		.compatible = "fsl,rapidio-delta",
> +	},
> +	{},
> +};
> +
> +static struct of_platform_driver of_rio_rpn_driver = {
> +	.name = "of-rio",
> +	.match_table = of_rio_rpn_ids,
> +	.probe = of_rio_rpn_probe,
> +};
> +
> +static __init int of_rio_rpn_init(void)
> +{
> +	return of_register_platform_driver(&of_rio_rpn_driver);
> +}
