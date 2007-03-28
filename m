Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXC1DUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXC1DUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXC1DUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:20:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39521 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbXC1DUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:20:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 1/21] MSI: Simplify BUG() handling in pci_disable_msi()
References: <20070322105328.4AB74DDF3D@ozlabs.org>
Date: Tue, 27 Mar 2007 21:19:23 -0600
In-Reply-To: <20070322105328.4AB74DDF3D@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:27 +1100")
Message-ID: <m1tzw6t5qc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> Although it might be nice to do a printk before BUG'ing, it's really not
> necessary, and it complicates the code.
>

Acked-by: Eric W. Biederman <ebiederm@xmission.com>

> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>
>  drivers/pci/msi.c |   19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> Index: msi-new/drivers/pci/msi.c
> ===================================================================
> --- msi-new.orig/drivers/pci/msi.c
> +++ msi-new/drivers/pci/msi.c
> @@ -646,18 +646,15 @@ void pci_disable_msi(struct pci_dev* dev
>  	if (!entry || !entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
>  		return;
>  	}
> -	if (irq_has_action(dev->first_msi_irq)) {
> - printk(KERN_WARNING "PCI: %s: pci_disable_msi() called without "
> -		       "free_irq() on MSI irq %d\n",
> -		       pci_name(dev), dev->first_msi_irq);
> -		BUG_ON(irq_has_action(dev->first_msi_irq));
> -	} else {
> -		default_irq = entry->msi_attrib.default_irq;
> -		msi_free_irq(dev, dev->first_msi_irq);
>  
> -		/* Restore dev->irq to its default pin-assertion irq */
> -		dev->irq = default_irq;
> -	}
> +	BUG_ON(irq_has_action(dev->first_msi_irq));
> +
> +	default_irq = entry->msi_attrib.default_irq;
> +	msi_free_irq(dev, dev->first_msi_irq);
> +
> +	/* Restore dev->irq to its default pin-assertion irq */
> +	dev->irq = default_irq;
> +
>  	dev->first_msi_irq = 0;
>  }
>  
