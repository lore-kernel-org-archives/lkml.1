Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYGCR2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYGCR2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYGCR2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYGCR2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:28:04 -0400
Date: Thu, 3 Jul 2008 09:49:39 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: kay.sievers@vrfy.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: fix up bus_id changes in sparc core code
Message-ID: <20080703164939.GA13326@suse.de>
References: <20080702153651.GB30318@kroah.com> <20080703.033556.167121752.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703.033556.167121752.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 03:35:56AM -0700, David Miller wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> Date: Wed, 2 Jul 2008 08:36:51 -0700
> 
> > --- a/arch/sparc64/kernel/pci.c
> > +++ b/arch/sparc64/kernel/pci.c
> > @@ -408,7 +408,7 @@ struct pci_dev *of_create_pci_dev(struct
> >  	dev->class = class >> 8;
> >  	dev->revision = class & 0xff;
> >  
> > -	sprintf(dev->dev.bus_id, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
> > +	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
> >  		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
> >  
> >  	if (ofpci_verbose)
> 
> Those lines read:
> 
> 	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
> 		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
> 
> in Linus's current tree.
> 
> What are you patching against?  That first argument is not
> dev->dev.bus_id in any tree I have sitting here, it's always
> pci_name() :-)

Argh, I'm patching against a previous patch that was only sent to Jesse
for the PCI core, sorry for the confusion.

The patch for that is below.  It's probably easier for Jesse to take
both of these in his tree if you like, or I can send you just the Sparc
one, based on HEAD right now, and then the intermediate step in the PCI
patch would not be needed.

thanks,

greg k-h

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: PCI: make pci_name use dev_name

Also fixes up the sparc code that was assuming this is not a constant.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci.c |    2 +-
 include/linux/pci.h       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -408,7 +408,7 @@ struct pci_dev *of_create_pci_dev(struct
 	dev->class = class >> 8;
 	dev->revision = class & 0xff;
 
-	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+	sprintf(dev->dev.bus_id, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
 		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
 	if (ofpci_verbose)
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -977,9 +977,9 @@ static inline void pci_set_drvdata(struc
 /* If you want to know what to call your pci_dev, ask this function.
  * Again, it's a wrapper around the generic device.
  */
-static inline char *pci_name(struct pci_dev *pdev)
+static inline const char *pci_name(struct pci_dev *pdev)
 {
-	return pdev->dev.bus_id;
+	return dev_name(&pdev->dev);
 }
 
 
