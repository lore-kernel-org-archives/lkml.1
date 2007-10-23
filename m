Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbXJWMmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbXJWMmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXJWMmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:42:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56721 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbXJWMmR (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:42:17 -0400
Date: Tue, 23 Oct 2007 22:41:37 +1000
From: David Chinner <dgc@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: [patch] Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071023124137.GP66820511@sgi.com>
References: <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com> <20071023070414.GM66820511@sgi.com> <20071023093035.GB24536@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023093035.GB24536@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 11:30:35AM +0200, Andi Kleen wrote:
> On Tue, Oct 23, 2007 at 05:04:14PM +1000, David Chinner wrote:
> > > You mean like vmap() could record the pages passed to it in the area->pages
> > > array, and we walk and release than in __vunmap() like it already does
> > > for vfree()?
> > > 
> > > If we did this, it would probably be best to pass a page release function
> > > into the vmap or vunmap call - we'd need page_cache_release() called on
> > > the page rather than __free_page()....
> > > 
> > > The solution belongs behind the vmap/vunmap interface, not in XFS....
> > 
> > Lightly tested(*) patch that does this with lazy unmapping
> > below for comment.
> 
> Thanks
> 
> > 
> > (*) a) kernel boots, b) made an XFS filesystem with 64k directory
> > blocks, created ~100,000 files in a directory to get a wide btree
> > (~1700 blocks, still only a single level) and run repeated finds
> > across it dropping caches in between.  Each traversal maps and
> > unmaps every btree block.
> 
> Hmm, the __free_page -> page_cache_release() change in vfree() would
> have been simpler wouldn't it? 

Yes, it would, but I tried to leave vmalloc doing the same thing as
it was before. I think that it would be safe simply to call put_page()
directly in the __vunmap() code and drop all the release function
passing, but I don't know enough about that code to say for certain.
I'll spin up another patch tomorrow that does this and see how it goes.

> But if it works it is fine.

Seems to - it's passed XFSQA with 64k directories and a bunch of
dirstress workouts as well.

Nick, Jeremy, (others?) any objections to this approach to solve
the problem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
