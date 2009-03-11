Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZCKEim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZCKEim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZCKEhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:37:55 -0400
Received: from kroah.org ([198.145.64.141]:57803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753946AbZCKEhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:37:52 -0400
Date: Tue, 10 Mar 2009 21:36:13 -0700
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090311043613.GC25746@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-2-git-send-email-yu.zhao@intel.com> <20090306200810.GD25995@parisc-linux.org> <20090307023845.GD3596@kroah.com> <20090310011944.GB5063@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310011944.GB5063@yzhao-otc.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 09:19:44AM +0800, Yu Zhao wrote:
> On Sat, Mar 07, 2009 at 10:38:45AM +0800, Greg KH wrote:
> > On Fri, Mar 06, 2009 at 01:08:10PM -0700, Matthew Wilcox wrote:
> > > On Fri, Feb 20, 2009 at 02:54:42PM +0800, Yu Zhao wrote:
> > > > +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> > > > +		if (pdev->sriov)
> > > > +			break;
> > > > +	if (list_empty(&dev->bus->devices) || !pdev->sriov)
> > > > +		pdev = NULL;
> > > > +	ctrl = 0;
> > > > +	if (!pdev && pci_ari_enabled(dev->bus))
> > > > +		ctrl |= PCI_SRIOV_CTRL_ARI;
> > > > +
> > > 
> > > I don't like this loop.  At the end of a list_for_each_entry() loop,
> > > pdev will not be pointing at a pci_device, it'll be pointing to some
> > > offset from &dev->bus->devices.  So checking pdev->sriov at this point
> > > is really, really bad.  I would prefer to see something like this:
> > > 
> > >         ctrl = 0;
> > >         list_for_each_entry(pdev, &dev->bus->devices, bus_list) {
> > >                 if (pdev->sriov)
> > >                         goto ari_enabled;
> > >         }
> > > 
> > >         if (pci_ari_enabled(dev->bus))
> > >                 ctrl = PCI_SRIOV_CTRL_ARI;
> > >  ari_enabled:
> > >         pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
> > 
> > No, please use bus_for_each_dev() instead, or bus_find_device(), don't
> > walk the bus list by hand.  I'm kind of surprised that even builds.  Hm,
> > in looking at the 2.6.29-rc kernels, I notice it will not even build at
> > all, you are now forced to use those functions, which is good.
> 
> The devices haven't been added at this time, so we can't use
> bus_for_each_dev(). I guess that's why the `bus->devices' exists, and
> actually pci_bus_add_devices() walks the bus list same way to retrieve
> the devices and add them.

ah, this is struct pci_bus, not struct bus_type, my mistake.

sorry for the noise,

greg k-h
