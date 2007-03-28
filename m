Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbXC1GaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbXC1GaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXC1GaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:30:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57847 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXC1GaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:30:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 14/21] MSI: Use a list instead of the custom link structure
References: <20070322105343.3B358DDF6D@ozlabs.org>
Date: Wed, 28 Mar 2007 00:29:45 -0600
In-Reply-To: <20070322105343.3B358DDF6D@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:41 +1100")
Message-ID: <m13b3pswx2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> The msi descriptors are linked together with what looks a lot like
> a linked list, but isn't a struct list_head list. Make it one.
>
> The only complication is that previously we walked a list of irqs, and
> got the descriptor for each with get_irq_msi(). Now we have a list of
> descriptors and need to get the irq out of it, so it needs to be in the
> actual struct msi_desc. We use 0 to indicate no irq is setup.
>
> At some point after a pci_dev is created we need to initialise its
> msi_list. pci_device_add() looks like the right place to do that, although
> I'm not convinced it's 100% safe. In drivers/char/agp/alpha-agp.c we create
> a pci_dev and I don't see that it ever gets passed to pci_device_add(), but
> we probably don't care.

Well that one appears to be a dummy place holder and probably should at
least have a kzalloc to initialize all of the fields to know values.

Regardless the normal pci device allocation does use kzalloc so we will
have well defined if not beautiful behavior if we try and use it.

Until we have a case where we need to use the msi_list outside of 
where we enable and disable msi we should be perfectly fine initializing
the list somewhere inside of pci_enable_msi, and pci_enable_msix.
With dev->msi_enabled and dev->msix_enabled serving as flags to the
rest of the world that it is safe to look at the list.

It certainly sounds safer to me then becoming to closely coupled with
code that doesn't really care about how msi works.  Heck even though
we repeat the call twice I bet it will even be less code.

> --- msi-new.orig/include/linux/msi.h
> +++ msi-new/include/linux/msi.h
> @@ -1,6 +1,8 @@
>  #ifndef LINUX_MSI_H
>  #define LINUX_MSI_H
>  
> +#include <linux/list.h>
> +
>  struct msi_msg {
>  	u32	address_lo;	/* low 32 bits of msi message address */
>  	u32	address_hi;	/* high 32 bits of msi message address */
> @@ -24,10 +26,8 @@ struct msi_desc {
>  		unsigned default_irq;	/* default pre-assigned irq	  */
>  	}msi_attrib;
>  
> -	struct {
> -		__u16	head;
> -		__u16	tail;
> -	}link;
> +	int irq;
This should be "unsigned int irq"
> +	struct list_head list;
>  
>  	void __iomem *mask_base;
>  	struct pci_dev *dev;

Eric
