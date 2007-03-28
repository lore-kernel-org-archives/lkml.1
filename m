Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbXC1Nfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbXC1Nfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXC1Nfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:35:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44468 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXC1Nfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:35:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Meyer <thomas@m3y3r.de>, Frederic Riss <frederic.riss@gmail.com>,
       Marcus Better <marcus@better.se>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] MSI-X: fix resume crash
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070327015949.GB16477@stusta.de> <20070328121958.GA11290@elte.hu>
	<20070328124121.GA23564@elte.hu> <20070328130326.GA27126@elte.hu>
	<20070328130630.GA28108@elte.hu>
Date: Wed, 28 Mar 2007 07:31:48 -0600
In-Reply-To: <20070328130630.GA28108@elte.hu> (Ingo Molnar's message of "Wed,
	28 Mar 2007 15:06:30 +0200")
Message-ID: <m1slbppk8r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> [...] I'll now re-test Eric's MSI patch.
>
> Eric's patch seems to have done the trick on my T60: i've done 10 
> suspend+resumes and each worked fine. I've tidied up the description 
> part of Eric's patch a bit for upstream application - find it below.

Thanks.  Tidying up the description has been on my todo list for the
last little bit but I just haven't gotten there.

I've gotten at least Tony's sign off on the architectural direction
so there is nothing to prevent this patch from going in.  Unless
Linus or someone wants a more thorough patch this late in the
release cycle.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>


> ---------------------->
> Subject: [patch] MSI-X: fix resume crash
> From: Eric W. Biederman <ebiederm@xmission.com>
>
> I think the right solution is to simply make pci_enable_device just flip 
> enable bits and move the rest of the work someplace else.
>
> However a thorough cleanup is a little extreme for this point in the 
> release cycle, so I think a quick hack that makes the code not stomp the 
> irq when msi irq's are enabled should be the first fix.  Then we can 
> later make the code not change the irqs at all.
>
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
>
> What I'm proposing we do is move the irq allocation code out of 
> pci_enable_device and the irq freeing code out of pci_disable_device in 
> the future.  If we move ia64 to a model where the irq number equal the 
> gsi like we have for x86_64 and are in the middle of for i386 that 
> should be pretty straight forward.  It would even be relatively simple 
> to delay vector allocation in that context until request_irq, if we 
> needed the delayed allocation benefit.  Do you two have any problems 
> with moving in that direction?
>
> If fixing the arch code is unacceptable for some reason I'm not aware of 
> we need to audit the 10-20 drivers that call pci_disable_device in their 
> suspend/resume processing and ensure that they have freed all of the 
> irqs before that point.  Given that I have bug reports on the msi path I 
> know that isn't true.
>
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
