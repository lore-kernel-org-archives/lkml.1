Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZGGWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZGGWKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbZGGWKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:10:14 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48126 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbZGGWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:10:11 -0400
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem
	allocator
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090707165350.GA2782@cmpxchg.org>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
	 <1246950530.24285.7.camel@penberg-laptop>
	 <20090707165350.GA2782@cmpxchg.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 23:09:46 +0100
Message-Id: <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 22:09:48.0429 (UTC) FILETIME=[A48293D0:01C9FF4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 18:53 +0200, Johannes Weiner wrote:
> On Tue, Jul 07, 2009 at 10:08:50AM +0300, Pekka Enberg wrote:
> > On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
> > > @@ -597,7 +601,9 @@ restart:
> > >  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
> > >  					unsigned long goal)
> > >  {
> > > -	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> > > +	void *ptr =  ___alloc_bootmem_nopanic(size, align, goal, 0);
> > > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > > +	return ptr;
> 
> You may get an object from kzalloc() here, I don't think you want to
> track that (again), right?

You are write, I missed the alloc_arch_preferred_bootmem() function
which may call kzalloc().

> Pekka already worked out all the central places to catch 'slab already
> available' allocations, they can probably help you place the hooks.

It seems that alloc_bootmem_core() is central to all the bootmem
allocations. Is it OK to place the kmemleak_alloc hook only in this
function?

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 5a649a0..74cbb34 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -520,6 +520,7 @@ find_block:
 		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
 				start_off);
 		memset(region, 0, size);
+		kmemleak_alloc(region, size, 1, 0);
 		return region;
 	}
 

> > > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> 
> These GFP_KERNEL startled me.  We know for sure that this code runs in
> earlylog mode only and gfp is unused, right?  Can you perhaps just
> pass 0 for gfp instead?

Yes, indeed.

Thanks for your comments.

-- 
Catalin

