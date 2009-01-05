Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZAENcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZAENcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZAENbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:31:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54543 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbZAENbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:31:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [RFC][PATCH 6/10] PCI PM: Rearrange code in pci-driver.c
Date: Mon, 5 Jan 2009 14:32:27 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812302343.07164.rjw@sisk.pl> <20090105112501.GK27199@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090105112501.GK27199@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051432.27718.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Pavel Machek wrote:
> Hi!
> 
> > Rename two functions and rearrange code in drivers/pci/pci-driver.c
> > so that it's easier to follow.  In particular, separate invocations
> > of the legacy callbacks from the rest of the new callbacks' code.
> > 
> > No functional changes should result from this.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-driver.c |  104 +++++++++++++++++++++++++++++------------------
> >  1 file changed, 65 insertions(+), 39 deletions(-)
> >
> 
> > @@ -504,17 +504,21 @@ static int pci_pm_suspend(struct device 
> >  	struct device_driver *drv = dev->driver;
> >  	int error = 0;
> >  
> > +	if (pci_has_legacy_pm_support(pci_dev)) {
> > +		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
> > +		goto Exit;
> > +	}
> > +
> >  	if (drv && drv->pm) {
> >  		if (drv->pm->suspend) {
> >  			error = drv->pm->suspend(dev);
> >  			suspend_report_result(drv->pm->suspend, error);
> >  		}
> > -	} else if (pci_has_legacy_pm_support(pci_dev)) {
> > -		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
> >  	} else {
> >  		pci_pm_default_suspend(pci_dev);
> >  	}
> >
> 
> Does this mean that pci_has_legacy_pm_support() => !(drv && drv->pm) ?

Yes, it does.

> Should pci_has_legacy_pm_support() check for that and WARN() in case
> both sets of callbacks are set?

Yes, I think I can add a WARN_ON() in there.

Thanks,
Rafael
