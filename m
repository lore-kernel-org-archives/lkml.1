Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbXEXU6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbXEXU6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXEXU6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:58:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53779 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXEXU6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:58:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tom.l.nguyen@intel.com, iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: msi_free_irqs #2
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
	<20070524102702.bca37396.akpm@linux-foundation.org>
	<20070524200743.GB14083@beardog.cca.cpqcorp.net>
Date: Thu, 24 May 2007 14:53:08 -0600
In-Reply-To: <20070524200743.GB14083@beardog.cca.cpqcorp.net> (Mike Miller's
	message of "Thu, 24 May 2007 15:07:43 -0500")
Message-ID: <m1lkfedjuz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Could you please try the patch below.  Unless I have misread something
this should fix your problem....

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 000c9ae..2e1d4af 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -404,7 +404,7 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->dev = dev;
 		entry->mask_base = base;
 
-		list_add(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &dev->msi_list);
 	}
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);

> Michael or Eric, would you please review this patch and see if it's OK? Adding
> an else
> between the the if (list_is....) and the writel resolved the Oops. I'm not sure
> how this
> is supposed to work but using entry->mask_base after iounmap'ing seems wrong.

I think I would rather just swap those two lines of code.
We are manually setting the mask bit to make certain the irq doesn't
fire after we free it, and we clearly want to set the mask bit for
all the irq entries.

> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index d9cbd58..0e67723 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -560,10 +560,11 @@ static int msi_free_irqs(struct pci_dev* dev)
>  		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
>  			if (list_is_last(&entry->list, &dev->msi_list))
>  				iounmap(entry->mask_base);
> -
> -			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
> -				  * PCI_MSIX_ENTRY_SIZE
> -				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> +			else
> +				writel(1, entry->mask_base
> +					+ entry->msi_attrib.entry_nr
> +					* PCI_MSIX_ENTRY_SIZE
> +					+ PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
>  		}
>  		list_del(&entry->list);
>  		kfree(entry);
> -----------------------------------------------------------------------------------------
>
> I hope this clears up a little of the fog.

Yes it does thanks.

Eric
