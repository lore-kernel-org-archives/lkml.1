Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXEXVLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXEXVLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXEXVLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:11:16 -0400
Received: from palrel10.hp.com ([156.153.255.245]:56679 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXEXVLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:11:15 -0400
Date: Thu, 24 May 2007 16:11:12 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tom.l.nguyen@intel.com, iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: msi_free_irqs #2
Message-ID: <20070524211112.GE14083@beardog.cca.cpqcorp.net>
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net> <20070524102702.bca37396.akpm@linux-foundation.org> <20070524200743.GB14083@beardog.cca.cpqcorp.net> <m1lkfedjuz.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkfedjuz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 02:53:08PM -0600, Eric W. Biederman wrote:
> 
> 
> Could you please try the patch below.  Unless I have misread something
> this should fix your problem....
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 000c9ae..2e1d4af 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -404,7 +404,7 @@ static int msix_capability_init(struct pci_dev *dev,
>  		entry->dev = dev;
>  		entry->mask_base = base;
>  
> -		list_add(&entry->list, &dev->msi_list);
> +		list_add_tail(&entry->list, &dev->msi_list);
>  	}
>  
>  	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
> 
> > Michael or Eric, would you please review this patch and see if it's OK? Adding
> > an else
> > between the the if (list_is....) and the writel resolved the Oops. I'm not sure
> > how this
> > is supposed to work but using entry->mask_base after iounmap'ing seems wrong.
> 
> I think I would rather just swap those two lines of code.
> We are manually setting the mask bit to make certain the irq doesn't
> fire after we free it, and we clearly want to set the mask bit for
> all the irq entries.
> 
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > index d9cbd58..0e67723 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -560,10 +560,11 @@ static int msi_free_irqs(struct pci_dev* dev)
> >  		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
> >  			if (list_is_last(&entry->list, &dev->msi_list))
> >  				iounmap(entry->mask_base);
> > -
> > -			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
> > -				  * PCI_MSIX_ENTRY_SIZE
> > -				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> > +			else
> > +				writel(1, entry->mask_base
> > +					+ entry->msi_attrib.entry_nr
> > +					* PCI_MSIX_ENTRY_SIZE
> > +					+ PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> >  		}
> >  		list_del(&entry->list);
> >  		kfree(entry);

Here's a patch that just reverses the 2 lines of code as Eric suggests. Please
consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Chase Maupin <chase.maupin@hp.com>

Thanks,
mikem
----------------------------------------------------------------------------------------
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e01380b..6632150 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -558,12 +558,12 @@ static int msi_free_irqs(struct pci_dev* dev)
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
-			if (list_is_last(&entry->list, &dev->msi_list))
-				iounmap(entry->mask_base);
-
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+
+			if (list_is_last(&entry->list, &dev->msi_list))
+				iounmap(entry->mask_base);
 		}
 		list_del(&entry->list);
 		kfree(entry);
