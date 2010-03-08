Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0CHWje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:39:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0CHWja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:39:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] PNPACPI: add support for remote wakeup
Date: Mon, 8 Mar 2010 23:42:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <Pine.LNX.4.44L0.1003081648510.1297-100000@iolanthe.rowland.org> <201003081521.59985.bjorn.helgaas@hp.com>
In-Reply-To: <201003081521.59985.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003082342.29031.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 March 2010, Bjorn Helgaas wrote:
> On Monday 08 March 2010 02:50:50 pm Alan Stern wrote:
> > This patch (as1354) adds remote-wakeup support to the pnpacpi driver.
> > The new can_wakeup method also allows other PNP protocol drivers
> > (pnpbios or iaspnp) to add wakeup support, but I don't know enough
> > about how they work to actually do it.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> We usually send PNP patches through the ACPI tree, so I added a CC
> to linux-acpi.
> 
> > --- usb-2.6.orig/drivers/pnp/core.c
> > +++ usb-2.6/drivers/pnp/core.c
> > @@ -164,6 +164,9 @@ int __pnp_add_device(struct pnp_dev *dev
> >  	list_add_tail(&dev->global_list, &pnp_global);
> >  	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
> >  	spin_unlock(&pnp_lock);
> > +	if (dev->protocol->can_wakeup)
> > +		device_set_wakeup_capable(&dev->dev,
> > +				dev->protocol->can_wakeup(dev));
> 
> I also added Rafael because he added code in acpi_bind_one() that
> does the same thing.  I think the struct dev there will be the same
> one as &dev->dev here: we build both an acpi_device and a pnp_dev,
> and they refer to the same struct device.
> 
> However, I think we still need your patch because acpi_bind_one()
> is only used for PCI devices, so it looks like there's currently
> no way to use acpi_pm_device_sleep_wake() for non-PCI devices.

That's correct AFAICS.

> Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> >  	return device_register(&dev->dev);
> >  }
> >  
> > Index: usb-2.6/drivers/pnp/pnpacpi/core.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/pnp/pnpacpi/core.c
> > +++ usb-2.6/drivers/pnp/pnpacpi/core.c
> > @@ -121,17 +121,37 @@ static int pnpacpi_disable_resources(str
> >  }
> >  
> >  #ifdef CONFIG_ACPI_SLEEP
> > +static bool pnpacpi_can_wakeup(struct pnp_dev *dev)
> > +{
> > +	struct acpi_device *acpi_dev = dev->data;
> > +	acpi_handle handle = acpi_dev->handle;
> > +
> > +	return acpi_bus_can_wakeup(handle);
> > +}
> > +
> >  static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
> >  {
> >  	struct acpi_device *acpi_dev = dev->data;
> >  	acpi_handle handle = acpi_dev->handle;
> >  	int power_state;
> >  
> > +	if (device_can_wakeup(&dev->dev)) {
> > +		int rc = acpi_pm_device_sleep_wake(&dev->dev,
> > +				device_may_wakeup(&dev->dev));
> > +
> > +		if (rc)
> > +			return rc;
> > +	}
> >  	power_state = acpi_pm_device_sleep_state(&dev->dev, NULL);
> >  	if (power_state < 0)
> >  		power_state = (state.event == PM_EVENT_ON) ?
> >  				ACPI_STATE_D0 : ACPI_STATE_D3;
> >  
> > +	/* acpi_bus_set_power() often fails (keyboard port can't be
> > +	 * powered-down?), and in any case, our return value is ignored
> > +	 * by pnp_bus_suspend().  Hence we don't revert the wakeup
> > +	 * setting if the set_power fails.
> > +	 */
> >  	return acpi_bus_set_power(handle, power_state);
> >  }
> >  
> > @@ -140,6 +160,8 @@ static int pnpacpi_resume(struct pnp_dev
> >  	struct acpi_device *acpi_dev = dev->data;
> >  	acpi_handle handle = acpi_dev->handle;
> >  
> > +	if (device_may_wakeup(&dev->dev))
> > +		acpi_pm_device_sleep_wake(&dev->dev, false);
> >  	return acpi_bus_set_power(handle, ACPI_STATE_D0);
> >  }
> >  #endif
> > @@ -150,6 +172,7 @@ struct pnp_protocol pnpacpi_protocol = {
> >  	.set	 = pnpacpi_set_resources,
> >  	.disable = pnpacpi_disable_resources,
> >  #ifdef CONFIG_ACPI_SLEEP
> > +	.can_wakeup = pnpacpi_can_wakeup,
> >  	.suspend = pnpacpi_suspend,
> >  	.resume = pnpacpi_resume,
> >  #endif
