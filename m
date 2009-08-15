Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZHOPXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZHOPXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 11:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZHOPXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 11:23:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42560 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbZHOPXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 11:23:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] PCI: Runtime power management
Date: Sat, 15 Aug 2009 17:24:27 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
References: <200908081625.57333.rjw@sisk.pl> <20090814223013.GB20015@srcf.ucam.org> <200908151641.56571.rjw@sisk.pl>
In-Reply-To: <200908151641.56571.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908151724.27207.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 August 2009, Rafael J. Wysocki wrote:
> On Saturday 15 August 2009, Matthew Garrett wrote:
> > On Fri, Aug 14, 2009 at 11:22:27PM +0200, Rafael J. Wysocki wrote:
...
> > > > +	error = pci_pm_suspend(dev);
> > > 
> > > This has a chance to be confusing IMO.  pci_pm_suspend() calls the driver's
> > > ->suspend() routine, which is specific to suspend to RAM.  So, this means
> > > that drivers are supposed to implement ->runtime_suspend() only if they
> > > want to do something _in_ _addition_ to the things done by
> > > ->suspend() and ->suspend_noirq().
> > 
> > Yes, that was how I'd planned it. An alternative would be for 
> > runtime_suspend to return a negative value if there's an error, 0 if the 
> > bus code should continue or a positive value if the runtime_suspend() 
> > call handles all of it and the bus code should just return immediately?
> 
> I just don't think that the existing suspend-resume callbacks are suitable for
> runtime PM.
> 
> For example, in the majority of cases the existing suspend callbacks put
> devices into D3_hot (or into the deepest low power state allowed by the
> platform and hardware), but that means 10 ms latency, also for the resume
> part.  Do we want that for runtime PM for all drivers?
> 
> Perhaps a more suitable model would be to put devices into D1 first, if
> available, and then put them into D2 and D3 after specific delays?  Currently
> the core framework doesn't provide any tools for that, but it may be worth
> extending it for this purpose.
> 
> Also, I think it should be impossible to use the "legacy" callbacks for runtime
> PM.  They surely are not designed with that in mind.

To be more specific, let's go through pci_pm_suspend() and
pci_pm_suspend_noirq() and see what parts of these are useful for runtime PM.

pci_legacy_suspend() shouldn't be used at run time IMO, as I said above.

For runtime PM we shouldn't even continue if pm is NULL.  There's nothing
like "default runtime PM", either the driver supports it, or not.  We also
should require the callback to be implemented and IMO that should be
->runtime_suspend().

Of course we need to invoke the callback and call pci_fixup_device() after
that.

pci_legacy_suspend_late() shouldn't be used at run time.

Since I think we should require pm to be not NULL for runtime PM, the second
block in pci_pm_suspend_noirq() is redundant in that case.

Now, I don't think we need the _noirq callback for runtime PM, because
we've just executed the "regular" callback and I bet there are no devices
requiring additional driver-specific operations after pci_fixup_device().
So ->runtime_suspend() should be sufficient.

The remaining part of pci_pm_suspend_noirq() is useful, so it can be executed
by pci_pm_runtime_suspend() directly.

Thus we get

static int pci_pm_runtime_suspend(struct device *dev)
{
	struct pci_dev *pci_dev = to_pci_dev(dev);
	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
	int error;

	if (!pm || !pm->runtime_suspend)
		return -ENOSYS;

	pci_dev->state_saved = false;

	error = pm->runtime_suspend(dev);
	suspend_report_result(pm->runtime_suspend, error);
	if (error)
		return error;

	pci_fixup_device(pci_fixup_suspend, pci_dev);

	if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
	    && pci_dev->current_state != PCI_UNKNOWN) {
		WARN_ONCE(pci_dev->current_state != prev,
				"PCI PM: State of device not saved by %pF\n",
				pm->runtime_suspend);
		return 0;
	}

	if (!pci_dev->state_saved) {
		pci_save_state(pci_dev);
		if (!pci_is_bridge(pci_dev))
			pci_prepare_to_sleep(pci_dev);
	}

	pci_pm_set_unknown_state(pci_dev);

	return 0;
}

Now, if the driver has a universal suspend routine, like for example r8169,
it only needs to point .runtime_suspend to that one and it should work.

Thanks,
Rafael
