Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbZABTZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbZABTZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZABTZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:25:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbZABTZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:25:21 -0500
Date: Fri, 2 Jan 2009 20:25:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb: Add missing __init annotations
Message-ID: <20090102192502.GF14249@elte.hu>
References: <adamyedq8p3.fsf@cisco.com> <20090101130255.GA21886@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101130255.GA21886@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Tue, Dec 30, 2008 at 08:18:00PM -0800, Roland Dreier wrote:
> > The current kernel build warns:
> > 
> >     WARNING: vmlinux.o(.text+0x11458): Section mismatch in reference from the function swiotlb_alloc_boot() to the function .init.text:__alloc_bootmem_low()
> >     The function swiotlb_alloc_boot() references
> >     the function __init __alloc_bootmem_low().
> >     This is often because swiotlb_alloc_boot lacks a __init
> >     annotation or the annotation of __alloc_bootmem_low is wrong.
> >     
> >     WARNING: vmlinux.o(.text+0x1011f2): Section mismatch in reference from the function swiotlb_late_init_with_default_size() to the function .init.text:__alloc_bootmem_low()
> >     The function swiotlb_late_init_with_default_size() references
> >     the function __init __alloc_bootmem_low().
> >     This is often because swiotlb_late_init_with_default_size lacks a __init
> >     annotation or the annotation of __alloc_bootmem_low is wrong.
> > 
> > and indeed the functions calling __alloc_bootmem_low() can be marked
> > __init as well.
> > 
> > Signed-off-by: Roland Dreier <rolandd@cisco.com>
> > ---
> > Not 100% sure if this is the correct fix but it seems OK for me.
> > 
> >  arch/x86/kernel/pci-swiotlb_64.c |    2 +-
> >  lib/swiotlb.c                    |    4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
> > index 242c344..8cba374 100644
> > --- a/arch/x86/kernel/pci-swiotlb_64.c
> > +++ b/arch/x86/kernel/pci-swiotlb_64.c
> > @@ -13,7 +13,7 @@
> >  
> >  int swiotlb __read_mostly;
> >  
> > -void *swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> > +void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> >  {
> >  	return alloc_bootmem_low_pages(size);
> >  }
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index fa2dc4e..1b76f78 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -116,7 +116,7 @@ setup_io_tlb_npages(char *str)
> >  __setup("swiotlb=", setup_io_tlb_npages);
> >  /* make io_tlb_overflow tunable too? */
> >  
> > -void * __weak swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> > +void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
> >  {
> >  	return alloc_bootmem_low_pages(size);
> >  }
> > @@ -186,7 +186,7 @@ static void swiotlb_print_info(unsigned long bytes)
> >   * Statically reserve bounce buffer space and initialize bounce buffer data
> >   * structures for the software IO TLB used to implement the DMA API.
> >   */
> > -void __init
> > +void __init __weak
> >  swiotlb_init_with_default_size(size_t default_size)
> 
> This change looks unrealted to __init annotation described in the 
> changelog. Was it intentional?

that hunk definitely looks wrong.

	Ingo
