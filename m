Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXJWAh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXJWAh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXJWAhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:37:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56276 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751242AbXJWAhR (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:37:17 -0400
Date: Tue, 23 Oct 2007 10:36:41 +1000
From: David Chinner <dgc@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071023003641.GF995458@sgi.com>
References: <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022233514.GA9057@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 01:35:14AM +0200, Andi Kleen wrote:
> On Tue, Oct 23, 2007 at 08:32:25AM +1000, David Chinner wrote:
> > On Mon, Oct 22, 2007 at 09:07:40PM +0200, Andi Kleen wrote:
> > > It's hidden now so it causes any obvious failures any more. Just subtle
> > > ones which is much worse.
> > 
> > There's no evidence of any problems ever being caused by this code.
.....
> Also the corruption will not be on the XFS side, but on the uncached mapping
> so typically some data sent to some device gets a few corrupted cache line
> sized blocks.  Depending on the device this might also not be fatal -- e.g.
> if it is texture data some corrupted pixels occasionally are not that
> visible. But there can be still cases where it can cause real failures when
> it hits something critical (the failures were it was tracked down was
> usually it hitting some command ring and the hardware erroring out) 

There seems to be little evidence of that occurring around the place.

> > It's been there for years.
> 
> That doesn't mean it is correct.

Right, but it also points to the fact that it's not causing problems
from 99.999% of ppl out there.

> Basically you're saying: I don't care if I corrupt device driver data.
> That's not a very nice thing to say.

No, I did not say that. I said that there's no evidence that points to
this causing problems anywhere. 

> > > But why not just disable it?  It's not critical functionality, just a
> > > optimization that unfortunately turned out to be incorrect.
> > 
> > It is critical functionality for larger machines because vmap()/vunmap()
> > really does suck in terms of scalability.
> 
> Critical perhaps, but also broken.
> 
> And if it's that big a problem would it be really that difficult to change
> only the time critical paths using it to not?  I assume it's only the
> directory code where it is a problem?  That would be likely even faster in
> general.

Difficult - yes. All the btree code in XFS would have to be rewritten
to remove the assumption that the buffer structures are contiguous in
memory. Any bug we introduce in doing this will result in on disk corruption,
which is far worse than occasionally crashing a machine with a stray
mapping.

> > > It could be made correct short term by not freeing the pages until
> > > vunmap for example.
> > 
> > Could vmap()/vunmap() take references to the pages that are mapped? That
> > way delaying the unmap would also delay the freeing of the pages and hence
> > we'd have no problems with the pages being reused before the mapping is
> > torn down. That'd work for Xen even with XFS's lazy unmapping scheme, and
> > would allow Nick's more advanced methods to work as well....
> 
> You could always just keep around an array of the pages and then drop the
> reference count after unmap. Or walk the vmalloc mapping and generate such
> an array before freeing, then unmap and then drop the reference counts.

You mean like vmap() could record the pages passed to it in the area->pages
array, and we walk and release than in __vunmap() like it already does
for vfree()?

If we did this, it would probably be best to pass a page release function
into the vmap or vunmap call - we'd need page_cache_release() called on
the page rather than __free_page()....

The solution belongs behind the vmap/vunmap interface, not in XFS....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
