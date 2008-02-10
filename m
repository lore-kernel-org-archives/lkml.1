Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYBJTNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYBJTNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbYBJTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:13:34 -0500
Received: from colo.lackof.org ([198.49.126.79]:60393 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbYBJTNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:13:32 -0500
Date: Sun, 10 Feb 2008 12:13:13 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080210191313.GA9045@colo.lackof.org>
References: <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210145122.GC5299@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 07:51:22AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> Date: Sun, 10 Feb 2008 09:45:28 -0500
> Subject: [PATCH] Change pci_raw_ops to pci_raw_read/write
...
> -static int
> -pci_read (struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
> +static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
> +							int size, u32 *value)
>  {
> -	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
> +	return raw_pci_read(pci_domain_nr(bus), bus->number,
>  				 devfn, where, size, value);

Willy,
Just wondering...why don't we just pass "struct bus*" through to the
raw_pci* ops?
My thinking is if a PCI bus controller or bridge is discovered, then we should
always create a matching "struct bus *".

Your patch looks fine to me but if you (and others) agree with the above,
I can make patch to change the internal interface. The pci_*_config API
needs to remain the same.

...
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -27,7 +27,7 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
>  	pci_write_config_byte(dev, 0xf4, config|0x2);
>  
>  	/* read xTPR register */
> -	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
> +	raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);

Why are we using raw_pci_read here instead of pci_read_config_dword()?
If the pci_write_config_byte() above works, then I expect the read
to work too.

To be clear, this is not a problem with this patch...rather a seperate
problem with the original code.

hth,
grant
