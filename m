Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZAELZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZAELZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZAELZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:25:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33532 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZAELZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:25:03 -0500
Date: Mon, 5 Jan 2009 12:25:01 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/10] PCI PM: Rearrange code in pci-driver.c
Message-ID: <20090105112501.GK27199@atrey.karlin.mff.cuni.cz>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302343.07164.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812302343.07164.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Rename two functions and rearrange code in drivers/pci/pci-driver.c
> so that it's easier to follow.  In particular, separate invocations
> of the legacy callbacks from the rest of the new callbacks' code.
> 
> No functional changes should result from this.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |  104 +++++++++++++++++++++++++++++------------------
>  1 file changed, 65 insertions(+), 39 deletions(-)
>

> @@ -504,17 +504,21 @@ static int pci_pm_suspend(struct device 
>  	struct device_driver *drv = dev->driver;
>  	int error = 0;
>  
> +	if (pci_has_legacy_pm_support(pci_dev)) {
> +		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
> +		goto Exit;
> +	}
> +
>  	if (drv && drv->pm) {
>  		if (drv->pm->suspend) {
>  			error = drv->pm->suspend(dev);
>  			suspend_report_result(drv->pm->suspend, error);
>  		}
> -	} else if (pci_has_legacy_pm_support(pci_dev)) {
> -		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
>  	} else {
>  		pci_pm_default_suspend(pci_dev);
>  	}
>

Does this mean that pci_has_legacy_pm_support() => !(drv && drv->pm) ?
Should pci_has_legacy_pm_support() check for that and WARN() in case
both sets of callbacks are set?
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
