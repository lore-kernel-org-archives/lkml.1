Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbYHUWOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbYHUWOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbYHUWOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:14:40 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:20424 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYHUWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:14:39 -0400
Date: Thu, 21 Aug 2008 16:14:38 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: refcount leak in pci_get_device()?
Message-ID: <20080821221438.GC20014@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821204758.GB31543@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Thu, Aug 21, 2008 at 02:25:04PM -0600, Matthew Wilcox wrote:
> > On Thu, Aug 21, 2008 at 02:19:18PM -0600, Alex Chiang wrote:
> > > #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
> > > 
> > > That eventually calls pci_get_dev_by_id(), which increases the
> > > refcount on the device, but never decrements it.
> > > 
> > > Looks like that change in behavior happened here:
> > > 
> > > 	PCI: clean up search.c a lot
> > > 	95247b57ed844511a212265b45cf9a919753aea1
> > > 
> > > pci_get_device() used to decrement the refcount, but no longer
> > > does.
> > > 
> > > Thanks to Matthew Wilcox for helping me get this far...
> > > 
> > > Like I said, I'm still trying to track down my particular issue,
> > > but I'd like to get your opinion on this.
> > 
> > In particular, I'd like to know whether this should be fixed by
> > pci_get_dev_by_id() decrementing the refcount of from/dev_start,
> > pci_get_subsys() decrementing 'from', or by bus_find_device()
> > decrementing 'start'.  It looks like bus_find_device() is the place
> > where this should logically happen, but the kerneldoc doesn't document
> > the intended behaviour.
> 
> Ah, no the driver core isn't supposed to do this, it's something the pci
> functions do out of "niceness" as that's how we can use them in an
> iterator properly.
> 
> Does the following (untested) patch fix the issue for you all?

Perfect, yes.

I applied it, and observed the refcount on the device I was using
to debug this problem.

I was able to modprobe acpiphp successfully, and echo 0 into the
device's 'power' file.

I then watched the rest of the hotplug core do its thing,
decrementing the refcount properly along the way, and at the end,
we did call pci_release_dev(), as I originally expected to. :)

Just to verify, I toggled the device's power a few times (echoing
a 1 and then a 0, etc.) and watched the refcounts. After each
offline, we properly called pci_release_dev().

Thanks for fixing this. It fixes a pretty bad leak in the hotplug
core (we were leaking an entire struct pci_dev * # of functions
for each offlined card, the first time around; subsequent
onlines/offlines were ok).

Tested-by: Alex Chiang <achiang@hp.com>

/ac

> 
> thanks,
> 
> greg k-h
> 
> --------------
> Subject: PCI: fix reference leak in pci_get_dev_by_id()
> 
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Alex Chiang and Matthew Wilcox pointed out that pci_get_dev_by_id() does
> not properly decrement the reference on the from pointer if it is
> present, like the documentation for the function states it will.
> 
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Alex Chiang <achiang@hp.com>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 217814f..3b3b5f1 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -280,6 +280,8 @@ static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
>  			      match_pci_dev_by_id);
>  	if (dev)
>  		pdev = to_pci_dev(dev);
> +	if (from)
> +		pci_dev_put(from);
>  	return pdev;
>  }
>  
> 
