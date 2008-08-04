Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYHDCwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYHDCwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYHDCvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:51:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36441 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYHDCvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:51:53 -0400
Date: Sun, 3 Aug 2008 20:51:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Message-ID: <20080804025137.GI26461@parisc-linux.org>
References: <1217786532.4179.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 01:02:12PM -0500, James Bottomley wrote:
> +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> +{
> +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> +
> +	dev_printk(KERN_ERR, &pdev->dev,
> +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> +		   parent->dev.bus_id, parent->vendor, parent->device);
> +	dev_printk(KERN_ERR, &pdev->dev, "%s\n", reason);
> +	dev_printk(KERN_ERR, &pdev->dev, "Please report to linux-kernel@vger.kernel.org\n");
> +	WARN_ON(1);
> +}

Will the dev_printk() strings be included in the kerneloops report?  And
what if there is no parent of the device?  Consider device 00:02.0 on my
laptop:

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
        Subsystem: Fujitsu Limited. Device 13fe
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16

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

Couldn't this be written more concisely as:

	if (pdev->msix_enabled) {
		pci_note_irq_problem(pdev, "MSIX routing failure");
		return PCI_LOST_IRQ_DISABLE_MSIX;
	}
	if (pdev->msi_enabled) {
		pci_note_irq_problem(pdev, "MSI routing failure");
		return PCI_LOST_IRQ_DISABLE_MSI;
	}

> +#ifdef CONFIG_ACPI
> +	if (!(acpi_disabled || acpi_noirq)) {
> +		pci_note_irq_problem(pdev, "Potential ACPI misrouting please reboot with acpi=noirq");
> +		/* currently no way to fix acpi on the fly */
> +		return PCI_LOST_IRQ_DISABLE_ACPI;
> +	}
> +#endif
> +	pci_note_irq_problem(pdev, "unknown cause (not MSI or ACPI)");
> +	return PCI_LOST_IRQ_NO_INFORMATION;
> +}
> +EXPORT_SYMBOL(pci_lost_interrupt);
