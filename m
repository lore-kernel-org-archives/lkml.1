Return-Path: <linux-kernel-owner+w=401wt.eu-S965942AbXC2Eio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965942AbXC2Eio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965944AbXC2Eio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:38:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:48970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965942AbXC2Ein (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:38:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>, luming.yu@intel.com
Subject: Re: [patch] MSI-X: fix resume crash
Date: Thu, 29 Mar 2007 00:30:30 -0400
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas@m3y3r.de>, Frederic Riss <frederic.riss@gmail.com>,
       Marcus Better <marcus@better.se>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070328130326.GA27126@elte.hu> <20070328130630.GA28108@elte.hu>
In-Reply-To: <20070328130630.GA28108@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703290030.31228.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony, Len the way pci_disable_device is being used in a suspend/resume 
> path by a few drivers is completely incompatible with the way irqs are 
> allocated on ia64.  In particular people the following sequence occurs 
> in several drivers.
> 
> probe:
>   pci_enable_device(pdev);
>   request_irq(pdev->irq);
> suspend:
>   pci_disable_device(pdev);
> resume:
>   pci_enable_device(pdev);
> remove:
>   free_irq(pdev->irq);
>   pci_disable_device(pdev);

There are no IA64 machines that support system suspend/resume today --
so you have 0 chance of breaking the IA64 suspend/resume installed base.

My understanding is that Luming Yu has cobbled IA64 S4 support
together for a future release though.

> What I'm proposing we do is move the irq allocation code out of 
> pci_enable_device and the irq freeing code out of pci_disable_device in 
> the future.  If we move ia64 to a model where the irq number equal the 
> gsi like we have for x86_64 and are in the middle of for i386 that 
> should be pretty straight forward. It would even be relatively simple  
> to delay vector allocation in that context until request_irq, if we 
> needed the delayed allocation benefit.  Do you two have any problems 
> with moving in that direction?

I think consistency here would be _wonderful_.
Of course the beauty of having identity GSI=IRQ and a /proc/interrupts
that tells you what IOAPIC pin you are using become moot with MSI --
but hey, showing the IRQ number rather than the vector number
is consistent and makes sense.

> If fixing the arch code is unacceptable for some reason I'm not aware of 
> we need to audit the 10-20 drivers that call pci_disable_device in their 
> suspend/resume processing and ensure that they have freed all of the 
> irqs before that point.  Given that I have bug reports on the msi path I 
> know that isn't true.

I think the suspend/resume interrupt logic needs some serious attention.
We've had several schemes for suspend/resume of interrupts, several
changes in strategy, and right now I think we are inconsistent,
and frankly, I'm amazed it works at all.

-Len


> From: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/cris/arch-v32/drivers/pci/bios.c |    4 +++-
>  arch/frv/mb93090-mb00/pci-vdk.c       |    3 ++-
>  arch/i386/pci/common.c                |    6 ++++--
>  arch/ia64/pci/pci.c                   |    8 ++++++--
>  4 files changed, 15 insertions(+), 6 deletions(-)
> 
> Index: linux/arch/cris/arch-v32/drivers/pci/bios.c
> ===================================================================
> --- linux.orig/arch/cris/arch-v32/drivers/pci/bios.c
> +++ linux/arch/cris/arch-v32/drivers/pci/bios.c
> @@ -100,7 +100,9 @@ int pcibios_enable_device(struct pci_dev
>  	if ((err = pcibios_enable_resources(dev, mask)) < 0)
>  		return err;
>  
> -	return pcibios_enable_irq(dev);
> +	if (!dev->msi_enabled)
> +		pcibios_enable_irq(dev);
> +	return 0;
>  }
>  
>  int pcibios_assign_resources(void)
> Index: linux/arch/frv/mb93090-mb00/pci-vdk.c
> ===================================================================
> --- linux.orig/arch/frv/mb93090-mb00/pci-vdk.c
> +++ linux/arch/frv/mb93090-mb00/pci-vdk.c
> @@ -466,6 +466,7 @@ int pcibios_enable_device(struct pci_dev
>  
>  	if ((err = pcibios_enable_resources(dev, mask)) < 0)
>  		return err;
> -	pcibios_enable_irq(dev);
> +	if (!dev->msi_enabled)
> +		pcibios_enable_irq(dev);
>  	return 0;
>  }
> Index: linux/arch/i386/pci/common.c
> ===================================================================
> --- linux.orig/arch/i386/pci/common.c
> +++ linux/arch/i386/pci/common.c
> @@ -434,11 +434,13 @@ int pcibios_enable_device(struct pci_dev
>  	if ((err = pcibios_enable_resources(dev, mask)) < 0)
>  		return err;
>  
> -	return pcibios_enable_irq(dev);
> +	if (!dev->msi_enabled)
> +		return pcibios_enable_irq(dev);
> +	return 0;
>  }
>  
>  void pcibios_disable_device (struct pci_dev *dev)
>  {
> -	if (pcibios_disable_irq)
> +	if (!dev->msi_enabled && pcibios_disable_irq)
>  		pcibios_disable_irq(dev);
>  }
> Index: linux/arch/ia64/pci/pci.c
> ===================================================================
> --- linux.orig/arch/ia64/pci/pci.c
> +++ linux/arch/ia64/pci/pci.c
> @@ -557,14 +557,18 @@ pcibios_enable_device (struct pci_dev *d
>  	if (ret < 0)
>  		return ret;
>  
> -	return acpi_pci_irq_enable(dev);
> +	if (!dev->msi_enabled)
> +		return acpi_pci_irq_enable(dev);
> +	return 0;
>  }
>  
>  void
>  pcibios_disable_device (struct pci_dev *dev)
>  {
>  	BUG_ON(atomic_read(&dev->enable_cnt));
> -	acpi_pci_irq_disable(dev);
> +	if (!dev->msi_enabled)
> +		acpi_pci_irq_disable(dev);
> +	return 0;
>  }
>  
>  void
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
