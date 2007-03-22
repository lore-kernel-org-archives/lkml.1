Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbXCVOYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbXCVOYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbXCVOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:24:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42203 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbXCVOYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:24:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 17/21] MSI: Clear the irq_desc's msi pointer on free
References: <20070322105344.A34C6DDF74@ozlabs.org>
Date: Thu, 22 Mar 2007 08:23:33 -0600
In-Reply-To: <20070322105344.A34C6DDF74@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:43 +1100")
Message-ID: <m1slbx8ihm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> Currently we never clear the msi_desc pointer in the irq_desc. This
> leaves us with a pointer to free'ed memory hanging around. No one seems
> to have hit this, so presumably other parts of the code are protecting
> us from ever using the stale pointer .. or we're just lucky, we should
> still clear it.

Hmm.  Maybe.  Currently this is done in dynamic_irq_cleanup,
at least for everything except sparc64.

>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>
>  drivers/pci/msi.c |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: msi-new/drivers/pci/msi.c
> ===================================================================
> --- msi-new.orig/drivers/pci/msi.c
> +++ msi-new/drivers/pci/msi.c
> @@ -520,6 +520,7 @@ static int msi_free_irq(struct pci_dev* 
>  	list_del(&entry->list);
>  
>  	arch_teardown_msi_irq(irq);
> +	set_irq_msi(irq, NULL);
>  	kfree(entry);
>  
>  	if (type == PCI_CAP_ID_MSIX && list_empty(&dev->msi_list))
