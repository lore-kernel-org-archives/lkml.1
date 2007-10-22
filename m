Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXJVTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXJVTHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXJVTHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:07:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40939 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbXJVTHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:07:43 -0400
Date: Mon, 22 Oct 2007 21:07:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, dean gaudet <dean@arctic.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071022190740.GA1695@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471CEEB4.9040807@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 11:40:52AM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >   
> >> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> >> stray mappings, which upsets Xen.
> >>     
> >
> > Again it not just upsets Xen, keeping mappings to freed pages is wrong generally 
> > and violates the x86 (and likely others like PPC) architecture because it can 
> > cause illegal caching attribute aliases.
> >
> > The patch that went into the tree was really not correct -- this
> > bogus optimization should have been unconditionally removed
> > or if you really wanted an ifdef made dependent on !CONFIG_XEN &&
> > !CONFIG_AGP (and likely && !CONFIG_DRM && !CONFIG_anything else that
> > uses uncached mappings in memory). 
> >
> > You just worked around the obvious failure and leave the non obvious
> > rare corruptions in, which isn't a good strategy.
> 
> Well, at least it becomes a known issue and/or placeholder for when Nick

It's hidden now so it causes any obvious failures any more. Just
subtle ones which is much worse.

But why not just disable it?  It's not critical functionality,
just a optimization that unfortunately turned out to be incorrect.

It could be made correct short term by not freeing the pages until
vunmap for example.

> does his grand unified vmap manager.  I guess a clean workaround would
> be to add a CONFIG_XFS_LAZY_UNMAP, and do it at the Kconfig level... 
> I'll cook up a patch.

This option could only be safely set in architectures that don't
care about caching attribute aliases or never remap kernel pages
uncached. That's not x86, powerpc, ia64 at a minimum.

I think the only good short term fix is to turn your ifdef CONFIG_XEN
into a #if 0

-Andi

