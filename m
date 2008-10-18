Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbYJRWco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbYJRWco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYJRWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:32:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYJRWci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:32:38 -0400
Date: Sun, 19 Oct 2008 00:32:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
Message-ID: <20081018223214.GA5093@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie> <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224366690.4384.89.camel@koto.keithp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Keith Packard <keithp@keithp.com> wrote:

> On Sat, 2008-10-18 at 22:37 +0200, Ingo Molnar wrote:
> 
> > But i think the direction of the new GEM code is subtly wrong here, 
> > because it tries to manage memory even on 64-bit systems. IMO it 
> > should just map the _whole_ graphics aperture (non-cached) and be 
> > done with it. There's no faster method at managing pages than the 
> > CPU doing a TLB fill from pagetables.
> 
> Yeah, we're stuck thinking that we "can't" map the aperture because 
> it's too large, but with a 64-bit kernel, we should be able to keep it 
> mapped permanently.
> 
> Of course, the io_reserve_pci_resource and io_map_atomic functions 
> could do precisely that, as kmap_atomic does on non-HIGHMEM systems 
> today.

okay, so basically what we need is a shared API that does per page 
kmap_atomic on 32-bit, and just an ioremap() on 64-bit. I had the 
impression that you were suggesting to extend kmap_atomic() to 64-bit - 
which would be wrong.

So, in terms of the 4 APIs you suggest:

  struct io_mapping *io_reserve_pci_resource(struct pci_dev *dev,
                                             int bar,
                                             int prot);
  void io_mapping_free(struct io_mapping *mapping);

  void *io_map_atomic(struct io_mapping *mapping, unsigned long pfn);
  void io_unmap_atomic(struct io_mapping *mapping, unsigned long pfn);

here is what we'd do on 64-bit:

  - io_reserve_pci_resource() would just do an ioremap(), and would save 
    the ioremap-ed memory into struct io_mapping.

  - io_mapping_free() does the iounmap()

  - io_map_atomic(): just arithmetics, returns mapping->base + pfn - no 
    TLB activities at all.

  - io_unmap_atomic(): NOP.

it's as fast as it gets: zero overhead in essence. Note that it's also 
shared between all CPUs and there's no aliasing trouble.

And we could make it even faster: if you think we could even use 2MB 
TLBs for the _linear_ ioremap()s here, hm? There's plenty of address 
space on 64-bit so we can align to 2MB just fine - and aperture sizes 
are 2MB sized anyway.

Or we could go one step further and install these aperture mappings into 
the _kernel linear_ address space. That would be even faster, because 
we'd have a constant offset. We have the (2MB mappings aware) mechanism 
for that already. (Yinghai Cc:-ed - he did a lot of great work to 
generalize this area.)

(In fact if we installed it into the linear kernel address space, and if 
the aperture is 1GB aligned, we will automatically use gbpages for it. 
Were Intel to support gbpages in the future ;-)

the _real_ remapping in a graphics aperture happens on the GPU level 
anyway, you manage an in-RAM GPU pagetable that just works like an 
IOMMU, correct?

on 32-bit we'd have what you use in the GEM code today:

  - io_reserve_pci_resource(): a NOP in essence

  - io_mapping_free(): a NOP

  - io_map_atomic(): does a kmap_atomic(pfn)

  - io_unmap_atomic(): does a kunmap_atomic(pfn)

so on 32-bit we have the INVLPG TLB overhead and preemption restrictions 
- but we knew that. We'd have to allow atomic_kmap() on non-highmem as 
well but that's fair.

Mind sending patches for this? :-)

	Ingo
