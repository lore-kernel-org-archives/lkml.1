Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbZGHJoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbZGHJoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbZGHJoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:44:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45666 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbZGHJoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:44:08 -0400
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem
	allocator
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1247035701.15919.35.camel@penberg-laptop>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
	 <1246950530.24285.7.camel@penberg-laptop>
	 <20090707165350.GA2782@cmpxchg.org>
	 <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
	 <1247035701.15919.35.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 08 Jul 2009 10:43:51 +0100
Message-Id: <1247046231.6595.14.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 09:43:52.0043 (UTC) FILETIME=[9A09CBB0:01C9FFB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 09:48 +0300, Pekka Enberg wrote:
> On Tue, 2009-07-07 at 23:09 +0100, Catalin Marinas wrote:
> > On Tue, 2009-07-07 at 18:53 +0200, Johannes Weiner wrote:
> > > On Tue, Jul 07, 2009 at 10:08:50AM +0300, Pekka Enberg wrote:
> > > > On Mon, 2009-07-06 at 11:51 +0100, Catalin Marinas wrote:
> > > > > @@ -597,7 +601,9 @@ restart:
> > > > >  void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
> > > > >  					unsigned long goal)
> > > > >  {
> > > > > -	return ___alloc_bootmem_nopanic(size, align, goal, 0);
> > > > > +	void *ptr =  ___alloc_bootmem_nopanic(size, align, goal, 0);
> > > > > +	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
> > > > > +	return ptr;
> > > 
> > > You may get an object from kzalloc() here, I don't think you want to
> > > track that (again), right?
> > 
> > You are write, I missed the alloc_arch_preferred_bootmem() function
> > which may call kzalloc().
> > 
> > > Pekka already worked out all the central places to catch 'slab already
> > > available' allocations, they can probably help you place the hooks.
> > 
> > It seems that alloc_bootmem_core() is central to all the bootmem
> > allocations. Is it OK to place the kmemleak_alloc hook only in this
> > function?
> 
> I think so. Johannes?

To get a better view, here's the complete patch:


kmemleak: Add callbacks to the bootmem allocator

From: Catalin Marinas <catalin.marinas@arm.com>

This patch adds kmemleak_alloc/free callbacks to the bootmem allocator.
This would allow scanning of such blocks and help avoiding a whole class
of false positives and more kmemleak annotations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/bootmem.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index d2a9ce9..90f3ed0 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -335,6 +335,8 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 {
 	unsigned long start, end;
 
+	kmemleak_free_part(__va(physaddr), size);
+
 	start = PFN_UP(physaddr);
 	end = PFN_DOWN(physaddr + size);
 
@@ -354,6 +356,8 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 	unsigned long start, end;
 
+	kmemleak_free_part(__va(addr), size);
+
 	start = PFN_UP(addr);
 	end = PFN_DOWN(addr + size);
 
@@ -516,6 +520,7 @@ find_block:
 		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
 				start_off);
 		memset(region, 0, size);
+		kmemleak_alloc(region, size, 1, 0);
 		return region;
 	}
 

-- 
Catalin

