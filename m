Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYHERDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYHERDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760360AbYHERDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:03:16 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:50650 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758794AbYHERDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:03:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=tL0fQxS60B0b0SheU/AnlvG8/NxjAzOIZsKUpmYWDxWdJCyrt0LSFrq8/bsNZe5NlFb6loOzL/v8ZBrXUn5eeu/PdzgR8pMapbM47MrYDQAaaGQlHCZ5/LrZFz4fIF3m;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 5 Aug 2008 10:03:10 -0700
User-Agent: KMail/1.9.9
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain>
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051003.10400.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 03, 2008 11:02 am James Bottomley wrote:
> +/**
> + * pci_lost_interrupt - reports a lost PCI interrupt
> + * @pdev:	device whose interrupt is lost
> + *
> + * The primary function of this routine is to report a lost interrupt
> + * in a standard way which users can recognise (instead of blaming the
> + * driver).
> + *
> + * Returns:
> + *  a suggestion for fixing it (although the driver is not required to
> + * act on this).
> + */
> +enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *pdev)
> +{
> +	if (pdev->msi_enabled || pdev->msix_enabled) {
> +		enum pci_lost_interrupt_reason ret;
> +
> +		if (pdev->msix_enabled) {
> +			pci_note_irq_problem(pdev, "MSIX routing failure");
> +			ret = PCI_LOST_IRQ_DISABLE_MSIX;
> +		} else {
> +			pci_note_irq_problem(pdev, "MSI routing failure");
> +			ret = PCI_LOST_IRQ_DISABLE_MSI;
> +		}
> +		return ret;
> +	}
> +#ifdef CONFIG_ACPI
> +	if (!(acpi_disabled || acpi_noirq)) {
> +		pci_note_irq_problem(pdev, "Potential ACPI misrouting please reboot with
> acpi=noirq"); +		/* currently no way to fix acpi on the fly */
> +		return PCI_LOST_IRQ_DISABLE_ACPI;
> +	}
> +#endif
> +	pci_note_irq_problem(pdev, "unknown cause (not MSI or ACPI)");
> +	return PCI_LOST_IRQ_NO_INFORMATION;
> +}

This seems to be a function that just returns what type of IRQ you're using or 
how it's routed and it isn't necessarily "lost interrupt" specific.

This information is clearly useful to drivers both for informational purposes 
and for debugging problems, so on that front it looks good.  However, I think 
it should probably be called pci_interrupt_type(struct pci_dev *dev) or 
something instead, and just return an enum of either MSIX, MSI, or LINE 
(though I'm open to better names).  From that, the driver can infer what 
might be going wrong, though in the case of a LINE interrupt, all you can 
really do is report that there's probably a platform IRQ routing problem.

Jesse
