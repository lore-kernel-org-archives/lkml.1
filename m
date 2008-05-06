Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbYEFVSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbYEFVSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbYEFVR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:17:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53653 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbYEFVRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:17:54 -0400
Date: Tue, 6 May 2008 22:17:50 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: parisc DISCONTIGMEM compile breakage
Message-ID: <20080506211750.GA13214@csn.ul.ie>
References: <20080506134648.GA30082@cs181133002.pp.htv.fi> <20080506152713.GA5034@csn.ul.ie> <1210103927.3057.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1210103927.3057.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/05/08 14:58), James Bottomley didst pronounce:
> On Tue, 2008-05-06 at 16:27 +0100, Mel Gorman wrote:
> > On (06/05/08 16:46), Adrian Bunk didst pronounce:
> > > Commit 54a6eb5c4765aa573a030ceeba2c14e3d2ea5706
> > > (mm: use two zonelist that are filtered by GFP mask)
> > > causes the following build error with CONFIG_DISCONTIGMEM=y
> > > on parisc:
> > > 
> > 
> > Thanks Adrian. I don't have a pa-risc cross-compiler and there isn't one
> > at the usual source http://userweb.kernel.org/~akpm/cross-compilers but the
> > patch below should fix it. Note that this debugging code should be deleted if
> > the mm-initialisation-and-debugging framework in -mm is merged to mainline
> > as it knows how to print all the zonelists where as the pa-risc equivilant
> > misses the GFP_THISNODE lists.
> > 
> > =====
> > Subject: [PATCH] Fix pa-risc DISCONTIGMEM compile breakage
> >     
> > PA-RISC to aid debugging prints out the zonelists setup by the system. A
> > bad call to node_zonelist() breaks at compile-time. This patch fixes it.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  arch/parisc/mm/init.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> > index 1f01284..b0ed709 100644
> > --- a/arch/parisc/mm/init.c
> > +++ b/arch/parisc/mm/init.c
> > @@ -606,7 +606,7 @@ void show_mem(void)
> >  		int i, j;
> >  
> >  		for (i = 0; i < npmem_ranges; i++) {
> > -			zl = node_zonelist(i);
> > +			zl = node_zonelist(i, 0);
> >  			for (j = 0; j < MAX_NR_ZONES; j++) {
> 
> This rather doesn't look right.  The intent is for i to iterate over the
> ranges (as nodes) and j to iterate over the zones to get the zonelist.

Yes, that appears to be the original intention.

> The original variable k was going over the mappings, which you replaced
> with for_each_zone_zonelist.  If you use node_zonelist(i, 0) you don't
> really look at the actual zones in the map.
> 

No, but you filter the one list based on the highest zone that can be
accesssed.

> Therefore it seems what will give the original functionality back is
> actually this:
> 

To be fair, a few weeks ago you would have been right. Since then zonelists
have changed though so that there are only two zonelists per node in
git-latest. One which is for general allocations and one for GFP_THISNODE. The
zonelist is filtered based on the GFP flags, hence the iterator. I copied the
parisc code with the compile-fix into mm/page_alloc.c and called it just to
be sure and with qemu, I see

[    0.628960] Zone list for zone 0 on node 0: [0/DMA] 
[    0.628960] Zone list for zone 1 on node 0: [0/Normal] [0/DMA] 
[    0.628960] Zone list for zone 2 on node 0: [0/HighMem] [0/Normal] [0/DMA] 
[    0.628960] Zone list for zone 3 on node 0: [0/Movable] [0/HighMem] [0/Normal] [0/DMA]

which looks right (movablecore was specified hence the existance of the
movable zone).

> <SNIP>
>  			for (j = 0; j < MAX_NR_ZONES; j++) {
> +				struct zonelist *zl;
>  				struct zoneref *z;
>  				struct zone *zone;
>  
> +				zl = NODE_DATA(i)->node_zonelists + j;
> +

This would read past the end of the node_zonelists array which is only
MAX_ZONELISTS (2 for CONFIG_NUMA) in size.

>  				printk("Zone list for zone %d on node %d: ", j, i);
>  				for_each_zone_zonelist(zone, z, zl, j)
>  					printk("[%d/%s] ", zone_to_nid(zone),
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
