Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYBDUSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYBDUSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYBDUS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:18:26 -0500
Received: from usul.saidi.cx ([204.11.33.34]:41701 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755867AbYBDUSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:18:25 -0500
To: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH] mmc: Handle suspend/resume in Ricoh MMC disabler (resent
 refreshed)
MIME-Version: 1.0
Date: Mon, 4 Feb 2008 15:17:10 -0500
From: Philip Langdale <philipl@overt.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
In-Reply-To: <200802041925.39529.fseidel@suse.de>
References: <200802041925.39529.fseidel@suse.de>
Message-ID: <a6708194c3be1ccc3d0da18553ed7288@localhost>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 Feb 2008 19:25:38 +0100, Frank Seidel <fseidel@suse.de> wrote:
> From: Philip Langdale <philipl@overt.org>
> 
> As pci config space is reinitialised on suspend/resume cycle, the
> disabler needs to work its magic at resume time. For symmetry this
> change also explicitly enables the controller at suspend time but
> it's not strictly necessary.
> 
> Signed-off-by: Philip Langdale <philipl@overt.org>
> Signed-off-by: Frank Seidel <fseidel@suse.de>
> ---
>  drivers/mmc/host/ricoh_mmc.c |   97
> +++++++++++++++++++++++++++++++------------
>  1 file changed, 72 insertions(+), 25 deletions(-)
> 
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ b/drivers/mmc/host/ricoh_mmc.c
> @@ -41,6 +41,46 @@ static const struct pci_device_id pci_id
> 
>  MODULE_DEVICE_TABLE(pci, pci_ids);
> 
> +static int ricoh_mmc_disable(struct pci_dev *fw_dev)
> +{
> +	u8 write_enable;
> +	u8 disable;
> +
> +	pci_read_config_byte(fw_dev, 0xCB, &disable);
> +	if (disable & 0x02) {
> +		printk(KERN_INFO DRIVER_NAME
> +		       ": Controller already disabled. Nothing to do.\n");
> +		return -ENODEV;
> +	}
> +
> +	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> +	pci_write_config_byte(fw_dev, 0xCA, 0x57);
> +	pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
> +	pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +
> +	printk(KERN_INFO DRIVER_NAME
> +	       ": Controller is now disabled.\n");
> +
> +	return 0;
> +}
> +
> +static int ricoh_mmc_enable(struct pci_dev *fw_dev)
> +{
> +	u8 write_enable;
> +	u8 disable;
> +
> +	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> +	pci_read_config_byte(fw_dev, 0xCB, &disable);
> +	pci_write_config_byte(fw_dev, 0xCA, 0x57);
> +	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
> +	pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +
> +	printk(KERN_INFO DRIVER_NAME
> +	       ": Controller is now re-enabled.\n");
> +
> +	return 0;
> +}
> +
>  static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
>  				     const struct pci_device_id *ent)
>  {
> @@ -61,26 +101,12 @@ static int __devinit ricoh_mmc_probe(str
>  	while ((fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
> PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
>  		    pdev->bus == fw_dev->bus) {
> -			u8 write_enable;
> -			u8 disable;
> -
> -			pci_read_config_byte(fw_dev, 0xCB, &disable);
> -			if (disable & 0x02) {
> -				printk(KERN_INFO DRIVER_NAME
> -				       ": Controller already disabled. Nothing to do.\n");
> +			if (ricoh_mmc_disable(fw_dev) != 0) {
>  				return -ENODEV;
>  			}
> 
> -			pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -			pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -			pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
> -			pci_write_config_byte(fw_dev, 0xCA, write_enable);
> -
>  			pci_set_drvdata(pdev, fw_dev);
> 
> -			printk(KERN_INFO DRIVER_NAME
> -			       ": Controller is now disabled.\n");
> -
>  			break;
>  		}
>  	}
> @@ -96,30 +122,51 @@ static int __devinit ricoh_mmc_probe(str
> 
>  static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
>  {
> -	u8 write_enable;
> -	u8 disable;
>  	struct pci_dev *fw_dev = NULL;
> 
>  	fw_dev = pci_get_drvdata(pdev);
>  	BUG_ON(fw_dev == NULL);
> 
> -	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -	pci_read_config_byte(fw_dev, 0xCB, &disable);
> -	pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
> -	pci_write_config_byte(fw_dev, 0xCA, write_enable);
> -
> -	printk(KERN_INFO DRIVER_NAME
> -	       ": Controller is now re-enabled.\n");
> +	ricoh_mmc_enable(fw_dev);
> 
>  	pci_set_drvdata(pdev, NULL);
>  }
> 
> +static int ricoh_mmc_suspend (struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct pci_dev *fw_dev = NULL;
> +
> +	fw_dev = pci_get_drvdata(pdev);
> +	BUG_ON(fw_dev == NULL);
> +
> +	printk(KERN_INFO DRIVER_NAME ": Suspending.\n");
> +
> +	ricoh_mmc_enable(fw_dev);
> +
> +	return 0;
> +}
> +
> +static int ricoh_mmc_resume (struct pci_dev *pdev)
> +{
> +	struct pci_dev *fw_dev = NULL;
> +
> +	fw_dev = pci_get_drvdata(pdev);
> +	BUG_ON(fw_dev == NULL);
> +
> +	printk(KERN_INFO DRIVER_NAME ": Resuming.\n");
> +
> +	ricoh_mmc_disable(fw_dev);
> +
> +	return 0;
> +}
> +
>  static struct pci_driver ricoh_mmc_driver = {
>  	.name = 	DRIVER_NAME,
>  	.id_table =	pci_ids,
>  	.probe = 	ricoh_mmc_probe,
>  	.remove =	__devexit_p(ricoh_mmc_remove),
> +	.suspend =	ricoh_mmc_suspend,
> +	.resume =	ricoh_mmc_resume,
>  };
> 
> 
>
/*****************************************************************************\

ACK.

Thanks for fixing it up.

--phil

