Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXITGhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXITGhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXITGhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:37:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbXITGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:37:42 -0400
Date: Wed, 19 Sep 2007 23:37:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valentine Barshak <vbarshak@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] pci: Fix e100 interrupt quirk
Message-Id: <20070919233726.9d81b674.akpm@linux-foundation.org>
In-Reply-To: <20070918111737.GA7026@ru.mvista.com>
References: <20070918111737.GA7026@ru.mvista.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 15:17:37 +0400 Valentine Barshak <vbarshak@ru.mvista.com> wrote:

> PCI memory space may have a 64-bit offset on some architectures
> (for example, PowerPC 440) and the actual PCI memory address
> has to fixed up (an offset to PCI mem space shuld be added)
> before remapping. So, pci_iomap should be used instead of
> reading and remapping PCI BAR directly. This has been tested
> on Sequoia PowerPC 440EPx board.
> 
> Signed-off-by: Valentine Barshak <vbarshak@ru.mvista.com>
> ---
> 
> --- linux-2.6.orig/drivers/pci/quirks.c	2007-09-04 21:15:43.000000000 +0400
> +++ linux-2.6.bld/drivers/pci/quirks.c	2007-09-05 20:46:14.000000000 +0400
> @@ -1444,9 +1444,9 @@
>  static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
>  {
>  	u16 command;
> -	u32 bar;
>  	u8 __iomem *csr;
>  	u8 cmd_hi;
> +	int rc;
>  
>  	switch (dev->device) {
>  	/* PCI IDs taken from drivers/net/e100.c */
> @@ -1476,16 +1476,17 @@
>  	 * re-enable them when it's ready.
>  	 */
>  	pci_read_config_word(dev, PCI_COMMAND, &command);
> -	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0, &bar);
>  
> -	if (!(command & PCI_COMMAND_MEMORY) || !bar)
> +	rc = pci_request_region(dev, 0, "e100_quirk");
> +
> +	if (!(command & PCI_COMMAND_MEMORY) || (rc < 0))
>  		return;

Really?  So if pci_request_region() failed and !(command & PCI_COMMAND_MEMORY),
we leak the region?  So the next call to this function will fail?


> -	csr = ioremap(bar, 8);
> +	csr = pci_iomap(dev, 0, 8);
>  	if (!csr) {
>  		printk(KERN_WARNING "PCI: Can't map %s e100 registers\n",
>  			pci_name(dev));
> -		return;
> +		goto e100_quirk_exit;
>  	}
>  
>  	cmd_hi = readb(csr + 3);
> @@ -1495,7 +1496,9 @@
>  		writeb(1, csr + 3);
>  	}
>  
> -	iounmap(csr);
> +	pci_iounmap(dev, csr);
> +e100_quirk_exit:
> +	pci_release_region(dev, 0);
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_e100_interrupt);
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
