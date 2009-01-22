Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZAVIhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZAVIhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZAVIgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:36:46 -0500
Received: from mga07.intel.com ([143.182.124.22]:47737 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbZAVIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:36:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,305,1231142400"; 
   d="scan'208";a="102650659"
Subject: Re: Mainline kernel OLTP performance update
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
In-Reply-To: <alpine.DEB.1.10.0901211852060.18367@qirst.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901161503.13730.nickpiggin@yahoo.com.au>
	 <20090115201210.ca1a9542.akpm@linux-foundation.org>
	 <200901161746.25205.nickpiggin@yahoo.com.au>
	 <20090116065546.GJ31013@parisc-linux.org>
	 <1232092430.11429.52.camel@ymzhang>  <87sknjeemn.fsf@basil.nowhere.org>
	 <1232428583.11429.83.camel@ymzhang>
	 <alpine.DEB.1.10.0901211852060.18367@qirst.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Jan 2009 16:36:34 +0800
Message-Id: <1232613395.11429.122.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 18:58 -0500, Christoph Lameter wrote:
> On Tue, 20 Jan 2009, Zhang, Yanmin wrote:
> 
> > kmem_cache ﻿skbuff_head_cache's object size is just 256, so it shares the kmem_cache
> > with ﻿:0000256. Their order is 1 which means every slab consists of 2 physical pages.
> 
> That order can be changed. Try specifying slub_max_order=0 on the kernel
> command line to force an order 0 alloc.
I tried ﻿slub_max_order=0 and there is no improvement on this UDP-U-4k issue.
Both get_page_from_freelist and __free_pages_ok's cpu time are still very high.

I checked my instrumentation in kernel and found it's caused by large object allocation/free
whose size is more than PAGE_SIZE. Here its order is 1.

The right free callchain is __kfree_skb => skb_release_all => skb_release_data.

So this case isn't the issue that batch of allocation/free might erase partial page
functionality.

'#slaninfo -AD' couldn't show statistics of large object allocation/free. Can we add
such info? That will be more helpful.

In addition, I didn't find such issue wih TCP stream testing.

> 
> The queues of the page allocator are of limited use due to their overhead.
> Order-1 allocations can actually be 5% faster than order-0. order-0 makes
> sense if pages are pushed rapidly to the page allocator and are then
> reissues elsewhere. If there is a linear consumption then the page
> allocator queues are just overhead.
> 
> > Page allocator has an array at zone_pcp(zone, cpu)->pcp to keep a page buffer for page order 0.
> > But here ﻿skbuff_head_cache's order is 1, so UDP-U-4k couldn't benefit from the page buffer.
> 
> That usually does not matter because of partial list avoiding page
> allocator actions.

> 
> > SLQB has no such issue, because:
> > 1) SLQB has a percpu freelist. Free objects are put to the list firstly and can be picked up
> > later on quickly without lock. A batch parameter to control the free object recollection is mostly
> > 1024.
> > 2) SLQB slab order mostly is 0, so although sometimes it calls alloc_pages/free_pages, it can
> > benefit from ﻿zone_pcp(zone, cpu)->pcp page buffer.
> >
> > So SLUB need resolve such issues that one process allocates a batch of objects and another process
> > frees them batchly.
> 
> SLUB has a percpu freelist but its bounded by the basic allocation unit.
> You can increase that by modifying the allocation order. Writing a 3 or 5
> into the order value in /sys/kernel/slab/xxx/order would do the trick.

