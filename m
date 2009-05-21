Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZEULqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZEULqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZEULqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:46:01 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:55004 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242AbZEULp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:45:59 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, beckyb@kernel.crashing.org,
       okir@suse.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, gregkh@suse.de
In-Reply-To: <20090521201951I.fujita.tomonori@lab.ntt.co.jp>
References: <1242901733.22654.138.camel@zakaz.uk.xensource.com>
	 <20090521193910W.fujita.tomonori@lab.ntt.co.jp>
	 <1242903785.22654.157.camel@zakaz.uk.xensource.com>
	 <20090521201951I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 21 May 2009 12:45:35 +0100
Message-Id: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: Where do we stand with the Xen patches?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=ez88a1iWV38A:10 a=-82-ppXOAuYA:10 a=AZfGcq7nAAAA:8 a=y17F1dd-FnG1m59uqQwA:9 a=G8RfJF60HiEX-KzJIskA:7 a=KBtJPBujKLwMbhol9VQh9GqEo7MA:4 a=ffKWaBO-ZW4rYnCi:21 a=jdS2Gfu7OU8xr2Bw:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 20:19 +0900, FUJITA Tomonori wrote:
> On Thu, 21 May 2009 12:03:05 +0100
> Ian Campbell <ijc@hellion.org.uk> wrote:
> 
> > On Thu, 2009-05-21 at 06:39 -0400, FUJITA Tomonori wrote:
> > > On Thu, 21 May 2009 11:28:53 +0100
> > > Ian Campbell <ijc@hellion.org.uk> wrote:
> > >  
> > > > +#ifdef CONFIG_PCI_XEN
> > > > +extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
> > > > +#else
> > > > +static inline int xen_range_needs_mapping(phys_addr_t paddr, size_t size) { return 0; }
> > > > +#endif
> > > 
> > > I know Xen can do something like this but you think that this is
> > > clean?
> > 
> > Well, defining a static inline function when a CONFIG option is disabled
> > is fairly idiomatic in the kernel and in general hiding these sorts of
> > things in the headers in this way is preferred to having them in .c
> > files. See e.g. the handling of CONFIG_PRINTK in include/linux/kernel.h
> > or CONFIG_HIGHMEM in include/linux/highmem.h for just two examples out
> > of many.
> 
> Well, I know that it's idiomatic, but placing CONFIG_PCI_XEN in
> arch/{x86|ia64}/include/asm/ is a wrong abstraction to me.

Agreed, include/xen/swiotlb.h is the right place for it.

> > > In addition, you also the similar hack in
> > > arch/ia64/include/asm/dma-mapping.h for ia64's dom0 support, I think.
> > > 
> > > IMO, your patch just moves the ugly hacks from lib/swiotlb.c to
> > > arch/{x86|ia64}/include/asm/dma-mapping.h.
> > 
> > I nearly suggested that for this hook it might actually be preferable to
> > put the one line Xen hook directly into swiotlb.c. I didn't think this
> > suggestion would go down very well though.
> 
> Any arch or Xen specific code should not live in swiotlb.c

Again agreed, which is why I didn't suggest it ;-)

> > In any case something along these lines needs to go somewhere. I think
> > you are slightly mischaracterising this as an "ugly hack" -- it is a
> > necessary interface to enable a particular use-case, and it actually has
> > a very small cross section (it's basically five or six lines of code).
> 

> 
> A necessary interface? Sorry, I don't buy it. It's necessary for
> only Xen. And it's not fit well for swiotlb and the architecture
> abstraction.

I said "necessary interface to enable a particular use-case". Xen is a
valid use case -- I appreciate that you personally may have no interest
in it but plenty of people do and plenty of people would like to see it
working in the mainline kernels.

In terms of clean abstraction this is a architecture hook to allow
mappings to be forced through the swiotlb. It is essentially a more
flexible extension to the existing swiotlb_force flag, in fact
swiotlb_force_mapping() might even be a better name for it.

IMHO, the benefits here (working Xen domain 0 plus PCI passthrough to
guest domains) are well worth the costs.

> > If there was a cleaner way to achieve the same result we would of course
> > go with that. I don't think duplicating swiotlb.c, as has been suggested
> > as the alternative, just for that one hook point makes sense.
> 
> One hook? You need to reread swiotlb.c. There are more. All should go.

I meant that swiotlb_range_needs_mapping is the single contentious hook
as far as I can tell. It is the only one which you appear to be
disputing the very existence of (irrespective of whether it uses __weak
or is moved into asm/dma-mapping.h). The other existing __weak hooks are
useful to other users too and all can, AFAICT, be moved into
asm/dma-mapping.h.

You have already dealt with moving swiotlb_address_needs_mapping and I
am currently looking into the the phys_to_bus and bus_to_phys ones. That
just leaves the alloc functions, which are next on my list after
phys_to_bus and bus_to_phys. Will finishing up those patches resolve
most of your objections are do you have others?

Ian.

-- 
Ian Campbell

This supersedes all previous notices.

