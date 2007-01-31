Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbXAaDXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbXAaDXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbXAaDXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:23:03 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:52446 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932417AbXAaDXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:23:01 -0500
Date: Wed, 31 Jan 2007 14:22:24 +1100
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, "Martin J. Bligh" <mbligh@mbligh.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070131032224.GV44411608@melbourne.sgi.com>
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org> <1170063848.6189.121.camel@twins> <45BE9FE8.4080603@mbligh.org> <20070129174118.0e922ab3.akpm@osdl.org> <45BEA41A.6020209@mbligh.org> <20070129181557.d4d17dd0.akpm@osdl.org> <20070131004436.GS44411608@melbourne.sgi.com> <20070130171132.7be3b054.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130171132.7be3b054.akpm@osdl.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 05:11:32PM -0800, Andrew Morton wrote:
> On Wed, 31 Jan 2007 11:44:36 +1100
> David Chinner <dgc@sgi.com> wrote:
> 
> > On Mon, Jan 29, 2007 at 06:15:57PM -0800, Andrew Morton wrote:
> > > We still don't know what is the source of kmap() activity which
> > > necessitated this patch btw.  AFAIK the busiest source is ext2 directories,
> > > but perhaps NFS under certain conditions?
> > > 
> > > <looks at xfs_iozero>
> > > 
> > > ->prepare_write no longer requires that the caller kmap the page.
> > 
> > Agreed, but don't we (xfs_iozero) have to map it first to zero it?
> > 
> > I think what you are saying here, Andrew, is that we can
> > do something like:
> > 
> > 	page = grab_cache_page
> > 	->prepare_write(page)
> > 	kaddr = kmap_atomic(page, KM_USER0)
> > 	memset(kaddr+offset, 0, bytes)
> > 	flush_dcache_page(page)
> > 	kunmap_atomic(kaddr, KM_USER0)
> > 	->commit_write(page)
> > 
> > to avoid using kmap() altogether?
> 
> Yup.  Even better, use clear_highpage().

For even more goodness, clearmem_highpage_flush() does exactly
the right thing for partial page zeroing ;)

Thanks, Andrew, I've added a patch to my QA tree with this mod.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
