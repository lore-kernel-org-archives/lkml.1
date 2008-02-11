Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYBKHu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYBKHu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYBKHuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:50:16 -0500
Received: from colo.lackof.org ([198.49.126.79]:48339 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYBKHuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:50:14 -0500
Date: Mon, 11 Feb 2008 00:49:54 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: raw_pci_read in quirk_intel_irqbalance
Message-ID: <20080211074954.GA11388@colo.lackof.org>
References: <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com> <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org> <20080210204556.GG5299@parisc-linux.org> <20080210230204.GH5299@parisc-linux.org> <20080211050415.GJ5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211050415.GJ5299@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 10:04:16PM -0700, Matthew Wilcox wrote:
> > "A disabled or non-existent device's configuration register space is
> > hidden. A disabled or non-existent device will return all ones for reads
> > and will drop writes just as if the cycle terminated with a Master Abort
> > on PCI."
> 
> I'd like to thank Grant for pointing out to me that this is exactly what
> the write immediately above this is doing -- enabling device 8 to
> respond to config space cycles.

welcome.

...
> >From f565b65591a3f90a272b1d511e4ab1728861fe77 Mon Sep 17 00:00:00 2001
> From: Matthew Wilcox <matthew@wil.cx>
> Date: Sun, 10 Feb 2008 23:18:15 -0500
> Subject: [PATCH] Use proper abstractions in quirk_intel_irqbalance
> 
> Since we may not have a pci_dev for the device we need to access, we can't
> use pci_read_config_word.  But raw_pci_read is an internal implementation
> detail; it's better to use the architected pci_bus_read_config_word
> interface.  Using PCI_DEVFN instead of a mysterious constant helps
> reassure everyone that we really do intend to access device 8.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  arch/x86/kernel/quirks.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index 1941482..c47208f 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -11,7 +11,7 @@
>  static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
>  {
>  	u8 config, rev;
> -	u32 word;
> +	u16 word;
>  
>  	/* BIOS may enable hardware IRQ balancing for
>  	 * E7520/E7320/E7525(revision ID 0x9 and below)
> @@ -26,8 +26,11 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
>  	pci_read_config_byte(dev, 0xf4, &config);
>  	pci_write_config_byte(dev, 0xf4, config|0x2);

Can you also add a comment which points at the Intel documentation?

http://download.intel.com/design/chipsets/datashts/30300702.pdf
Page 34 documents 0xf4 register.

And I just doubled checked that the 0xf4 register value is restored later
in the quirk (obvious when you look at the code but not from the patch).

> -	/* read xTPR register */
> -	raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);
> +	/*
> +	 * read xTPR register.  We may not have a pci_dev for device 8
> +	 * because it might be hidden until the above write.
> +	 */
> +	pci_bus_read_config_word(dev->bus, PCI_DEVFN(8, 0), 0x4c, &word);

Yeah, this should work even though we don't have a dev for it.

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant
