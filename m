Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbZFLDpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbZFLDpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZFLDpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:45:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60213 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZFLDpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:45:41 -0400
Date: Fri, 12 Jun 2009 12:44:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, yinghai@kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: boot panic with memcg enabled (Was [PATCH 3/4] memcg: don't use
 bootmem allocator in setup code)
Message-Id: <20090612124408.721ba2ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090612115501.df12a457.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI>
	<4A31C258.2050404@cn.fujitsu.com>
	<20090612115501.df12a457.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 11:55:01 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 12 Jun 2009 10:50:00 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > (This patch should have CCed memcg maitainers)
> > 
> > My box failed to boot due to initialization failure of page_cgroup, and
> > it's caused by this patch:
> > 
> > +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
> > 
> 
> Oh, I don't know this patch ;(
> 
> > I added a printk, and found that order == 11 == MAX_ORDER.
> > 
> maybe possible because this allocates countinous pages of 60%? length of
> memmap. 
> If __alloc_bootmem_node_nopanic() is not available any more, memcg should be
> only used under CONFIG_SPARSEMEM. 
> 
> Is that a request from bootmem maintainer ?
> 
In other words,
 - Is there any replacment function to allocate continuous pages bigger
   than MAX_ORDER ?
 - If not, memcg (and io-controller under development) shouldn't support
   memory model other than SPARSEMEM.

IIUC, page_cgroup_init() is called before mem_init() and we could use
alloc_bootmem() here.

Could someone teach me which thread should I read to know
"why alloc_bootmem() is gone ?" ?

Thanks,
-Kame

> Thanks,
> -Kame
> 
> 
> > Pekka J Enberg wrote:
> > > From: Yinghai Lu <yinghai@kernel.org>
> > > 
> > > The bootmem allocator is no longer available for page_cgroup_init() because we
> > > set up the kernel slab allocator much earlier now.
> > > 
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > > ---
> > >  mm/page_cgroup.c |   12 ++++++++----
> > >  1 files changed, 8 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> > > index 791905c..3dd4a90 100644
> > > --- a/mm/page_cgroup.c
> > > +++ b/mm/page_cgroup.c
> > > @@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup(int nid)
> > >  	struct page_cgroup *base, *pc;
> > >  	unsigned long table_size;
> > >  	unsigned long start_pfn, nr_pages, index;
> > > +	struct page *page;
> > > +	unsigned int order;
> > >  
> > >  	start_pfn = NODE_DATA(nid)->node_start_pfn;
> > >  	nr_pages = NODE_DATA(nid)->node_spanned_pages;
> > > @@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup(int nid)
> > >  		return 0;
> > >  
> > >  	table_size = sizeof(struct page_cgroup) * nr_pages;
> > > -
> > > -	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
> > > -			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
> > > -	if (!base)
> > > +	order = get_order(table_size);
> > > +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
> > > +	if (!page)
> > > +		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
> > > +	if (!page)
> > >  		return -ENOMEM;
> > > +	base = page_address(page);
> > >  	for (index = 0; index < nr_pages; index++) {
> > >  		pc = base + index;
> > >  		__init_page_cgroup(pc, start_pfn + index);
> > 
> > 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

