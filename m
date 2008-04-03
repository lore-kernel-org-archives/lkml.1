Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYDCArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYDCArb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYDCArX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:47:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:23132 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbYDCArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iuSBXorwlfab8RmXvDSwARkwUt94S2xSDF0tdBRI4fqe1+XJAhDvJ95RSCpTVHJquVUj2e8ua47KdiM/Xah87ZE8CJTFWOFV3VA2BbUEXZ2YXKgvr/o9rA9DpYeyVOS/UcUmvDDt8oChtX3DDdLI+6K4j+ZoPwJcVF0Eymyv/u4=
Message-ID: <86802c440804021747j2e82a30ew8568e4339e272e36@mail.gmail.com>
Date: Wed, 2 Apr 2008 17:47:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       michael@ellerman.id.au,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1207180285.30407.45.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804021525.48799.yhlu.kernel@gmail.com>
	 <1207180285.30407.45.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 4:51 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
> On Wed, 2008-04-02 at 15:25 -0700, Yinghai Lu wrote:
>  > [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
>
> > so try to allocate usemap at first altogether.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > diff --git a/mm/sparse.c b/mm/sparse.c
>  > index d3cb085..782ebe5 100644
>  > --- a/mm/sparse.c
>  > +++ b/mm/sparse.c
>  > @@ -294,7 +294,7 @@ void __init sparse_init(void)
>  >       unsigned long pnum;
>  >       struct page *map;
>  >       unsigned long *usemap;
>  > -     struct page **section_map;
>  > +     unsigned long **usemap_map;
>  >       int size;
>  >       int node;
>  >
>  > @@ -305,27 +305,31 @@ void __init sparse_init(void)
>  >        * make next 2M slip to one more 2M later.
>  >        * then in big system, the memmory will have a lot hole...
>  >        * here try to allocate 2M pages continously.
>
>  Comments are x86-64 specific. On ppc its 16MB chunks :(
>
>
>
>  > +      *
>  > +      * powerpc hope to sparse_init_one_section right after each
>  > +      * sparse_early_mem_map_alloc, so allocate usemap_map
>  > +      * at first.
>  >        */
>  > -     size = sizeof(struct page *) * NR_MEM_SECTIONS;
>  > -     section_map = alloc_bootmem(size);
>  > -     if (!section_map)
>  > -             panic("can not allocate section_map\n");
>  > +     size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
>  > +     usemap_map = alloc_bootmem(size);
>  > +     if (!usemap_map)
>  > +             panic("can not allocate usemap_map\n");
>  >
>  >       for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  >               if (!present_section_nr(pnum))
>  >                       continue;
>  > -             section_map[pnum] = sparse_early_mem_map_alloc(pnum);
>  > +             usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
>  >       }
>  >
>  >       for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
>  >               if (!present_section_nr(pnum))
>  >                       continue;
>  >
>  > -             map = section_map[pnum];
>  > +             map = sparse_early_mem_map_alloc(pnum);
>  >               if (!map)
>  >                        continue;
>  >
>  > -             usemap = sparse_early_usemap_alloc(pnum);
>  > +             usemap = usemap_map[pnum];
>  >               if (!usemap)
>  >                       continue;
>
>  You may want to move this check before doing sparse_early_mem_map_alloc
>  (). We are also not handling errors properly (freeing up the unused
>  map or usemap) if we "continue". I know the original code is this way,
>  but you touched it last :)

Yes. could avoid some leak...

YH
