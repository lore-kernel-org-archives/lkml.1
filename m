Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXIXV02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXIXV02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbXIXV0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:26:19 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:3786 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbXIXV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:26:18 -0400
Message-ID: <46F82BCF.1020702@genesi-usa.com>
Date: Mon, 24 Sep 2007 22:27:43 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: IDE broken on Pegasos PPC platform
References: <46F80BB1.7050902@redhat.com>
In-Reply-To: <46F80BB1.7050902@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah I'll ack it if it matters, although I'd make a nit about the
fixing of device tree entries in prom_init and have it moved to
nvramrc or a Forth script or boot loader..

Pegasos IDE quirks have been "fixed" so many times now in Linux,
this code's going to get reshuffled again in other changes, I
think the device tree should be fixed at the firmware level and
not in the kernel.

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations

Chuck Ebbert wrote:
> Without this patch, taken from a Suse 2.6.22 kernel, the Pegasos
> PPC machines can't use their IDE interface. Is this the right fix?
> 
> Bug:
> https://bugzilla.redhat.com/show_bug.cgi?id=247602
> Patch (also below):
> https://bugzilla.redhat.com/attachment.cgi?id=167747
> 
> ===============
> 
> The built-in IDE controller is configured in legacy mode,
> but the PCI registers advertise native mode.
> Force the PCI class into legacy mode. This allows pata_via to access
> two drives.
> The Pegasos specific irq enforcement in the via82cxxx driver
> must stay because there is aparently no generic way to setup irq per channel.
> 
> Tested on Pegasos2 with firmware version 20040810, and two IDE disks.
> 
> ---
>  arch/powerpc/kernel/prom_init.c   |   11 ++++++++---
>  arch/powerpc/platforms/chrp/pci.c |   29 +++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 3 deletions(-)
> 
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -2044,6 +2044,7 @@ static void __init fixup_device_tree_map
>  /*
>   * Pegasos and BriQ lacks the "ranges" property in the isa node
>   * Pegasos needs decimal IRQ 14/15, not hexadecimal
> + * Pegasos has the IDE configured in legacy mode, but advertised as native
>   */
>  static void __init fixup_device_tree_chrp(void)
>  {
> @@ -2081,9 +2082,13 @@ static void __init fixup_device_tree_chr
>  		prom_printf("Fixing up IDE interrupt on Pegasos...\n");
>  		prop[0] = 14;
>  		prop[1] = 0x0;
> -		prop[2] = 15;
> -		prop[3] = 0x0;
> -		prom_setprop(ph, name, "interrupts", prop, 4*sizeof(u32));
> +		prom_setprop(ph, name, "interrupts", prop, 2*sizeof(u32));
> +		prom_printf("Fixing up IDE class-code on Pegasos...\n");
> +		rc = prom_getprop(ph, "class-code", prop, sizeof(u32));
> +		if (rc == sizeof(u32)) {
> +			prop[0] &= ~0x5;
> +			prom_setprop(ph, name, "class-code", prop, sizeof(u32));
> +		}
>  	}
>  }
>  #else
> --- a/arch/powerpc/platforms/chrp/pci.c
> +++ b/arch/powerpc/platforms/chrp/pci.c
> @@ -338,3 +338,32 @@ void chrp_pci_fixup_winbond_ata(struct p
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_82C105,
>  		chrp_pci_fixup_winbond_ata);
> +
> +/* Pegasos2 firmware version 20040810 configures the built-in IDE controller
> + * in legacy mode, but sets the PCI registers to PCI native mode.
> + * The chip can only operate in legacy mode, so force the PCI class into legacy
> + * mode as well. The same fixup must be done to the class-code property in
> + * the IDE node /pci@80000000/ide@C,1
> + */
> +static void chrp_pci_fixup_vt8231_ata(struct pci_dev *viaide)
> +{
> +	u8 progif;
> +	struct pci_dev *viaisa;
> +
> +	if (!machine_is(chrp) || _chrp_type != _CHRP_Pegasos)
> +		return;
> +	if (viaide->irq != 14)
> +		return;
> +
> +	viaisa = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8231, NULL);
> +	if (!viaisa)
> +		return;
> +	printk("Fixing VIA IDE, force legacy mode on '%s'\n", viaide->dev.bus_id);
> +
> +	pci_read_config_byte(viaide, PCI_CLASS_PROG, &progif);
> +	pci_write_config_byte(viaide, PCI_CLASS_PROG, progif & ~0x5);
> +	viaide->class &= ~0x5;
> +
> +	pci_dev_put(viaisa);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, chrp_pci_fixup_vt8231_ata);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
