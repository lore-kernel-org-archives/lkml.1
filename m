Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZCGW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZCGW23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbZCGW2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:28:21 -0500
Received: from relais.videotron.ca ([24.201.245.36]:45000 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZCGW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:28:20 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_HyeKNxqBgOgLF95hf5wMHA)"
Date: Sat, 07 Mar 2009 17:28:06 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC] atomic highmem kmap page pinning
In-reply-to: <28c262360903051514n53e54df8x935aa398e16795ce@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0903071721040.30483@xanadu.home>
References: <alpine.LFD.2.00.0903040014140.5511@xanadu.home>
 <20090304171429.c013013c.minchan.kim@barrios-desktop>
 <alpine.LFD.2.00.0903041101170.5511@xanadu.home>
 <20090305080717.f7832c63.minchan.kim@barrios-desktop>
 <alpine.LFD.2.00.0903042129140.5511@xanadu.home>
 <20090305132054.888396da.minchan.kim@barrios-desktop>
 <alpine.LFD.2.00.0903042350210.5511@xanadu.home>
 <28c262360903051423g1fbf5067i9835099d4bf324ae@mail.gmail.com>
 <20090305225921.GE918@n2100.arm.linux.org.uk>
 <28c262360903051514n53e54df8x935aa398e16795ce@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_HyeKNxqBgOgLF95hf5wMHA)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Fri, 6 Mar 2009, Minchan Kim wrote:

> On Fri, Mar 6, 2009 at 7:59 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Mar 06, 2009 at 07:23:44AM +0900, Minchan Kim wrote:
> >> > +#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> >> > +/**
> >> > + * kmap_high_get - pin a highmem page into memory
> >> > + * @page: &struct page to pin
> >> > + *
> >> > + * Returns the page's current virtual memory address, or NULL if no mapping
> >> > + * exists.  When and only when a non null address is returned then a
> >> > + * matching call to kunmap_high() is necessary.
> >> > + *
> >> > + * This can be called from any context.
> >> > + */
> >> > +void *kmap_high_get(struct page *page)
> >> > +{
> >> > +       unsigned long vaddr, flags;
> >> > +
> >> > +       spin_lock_kmap_any(flags);
> >> > +       vaddr = (unsigned long)page_address(page);
> >> > +       if (vaddr) {
> >> > +               BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
> >> > +               pkmap_count[PKMAP_NR(vaddr)]++;
> >> > +       }
> >> > +       spin_unlock_kmap_any(flags);
> >> > +       return (void*) vaddr;
> >> > +}
> >> > +#endif
> >>
> >> Let's add empty function for architecture of no ARCH_NEEDS_KMAP_HIGH_GET,
> >
> > The reasoning being?
> 
> I thought it can be used in common arm function.
> so, for VIVT, it can be work but for VIPT, it can be nulled as
> preventing compile error.

The issue is not about VIVT vs VIPT, but rather about the fact that IO 
transactions don't snoop the cache.  So this is needed even for current 
VIPT implementations.

> But, I don't know where we use kmap_high_get since I didn't see any
> patch which use it.
> If it is only used architecture specific place,  pz, forgot my comment.

Yes, that's the case.  And it is much preferable to have a compilation 
error than providing an empty stub to silently mask out misuses.


Nicolas

--Boundary_(ID_HyeKNxqBgOgLF95hf5wMHA)--
