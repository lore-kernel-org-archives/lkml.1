Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbZGHGsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbZGHGsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758484AbZGHGsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:48:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55945 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbZGHGsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:48:23 -0400
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem
 allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
	 <1246950530.24285.7.camel@penberg-laptop>
	 <20090707165350.GA2782@cmpxchg.org>
	 <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
Date: Wed, 08 Jul 2009 09:48:21 +0300
Message-Id: <1247035701.15919.35.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Tue, 2009-07-07 at 23:09 +0100, Catalin Marinas wrote:
> On Tue, 2009-07-07 at 18:53 +0200, Johannes Weiner wrote:
> > On Tue, Jul 07, 2009 at 10:08:50AM +0300, Pekka Enberg wrote:
> > > On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
> > > > @@ -597,7 +601,9 @@ restart:
> > > >  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
> > > >  					unsigned long goal)
> > > >  {
> > > > -	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> > > > +	void *ptr =  ___alloc_bootmem_nopanic(size, align, goal, 0);
> > > > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > > > +	return ptr;
> > 
> > You may get an object from kzalloc() here, I don't think you want to
> > track that (again), right?
> 
> You are write, I missed the alloc_arch_preferred_bootmem() function
> which may call kzalloc().
> 
> > Pekka already worked out all the central places to catch 'slab already
> > available' allocations, they can probably help you place the hooks.
> 
> It seems that alloc_bootmem_core() is central to all the bootmem
> allocations. Is it OK to place the kmemleak_alloc hook only in this
> function?

I think so. Johannes?

> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 5a649a0..74cbb34 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -520,6 +520,7 @@ find_block:
>  		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
>  				start_off);
>  		memset(region, 0, size);
> +		kmemleak_alloc(region, size, 1, 0);
>  		return region;
>  	}


