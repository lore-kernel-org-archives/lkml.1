Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYGCQis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYGCQis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGCQik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:38:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54660 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYGCQij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:38:39 -0400
Date: Thu, 3 Jul 2008 17:38:37 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
       babydr@baby-dragons.com, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, a.beregalov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
Message-ID: <20080703163836.GD18055@csn.ul.ie>
References: <20080701080910.GA10865@csn.ul.ie> <20080701175855.GI32727@shadowen.org> <20080701190741.GB16501@csn.ul.ie> <1214944175.26855.18.camel@dwillia2-linux.ch.intel.com> <20080702051759.GA26338@csn.ul.ie> <1215049766.2840.43.camel@dwillia2-linux.ch.intel.com> <20080703042750.GB14614@csn.ul.ie> <alpine.LFD.1.10.0807022135360.18105@woody.linux-foundation.org> <20080703050036.GD14614@csn.ul.ie> <1215064455.15797.4.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1215064455.15797.4.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/07/08 22:54), Dan Williams didst pronounce:
> 
> On Wed, 2008-07-02 at 22:00 -0700, Mel Gorman wrote:
> 
> > Subject: [PATCH] Do not overwrite nr_zones on !NUMA when initialising zlcache_ptr
> > 
> > With the two-zonelist patches on !NUMA machines, there really is only one
> > zonelist as __GFP_THISNODE is meaningless. However, during initialisation, the
> > assumption is made that two zonelists exist when initialising zlcache_ptr. The
> > result is that pgdat->nr_zones is always 0. As kswapd uses this value to
> > determine what reclaim work is necessary, the result is that kswapd never
> > reclaims. This causes processes to stall frequently in low-memory situations
> > as they always direct reclaim.  This patch initialises zlcache_ptr correctly.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  page_alloc.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.26-rc8-clean/mm/page_alloc.c linux-2.6.26-rc8-fix-kswapd-on-numa/mm/page_alloc.c
> > --- linux-2.6.26-rc8-clean/mm/page_alloc.c      2008-06-24 18:58:20.000000000 -0700
> > +++ linux-2.6.26-rc8-fix-kswapd-on-numa/mm/page_alloc.c 2008-07-02 21:49:09.000000000 -0700
> > @@ -2328,7 +2328,6 @@ static void build_zonelists(pg_data_t *p
> >  static void build_zonelist_cache(pg_data_t *pgdat)
> >  {
> >         pgdat->node_zonelists[0].zlcache_ptr = NULL;
> > -       pgdat->node_zonelists[1].zlcache_ptr = NULL;
> >  }
> > 
> >  #endif /* CONFIG_NUMA */
> > 
> 
> Bug squished.
> 
> # for i in `seq 1 5`; do dd if=/dev/zero of=/dev/md0 bs=1024k count=2048; done
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 7.73352 s, 278 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 7.6845 s, 279 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 7.74428 s, 277 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 7.65959 s, 280 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 7.73107 s, 278 MB/s
> 
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> 

Great news. Dan, thanks a lot for reporting and persisting with the testing
of various bits and pieces to get this pinned down. It is greatly appreciated.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
