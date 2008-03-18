Return-Path: <linux-kernel-owner+w=401wt.eu-S940616AbYCSXvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940616AbYCSXvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765125AbYCSWWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:22:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:41606 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762911AbYCSWWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:22:54 -0400
Message-ID: <86802c440803181057j710a1ba7mfa14acd3ea1f626c@mail.gmail.com>
Date: Tue, 18 Mar 2008 10:57:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: allocate section_map for sparse_init
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20080318094132.GB11587@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803121051q20023badsf8e6e0571f4bb92e@mail.gmail.com>
	 <20080313111934.GA12351@csn.ul.ie>
	 <86802c440803131102u79fcc774j440eef4356083b56@mail.gmail.com>
	 <20080318094132.GB11587@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 2:41 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On (13/03/08 11:02), Yinghai Lu didst pronounce:
>
>
> > On Thu, Mar 13, 2008 at 4:19 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>  > > On (12/03/08 10:51), Yinghai Lu didst pronounce:
>  > >
>  > >
>  > > > [PATCH] mm: allocate section_map for sparse_init
>  > >  >
>  > >  > allocate section_map in bootmem instead of using __initdata.
>  > >  >
>  > >  > need to apply it after
>  > >  >         [PATCH] mm: fix boundary checking in free_bootmem_core
>  > >  >         [PATCH] mm: make mem_map allocation continuous.
>  > >  >
>  > >  >
>  > >  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  > >
>  > >  > Index: linux-2.6/mm/sparse.c
>  > >  > ===================================================================
>  > >  > --- linux-2.6.orig/mm/sparse.c
>  > >  > +++ linux-2.6/mm/sparse.c
>  > >  > @@ -285,8 +285,6 @@ struct page __init *sparse_early_mem_map
>  > >  >       return NULL;
>  > >  >  }
>  > >  >
>  > >  > -/* section_map pointer array is 64k */
>  > >  > -static __initdata struct page *section_map[NR_MEM_SECTIONS];
>  > >  >  /*
>  > >  >   * Allocate the accumulated non-linear sections, allocate a mem_map
>  > >  >   * for each and record the physical to section mapping.
>  > >  > @@ -296,6 +294,9 @@ void __init sparse_init(void)
>  > >  >       unsigned long pnum;
>  > >  >       struct page *map;
>  > >  >       unsigned long *usemap;
>  > >  > +     struct page **section_map;
>  > >  > +     int size;
>  > >  > +     int node;
>  > >  >
>  > >  >       /*
>  > >  >        * map is using big page (aka 2M in x86 64 bit)
>  > >  > @@ -305,13 +306,17 @@ void __init sparse_init(void)
>  > >  >        * then in big system, the memmory will have a lot hole...
>  > >  >        * here try to allocate 2M pages continously.
>  > >  >        */
>  > >  > +     size = sizeof(struct page *) * NR_MEM_SECTIONS;
>  > >  > +     section_map = alloc_bootmem(size);
>  > >  > +     if (!section_map)
>  > >  > +             panic("can not allocate section_map\n");
>  > >  > +
>  > >  >       for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  > >  >               if (!present_section_nr(pnum))
>  > >  >                       continue;
>  > >  >               section_map[pnum] = sparse_early_mem_map_alloc(pnum);
>  > >  >       }
>  > >  >
>  > >  > -
>  > >  >       for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  > >  >               if (!present_section_nr(pnum))
>  > >  >                       continue;
>  > >  > @@ -327,6 +332,9 @@ void __init sparse_init(void)
>  > >  >               sparse_init_one_section(__nr_to_section(pnum), pnum, map,
>  > >  >                                                               usemap);
>  > >  >       }
>  > >  > +
>  > >  > +     for_each_online_node(node)
>  > >  > +             free_bootmem_node(NODE_DATA(node), __pa(section_map), size);
>  > >
>  > >  Why are you iterating every online node here instead of just calling
>  > >  free_bootmem(__pa(section_map), size) ?
>  >
>  > free_bootmem will assume use bdata on NODE_DATA(0).
>  >
>
>  True. The unwritten assumption is that NODE_DATA(0) always has memory
>  for allocate or free.
>
>
>  > some cases: four nodes system: only have memory installed for node 1,
>  > and node 3.
>  > alloc_bootmem will loop to get bootmem from node1, because there is no
>  > ram node0, and not NODE_DATA(0) ...
>  >
>  > we may update free_bootmem to loop all bdata or all online nodes to
>  > call free_bootmem_core...
>  >
>
>  Alternatively, update free_bootmem so that it figures out which node it is
>  meant to be freeing to based on the PFN of the page currently being freed.
>
>  It still doesn't seem right to try freeing on all online nodes as it looks like
>  free_bootmem_core() should flip bits outside the range of its node_bootmem_map
>  which could cause tricky bugs.
>
>  As things currently stand with bootmem, what you should be doing is using
>  for_each_online_node() to figure out which node you can allocate from,
>  remembering that node and calling free_bootmem_node() once. If you fix
>  free_bootmem() though, you should only need to call free_bootmem() once
>  in this patch.

Yes

with the new free_bootmem that loop bdata_list, we can call
free_bootmem.

YH
