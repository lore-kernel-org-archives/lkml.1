Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYCMSCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYCMSCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYCMSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:02:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:5267 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYCMSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KhsxEME2qhcXcs+HCwFBG1jM7kAHliffWVJafaI2dl94/vgXUZ8EQF+4UGBYbo5gOjEMIRL7sAKZaTF/Xyz/gbrsvK9eNBGDaOPhP1EnKKr5I0KXEm/7LdhxEY3WHiCAB9UwzJ194gH7KNt1gUFow/w48bQ/r1A+t0o/SiCHUPo=
Message-ID: <86802c440803131102u79fcc774j440eef4356083b56@mail.gmail.com>
Date: Thu, 13 Mar 2008 11:02:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: allocate section_map for sparse_init
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20080313111934.GA12351@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803121051q20023badsf8e6e0571f4bb92e@mail.gmail.com>
	 <20080313111934.GA12351@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 4:19 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On (12/03/08 10:51), Yinghai Lu didst pronounce:
>
>
> > [PATCH] mm: allocate section_map for sparse_init
>  >
>  > allocate section_map in bootmem instead of using __initdata.
>  >
>  > need to apply it after
>  >         [PATCH] mm: fix boundary checking in free_bootmem_core
>  >         [PATCH] mm: make mem_map allocation continuous.
>  >
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>  > Index: linux-2.6/mm/sparse.c
>  > ===================================================================
>  > --- linux-2.6.orig/mm/sparse.c
>  > +++ linux-2.6/mm/sparse.c
>  > @@ -285,8 +285,6 @@ struct page __init *sparse_early_mem_map
>  >       return NULL;
>  >  }
>  >
>  > -/* section_map pointer array is 64k */
>  > -static __initdata struct page *section_map[NR_MEM_SECTIONS];
>  >  /*
>  >   * Allocate the accumulated non-linear sections, allocate a mem_map
>  >   * for each and record the physical to section mapping.
>  > @@ -296,6 +294,9 @@ void __init sparse_init(void)
>  >       unsigned long pnum;
>  >       struct page *map;
>  >       unsigned long *usemap;
>  > +     struct page **section_map;
>  > +     int size;
>  > +     int node;
>  >
>  >       /*
>  >        * map is using big page (aka 2M in x86 64 bit)
>  > @@ -305,13 +306,17 @@ void __init sparse_init(void)
>  >        * then in big system, the memmory will have a lot hole...
>  >        * here try to allocate 2M pages continously.
>  >        */
>  > +     size = sizeof(struct page *) * NR_MEM_SECTIONS;
>  > +     section_map = alloc_bootmem(size);
>  > +     if (!section_map)
>  > +             panic("can not allocate section_map\n");
>  > +
>  >       for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  >               if (!present_section_nr(pnum))
>  >                       continue;
>  >               section_map[pnum] = sparse_early_mem_map_alloc(pnum);
>  >       }
>  >
>  > -
>  >       for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  >               if (!present_section_nr(pnum))
>  >                       continue;
>  > @@ -327,6 +332,9 @@ void __init sparse_init(void)
>  >               sparse_init_one_section(__nr_to_section(pnum), pnum, map,
>  >                                                               usemap);
>  >       }
>  > +
>  > +     for_each_online_node(node)
>  > +             free_bootmem_node(NODE_DATA(node), __pa(section_map), size);
>
>  Why are you iterating every online node here instead of just calling
>  free_bootmem(__pa(section_map), size) ?

free_bootmem will assume use bdata on NODE_DATA(0).

some cases: four nodes system: only have memory installed for node 1,
and node 3.
alloc_bootmem will loop to get bootmem from node1, because there is no
ram node0, and not NODE_DATA(0) ...

we may update free_bootmem to loop all bdata or all online nodes to
call free_bootmem_core...

YH
