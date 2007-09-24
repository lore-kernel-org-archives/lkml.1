Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbXIXUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbXIXUzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXIXUzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:55:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:42039 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXIXUzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q5PeXnjwmjzQ9TilGDBELN4ASAqfn8ZpUHuZ5C47hoTgYtvhEEmnIzoCj8GLF0zajuhhFd2jFFZgD66WYdC9MBWImsE9KIKgbnW1YOMni/iZP/Z/W4xA+VcL5aRTQJ9DT55QIrwQXGMXxyUwOC6omXGvI4sqwd1YRckvDxkz5iE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: libata broken on Pegasos PPC platform (was: Re: IDE broken on Pegasos PPC platform)
Date: Mon, 24 Sep 2007 22:58:28 +0200
User-Agent: KMail/1.9.6
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Olaf Hering <olaf@aepfle.de>
References: <46F80BB1.7050902@redhat.com>
In-Reply-To: <46F80BB1.7050902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709242258.28497.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007, Chuck Ebbert wrote:
> Without this patch, taken from a Suse 2.6.22 kernel, the Pegasos
> PPC machines can't use their IDE interface. Is this the right fix?

This or use IDE via82cxxx driver.

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

Somehow Signed-off-by got lost in this version of the patch....

IIRC the patch comes from Olaf Hering (added to cc:) and is the way to go

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

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
