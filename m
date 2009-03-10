Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZCJU7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZCJU7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZCJU7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:59:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:44175 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbZCJU7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:59:35 -0400
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090310150126.GB5633@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <20090306114149.GA5371@soziologie.ch> <1236638264.7260.192.camel@pasglop>
	 <200903101032.58617.rjw@sisk.pl>  <20090310150126.GB5633@soziologie.ch>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 07:58:46 +1100
Message-Id: <1236718726.7086.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 16:01 +0100, Gaudenz Steinlin wrote:
> Hi Rafael
> 
> On Tue, Mar 10, 2009 at 10:32:58AM +0100, Rafael J. Wysocki wrote:
> > 
> > Gaudenz, I'd also like to know if the appended patch (on top of vanilla Linus'
> > tree) makes any different.  Unfortunately, I haven't had the time to test it
> > myself yet.
> 
> No, this patch does not make any difference.

What about the one I sent you that removes the early wakeup ?

Cheers,
Ben.

> Gaudenz
> 
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/pci/pci-driver.c |   42 ++++++++++++++++++++++++++++++------------
> >  1 file changed, 30 insertions(+), 12 deletions(-)
> > 
> > Index: linux-2.6/drivers/pci/pci-driver.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci-driver.c
> > +++ linux-2.6/drivers/pci/pci-driver.c
> > @@ -556,7 +556,7 @@ static int pci_pm_suspend_noirq(struct d
> >  static int pci_pm_resume_noirq(struct device *dev)
> >  {
> >  	struct pci_dev *pci_dev = to_pci_dev(dev);
> > -	struct device_driver *drv = dev->driver;
> > +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> >  	int error = 0;
> >  
> >  	pci_pm_default_resume_noirq(pci_dev);
> > @@ -564,8 +564,13 @@ static int pci_pm_resume_noirq(struct de
> >  	if (pci_has_legacy_pm_support(pci_dev))
> >  		return pci_legacy_resume_early(dev);
> >  
> > -	if (drv && drv->pm && drv->pm->resume_noirq)
> > -		error = drv->pm->resume_noirq(dev);
> > +	if (pm) {
> > +		if (pm->resume_noirq)
> > +			error = pm->resume_noirq(dev);
> > +	} else {
> > +		if (pci_is_bridge(pci_dev))
> > +			pci_pm_reenable_device(pci_dev);
> > +	}
> >  
> >  	return error;
> >  }
> > @@ -592,7 +597,8 @@ static int pci_pm_resume(struct device *
> >  		if (pm->resume)
> >  			error = pm->resume(dev);
> >  	} else {
> > -		pci_pm_reenable_device(pci_dev);
> > +		if (!pci_is_bridge(pci_dev))
> > +			pci_pm_reenable_device(pci_dev);
> >  	}
> >  
> >  	return 0;
> > @@ -662,7 +668,7 @@ static int pci_pm_freeze_noirq(struct de
> >  static int pci_pm_thaw_noirq(struct device *dev)
> >  {
> >  	struct pci_dev *pci_dev = to_pci_dev(dev);
> > -	struct device_driver *drv = dev->driver;
> > +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> >  	int error = 0;
> >  
> >  	if (pci_has_legacy_pm_support(pci_dev))
> > @@ -670,8 +676,13 @@ static int pci_pm_thaw_noirq(struct devi
> >  
> >  	pci_update_current_state(pci_dev, PCI_D0);
> >  
> > -	if (drv && drv->pm && drv->pm->thaw_noirq)
> > -		error = drv->pm->thaw_noirq(dev);
> > +	if (pm) {
> > +		if (pm->thaw_noirq)
> > +			error = pm->thaw_noirq(dev);
> > +	} else {
> > +		if (pci_is_bridge(pci_dev))
> > +			pci_pm_reenable_device(pci_dev);
> > +	}
> >  
> >  	return error;
> >  }
> > @@ -689,7 +700,8 @@ static int pci_pm_thaw(struct device *de
> >  		if (pm->thaw)
> >  			error = pm->thaw(dev);
> >  	} else {
> > -		pci_pm_reenable_device(pci_dev);
> > +		if (!pci_is_bridge(pci_dev))
> > +			pci_pm_reenable_device(pci_dev);
> >  	}
> >  
> >  	return error;
> > @@ -744,7 +756,7 @@ static int pci_pm_poweroff_noirq(struct 
> >  static int pci_pm_restore_noirq(struct device *dev)
> >  {
> >  	struct pci_dev *pci_dev = to_pci_dev(dev);
> > -	struct device_driver *drv = dev->driver;
> > +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> >  	int error = 0;
> >  
> >  	pci_pm_default_resume_noirq(pci_dev);
> > @@ -752,8 +764,13 @@ static int pci_pm_restore_noirq(struct d
> >  	if (pci_has_legacy_pm_support(pci_dev))
> >  		return pci_legacy_resume_early(dev);
> >  
> > -	if (drv && drv->pm && drv->pm->restore_noirq)
> > -		error = drv->pm->restore_noirq(dev);
> > +	if (pm) {
> > +		if (pm->restore_noirq)
> > +			error = pm->restore_noirq(dev);
> > +	} else {
> > +		if (pci_is_bridge(pci_dev))
> > +			pci_pm_reenable_device(pci_dev);
> > +	}
> >  
> >  	return error;
> >  }
> > @@ -780,7 +797,8 @@ static int pci_pm_restore(struct device 
> >  		if (pm->restore)
> >  			error = pm->restore(dev);
> >  	} else {
> > -		pci_pm_reenable_device(pci_dev);
> > +		if (!pci_is_bridge(pci_dev))
> > +			pci_pm_reenable_device(pci_dev);
> >  	}
> >  
> >  	return error;
> 

