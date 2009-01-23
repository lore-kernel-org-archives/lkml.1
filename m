Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbZAWDDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbZAWDDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 22:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZAWDDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 22:03:06 -0500
Received: from mga10.intel.com ([192.55.52.92]:65032 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756162AbZAWDDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 22:03:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,310,1231142400"; 
   d="scan'208";a="424822294"
Subject: Re: Mainline kernel OLTP performance update
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
In-Reply-To: <1232617672.14549.25.camel@penberg-laptop>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901161503.13730.nickpiggin@yahoo.com.au>
	 <20090115201210.ca1a9542.akpm@linux-foundation.org>
	 <200901161746.25205.nickpiggin@yahoo.com.au>
	 <20090116065546.GJ31013@parisc-linux.org>
	 <1232092430.11429.52.camel@ymzhang>  <87sknjeemn.fsf@basil.nowhere.org>
	 <1232428583.11429.83.camel@ymzhang>
	 <alpine.DEB.1.10.0901211852060.18367@qirst.com>
	 <1232613395.11429.122.camel@ymzhang>
	 <1232615707.14549.6.camel@penberg-laptop>
	 <1232616517.11429.129.camel@ymzhang>
	 <1232617672.14549.25.camel@penberg-laptop>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Jan 2009 11:02:53 +0800
Message-Id: <1232679773.11429.155.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 11:47 +0200, Pekka Enberg wrote:
> On Thu, 2009-01-22 at 17:28 +0800, Zhang, Yanmin wrote:
> > On Thu, 2009-01-22 at 11:15 +0200, Pekka Enberg wrote:
> > > On Thu, 2009-01-22 at 16:36 +0800, Zhang, Yanmin wrote:
> > > > On Wed, 2009-01-21 at 18:58 -0500, Christoph Lameter wrote:
> > > > > On Tue, 20 Jan 2009, Zhang, Yanmin wrote:
> > > > > 
> > > > > > kmem_cache ﻿skbuff_head_cache's object size is just 256, so it shares the kmem_cache
> > > > > > with ﻿:0000256. Their order is 1 which means every slab consists of 2 physical pages.
> > > > > 
> > > > > That order can be changed. Try specifying slub_max_order=0 on the kernel
> > > > > command line to force an order 0 alloc.
> > > > I tried ﻿slub_max_order=0 and there is no improvement on this UDP-U-4k issue.
> > > > Both get_page_from_freelist and __free_pages_ok's cpu time are still very high.
> > > > 
> > > > I checked my instrumentation in kernel and found it's caused by large object allocation/free
> > > > whose size is more than PAGE_SIZE. Here its order is 1.
> > > > 
> > > > The right free callchain is __kfree_skb => skb_release_all => skb_release_data.
> > > > 
> > > > So this case isn't the issue that batch of allocation/free might erase partial page
> > > > functionality.
> > > 
> > > So is this the kfree(skb->head) in skb_release_data() or the put_page()
> > > calls in the same function in a loop?
> > It's ﻿kfree(skb->head).
> > 
> > > 
> > > If it's the former, with big enough size passed to __alloc_skb(), the
> > > networking code might be taking a hit from the SLUB page allocator
> > > pass-through.
> 
> Do we know what kind of size is being passed to __alloc_skb() in this
> case?
In function __alloc_skb, original parameter size=4155,
SKB_DATA_ALIGN(size)=4224, sizeof(struct skb_shared_info)=472, so
__kmalloc_track_caller's parameter size=4696.

>  Maybe we want to do something like this.
> 
> 		Pekka
> 
> SLUB: revert page allocator pass-through
This patch amost fixes the netperf UDP-U-4k issue.

#slabinfo -AD
Name                   Objects    Alloc     Free   %Fast
:0000256                  1658 70350463 70348946  99  99 
kmalloc-8192                31 70322309 70322293  99  99 
:0000168                  2592   143154   140684  93  28 
:0004096                  1456    91072    89644  99  96 
:0000192                  3402    63838    60491  89  11 
:0000064                  6177    49635    43743  98  77 

So ﻿kmalloc-8192 appears. Without the patch, ﻿kmalloc-8192 hides.
﻿kmalloc-8192's default order on my 8-core stoakley is 2.

1) If I start CPU_NUM clients and servers, SLUB's result is about 2% better than SLQB's;
2) If I start 1 clinet and 1 server, and bind them to different physical cpu, SLQB's result
is about 10% better than SLUB's.

I don't know why there is still 10% difference with item 2). Maybe cachemiss causes it?

> 
> This is a revert of commit aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB:
> direct pass through of page size or higher kmalloc requests").
> ---
> 
> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index 2f5c16b..3bd3662 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h


