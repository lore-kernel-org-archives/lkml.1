Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZIBSBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZIBSBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZIBSBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:01:00 -0400
Received: from kroah.org ([198.145.64.141]:47353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZIBSA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:00:59 -0400
Date: Wed, 2 Sep 2009 10:56:57 -0700
From: Greg KH <greg@kroah.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Tejun Heo <tj@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Shane Huang <Shane.Huang@amd.com>
Subject: Re: [PATCH] pci: separate out pci_add_dynid()
Message-ID: <20090902175657.GA5737@kroah.com>
References: <4A9E38FA.3000506@kernel.org>
 <20090902161048.GA5405@lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902161048.GA5405@lackof.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 10:10:48AM -0600, Grant Grundler wrote:
> On Wed, Sep 02, 2009 at 06:20:58PM +0900, Tejun Heo wrote:
> > Separate out pci_add_dynid() from store_new_id() and export it so that
> > in-kernel code can add PCI IDs dynamically.  As the function will be
> > available regardless of HOTPLUG, put it and pull pci_free_dynids()
> > outside of CONFIG_HOTPLUG.
> > 
> > This will be used by pci-stub to initialize initial IDs via module
> > param.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > ---
> >  drivers/pci/pci-driver.c |  119 +++++++++++++++++++++++++++++------------------
> >  include/linux/pci.h      |    5 +
> >  2 files changed, 79 insertions(+), 45 deletions(-)
> > 
> > Index: ata/drivers/pci/pci-driver.c
> > ===================================================================
> > --- ata.orig/drivers/pci/pci-driver.c
> > +++ ata/drivers/pci/pci-driver.c
> > @@ -19,37 +19,98 @@
> >  #include <linux/cpu.h>
> >  #include "pci.h"
> > 
> > -/*
> > - * Dynamic device IDs are disabled for !CONFIG_HOTPLUG
> > - */
> 
> The comment was removed here. Ok.
> 
> > -
> >  struct pci_dynid {
> >  	struct list_head node;
> >  	struct pci_device_id id;
> >  };
> > 
> > -#ifdef CONFIG_HOTPLUG
> > +/**
> > + * pci_add_dynid - add a new PCI device ID to this driver and re-probe devices
> > + * @drv: target pci driver
> > + * @vendor: PCI vendor ID
> > + * @device: PCI device ID
> > + * @subvendor: PCI subvendor ID
> > + * @subdevice: PCI subdevice ID
> > + * @class: PCI class
> > + * @class_mask: PCI class mask
> > + * @driver_data: private driver data
> > + *
> > + * Adds a new dynamic pci device ID to this driver and causes the
> > + * driver to probe for all devices again.  @drv must have been
> > + * registered prior to calling this function.
> > + *
> > + * CONTEXT:
> > + * Does GFP_KERNEL allocation.
> > + *
> > + * RETURNS:
> > + * 0 on success, -errno on failure.
> > + */
> > +int pci_add_dynid(struct pci_driver *drv,
> > +		  unsigned int vendor, unsigned int device,
> > +		  unsigned int subvendor, unsigned int subdevice,
> > +		  unsigned int class, unsigned int class_mask,
> > +		  unsigned long driver_data)
> > +{
> > +	struct pci_dynid *dynid;
> > +	int retval;
> > +
> > +	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
> > +	if (!dynid)
> > +		return -ENOMEM;
> > +
> > +	dynid->id.vendor = vendor;
> > +	dynid->id.device = device;
> > +	dynid->id.subvendor = subvendor;
> > +	dynid->id.subdevice = subdevice;
> > +	dynid->id.class = class;
> > +	dynid->id.class_mask = class_mask;
> > +	dynid->id.driver_data = driver_data;
> > 
> > +	spin_lock(&drv->dynids.lock);
> > +	list_add_tail(&dynid->node, &drv->dynids.list);
> > +	spin_unlock(&drv->dynids.lock);
> > +
> > +	get_driver(&drv->driver);
> 
> Return value ignored caught my attention... But I can't say if that's wrong.
> 
> I'm not finding any documentation on get_driver() in Documentation/ .
> Looking at drivers/base/driver.c:get_driver() code, I'm confused why this
> function bothers returning struct device_driver *. My expectation is 
> the input parameter "drv" is the same as "priv->driver" that gets returned.
> No?

Yes.

> In any case, if the Docbook comments for get_driver() could explain
> whatever subtle difference there is, that would be helpful.

There is no difference, we were just trying to be kind way back when it
was first written, 6+ years ago :)


thanks,

greg k-h
