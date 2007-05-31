Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbXEaEtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbXEaEtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXEaEtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:49:32 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbXEaEtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:49:31 -0400
Date: Wed, 30 May 2007 21:48:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Russell King" <rmk@arm.linux.org.uk>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Message-Id: <20070530214859.ec026ac8.akpm@linux-foundation.org>
In-Reply-To: <86802c440705302136h1f2da2d8j881e062dfa6b7d7a@mail.gmail.com>
References: <200705291844.00308.yinghai.lu@sun.com>
	<20070530201335.94f73eb9.akpm@linux-foundation.org>
	<86802c440705302134l637df0fbm9a3b99eff19201@mail.gmail.com>
	<86802c440705302136h1f2da2d8j881e062dfa6b7d7a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 21:36:41 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On 5/30/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On 5/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Tue, 29 May 2007 18:43:59 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > >
> > > > [PATCH 4/5] serial: convert early_uart to earlycon for 8250
> > >
> > > drivers/serial/8250_early.c: In function 'parse_options':
> > > drivers/serial/8250_early.c:143: error: 'FIX_EARLYCON_MEM_BASE' undeclared (first use in this function)
> > > drivers/serial/8250_early.c:143: error: (Each undeclared identifier is reported only once
> > >
> > > That was with http://userweb.kernel.org/~akpm/config-sony.txt, but this is
> > > going to break a whole pile of architectures (alpha, powerpc, others).
> >
> > alpha, powerpc, others may need sth like ia64, if they do not support fixmap.
> >
> >
> 
> or create dummy fixmap.h that doesn't support fixmap.
> 

You could require that the architecture implement some specific function
for mapping the early-uart.  Say,

void __iomem *map_early_uart(unsigned long phys_addr, unsigned long len);
void unmap_early_uart(void * __iomem *addr);

then, in drivers/serial/8250_early.c, do


void __iomem * __attribute__((weak))
map_early_uart(unsigned long phys_addr, unsigned long len)
{
	return ioremap(phys_addr, len);
}

void __attribute__((weak)) unmap_early_uart(void * __iomem *addr)
{
	iounmap(addr);
}

and in arch/i386/mm/ioremap.c



#ifdef CONFIG_something

void __iomem *map_early_uart(unsigned long phys_addr, unsigned long len)
{
	void __iomem * vaddr;
	set_fixmap_nocache(idx, phys & PAGE_MASK);
	vaddr = (void __iomem *)__fix_to_virt(idx);
	vaddr += phys & ~PAGE_MASK;

	return vaddr;
}

void unmap_early_uart(void * __iomem *addr)
{
	/* nothing to do */
}

#endif

or such.

