Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYGGQp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYGGQp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYGGQpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:45:50 -0400
Received: from colo.lackof.org ([198.49.126.79]:59800 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYGGQps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:45:48 -0400
Date: Mon, 7 Jul 2008 10:45:34 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       michael@ellerman.id.au, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/4] AHCI: Request multiple MSIs
Message-ID: <20080707164534.GF7521@colo.lackof.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-3-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215264855-4372-3-git-send-email-matthew@wil.cx>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 09:34:14AM -0400, Matthew Wilcox wrote:
> AHCI controllers can support up to 16 interrupts, one per port.  This
> saves us a readl() in the interrupt path to determine which port has
> generated the interrupt.

If the system is busy, the readl is the cost of coalescing the
interrupts.  I suspect it's cheaper to take one readl than
handle 16 individual interrupts.

I'm just pointing out the only upside of the existing code and not trying
to argue against this patch.

Can you confirm the upside for the use case of when multiple SSDs are attached?

Avoiding the readl _and_ the loop will work much better if interrupts
are getting redirected to multiple CPUs. Latency for each drive will
be substantially lower and handle many more IOPS.

Hrm...without targeting a particular socket on a multi-socket machine,
spinlocks and control data cachelines are going to bounce around alot.
*shrug*

BTW, one more downside of the regular IRQ is it's possibly shared.
Using MSI guaratees exclusive IRQ and avoids spurious readl's
when AHCI is not busy but the other device is. This would be worth
noting (or as a reminder) in the change log or as a comment in
the code.


hth,
grant

> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/ata/ahci.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 79 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 061817a..4b2f90a 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -102,6 +102,7 @@ enum {
>  	/* HOST_CTL bits */
>  	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
>  	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
> +	HOST_MSI_RSM		= (1 << 2),  /* Revert to Single Message */
>  	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
>  
>  	/* HOST_CAP bits */
> @@ -1771,6 +1772,13 @@ static void ahci_port_intr(struct ata_port *ap)
>  	}
>  }
>  
> +static irqreturn_t ahci_msi_interrupt(int irq, void *dev_instance)
> +{
> +	struct ata_port *ap = dev_instance;
> +	ahci_port_intr(ap);
> +	return IRQ_HANDLED;
> +}
> +
>  static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
>  {
>  	struct ata_host *host = dev_instance;
> @@ -2210,6 +2218,66 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
>  	}
>  }
>  
> +static int ahci_request_irqs(struct pci_dev *pdev, struct ata_host *host)
> +{
> +	int i, n_irqs, rc;
> +	struct ahci_host_priv *hpriv = host->private_data;
> +
> +	if (hpriv->flags & AHCI_HFLAG_NO_MSI) {
> +		n_irqs = 1;
> +	} else {
> +		u16 control;
> +		int pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
> +		pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &control);
> +		n_irqs = 1 << ((control & PCI_MSI_FLAGS_QMASK) >> 1);
> +
> +		for (;;) {
> +			rc = pci_enable_msi_block(pdev, n_irqs);
> +			if (rc == 0) {
> +				void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
> +				u32 host_ctl = readl(mmio + HOST_CTL);
> +				if ((host_ctl & HOST_MSI_RSM) == 0)
> +					break;
> +				pci_disable_msi(pdev);
> +				n_irqs = 1;
> +			} else if (rc < 0) {
> +				n_irqs = 1;
> +				pci_intx(pdev, 1);
> +				break;
> +			} else {
> +				n_irqs = rc;
> +			}
> +		}
> +	}
> +
> +	/* FIXME: Add support for CCC */
> +	if (n_irqs > host->n_ports) {
> +		n_irqs = host->n_ports;
> +	} else if (n_irqs < host->n_ports) {
> +		n_irqs--;
> +		rc = devm_request_irq(host->dev, pdev->irq + n_irqs,
> +				ahci_interrupt, IRQF_SHARED,
> +				dev_driver_string(host->dev), host);
> +		if (rc)
> +			goto release_block;
> +	}
> +
> +	for (i = 0; i < n_irqs; i++) {
> +		rc = devm_request_irq(host->dev, pdev->irq + i,
> +				ahci_msi_interrupt, IRQF_SHARED,
> +				dev_driver_string(host->dev), host->ports[i]);
> +		if (rc)
> +			goto release_block;
> +	}
> +
> +	return 0;
> +
> + release_block:
> +	pci_disable_msi(pdev);
> +	pci_intx(pdev, 1);
> +	return rc;
> +}
> +
>  static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	static int printed_version;
> @@ -2268,9 +2336,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))
>  		hpriv->flags |= AHCI_HFLAG_NO_MSI;
>  
> -	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
> -		pci_intx(pdev, 1);
> -
>  	/* save initial config */
>  	ahci_save_initial_config(pdev, hpriv);
>  
> @@ -2325,8 +2390,17 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	ahci_print_info(host);
>  
>  	pci_set_master(pdev);
> -	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
> -				 &ahci_sht);
> +
> +	rc = ata_host_start(host);
> +	if (rc)
> +		return rc;
> +
> +	rc = ahci_request_irqs(pdev, host);
> +	if (rc)
> +		return rc;
> +
> +	rc = ata_host_register(host, &ahci_sht);
> +	return rc;
>  }
>  
>  static int __init ahci_init(void)
> -- 
> 1.5.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
