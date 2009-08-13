Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZHMVrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZHMVrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZHMVrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:47:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53922 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZHMVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:47:04 -0400
Date: Thu, 13 Aug 2009 22:47:01 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] PCI: Runtime power management
Message-ID: <20090813214701.GC14532@srcf.ucam.org>
References: <20090813002925.GA2532@srcf.ucam.org> <Pine.LNX.4.44L0.0908131100440.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908131100440.2940-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:17:05AM -0400, Alan Stern wrote:
> On Thu, 13 Aug 2009, Matthew Garrett wrote:
> 
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> 
> > +#ifdef CONFIG_PM_RUNTIME
> > +
> > +static int pci_pm_runtime_suspend(struct device *dev)
> > +{
> > +	struct pci_dev *pci_dev = to_pci_dev(dev);
> > +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +	int error;
> > +
> > +	device_set_wakeup_enable(dev, 1);
> 
> This is a userspace policy parameter.  Kernel code should not alter it.
> Instead you should test device_may_wakeup.

Ugh. I'd really prefer us to assume that drivers are able to cope unless 
proven otherwise. Userspace policy makes sense where we don't have any 
idea whether something will work or not, but I'd really expect that most 
PCI drivers will either cope (in which case they'll have enabling code) 
or won't (in which case they won't). Why would we want userspace to 
influence this?

> > +	enable_irq(pci_dev->irq);
> > +resume:
> > +	pci_pm_resume(dev);
> > +out:
> > +	pci_enable_runtime_wake(pci_dev, false);
> > +	return error;
> > +}
> 
> The goto statements and unwinding code don't match up.

I'll look at that.

> > +	if (error)
> > +		return error;
> > +
> > +	return 0;
> > +}
> 
> Log an error message when something goes wrong?

Seems fair.

> > +static void pci_pm_runtime_idle(struct device *dev)
> > +{
> > +	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> > +
> > +	if (pm && pm->runtime_idle)
> > +		pm->runtime_idle(dev);
> > +
> > +	pm_schedule_suspend(dev, 0);
> > +}
> 
> This misses the point.  The whole idea of runtime_idle is to tell you 
> that the device is idle and might be ready to be suspended.  If you're 
> going to call pm_schedule_suspend anyway, there's no reason to invoke 
> pm->runtime_idle.

My understanding of the API was that pm_device_put() invokes 
runtime_idle if the refcount hits 0. The bus layer has no idea of the 
refcount, and calling suspend directly from the driver would defeat the 
point of the system-wide recounting.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
