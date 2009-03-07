Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZCGC61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZCGC61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 21:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCGC5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 21:57:33 -0500
Received: from kroah.org ([198.145.64.141]:35956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754662AbZCGC5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 21:57:31 -0500
Date: Fri, 6 Mar 2009 18:38:45 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090307023845.GD3596@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-2-git-send-email-yu.zhao@intel.com> <20090306200810.GD25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306200810.GD25995@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 01:08:10PM -0700, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:42PM +0800, Yu Zhao wrote:
> > +	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
> > +		if (pdev->sriov)
> > +			break;
> > +	if (list_empty(&dev->bus->devices) || !pdev->sriov)
> > +		pdev = NULL;
> > +	ctrl = 0;
> > +	if (!pdev && pci_ari_enabled(dev->bus))
> > +		ctrl |= PCI_SRIOV_CTRL_ARI;
> > +
> 
> I don't like this loop.  At the end of a list_for_each_entry() loop,
> pdev will not be pointing at a pci_device, it'll be pointing to some
> offset from &dev->bus->devices.  So checking pdev->sriov at this point
> is really, really bad.  I would prefer to see something like this:
> 
>         ctrl = 0;
>         list_for_each_entry(pdev, &dev->bus->devices, bus_list) {
>                 if (pdev->sriov)
>                         goto ari_enabled;
>         }
> 
>         if (pci_ari_enabled(dev->bus))
>                 ctrl = PCI_SRIOV_CTRL_ARI;
>  ari_enabled:
>         pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);

No, please use bus_for_each_dev() instead, or bus_find_device(), don't
walk the bus list by hand.  I'm kind of surprised that even builds.  Hm,
in looking at the 2.6.29-rc kernels, I notice it will not even build at
all, you are now forced to use those functions, which is good.

Has anyone even tried to build this patch recently?

thanks,

greg k-h
