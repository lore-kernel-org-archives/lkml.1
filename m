Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYGXRKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYGXRKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYGXRK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:10:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYGXRK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:10:28 -0400
Date: Thu, 24 Jul 2008 09:54:12 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH PROPOSAL] libata/pci: Move D3 hack handling from libata
	into PCI
Message-ID: <20080724165412.GB6950@kroah.com>
References: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 05:18:38PM +0100, Alan Cox wrote:
> Libata has some hacks to deal with certain controllers going silly in D3
> state. The right way to handle this is to keep a PCI device flag for such
> devices. That can then be generalised for no ATA devices with power
> problems.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

No objection from me at all, but the current PCI maintainer might want
to also look at it :)

(added Jesse to the CC: with the full patch below.)

thanks,

greg k-h

> 
> diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
> index fbe6057..c5f91e6 100644
> --- a/drivers/ata/pata_acpi.c
> +++ b/drivers/ata/pata_acpi.c
> @@ -259,12 +259,6 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
>  		.port_ops	= &pacpi_ops,
>  	};
>  	const struct ata_port_info *ppi[] = { &info, NULL };
> -	if (pdev->vendor == PCI_VENDOR_ID_ATI) {
> -		int rc = pcim_enable_device(pdev);
> -		if (rc < 0)
> -			return rc;
> -		pcim_pin_device(pdev);
> -	}
>  	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
>  }
>  
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index d00f0e0..1f70a9e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -572,6 +572,10 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  		if (!ret)
>  			pci_update_current_state(dev);
>  	}
> +	/* This device is quirked not to be put into D3, so
> +	   don't put it in D3 */
> +	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
> +		return 0;
>  
>  	error = pci_raw_set_power_state(dev, state);
>  
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 12d4893..11cc96d 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -908,7 +908,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB
>  /*
>   *	Intel 82801CAM ICH3-M datasheet says IDE modes must be the same
>   */
> -static void __init quirk_ide_samemode(struct pci_dev *pdev)
> +static void __devinit quirk_ide_samemode(struct pci_dev *pdev)
>  {
>  	u8 prog;
>  
> @@ -923,6 +923,19 @@ static void __init quirk_ide_samemode(struct pci_dev *pdev)
>  }
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_10, quirk_ide_samemode);
>  
> +/*
> + * Some ATA devices break if put into D3
> + */
> +
> +static void __devinit quirk_no_ata_d3(struct pci_dev *pdev)
> +{
> +	/* Quirk the legacy ATA devices only. The AHCI ones are ok */
> +	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
> +		pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_ANY_ID, quirk_no_ata_d3);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, PCI_ANY_ID, quirk_no_ata_d3);
> +
>  /* This was originally an Alpha specific thing, but it really fits here.
>   * The i82375 PCI/EISA bridge appears as non-classified. Fix that.
>   */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index a6a088e..02ebeb5 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -124,6 +124,8 @@ enum pci_dev_flags {
>  	 * generation too.
>  	 */
>  	PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG = (__force pci_dev_flags_t) 1,
> +	/* Device configuration is irrevocably lost if disabled into D3 */
> +	PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) 2,
>  };
>  
>  typedef unsigned short __bitwise pci_bus_flags_t;
