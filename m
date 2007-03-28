Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbXC1MQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbXC1MQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXC1MQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:16:18 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55103 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXC1MQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:16:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 16/21] MSI: arch should connect the irq and the msi_desc desc when it's ready
References: <20070322105344.312FEDDF70@ozlabs.org>
Date: Wed, 28 Mar 2007 06:15:37 -0600
In-Reply-To: <20070322105344.312FEDDF70@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:42 +1100")
Message-ID: <m1bqidr2c6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> set_irq_msi() currently connects an irq_desc to an msi_desc. The archs call
> it at some point in their setup routine, and then the generic code sets up the
> reverse mapping from the msi_desc back to the irq.
>
> set_irq_msi() should really do both connections, making it the one and only
> call required to connect an irq with it's MSI desc.

Hmm.  This comment should be a little more forceful than a suggestion
to make ti clear you have made that change somewhere in this
patch.

> It should be the arch code that calls set_irq_msi(), and it should do so
> only once it's sure it's not going to fail the irq allocation.
>
> Given that there's no need for the arch to return the irq anymore, the return
> value from the arch setup routine just becomes 0 for success and !0 for
> failure.

Call it negative for failure, or possibly nonzero.  !0 == 1  Which
isn't what you meant, and is confusing comparing it to the code.

Ok.  This is likely me limit of picking on your patches for tonight.



> Index: msi-new/arch/ia64/kernel/msi_ia64.c
> ===================================================================
> --- msi-new.orig/arch/ia64/kernel/msi_ia64.c
> +++ msi-new/arch/ia64/kernel/msi_ia64.c
> @@ -74,7 +74,6 @@ int ia64_setup_msi_irq(struct pci_dev *p
>  	if (irq < 0)
>  		return irq;
>  
> -	set_irq_msi(irq, desc);
>  	dest_phys_id = cpu_physical_id(first_cpu(cpu_online_map));
>  	vector = irq;
>  
> @@ -91,11 +90,13 @@ int ia64_setup_msi_irq(struct pci_dev *p
>  		MSI_DATA_DELIVERY_FIXED |
>  		MSI_DATA_VECTOR(vector);
>  
> +	desc->irq = irq;
Setting desc->irq just before set_irq_msi appears redundant here.
> +	set_irq_msi(irq, desc);
>  	set_irq_chip_and_handler(irq, &ia64_msi_chip, handle_edge_irq);
>  	get_irq_chip(irq)->mask(irq);
>  	write_msi_msg(irq, &msg);
>  
> -	return irq;
> +	return 0;
>  }
>  
>  void ia64_teardown_msi_irq(unsigned int irq)

Eric
