Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbXJVWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbXJVWdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXJVWdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:33:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50949 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbXJVWdF (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:33:05 -0400
Date: Tue, 23 Oct 2007 08:32:25 +1000
From: David Chinner <dgc@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, dean gaudet <dean@arctic.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071022223224.GC995458@sgi.com>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022190740.GA1695@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 09:07:40PM +0200, Andi Kleen wrote:
> On Mon, Oct 22, 2007 at 11:40:52AM -0700, Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > >   
> > >> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> > >> stray mappings, which upsets Xen.
> > >>     
> > >
> > > Again it not just upsets Xen, keeping mappings to freed pages is wrong generally 
> > > and violates the x86 (and likely others like PPC) architecture because it can 
> > > cause illegal caching attribute aliases.
> > >
> > > The patch that went into the tree was really not correct -- this
> > > bogus optimization should have been unconditionally removed
> > > or if you really wanted an ifdef made dependent on !CONFIG_XEN &&
> > > !CONFIG_AGP (and likely && !CONFIG_DRM && !CONFIG_anything else that
> > > uses uncached mappings in memory). 
> > >
> > > You just worked around the obvious failure and leave the non obvious
> > > rare corruptions in, which isn't a good strategy.
> > 
> > Well, at least it becomes a known issue and/or placeholder for when Nick
> 
> It's hidden now so it causes any obvious failures any more. Just
> subtle ones which is much worse.

There's no evidence of any problems ever being caused by this code.
It's been there for years.

> But why not just disable it?  It's not critical functionality,
> just a optimization that unfortunately turned out to be incorrect.

It is critical functionality for larger machines because vmap()/vunmap()
really does suck in terms of scalability.

> It could be made correct short term by not freeing the pages until
> vunmap for example.

Could vmap()/vunmap() take references to the pages that are
mapped? That way delaying the unmap would also delay the freeing
of the pages and hence we'd have no problems with the pages
being reused before the mapping is torn down. That'd work for
Xen even with XFS's lazy unmapping scheme, and would allow
Nick's more advanced methods to work as well....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
