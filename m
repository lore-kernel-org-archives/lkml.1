Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYCQDht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYCQDht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYCQDhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:37:41 -0400
Received: from mga05.intel.com ([192.55.52.89]:39066 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301AbYCQDhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:37:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,510,1199692800"; 
   d="scan'208";a="534908680"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803141713340.29413@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
	 <1205463842.3215.188.camel@ymzhang>
	 <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
	 <1205478861.3215.279.camel@ymzhang>
	 <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0803141713340.29413@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 17 Mar 2008 11:35:40 +0800
Message-Id: <1205724940.3215.339.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 17:15 -0700, Christoph Lameter wrote:
> Here is a patch to just not perform refills but switch slabs instead. 
> Could check what effect doing so has on the statistics you see on the 16p?
> 
> ---
>  mm/slub.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2008-03-14 16:49:36.000000000 -0700
> +++ linux-2.6/mm/slub.c	2008-03-14 16:50:04.000000000 -0700
> @@ -1474,10 +1474,7 @@ static void *__slab_alloc(struct kmem_ca
>  		goto new_slab;
>  
>  	slab_lock(c->page);
> -	if (unlikely(!node_match(c, node)))
> -		goto another_slab;
> -
> -	stat(c, ALLOC_REFILL);
> +	goto another_slab;
>  
>  load_freelist:
>  	object = c->page->freelist;
There is no much help. In 2.6.25-rc5, REFILL means refill from c->page->freelist
and another_slab. It's looks like its definition is confusing. In the case of
hackbench, mostly, c->page->freelist is NULL.

With #hackbench 100 process 2000, 100*20*2 (totoally 4000) processes are started.
vmstat shows about 300~500 processes are at RUNNING state, so every processor runqueue
has more than 20 processes running on 16p tigerton.


Below is the data with kernel 2.6.25-rc5+your_patch.

[ymzhang@lkp-tt01-x8664 ~]$ slabinfo kmalloc-512

Slabcache: kmalloc-512           Aliases:  1 Order :  0 Objects: 352

Sizes (bytes)     Slabs              Debug                Memory
------------------------------------------------------------------------
Object :     512  Total  :      56   Sanity Checks : Off  Total:  229376
SlabObj:     512  Full   :      36   Redzoning     : Off  Used :  180224
SlabSiz:    4096  Partial:       4   Poisoning     : Off  Loss :   49152
Loss   :       0  CpuSlab:      16   Tracking      : Off  Lalig:       0
Align  :       8  Objects:       8   Tracing       : Off  Lpadd:       0

kmalloc-512 has no kmem_cache operations

kmalloc-512: Kernel object allocation
-----------------------------------------------------------------------
No Data

kmalloc-512: Kernel object freeing
------------------------------------------------------------------------
No Data

kmalloc-512: No NUMA information available.

Slab Perf Counter       Alloc     Free %Al %Fr
--------------------------------------------------
Fastpath             55883575  6130576  69   7
Slowpath             24131134 73883818  30  92
Page Alloc              84844    84788   0   0
Add partial            270625 23860257   0  29
Remove partial       24046290    84752  30   0
RemoteObj/SlabFrozen   270825   439015   0   0
Total                80014709 80014394

Deactivate Full=23860293(98%) Empty=200(0%) ToHead=0(0%) ToTail=270625(1%)


