Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXC3TEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXC3TEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXC3TEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:04:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52767 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbXC3TEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:04:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mitch Williams <mitch.a.williams@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, akpm@linux-foundation.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
References: <1175280848.17652.5.camel@strongmad>
Date: Fri, 30 Mar 2007 13:04:02 -0600
In-Reply-To: <1175280848.17652.5.camel@strongmad> (Mitch Williams's message of
	"Fri, 30 Mar 2007 11:54:08 -0700")
Message-ID: <m1irciime5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Williams <mitch.a.williams@intel.com> writes:

> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
>
> Because both MSI-X interrupt messages and MSI-X table writes are posted,
> it's possible for them to cross while in-flight.  This results in
> interrupts being received long after the kernel thinks they're disabled,
> and in interrupts being sent to stale vectors after rebalancing.
>
> This patch performs a read flush after writes to the MSI-X table for
> mask and unmask operations.  Since the SMP affinity is set while
> the interrupt is masked, and since it's unmasked immediately after,
> no additional flushes are required in the various affinity setting
> routines.
>
> This patch has been validated with (unreleased) network hardware which
> uses MSI-X.
>
> Revised with input from Eric Biederman.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
>
> diff -urpN -X dontdiff linux-2.6.21-rc5-clean/drivers/pci/msi.c
> linux-2.6.21-rc5/drivers/pci/msi.c
> --- linux-2.6.21-rc5-clean/drivers/pci/msi.c 2007-03-28 10:05:24.000000000 -0700
> +++ linux-2.6.21-rc5/drivers/pci/msi.c	2007-03-28 09:21:34.000000000 -0700
> @@ -68,6 +68,29 @@ static void msix_set_enable(struct pci_d
>  	}
>  }
>  
> +static void msix_flush_writes(unsigned int irq)
> +{
> +	struct msi_desc *entry;
> +
> +	entry = get_irq_msi(irq);
> +	BUG_ON(!entry || !entry->dev);
> +	switch (entry->msi_attrib.type) {
> +	case PCI_CAP_ID_MSI:
> +		/* nothing to do */
> +		break;
> +	case PCI_CAP_ID_MSIX:
> +	{
> +		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
> +			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> +		readl(entry->mask_base + offset);
> +		break;
> +	}
> +	default:
> +		BUG();
> +		break;
> +	}
> +}
> +
>  static void msi_set_mask_bit(unsigned int irq, int flag)
>  {
>  	struct msi_desc *entry;
> @@ -186,11 +209,13 @@ void write_msi_msg(unsigned int irq, str
>  void mask_msi_irq(unsigned int irq)
>  {
>  	msi_set_mask_bit(irq, 1);
> +	msix_flush_writes(irq);
>  }
>  
>  void unmask_msi_irq(unsigned int irq)
>  {
>  	msi_set_mask_bit(irq, 0);
> +	msix_flush_writes(irq);
>  }
>  
>  static int msi_free_irq(struct pci_dev* dev, int irq);
