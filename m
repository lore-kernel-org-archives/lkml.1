Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZCJBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZCJBSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZCJBSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:18:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:19130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZCJBSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:18:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,332,1233561600"; 
   d="scan'208";a="496425150"
Date: Tue, 10 Mar 2009 09:19:44 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090310011944.GB5063@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-2-git-send-email-yu.zhao@intel.com> <20090306200810.GD25995@parisc-linux.org> <20090307023845.GD3596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307023845.GD3596@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 10:38:45AM +0800, Greg KH wrote:
> On Fri, Mar 06, 2009 at 01:08:10PM -0700, Matthew Wilcox wrote:
> > On Fri, Feb 20, 2009 at 02:54:42PM +0800, Yu Zhao wrote:
> > > +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> > > +		if (pdev->sriov)
> > > +			break;
> > > +	if (list_empty(&dev->bus->devices) || !pdev->sriov)
> > > +		pdev = NULL;
> > > +	ctrl = 0;
> > > +	if (!pdev && pci_ari_enabled(dev->bus))
> > > +		ctrl |= PCI_SRIOV_CTRL_ARI;
> > > +
> > 
> > I don't like this loop.  At the end of a list_for_each_entry() loop,
> > pdev will not be pointing at a pci_device, it'll be pointing to some
> > offset from &dev->bus->devices.  So checking pdev->sriov at this point
> > is really, really bad.  I would prefer to see something like this:
> > 
> >         ctrl = 0;
> >         list_for_each_entry(pdev, &dev->bus->devices, bus_list) {
> >                 if (pdev->sriov)
> >                         goto ari_enabled;
> >         }
> > 
> >         if (pci_ari_enabled(dev->bus))
> >                 ctrl = PCI_SRIOV_CTRL_ARI;
> >  ari_enabled:
> >         pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
> 
> No, please use bus_for_each_dev() instead, or bus_find_device(), don't
> walk the bus list by hand.  I'm kind of surprised that even builds.  Hm,
> in looking at the 2.6.29-rc kernels, I notice it will not even build at
> all, you are now forced to use those functions, which is good.

The devices haven't been added at this time, so we can't use
bus_for_each_dev(). I guess that's why the `bus->devices' exists, and
actually pci_bus_add_devices() walks the bus list same way to retrieve
the devices and add them.

Thanks,
Yu
