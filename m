Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYBEWNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYBEWNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761076AbYBEWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:13:14 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36449 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760976AbYBEWNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:13:13 -0500
Date: Tue, 5 Feb 2008 14:13:12 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Greg KH <greg@kroah.com>
cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, r31dmaeu@pc0312b.rz.unibw-muenchen.de
Subject: Re: [stable] OOM-killer invoked but why ?
In-Reply-To: <20080205220445.GA6889@kroah.com>
Message-ID: <Pine.LNX.4.64.0802051412370.14665@schroedinger.engr.sgi.com>
References: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
 <20080205020737.cec97816.akpm@linux-foundation.org> <20080205110303.GA8288@linux.vnet.ibm.com>
 <20080205220445.GA6889@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Greg KH wrote:

> > > commit 96990a4ae979df9e235d01097d6175759331e88c
> > > Author: Christoph Lameter <clameter@sgi.com>
> > > Date:   Mon Jan 14 00:55:14 2008 -0800
> > > 
> > >     quicklists: Only consider memory that can be used with GFP_KERNEL
> > >     
> > >     Quicklists calculates the size of the quicklists based on the number of
> > >     free pages.  This must be the number of free pages that can be allocated
> > >     with GFP_KERNEL.  node_page_state() includes the pages in ZONE_HIGHMEM and
> > >     ZONE_MOVABLE which may lead the quicklists to become too large causing OOM.
> > >     
> > >     Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > >     Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > 
> > > diff --git a/mm/quicklist.c b/mm/quicklist.c
> > > index ae8189c..3f703f7 100644
> > > --- a/mm/quicklist.c
> > > +++ b/mm/quicklist.c
> > > @@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
> > >  static unsigned long max_pages(unsigned long min_pages)
> > >  {
> > >  	unsigned long node_free_pages, max;
> > > +	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
> > > +
> > > +	node_free_pages =
> > > +#ifdef CONFIG_ZONE_DMA
> > > +		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
> > > +#endif
> > > +#ifdef CONFIG_ZONE_DMA32
> > > +		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
> > > +#endif
> > > +		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
> > > 
> > > -	node_free_pages = node_page_state(numa_node_id(),
> > > -			NR_FREE_PAGES);
> > >  	max = node_free_pages / FRACTION_OF_NODE_MEM;
> > >  	return max(max, min_pages);
> > >  }
> > > 
> > > 
> > > I note that this didn't have the stable@kernel.org cc.  Christoph, did we
> > > deliberately decide not to backport?
> > > 
> > 
> > According to
> > http://archive.netbsd.se/?ml=linux-stable-commits&a=2008-01&m=6134301 ,
> > its been added to the stable tree. I remember asking Greg to add it.
> 
> And then Christoph told me to remove it...

No I asked you to add this patch and remove the earlier patch that 
tinkered around with tlb flushing.

