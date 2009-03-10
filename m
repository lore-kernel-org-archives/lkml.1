Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZCJPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZCJPBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZCJPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:01:34 -0400
Received: from ping.pong.ch ([212.103.71.101]:33084 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZCJPBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:01:34 -0400
Date: Tue, 10 Mar 2009 16:01:26 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
	breaks resume from RAM on PowerBook
Message-ID: <20090310150126.GB5633@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch> <20090306114149.GA5371@soziologie.ch> <1236638264.7260.192.camel@pasglop> <200903101032.58617.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903101032.58617.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

On Tue, Mar 10, 2009 at 10:32:58AM +0100, Rafael J. Wysocki wrote:
> 
> Gaudenz, I'd also like to know if the appended patch (on top of vanilla Linus'
> tree) makes any different.  Unfortunately, I haven't had the time to test it
> myself yet.

No, this patch does not make any difference.

Gaudenz

> 
> Thanks,
> Rafael
> 
> ---
>  drivers/pci/pci-driver.c |   42 ++++++++++++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -556,7 +556,7 @@ static int pci_pm_suspend_noirq(struct d
>  static int pci_pm_resume_noirq(struct device *dev)
>  {
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
> -	struct device_driver *drv = dev->driver;
> +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  	int error = 0;
>  
>  	pci_pm_default_resume_noirq(pci_dev);
> @@ -564,8 +564,13 @@ static int pci_pm_resume_noirq(struct de
>  	if (pci_has_legacy_pm_support(pci_dev))
>  		return pci_legacy_resume_early(dev);
>  
> -	if (drv && drv->pm && drv->pm->resume_noirq)
> -		error = drv->pm->resume_noirq(dev);
> +	if (pm) {
> +		if (pm->resume_noirq)
> +			error = pm->resume_noirq(dev);
> +	} else {
> +		if (pci_is_bridge(pci_dev))
> +			pci_pm_reenable_device(pci_dev);
> +	}
>  
>  	return error;
>  }
> @@ -592,7 +597,8 @@ static int pci_pm_resume(struct device *
>  		if (pm->resume)
>  			error = pm->resume(dev);
>  	} else {
> -		pci_pm_reenable_device(pci_dev);
> +		if (!pci_is_bridge(pci_dev))
> +			pci_pm_reenable_device(pci_dev);
>  	}
>  
>  	return 0;
> @@ -662,7 +668,7 @@ static int pci_pm_freeze_noirq(struct de
>  static int pci_pm_thaw_noirq(struct device *dev)
>  {
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
> -	struct device_driver *drv = dev->driver;
> +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  	int error = 0;
>  
>  	if (pci_has_legacy_pm_support(pci_dev))
> @@ -670,8 +676,13 @@ static int pci_pm_thaw_noirq(struct devi
>  
>  	pci_update_current_state(pci_dev, PCI_D0);
>  
> -	if (drv && drv->pm && drv->pm->thaw_noirq)
> -		error = drv->pm->thaw_noirq(dev);
> +	if (pm) {
> +		if (pm->thaw_noirq)
> +			error = pm->thaw_noirq(dev);
> +	} else {
> +		if (pci_is_bridge(pci_dev))
> +			pci_pm_reenable_device(pci_dev);
> +	}
>  
>  	return error;
>  }
> @@ -689,7 +700,8 @@ static int pci_pm_thaw(struct device *de
>  		if (pm->thaw)
>  			error = pm->thaw(dev);
>  	} else {
> -		pci_pm_reenable_device(pci_dev);
> +		if (!pci_is_bridge(pci_dev))
> +			pci_pm_reenable_device(pci_dev);
>  	}
>  
>  	return error;
> @@ -744,7 +756,7 @@ static int pci_pm_poweroff_noirq(struct 
>  static int pci_pm_restore_noirq(struct device *dev)
>  {
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
> -	struct device_driver *drv = dev->driver;
> +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  	int error = 0;
>  
>  	pci_pm_default_resume_noirq(pci_dev);
> @@ -752,8 +764,13 @@ static int pci_pm_restore_noirq(struct d
>  	if (pci_has_legacy_pm_support(pci_dev))
>  		return pci_legacy_resume_early(dev);
>  
> -	if (drv && drv->pm && drv->pm->restore_noirq)
> -		error = drv->pm->restore_noirq(dev);
> +	if (pm) {
> +		if (pm->restore_noirq)
> +			error = pm->restore_noirq(dev);
> +	} else {
> +		if (pci_is_bridge(pci_dev))
> +			pci_pm_reenable_device(pci_dev);
> +	}
>  
>  	return error;
>  }
> @@ -780,7 +797,8 @@ static int pci_pm_restore(struct device 
>  		if (pm->restore)
>  			error = pm->restore(dev);
>  	} else {
> -		pci_pm_reenable_device(pci_dev);
> +		if (!pci_is_bridge(pci_dev))
> +			pci_pm_reenable_device(pci_dev);
>  	}
>  
>  	return error;

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
