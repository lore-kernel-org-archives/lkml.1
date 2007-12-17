Return-Path: <linux-kernel-owner+w=401wt.eu-S935999AbXLQWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999AbXLQWLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbXLQWLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:11:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:58431 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbXLQWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:11:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="343569171"
Message-ID: <4766F0CD.30908@intel.com>
Date: Mon, 17 Dec 2007 13:57:33 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] PCI: fix for quirk_e100_interrupt()
References: <20071218003927.A3045@jurassic.park.msu.ru>
In-Reply-To: <20071218003927.A3045@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2007 21:58:09.0687 (UTC) FILETIME=[E9650270:01C840F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Check that the e100 is in the D0 power state. If it's not, it won't
> respond to MMIO accesses and we end up with master-abort machine
> checks on some platforms.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

what kind of platform actually is doing this? It almost seems like something is
wrong with that platform's BIOS and I wonder if this workaround should not be more
general (IOW is it not just e100 that is affected but other components as well?)

Auke


> ---
>  drivers/pci/quirks.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 26cc4dc..c8b2b9d 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1406,9 +1406,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID, quirk_netmos);
>  
>  static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
>  {
> -	u16 command;
> +	u16 command, pmcsr;
>  	u8 __iomem *csr;
>  	u8 cmd_hi;
> +	int pm;
>  
>  	switch (dev->device) {
>  	/* PCI IDs taken from drivers/net/e100.c */
> @@ -1442,6 +1443,17 @@ static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
>  	if (!(command & PCI_COMMAND_MEMORY) || !pci_resource_start(dev, 0))
>  		return;
>  
> +	/*
> +	 * Check that the device is in the D0 power state. If it's not,
> +	 * there is no point to look any further.
> +	 */
> +	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
> +	if (pm) {
> +		pci_read_config_word(dev, pm + PCI_PM_CTRL, &pmcsr);
> +		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) != PCI_D0)
> +			return;
> +	}
> +
>  	/* Convert from PCI bus to resource space.  */
>  	csr = ioremap(pci_resource_start(dev, 0), 8);
>  	if (!csr) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

