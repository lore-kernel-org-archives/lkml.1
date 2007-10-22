Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXJVXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXJVXf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 19:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXJVXfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 19:35:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37171 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXJVXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 19:35:16 -0400
Date: Tue, 23 Oct 2007 01:35:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071022233514.GA9057@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022223224.GC995458@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 08:32:25AM +1000, David Chinner wrote:
> On Mon, Oct 22, 2007 at 09:07:40PM +0200, Andi Kleen wrote:
> > On Mon, Oct 22, 2007 at 11:40:52AM -0700, Jeremy Fitzhardinge wrote:
> > > Andi Kleen wrote:
> > > > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > > >   
> > > >> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> > > >> stray mappings, which upsets Xen.
> > > >>     
> > > >
> > > > Again it not just upsets Xen, keeping mappings to freed pages is wrong generally 
> > > > and violates the x86 (and likely others like PPC) architecture because it can 
> > > > cause illegal caching attribute aliases.
> > > >
> > > > The patch that went into the tree was really not correct -- this
> > > > bogus optimization should have been unconditionally removed
> > > > or if you really wanted an ifdef made dependent on !CONFIG_XEN &&
> > > > !CONFIG_AGP (and likely && !CONFIG_DRM && !CONFIG_anything else that
> > > > uses uncached mappings in memory). 
> > > >
> > > > You just worked around the obvious failure and leave the non obvious
> > > > rare corruptions in, which isn't a good strategy.
> > > 
> > > Well, at least it becomes a known issue and/or placeholder for when Nick
> > 
> > It's hidden now so it causes any obvious failures any more. Just
> > subtle ones which is much worse.
> 
> There's no evidence of any problems ever being caused by this code.

We had a fairly nasty bug a couple of years ago with such
a mapping that took months to track down. Luckily we had 
help from a hardware debug lab, without that it would have
been very near impossible. But just stabilizing the problem was
a nightmare.

You will only see problems if the memory you're still mapping
will be allocated by someone who turns it into an uncached
mapping. And even then it doesn't happen always because
the CPU does not always do the necessary prefetches.

Also the corruption will not be on the XFS side,
but on the uncached mapping so typically some data sent
to some device gets a few corrupted cache line sized blocks.
Depending on the device this might also not be fatal -- e.g.
if it is texture data some corrupted pixels occasionally are 
not that visible. But there can be still cases where
it can cause real failures when it hits something critical
(the failures were it was tracked down was usually it hitting
some command ring and the hardware erroring out) 

Also every time I broke change_page_attr() flushing (which 
handles exactly this problem and is tricky so it got broken
a few times) I eventually got complaints/reports from some users who ran 
into such data inconsistencies. Given it was mostly from closed
3d driver users who seem to be most aggressive in using 
uncached mappings. But with more systems running more aggressive
3d drivers it'll likely get worse.

> It's been there for years.

That doesn't mean it is correct.

Basically you're saying: I don't care if I corrupt device driver
data. That's not a very nice thing to say.

> > But why not just disable it?  It's not critical functionality,
> > just a optimization that unfortunately turned out to be incorrect.
> 
> It is critical functionality for larger machines because vmap()/vunmap()
> really does suck in terms of scalability.

Critical perhaps, but also broken.

And if it's that big a problem would it be really that difficult
to change only the time critical paths using it to not?  I assume
it's only the directory code where it is a problem?  That would
be likely even faster in general.

> > It could be made correct short term by not freeing the pages until
> > vunmap for example.
> 
> Could vmap()/vunmap() take references to the pages that are
> mapped? That way delaying the unmap would also delay the freeing
> of the pages and hence we'd have no problems with the pages
> being reused before the mapping is torn down. That'd work for
> Xen even with XFS's lazy unmapping scheme, and would allow
> Nick's more advanced methods to work as well....

You could always just keep around an array of the pages and 
then drop the reference count after unmap. Or walk the vmalloc mapping
and generate such an array before freeing, then unmap and then
drop the reference counts.

Or the other alternative would be change the time critical code
that uses it to not.

-Andi

