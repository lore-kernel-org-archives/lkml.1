Return-Path: <linux-kernel-owner+w=401wt.eu-S1767341AbXCIQIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767341AbXCIQIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767340AbXCIQIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:08:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57319 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767339AbXCIQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:08:12 -0500
Message-ID: <45F18669.5070400@garzik.org>
Date: Fri, 09 Mar 2007 11:08:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.22] remove Intel combined mode quirk
References: <20070309160127.GA10226@havoc.gtf.org>
In-Reply-To: <20070309160127.GA10226@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 066689c..0a19466 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -779,40 +779,16 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
>  		/* Deal with combined mode hack. This side of the logic all
>  		   goes away once the combined mode hack is killed in 2.6.21 */
>  		if (!devm_request_region(dev, ATA_PRIMARY_CMD, 8, "libata")) {
> -			struct resource *conflict, res;
> -			res.start = ATA_PRIMARY_CMD;
> -			res.end = ATA_PRIMARY_CMD + 8 - 1;
> -			conflict = ____request_resource(&ioport_resource, &res);
> -			while (conflict->child)
> -				conflict = ____request_resource(conflict, &res);
> -			if (!strcmp(conflict->name, "libata"))
> -				legacy_mode |= ATA_PORT_PRIMARY;
> -			else {
> -				pcim_pin_device(pdev);
> -				printk(KERN_WARNING "ata: 0x%0X IDE port busy\n" \
> -						    "ata: conflict with %s\n",
> -						    ATA_PRIMARY_CMD,
> -						    conflict->name);
> -			}
> +			pcim_pin_device(pdev);
> +			printk(KERN_WARNING "ata: 0x%0X IDE port busy\n",
> +					    ATA_PRIMARY_CMD);
>  		} else
>  			legacy_mode |= ATA_PORT_PRIMARY;
>  
>  		if (!devm_request_region(dev, ATA_SECONDARY_CMD, 8, "libata")) {
> -			struct resource *conflict, res;
> -			res.start = ATA_SECONDARY_CMD;
> -			res.end = ATA_SECONDARY_CMD + 8 - 1;
> -			conflict = ____request_resource(&ioport_resource, &res);
> -			while (conflict->child)
> -				conflict = ____request_resource(conflict, &res);
> -			if (!strcmp(conflict->name, "libata"))
> -				legacy_mode |= ATA_PORT_SECONDARY;
> -			else {
> -				pcim_pin_device(pdev);
> -				printk(KERN_WARNING "ata: 0x%X IDE port busy\n" \
> -						    "ata: conflict with %s\n",
> -						    ATA_SECONDARY_CMD,
> -						    conflict->name);
> -			}
> +			pcim_pin_device(pdev);
> +			printk(KERN_WARNING "ata: 0x%X IDE port busy\n",
> +					    ATA_SECONDARY_CMD);
>  		} else
>  			legacy_mode |= ATA_PORT_SECONDARY;

I presume this will lend itself to further devres cleanups, now that 
this code is gone.  I just did the main change.

This will also affect the new init model stuff just posted.

