Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZHEXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZHEXdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZHEXde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:33:34 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:41228 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZHEXdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oBytS4Cw4gUu/ceXuSxl9SsegRPEyeSDDxl9xFDuXPmzt/MlxIpwzq1GmRFp9yFJPL
         J6pSYscouHq1n6An2cL5DEVN+5MTnMVtdBDBz93XTIr7tibusJNbPG2ItQVQEnd81LG6
         N30w9TUMVqDoiX7ER1CnMv3ewipnyjaJwtnQg=
Message-ID: <4A7A16C9.6030500@gmail.com>
Date: Wed, 05 Aug 2009 17:33:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for sata_nv
References: <20090805192055.8F2DE1007C@gold.linx.net>
In-Reply-To: <20090805192055.8F2DE1007C@gold.linx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 01:20 PM, Tony Vroon wrote:
> The nVidia MCP55 SATA2 controller quite happily supports MSI.
> This adds an option to use it. It is disabled by default and
> will only be honoured on the specific controller I tested.
> This was suggested in 2007 back when the driver was less mature,
> perhaps now is a better time for it.

I'm not sure the conditional on MCP55 is necessary, I would be inclined 
to just try to enable it on any device if the option is specified. 
pci_enable_msi will just fail harmlessly if the device doesn't support 
MSI capability or the kernel detects MSI is not usable on the machine 
(which these days I think we should be able to do fairly accurately on 
HT chipsets..)

>
> Signed-off-by: Tony Vroon<tony@linx.net>
>
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index b2d11f3..5ec29c4 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -602,6 +602,7 @@ MODULE_VERSION(DRV_VERSION);
>
>   static int adma_enabled;
>   static int swncq_enabled = 1;
> +static int msi_enabled;
>
>   static void nv_adma_register_mode(struct ata_port *ap)
>   {
> @@ -2459,6 +2460,13 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	} else if (type == SWNCQ)
>   		nv_swncq_host_init(host);
>
> +	/* enable MSI if requested */
> +	if (pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2&&
> +		msi_enabled) {
> +		dev_printk(KERN_NOTICE,&pdev->dev, "Using MSI\n");
> +		pci_enable_msi(pdev);
> +	}
> +
>   	pci_set_master(pdev);
>   	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
>   				 IRQF_SHARED, ipriv->sht);
> @@ -2558,4 +2566,6 @@ module_param_named(adma, adma_enabled, bool, 0444);
>   MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: false)");
>   module_param_named(swncq, swncq_enabled, bool, 0444);
>   MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
> +module_param_named(msi, msi_enabled, bool, 0444);
> +MODULE_PARM_DESC(msi, "Enable use of MSI (Default: false)");
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

