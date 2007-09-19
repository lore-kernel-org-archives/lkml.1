Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXISKlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXISKlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbXISKlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:41:39 -0400
Received: from mx12.go2.pl ([193.17.41.142]:37043 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756596AbXISKli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:41:38 -0400
Date: Wed, 19 Sep 2007 12:43:42 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Valentine Barshak <vbarshak@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix e100 interrupt quirk
Message-ID: <20070919104342.GB3226@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918111737.GA7026@ru.mvista.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-09-2007 13:17, Valentine Barshak wrote:
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

I didn't look at this too much, but isn't something like:
		if (rc >=  0)
			goto e100_quirk_exit;
needed before this return?

Regards,
Jarek P.
