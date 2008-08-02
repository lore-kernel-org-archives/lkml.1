Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYHBUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYHBUrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYHBUrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:47:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYHBUrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:47:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/2] ide: add proper PCI PM support
Date: Sat, 2 Aug 2008 22:49:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200808021917.04847.bzolnier@gmail.com>
In-Reply-To: <200808021917.04847.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808022249.38969.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 of August 2008, Bartlomiej Zolnierkiewicz wrote:
> * Keep pointer to ->init_chipset method also in
>   struct ide_host and set it in ide_host_alloc_all().
> 
> * Add ide_pci_suspend() and ide_pci_resume() helpers
>   (default ->suspend and ->resume implementations).
> 
> * ->init_chipset can no longer be marked __devinit.
> 
> * Add proper PCI PM support to IDE PCI host drivers
>   (rz1000.c and tc86c001.c are skipped for now since
>   they need to be converted from using ->init_hwif
>   to use ->init_chipset instead).

Well, first, the work on improving the PCI PM support by IDE drivers is much
appreciated.

Still, since you're adding new routines etc., it may be a good time to
implement them using the new PM framework, as defined in
include/linux/pm.h (please also have a look at drivers/pci/pci-driver.c for the
PCI bus type's PM callbacks implementation details).  Unfortunately, it's not
been well documented yet, so if you have any questions, please ask.

In fact, we need some example implementations of the new PM callbacks and
since you know the drivers in question very well, we could use your
implementations as examples, if you don't mind.  [Certainly, they would be
better than PM callbacks written by me for any driver. ;-) ]

> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

[--snip--]  

>  static int __init via_ide_init(void)
> Index: b/drivers/ide/setup-pci.c
> ===================================================================
> --- a/drivers/ide/setup-pci.c
> +++ b/drivers/ide/setup-pci.c
> @@ -659,3 +659,36 @@ void ide_pci_remove(struct pci_dev *dev)
>  	pci_disable_device(dev);
>  }
>  EXPORT_SYMBOL_GPL(ide_pci_remove);
> +
> +#ifdef CONFIG_PM
> +int ide_pci_suspend(struct pci_dev *dev, pm_message_t state)
> +{
> +	pci_save_state(dev);
> +	pci_disable_device(dev);
> +	pci_set_power_state(dev, pci_choose_state(dev, state));

pci_choose_state() is now considered as obsolete.  You can use
pci_target_state() or even pci_prepare_to_sleep() here.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ide_pci_suspend);
> +
> +int ide_pci_resume(struct pci_dev *dev)
> +{
> +	struct ide_host *host = pci_get_drvdata(dev);
> +	int rc;
> +
> +	pci_set_power_state(dev, PCI_D0);
> +

If you decide to use pci_prepare_to_sleep() above, please use
pci_back_from_sleep() here.

> +	rc = pci_enable_device(dev);
> +	if (rc)
> +		return rc;
> +
> +	pci_restore_state(dev);
> +	pci_set_master(dev);
> +
> +	if (host->init_chipset)
> +		host->init_chipset(dev);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ide_pci_resume);
> +#endif

Thanks,
Rafael
