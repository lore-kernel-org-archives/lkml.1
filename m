Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYBDUTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYBDUTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbYBDUTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:19:15 -0500
Received: from usul.saidi.cx ([204.11.33.34]:41713 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757030AbYBDUTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:19:14 -0500
To: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH v2] mmc: extend =?UTF-8?Q?ricoh=5Fmmc=20to=20support=20Ricoh?=
 =?UTF-8?Q?=20RL=35c=34=37=36?=
MIME-Version: 1.0
Date: Mon, 4 Feb 2008 15:18:03 -0500
From: Philip Langdale <philipl@overt.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
In-Reply-To: <200802041925.43081.fseidel@suse.de>
References: <200802041925.43081.fseidel@suse.de>
Message-ID: <9ce88d6b23a91fe7cd32e8d56c9212fa@localhost>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 Feb 2008 19:25:42 +0100, Frank Seidel <fseidel@suse.de> wrote:
> From: Frank Seidel <fseidel@suse.de>
> 
> This patch (base on current linus git tree plus Philip Langdales
> suspend/resume patch) adds support for the Ricoh RL5c476 chip:
> with this the mmc adapter that needs this disabler (R5C843) can
> also be handled correctly when it sits on a RL5c476.
> (+ minor style changes (removed spaces between function names
> and open parenthesis .. checkpatch warned from previos patch))
> 
> Signed-off-by: Frank Seidel <fseidel@suse.de>
> ---
>  drivers/mmc/host/ricoh_mmc.c |  101
> ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 80 insertions(+), 21 deletions(-)
> 
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ b/drivers/mmc/host/ricoh_mmc.c
> @@ -44,19 +44,43 @@ MODULE_DEVICE_TABLE(pci, pci_ids);
>  static int ricoh_mmc_disable(struct pci_dev *fw_dev)
>  {
>  	u8 write_enable;
> +	u8 write_target;
>  	u8 disable;
> 
> -	pci_read_config_byte(fw_dev, 0xCB, &disable);
> -	if (disable & 0x02) {
> -		printk(KERN_INFO DRIVER_NAME
> -		       ": Controller already disabled. Nothing to do.\n");
> -		return -ENODEV;
> -	}
> +	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
> +		/* via RL5C476 */
> +
> +		pci_read_config_byte(fw_dev, 0xB7, &disable);
> +		if (disable & 0x02) {
> +			printk(KERN_INFO DRIVER_NAME
> +				": Controller already disabled. " \
> +				"Nothing to do.\n");
> +			return -ENODEV;
> +		}
> +
> +		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
> +		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
> +		pci_read_config_byte(fw_dev, 0x8D, &write_target);
> +		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
> +		pci_write_config_byte(fw_dev, 0xB7, disable | 0x02);
> +		pci_write_config_byte(fw_dev, 0x8E, write_enable);
> +		pci_write_config_byte(fw_dev, 0x8D, write_target);
> +	} else {
> +		/* via R5C832 */
> +
> +		pci_read_config_byte(fw_dev, 0xCB, &disable);
> +		if (disable & 0x02) {
> +			printk(KERN_INFO DRIVER_NAME
> +			       ": Controller already disabled. " \
> +				"Nothing to do.\n");
> +			return -ENODEV;
> +		}
> 
> -	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -	pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -	pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
> -	pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> +		pci_write_config_byte(fw_dev, 0xCA, 0x57);
> +		pci_write_config_byte(fw_dev, 0xCB, disable | 0x02);
> +		pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +	}
> 
>  	printk(KERN_INFO DRIVER_NAME
>  	       ": Controller is now disabled.\n");
> @@ -67,13 +91,29 @@ static int ricoh_mmc_disable(struct pci_
>  static int ricoh_mmc_enable(struct pci_dev *fw_dev)
>  {
>  	u8 write_enable;
> +	u8 write_target;
>  	u8 disable;
> 
> -	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -	pci_read_config_byte(fw_dev, 0xCB, &disable);
> -	pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
> -	pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
> +		/* via RL5C476 */
> +
> +		pci_read_config_byte(fw_dev, 0x8E, &write_enable);
> +		pci_write_config_byte(fw_dev, 0x8E, 0xAA);
> +		pci_read_config_byte(fw_dev, 0x8D, &write_target);
> +		pci_write_config_byte(fw_dev, 0x8D, 0xB7);
> +		pci_read_config_byte(fw_dev, 0xB7, &disable);
> +		pci_write_config_byte(fw_dev, 0xB7, disable & ~0x02);
> +		pci_write_config_byte(fw_dev, 0x8E, write_enable);
> +		pci_write_config_byte(fw_dev, 0x8D, write_target);
> +	} else {
> +		/* via R5C832 */
> +
> +		pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> +		pci_read_config_byte(fw_dev, 0xCB, &disable);
> +		pci_write_config_byte(fw_dev, 0xCA, 0x57);
> +		pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
> +		pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +	}
> 
>  	printk(KERN_INFO DRIVER_NAME
>  	       ": Controller is now re-enabled.\n");
> @@ -85,6 +125,7 @@ static int __devinit ricoh_mmc_probe(str
>  				     const struct pci_device_id *ent)
>  {
>  	u8 rev;
> +	u8 ctrlfound = 0;
> 
>  	struct pci_dev *fw_dev = NULL;
> 
> @@ -98,20 +139,38 @@ static int __devinit ricoh_mmc_probe(str
>  		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
>  		(int)rev);
> 
> -	while ((fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
> PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
> +	while ((fw_dev =
> +		pci_get_device(PCI_VENDOR_ID_RICOH,
> +			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
>  		    pdev->bus == fw_dev->bus) {
> -			if (ricoh_mmc_disable(fw_dev) != 0) {
> +			if (ricoh_mmc_disable(fw_dev) != 0)
>  				return -ENODEV;
> -			}
> 
>  			pci_set_drvdata(pdev, fw_dev);
> 
> +			++ctrlfound;
>  			break;
>  		}
>  	}
> 
> -	if (pci_get_drvdata(pdev) == NULL) {
> +	fw_dev = NULL;
> +
> +	while (!ctrlfound &&
> +	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
> +					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
> +		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
> +		    pdev->bus == fw_dev->bus) {
> +			if (ricoh_mmc_disable(fw_dev) != 0)
> +				return -ENODEV;
> +
> +			pci_set_drvdata(pdev, fw_dev);
> +
> +			++ctrlfound;
> +		}
> +	}
> +
> +	if (!ctrlfound) {
>  		printk(KERN_WARNING DRIVER_NAME
>  		       ": Main firewire function not found. Cannot disable
> controller.\n");
>  		return -ENODEV;
> @@ -132,7 +191,7 @@ static void __devexit ricoh_mmc_remove(s
>  	pci_set_drvdata(pdev, NULL);
>  }
> 
> -static int ricoh_mmc_suspend (struct pci_dev *pdev, pm_message_t state)
> +static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	struct pci_dev *fw_dev = NULL;
> 
> @@ -146,7 +205,7 @@ static int ricoh_mmc_suspend (struct pci
>  	return 0;
>  }
> 
> -static int ricoh_mmc_resume (struct pci_dev *pdev)
> +static int ricoh_mmc_resume(struct pci_dev *pdev)
>  {
>  	struct pci_dev *fw_dev = NULL;

ACK.

Hopefully Pierre will re-emerge soon to accept this into his tree.

--phil

