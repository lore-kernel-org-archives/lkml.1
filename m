Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZAHWQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZAHWQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZAHWPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:15:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbZAHWPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:15:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: philipl@overt.org
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq (v2) (resend)
Date: Thu, 8 Jan 2009 23:14:52 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       sfr@canb.auug.org.au, "Pierre Ossman" <drzeus@drzeus.cx>
References: <40499.98.210.152.237.1231345314.squirrel@overt.org>
In-Reply-To: <40499.98.210.152.237.1231345314.squirrel@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901082314.52840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009, philipl@overt.org wrote:
> If ricoh_mmc suspends before sdhci_pci, it will pull the card
> out from under the controller, which could leave the system in
> a very confused state.

Does it really happen?  That depends on which of them is registered first.

> Using suspend/resume_noirq ensures that sdhci_pci suspends first
> and resumes second.

Well, I'm not sure if this is the best approach, but I don't know what the
dependencies between the devices are, so can you please explain that
to me?

That said, if you want to suspend-resume ricoh_mmc with interrupts disabled,
please use the legacy PCI .suspend_late() and .resume_early() callbacks for
that, since in the new framework the core will carry out some standard PM
operations in addition to your .suspend_noirq() and .resume_noirq().  It may
not be what you want in this case, though.

Thanks,
Rafael


> Signed-off-by: Philip Langdale <philipl@overt.org>
> Acked-by: Pierre Ossman <drzeus@drzeus.cx>
> ---
> 
>   ricoh_mmc.c |   20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
> index 1837719..b4958a7 100644
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ b/drivers/mmc/host/ricoh_mmc.c
> @@ -194,10 +194,14 @@ static void __devexit ricoh_mmc_remove(struct pci_dev *pdev)
>  	pci_set_drvdata(pdev, NULL);
>  }
> 
> -static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state) +static int
> ricoh_mmc_suspend_noirq(struct device *dev)
>  {
> +	struct pci_dev *pdev = NULL;
>  	struct pci_dev *fw_dev = NULL;
> 
> +	pdev = to_pci_dev(dev);
> +	BUG_ON(pdev == NULL);
> +
>  	fw_dev = pci_get_drvdata(pdev);
>  	BUG_ON(fw_dev == NULL);
> 
> @@ -208,10 +212,14 @@ static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
>  	return 0;
>  }
> 
> -static int ricoh_mmc_resume(struct pci_dev *pdev)
> +static int ricoh_mmc_resume_noirq(struct device *dev)
>  {
> +	struct pci_dev *pdev = NULL;
>  	struct pci_dev *fw_dev = NULL;
> 
> +	pdev = to_pci_dev(dev);
> +	BUG_ON(pdev == NULL);
> +
>  	fw_dev = pci_get_drvdata(pdev);
>  	BUG_ON(fw_dev == NULL);
> 
> @@ -222,13 +230,17 @@ static int ricoh_mmc_resume(struct pci_dev *pdev)
>  	return 0;
>  }
> 
> +static struct dev_pm_ops ricoh_mmc_pm_opts = {
> +	.suspend_noirq =	ricoh_mmc_suspend_noirq,
> +	.resume_noirq =		ricoh_mmc_resume_noirq,
> +};
> +
>  static struct pci_driver ricoh_mmc_driver = {
>  	.name = 	DRIVER_NAME,
>  	.id_table =	pci_ids,
>  	.probe = 	ricoh_mmc_probe,
>  	.remove =	__devexit_p(ricoh_mmc_remove),
> -	.suspend =	ricoh_mmc_suspend,
> -	.resume =	ricoh_mmc_resume,
> +	.driver.pm =	&ricoh_mmc_pm_opts,
>  };
> 
>  /*****************************************************************************\
> 
> Rafael,
> 
> Pierre asked that you take this patch into your tree because it depends on
> the new pm ops design.
