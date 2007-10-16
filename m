Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbXJPQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbXJPQAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934185AbXJPQAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:00:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55124 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbXJPQAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:00:32 -0400
Date: Tue, 16 Oct 2007 16:55:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 2)
Message-ID: <20071016155507.GB32551@flint.arm.linux.org.uk>
References: <200710131825.24768.bzolnier@gmail.com> <20071014001238.GP8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014001238.GP8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 01:12:39AM +0100, Al Viro wrote:
> Proposed addition to icside part, provided that ARM folks ACK it - gets
> icside to build and AFAICS it's correct:

Booted and tested as working.

Whatever-tag-that-is: Russell King <rmk+kernel@arm.linux.org.uk>

> diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
> index be30923..842fe08 100644
> --- a/drivers/ata/pata_icside.c
> +++ b/drivers/ata/pata_icside.c
> @@ -332,12 +332,13 @@ static void ata_dummy_noret(struct ata_port *port)
>  {
>  }
>  
> -static void pata_icside_postreset(struct ata_port *ap, unsigned int *classes)
> +static void pata_icside_postreset(struct ata_link *link, unsigned int *classes)
>  {
> +	struct ata_port *ap = link->ap;
>  	struct pata_icside_state *state = ap->host->private_data;
>  
>  	if (classes[0] != ATA_DEV_NONE || classes[1] != ATA_DEV_NONE)
> -		return ata_std_postreset(ap, classes);
> +		return ata_std_postreset(link, classes);
>  
>  	state->port[ap->port_no].disabled = 1;
>  
> @@ -395,29 +396,30 @@ static struct ata_port_operations pata_icside_port_ops = {
>  
>  static void __devinit
>  pata_icside_setup_ioaddr(struct ata_port *ap, void __iomem *base,
> -			 const struct portinfo *info)
> +			 struct pata_icside_info *info,
> +			 const struct portinfo *port)
>  {
>  	struct ata_ioports *ioaddr = &ap->ioaddr;
> -	void __iomem *cmd = base + info->dataoffset;
> +	void __iomem *cmd = base + port->dataoffset;
>  
>  	ioaddr->cmd_addr	= cmd;
> -	ioaddr->data_addr	= cmd + (ATA_REG_DATA    << info->stepping);
> -	ioaddr->error_addr	= cmd + (ATA_REG_ERR     << info->stepping);
> -	ioaddr->feature_addr	= cmd + (ATA_REG_FEATURE << info->stepping);
> -	ioaddr->nsect_addr	= cmd + (ATA_REG_NSECT   << info->stepping);
> -	ioaddr->lbal_addr	= cmd + (ATA_REG_LBAL    << info->stepping);
> -	ioaddr->lbam_addr	= cmd + (ATA_REG_LBAM    << info->stepping);
> -	ioaddr->lbah_addr	= cmd + (ATA_REG_LBAH    << info->stepping);
> -	ioaddr->device_addr	= cmd + (ATA_REG_DEVICE  << info->stepping);
> -	ioaddr->status_addr	= cmd + (ATA_REG_STATUS  << info->stepping);
> -	ioaddr->command_addr	= cmd + (ATA_REG_CMD     << info->stepping);
> -
> -	ioaddr->ctl_addr	= base + info->ctrloffset;
> +	ioaddr->data_addr	= cmd + (ATA_REG_DATA    << port->stepping);
> +	ioaddr->error_addr	= cmd + (ATA_REG_ERR     << port->stepping);
> +	ioaddr->feature_addr	= cmd + (ATA_REG_FEATURE << port->stepping);
> +	ioaddr->nsect_addr	= cmd + (ATA_REG_NSECT   << port->stepping);
> +	ioaddr->lbal_addr	= cmd + (ATA_REG_LBAL    << port->stepping);
> +	ioaddr->lbam_addr	= cmd + (ATA_REG_LBAM    << port->stepping);
> +	ioaddr->lbah_addr	= cmd + (ATA_REG_LBAH    << port->stepping);
> +	ioaddr->device_addr	= cmd + (ATA_REG_DEVICE  << port->stepping);
> +	ioaddr->status_addr	= cmd + (ATA_REG_STATUS  << port->stepping);
> +	ioaddr->command_addr	= cmd + (ATA_REG_CMD     << port->stepping);
> +
> +	ioaddr->ctl_addr	= base + port->ctrloffset;
>  	ioaddr->altstatus_addr	= ioaddr->ctl_addr;
>  
>  	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx",
> -		      info->raw_base + info->dataoffset,
> -		      info->raw_base + info->ctrloffset);
> +		      info->raw_base + port->dataoffset,
> +		      info->raw_base + port->ctrloffset);
>  
>  	if (info->raw_ioc_base)
>  		ata_port_desc(ap, "iocbase 0x%lx", info->raw_ioc_base);
> @@ -441,7 +443,7 @@ static int __devinit pata_icside_register_v5(struct pata_icside_info *info)
>  	info->nr_ports = 1;
>  	info->port[0] = &pata_icside_portinfo_v5;
>  
> -	info->raw_base = ecard_resource_start(ec, ECARD_RES_MEMC);
> +	info->raw_base = ecard_resource_start(info->ec, ECARD_RES_MEMC);
>  
>  	return 0;
>  }
> @@ -522,7 +524,7 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
>  		ap->flags |= ATA_FLAG_SLAVE_POSS;
>  		ap->ops = &pata_icside_port_ops;
>  
> -		pata_icside_setup_ioaddr(ap, info->base, info->port[i]);
> +		pata_icside_setup_ioaddr(ap, info->base, info, info->port[i]);
>  	}
>  
>  	return ata_host_activate(host, ec->irq, ata_interrupt, 0,

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
