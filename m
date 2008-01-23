Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYAWTwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYAWTwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYAWTwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:52:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42610 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYAWTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:52:43 -0500
Date: Wed, 23 Jan 2008 11:52:20 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is
	running on a memoryless node
Message-ID: <20080123195220.GB3848@us.ibm.com>
References: <20080123075821.GA17713@aepfle.de> <20080123105044.GD21455@csn.ul.ie> <20080123121459.GA18631@aepfle.de> <20080123125236.GA18876@aepfle.de> <20080123135513.GA14175@csn.ul.ie> <Pine.LNX.4.64.0801231611160.20050@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801231626320.21475@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801231648140.23343@sbz-30.cs.Helsinki.FI> <20080123155655.GB20156@csn.ul.ie> <Pine.LNX.4.64.0801231906520.1028@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801231906520.1028@sbz-30.cs.Helsinki.FI>
X-Operating-System: Linux 2.6.24-4-generic (i686)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2008 [19:29:15 +0200], Pekka J Enberg wrote:
> Hi,
> 
> On Wed, 23 Jan 2008, Mel Gorman wrote:
> > Applied in combination with the N_NORMAL_MEMORY revert and it fails to
> > boot. Console is as follows;
> 
> Thanks for testing!
> 
> On Wed, 23 Jan 2008, Mel Gorman wrote:
> > [c0000000005c3b40] c0000000000dadb4 .cache_grow+0x7c/0x338
> > [c0000000005c3c00] c0000000000db518 .fallback_alloc+0x1c0/0x224
> > [c0000000005c3cb0] c0000000000db920 .kmem_cache_alloc+0xe0/0x14c
> > [c0000000005c3d50] c0000000000dcbd0 .kmem_cache_create+0x230/0x4cc
> > [c0000000005c3e30] c0000000004c049c .kmem_cache_init+0x1ec/0x51c
> > [c0000000005c3ee0] c00000000049f8d8 .start_kernel+0x304/0x3fc
> > [c0000000005c3f90] c000000000008594 .start_here_common+0x54/0xc0
> > 
> > 0xc0000000000dadb4 is in cache_grow (mm/slab.c:2782).
> > 2777            local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
> > 2778    
> > 2779            /* Take the l3 list lock to change the colour_next on this node */
> > 2780            check_irq_off();
> > 2781            l3 = cachep->nodelists[nodeid];
> > 2782            spin_lock(&l3->list_lock);
> > 2783    
> > 2784            /* Get colour for the slab, and cal the next value. */
> > 2785            offset = l3->colour_next;
> > 2786            l3->colour_next++;
> 
> Ok, so it's too early to fallback_alloc() because in kmem_cache_init() we 
> do:
> 
>         for (i = 0; i < NUM_INIT_LISTS; i++) {
>                 kmem_list3_init(&initkmem_list3[i]);
>                 if (i < MAX_NUMNODES)
>                         cache_cache.nodelists[i] = NULL;
>         }
> 
> Fine. But, why are we hitting fallback_alloc() in the first place? It's 
> definitely not because of missing ->nodelists as we do:
> 
>         cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
> 
> before attempting to set up kmalloc caches. Now, if I understood 
> correctly, we're booting off a memoryless node so kmem_getpages() will 
> return NULL thus forcing us to fallback_alloc() which is unavailable at 
> this point.
> 
> As far as I can tell, there are two ways to fix this:
> 
>   (1) don't boot off a memoryless node (why are we doing this in the first 
>       place?)

On at least one of the machines in question, wasn't it the case that
node 0 had all the memory and node 1 had all the CPUs? In that case, you
would have to boot off a memoryless node? And as long as that is a
physically valid configuration, the kernel should handle it.

>   (2) initialize cache_cache.nodelists with initmem_list3 equivalents
>       for *each node hat has normal memory*
> 
> I am still wondering why this worked before, though.

I bet we didn't notice this breaking because SLUB became the default and
SLAB isn't on in the test.kernel.org testing, for instance. Perhaps we
should add a second set of runs for some of the boxes there to run with
CONFIG_SLAB on?

I'm curious if we know, for sure, of a kernel with CONFIG_SLAB=y that
has booted all of the boxes reporting issues? That is, did they all work
with 2.6.23?

Thanks,
Nish
