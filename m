Return-Path: <linux-kernel-owner+w=401wt.eu-S932276Ab0ANRC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0ANRC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255Ab0ANRCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:02:24 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56294 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0ANRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:02:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=MJNVgep5uKDn8LEV8Lt0zYi7StYgxwaLA51I5xgxbEXOEYLr5Xtf0j3yMk6TdFIZ/F
         bhhiFfbyh9ZtXkpCohKx42wACQ0l7uE4TwsAsXbs7RGtpZepzx5sSoVSb7qToBNK6lFN
         V0dpfarbVDK03Bf+uWx9BF29vMe+Ip2dVhkuE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: SATA_SIL on IXP425 workaround
Date: Thu, 14 Jan 2010 16:59:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <m33a4nfvva.fsf@intrepid.localdomain>
In-Reply-To: <m33a4nfvva.fsf@intrepid.localdomain>
MIME-Version: 1.0
Message-Id: <201001141659.19687.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009 06:31:21 pm Krzysztof Halasa wrote:
> I'm trying to add a workaround for IXP4xx CPUs to SATA SIL driver. The
> problem is that IXP4xx CPUs (Intel's XScale (ARM) network-oriented
> processors) are unable to perform 8 and 16-bit read from PCI MMIO, they
> can only do a full 32-bit readl(); SIL chips respond to that with PCI
> abort. The workaround is to use 8 and 16-bit regular IO reads (inb/inw)
> instead (MMIO write is not a problem).
> 
> For SIL3x12 the workaround is simple (attached) and it works on my 3512.
> I'm not sure about 3114 (the 4-port chip) - the PIO BARs have TF, CTL
> and BWDMA registers which are common to channels 0 and 2, and (the other
> set) to channels 1 and 3. Channel selection is done with bit 4 of
> device/head TF register, this is similar (same?) as PATA master/slave.
> Does that mean that I can simply treat channel 0 as PRI master, ch#2 as
> PRI slave, ch#1 as SEC master and ch#3 as SEC slave, and the SFF code
> will select the right device correctly? Does it need additional code?
> I don't have anything based on 3114.
> 
> Note: the large PRD is not a problem here, the transfer can be started
> by MMIO write. Only reads are an issue.

FWIW your patch is now in my atang tree (I'm aware that Jeff is working
on generic solution but in the meantime this non-intrusive patch allows
sata_sil to work on IXP425).

> --- a/drivers/ata/sata_sil.c
> +++ b/drivers/ata/sata_sil.c
> @@ -757,7 +757,12 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc)
>  		return rc;
>  
> +#ifdef CONFIG_ARCH_IXP4XX
> +	/* We need all 6 regions on IXP4xx */
> +	rc = pcim_iomap_regions(pdev, 0x3F, DRV_NAME);
> +#else
>  	rc = pcim_iomap_regions(pdev, 1 << SIL_MMIO_BAR, DRV_NAME);
> +#endif
>  	if (rc == -EBUSY)
>  		pcim_pin_device(pdev);
>  	if (rc)
> @@ -777,10 +782,18 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		struct ata_port *ap = host->ports[i];
>  		struct ata_ioports *ioaddr = &ap->ioaddr;
>  
> +#ifdef CONFIG_ARCH_IXP4XX
> +		/* IXP4xx CPUs can't perform 8 and 16-bit MMIO reads,
> +		   use normal IO from/to regions 0-5 instead */
> +		ioaddr->cmd_addr = host->iomap[i * 2];
> +		ioaddr->altstatus_addr = host->iomap[1 + i * 2] + 2;
> +		ioaddr->bmdma_addr = host->iomap[4] + sil_port[i].bmdma;
> +#else
>  		ioaddr->cmd_addr = mmio_base + sil_port[i].tf;
> -		ioaddr->altstatus_addr =
> -		ioaddr->ctl_addr = mmio_base + sil_port[i].ctl;
> +		ioaddr->altstatus_addr = mmio_base + sil_port[i].ctl;
>  		ioaddr->bmdma_addr = mmio_base + sil_port[i].bmdma;
> +#endif
> +		ioaddr->ctl_addr = mmio_base + sil_port[i].ctl;
>  		ioaddr->scr_addr = mmio_base + sil_port[i].scr;
>  		ata_sff_std_ports(ioaddr);

--
Bartlomiej Zolnierkiewicz
