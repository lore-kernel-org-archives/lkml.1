Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXJYUHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXJYUHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXJYUGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:06:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46806 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbXJYUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gEqHuHT0y8QwkIUnEV8FF4TgcPCC7lFy/o50DE+3NmxWbU9tt8CMp7IVVUX0m8nnDgnIWuxLzlc6Yw+KTAmEQo/9aOKLbcWwwI0KNjLtf1rf8IW50N3XZWruCThj5qr8ZMxtRDujGCSsWv7XMc5ONC+poqqKJPmiHShkPRBBiT4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/3] [IDE] Add helper __ide_setup_pci_device()
Date: Thu, 25 Oct 2007 21:33:20 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       akpm@linux-foundation.org
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234820.D91351F81A1@havoc.gtf.org>
In-Reply-To: <20071024234820.D91351F81A1@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252133.20992.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ The last few days were extra busy with pushing previously queued
  IDE bits upstream but I'm back to reviewing the new stuff. ]

Thanks for splitting your patch on smaller chunks.

On Thursday 25 October 2007, Jeff Garzik wrote:
> Like ide_setup_pci_device(), except with additional array argument
> 'u8 *idx' that permits low-level driver to become aware of its assigned
> hwifs.

I would prefer to avoid exporting this information to host drivers
if possible (they shouldn't need to know about higher-layer decisions,
plus this change opens the door for various "creative" abuses).

In case of sc1200 host driver fixes (patches #2-3/3) it should be
possible to remove the need for the below patch and at the same time
simplify sc1200 code further (more details in review of patch #2/2).

> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/ide/setup-pci.c |   17 ++++++++++++-----
>  include/linux/ide.h     |    1 +
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
> index 02d14bf..4960b9f 100644
> --- a/drivers/ide/setup-pci.c
> +++ b/drivers/ide/setup-pci.c
> @@ -666,12 +666,10 @@ out:
>  	return ret;
>  }
>  
> -int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
> +int __ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d,
> +			   u8 *idx)
>  {
> -	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
> -	int ret;
> -
> -	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
> +	int ret = do_ide_setup_pci_device(dev, d, idx, 1);
>  
>  	if (ret >= 0)
>  		ide_device_add(idx);
> @@ -679,6 +677,15 @@ int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
>  	return ret;
>  }
>  
> +EXPORT_SYMBOL_GPL(__ide_setup_pci_device);
> +
> +int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
> +{
> +	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
> +
> +	return __ide_setup_pci_device(dev, d, &idx[0]);
> +}
> +
>  EXPORT_SYMBOL_GPL(ide_setup_pci_device);
>  
>  int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index 4ed4777..3404fb9 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1244,6 +1244,7 @@ struct ide_port_info {
>  	u8			udma_mask;
>  };
>  
> +int __ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *, u8 *);
>  int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
>  int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);

