Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYBBHRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYBBHRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYBBHRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:17:01 -0500
Received: from usul.saidi.cx ([204.11.33.34]:60200 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbYBBHRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:17:00 -0500
Message-ID: <47A418E0.6040205@overt.org>
Date: Fri, 01 Feb 2008 23:16:48 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [PATCH] mmc: extend ricoh_mmc to support Ricoh RL5c476
References: <200801311838.24743.fseidel@suse.de>
In-Reply-To: <200801311838.24743.fseidel@suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Seidel wrote:
> From: Frank Seidel <fseidel@suse.de>
> 
> This patch (based on current linus git tree) adds support for
> the Ricoh RL5c476 chip: with this the mmc adapter that needs this
> disabler (R5C843) can also be handled correctly when it sits
> on a RL5c476.

Again, thanks a lot for investigating and finding the appropriate magic
incantations. My main comment is to please base this on top of my suspend/resume
patch which Pierre said he accepted but which isn't in his tree yet - I guess
he's busy offline right now - haven't heard from him in a while.

> Signed-off-by: Frank Seidel <fseidel@suse.de>
> ---
>  drivers/mmc/host/ricoh_mmc.c |   91 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 75 insertions(+), 16 deletions(-)
> 
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ b/drivers/mmc/host/ricoh_mmc.c
> @@ -45,8 +45,10 @@ static int __devinit ricoh_mmc_probe(str
>  				     const struct pci_device_id *ent)
>  {
>  	u8 rev;
> +	u8 ctrlfound = 0;
>  
>  	struct pci_dev *fw_dev = NULL;
> +	struct pci_dev *main_dev = NULL; /* for Ricoh RL5c476 II */

There's no need to have two pointers. One will do fine.

>  	BUG_ON(pdev == NULL);
>  	BUG_ON(ent == NULL);
> @@ -58,7 +60,47 @@ static int __devinit ricoh_mmc_probe(str
>  		pci_name(pdev), (int)pdev->vendor, (int)pdev->device,
>  		(int)rev);
>  
> -	while ((fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
> +	/* disable mmc controller via main function (RL5C476) */
> +	while ((main_dev =
> +		pci_get_device(PCI_VENDOR_ID_RICOH,
> +				PCI_DEVICE_ID_RICOH_RL5C476, main_dev))) {
> +		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(main_dev->devfn) &&
> +		    pdev->bus == main_dev->bus) {
> +			u8 write_enable;
> +			u8 write_target;
> +			u8 disable;
> +
> +			pci_read_config_byte(main_dev, 0xB7, &disable);
> +			if (disable & 0x02) {
> +				printk(KERN_INFO DRIVER_NAME
> +					": Controller already disabled. " \
> +					"Nothing to do.\n");
> +				return -ENODEV;
> +			}
> +
> +			pci_read_config_byte(main_dev, 0x8E, &write_enable);
> +			pci_write_config_byte(main_dev, 0x8E, 0xAA);
> +			pci_read_config_byte(main_dev, 0x8D, &write_target);
> +			pci_write_config_byte(main_dev, 0x8D, 0xB7);
> +			pci_write_config_byte(main_dev, 0xB7, disable | 0x02);
> +			pci_write_config_byte(main_dev, 0x8E, write_enable);
> +			pci_write_config_byte(main_dev, 0x8D, write_target);
> +
> +			pci_set_drvdata(pdev, main_dev);
> +
> +			printk(KERN_INFO DRIVER_NAME
> +				": Controller is now disabled " \
> +				"(via R5L5C476).\n");
> +
> +			ctrlfound = 1;
> +			break;
> +		}
> +	}
> +
> +	/* disable mmc controller via firewire function (R5C832) */
> +	while (!ctrlfound &&
> +	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
> +					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
>  		    pdev->bus == fw_dev->bus) {
>  			u8 write_enable;

It feels like there's a bit too much code duplication going on here, but I think
that after you rebase the patch it'll look a lot tidier and I won't feel bad about
it :-)

> @@ -67,7 +109,8 @@ static int __devinit ricoh_mmc_probe(str
>  			pci_read_config_byte(fw_dev, 0xCB, &disable);
>  			if (disable & 0x02) {
>  				printk(KERN_INFO DRIVER_NAME
> -				       ": Controller already disabled. Nothing to do.\n");
> +					": Controller already disabled. " \
> +					"Nothing to do.\n");
>  				return -ENODEV;
>  			}
>  
> @@ -79,15 +122,16 @@ static int __devinit ricoh_mmc_probe(str
>  			pci_set_drvdata(pdev, fw_dev);
>  
>  			printk(KERN_INFO DRIVER_NAME
> -			       ": Controller is now disabled.\n");
> +			       ": Controller is now disabled (via R5C832).\n");
>  
> -			break;
> +			ctrlfound = 1;
>  		}
>  	}
>  
> -	if (pci_get_drvdata(pdev) == NULL) {
> +	if (!ctrlfound) {
>  		printk(KERN_WARNING DRIVER_NAME
> -		       ": Main firewire function not found. Cannot disable controller.\n");
> +			": Needed function was not found. " \
> +			"Cannot disable controller.\n");
>  		return -ENODEV;
>  	}
>  
> @@ -97,20 +141,35 @@ static int __devinit ricoh_mmc_probe(str
>  static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
>  {
>  	u8 write_enable;
> +	u8 write_target;
>  	u8 disable;
> -	struct pci_dev *fw_dev = NULL;
> +	struct pci_dev *ctrl_dev = NULL;

Same as in probe. Just use one pointer.

> -	fw_dev = pci_get_drvdata(pdev);
> -	BUG_ON(fw_dev == NULL);
> +	ctrl_dev = pci_get_drvdata(pdev);
> +	BUG_ON(ctrl_dev == NULL);
>  
> -	pci_read_config_byte(fw_dev, 0xCA, &write_enable);
> -	pci_read_config_byte(fw_dev, 0xCB, &disable);
> -	pci_write_config_byte(fw_dev, 0xCA, 0x57);
> -	pci_write_config_byte(fw_dev, 0xCB, disable & ~0x02);
> -	pci_write_config_byte(fw_dev, 0xCA, write_enable);
> +	if (ctrl_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
> +		pci_read_config_byte(ctrl_dev, 0x8E, &write_enable);
> +		pci_write_config_byte(ctrl_dev, 0x8E, 0xAA);
> +		pci_read_config_byte(ctrl_dev, 0x8D, &write_target);
> +		pci_write_config_byte(ctrl_dev, 0x8D, 0xB7);
> +		pci_read_config_byte(ctrl_dev, 0xB7, &disable);
> +		pci_write_config_byte(ctrl_dev, 0xB7, disable & ~0x02);
> +		pci_write_config_byte(ctrl_dev, 0x8E, write_enable);
> +		pci_write_config_byte(ctrl_dev, 0x8D, write_target);
> +
> +		printk(KERN_INFO DRIVER_NAME
> +			": Controller is now re-enabled (via R5L5C476).\n");
> +	} else {
> +		pci_read_config_byte(ctrl_dev, 0xCA, &write_enable);
> +		pci_read_config_byte(ctrl_dev, 0xCB, &disable);
> +		pci_write_config_byte(ctrl_dev, 0xCA, 0x57);
> +		pci_write_config_byte(ctrl_dev, 0xCB, disable & ~0x02);
> +		pci_write_config_byte(ctrl_dev, 0xCA, write_enable);
>  
> -	printk(KERN_INFO DRIVER_NAME
> -	       ": Controller is now re-enabled.\n");
> +		printk(KERN_INFO DRIVER_NAME
> +			": Controller is now re-enabled (via R5C832).\n");
> +	}
>  
>  	pci_set_drvdata(pdev, NULL);
>  }
> 

--phil
