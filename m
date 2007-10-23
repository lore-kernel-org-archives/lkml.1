Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbXJWJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbXJWJas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXJWJaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:30:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXJWJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:30:37 -0400
Date: Tue, 23 Oct 2007 11:30:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: [patch] Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071023093035.GB24536@one.firstfloor.org>
References: <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com> <20071023070414.GM66820511@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023070414.GM66820511@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 05:04:14PM +1000, David Chinner wrote:
> On Tue, Oct 23, 2007 at 10:36:41AM +1000, David Chinner wrote:
> > On Tue, Oct 23, 2007 at 01:35:14AM +0200, Andi Kleen wrote:
> > > On Tue, Oct 23, 2007 at 08:32:25AM +1000, David Chinner wrote:
> > > > Could vmap()/vunmap() take references to the pages that are mapped? That
> > > > way delaying the unmap would also delay the freeing of the pages and hence
> > > > we'd have no problems with the pages being reused before the mapping is
> > > > torn down. That'd work for Xen even with XFS's lazy unmapping scheme, and
> > > > would allow Nick's more advanced methods to work as well....
> > > 
> > > You could always just keep around an array of the pages and then drop the
> > > reference count after unmap. Or walk the vmalloc mapping and generate such
> > > an array before freeing, then unmap and then drop the reference counts.
> > 
> > You mean like vmap() could record the pages passed to it in the area->pages
> > array, and we walk and release than in __vunmap() like it already does
> > for vfree()?
> > 
> > If we did this, it would probably be best to pass a page release function
> > into the vmap or vunmap call - we'd need page_cache_release() called on
> > the page rather than __free_page()....
> > 
> > The solution belongs behind the vmap/vunmap interface, not in XFS....
> 
> Lightly tested(*) patch that does this with lazy unmapping
> below for comment.

Thanks

> 
> (*) a) kernel boots, b) made an XFS filesystem with 64k directory
> blocks, created ~100,000 files in a directory to get a wide btree
> (~1700 blocks, still only a single level) and run repeated finds
> across it dropping caches in between.  Each traversal maps and
> unmaps every btree block.

Hmm, the __free_page -> page_cache_release() change in vfree() would
have been simpler wouldn't it? 

But if it works it is fine.

-Andi
